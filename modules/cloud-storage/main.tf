resource "google_storage_bucket" "storage_bucket" {
  name     = "terragrunt-gcp-demo-${var.environment_name}"
  location = var.location
  project  = var.project_id
}
