variable "project_id" {
  description = "Google Cloud Platform project ID"
  type        = string
}

variable "location" {
  description = "Google Cloud Platform resource location"
  type        = string
}

variable "environment_name" {
  description = "Name of the infrastructure environment"
  type        = string
}

variable "database_version" {
  description = "Family and version of Cloud SQL database"
  type        = string
}

variable "database_tier" {
  description = "Tier of Cloud SQL database"
  type        = string
}
