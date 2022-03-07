# Terragrunt GCP demo
This repo contains example Terragrunt setup, allowing you to bootstrap three different environments (dev, staging and prod) on Google Cloud Platform using Terragrunt, based on common Terraform codebase.

## Architecture
| GCP service | Dev | Staging | Prod
|-|-|-|-|
| Compute Engine | ✅ | ✅ | ✅ |
| Cloud Storage | ✅ | ✅ | ✅ |
| Cloud SQL | ❌ | ✅<br />db-f1-micro | ✅<br />db-g1-small |

## Project structure
Shared modules containing Terraform code only are located in `modules` directory. Each environment has its own directory in `environments` containing Terragrunt code and references to the earlier mentioned modules.

```
├── environments
│   ├── dev
│   │   ├── cloud-storage
│   │   │   └── terragrunt.hcl
│   │   ├── compute-engine
│   │   │   └── terragrunt.hcl
│   │   └── env.hcl
│   ├── prod
│   │   ├── cloud-sql
│   │   │   └── terragrunt.hcl
│   │   ├── cloud-storage
│   │   │   └── terragrunt.hcl
│   │   ├── compute-engine
│   │   │   └── terragrunt.hcl
│   │   └── env.hcl
│   └── staging
│       ├── cloud-sql
│       │   └── terragrunt.hcl
│       ├── cloud-storage
│       │   └── terragrunt.hcl
│       ├── compute-engine
│       │   └── terragrunt.hcl
│       └── env.hcl
├── modules
│   ├── cloud-sql
│   │   ├── main.tf
│   │   ├── terraform.tf
│   │   └── variables.tf
│   ├── cloud-storage
│   │   ├── main.tf
│   │   ├── terraform.tf
│   │   └── variables.tf
│   └── compute-engine
│       ├── main.tf
│       ├── terraform.tf
│       └── variables.tf
└── terragrunt.hcl
```


## Prerequisites
1. Make sure you have following tools installed:
   * [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   * [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
   * [gcloud CLI](https://cloud.google.com/sdk/docs/install)
1. Create a GCP project and set its ID for next commands:
```
% TERRAGRUNT_GCP_PROJECT_ID=your-project-id
```
1. Set GCP project ID in your local gcloud configuration:
```
% gcloud config set project $TERRAGRUNT_GCP_PROJECT_ID
```
1. Create service account for Terraform:
```
% gcloud iam service-accounts create terraform
```
1. Create access key for the service account:
```
% TERRAGRUNT_GCP_SA_NAME=$(gcloud iam service-accounts list --filter="email ~ ^terraform" --format='value(email)')
```
```
% gcloud iam service-accounts keys create terraform.json --iam-account $TERRAGRUNT_GCP_SA_NAME
```
1. Grant service account the project admin role (Note: you shouldn't be doing this in production, this is only for demo purposes):
```
% gcloud projects add-iam-policy-binding <projectId> --member=serviceAccount:$TERRAGRUNT_GCP_SA_NAME --role=roles/owner
```
1. Make sure Google APIs we're going to use are enabled in project:
```
gcloud services enable compute
gcloud services enable sqladmin
```
1. Adjust Cloud Storage bucket name for Terragrunt state and the project name/location in `terragrunt.hcl`:
```
state_bucket = "terragrunt-gcp-demo-state"
project  = "my-sandbox"
location = "europe-west4"
```  

## Running
1. Set path to service account key generated in steps above:
```
GOOGLE_APPLICATION_CREDENTIALS=terraform.json
```
1. Initialize Terragrunt and create the state bucket:
```
% terragrunt init        
Remote state GCS bucket terragrunt-gcp-demo-state does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y
Terraform initialized in an empty directory!
The directory has no Terraform configuration files. You may begin working
with Terraform immediately by creating Terraform configuration files.
```
1. Run plan to initialize all modules:
```
% terragrunt run-all plan
```
1. Run apply to create all resources:
```
% terragrunt run-all apply
```
1. Done! All your resources are created now.
1. (Optional) After testing & playing around, destroy all previously created resources:
```
% terragrunt run-all destroy
```

## Tips & tricks
### Modifying single environment
Terragrunt commands can be ran within subdirectories, which correspond to environments. For instance, you can apply only dev environment changes:
```
% cd environments/dev/
```
```
% terragrunt run-all plan
INFO[0000] The stack at /Users/user/projects/terragrunt-gcp-demo/environments/dev will be processed in the following order for command plan:
Group 1
- Module /Users/user/projects/terragrunt-gcp-demo/environments/dev/cloud-storage
- Module /Users/user/projects/terragrunt-gcp-demo/environments/dev/compute-engine
```
