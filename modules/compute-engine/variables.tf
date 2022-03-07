variable "project_id" {
  description = "Google Cloud Platform project ID"
  type        = string
}

variable "compute_engine_zone" {
  description = "Google Compute Engine zone to use"
  type        = string
}

variable "environment_name" {
  description = "Name of the infrastructure environment"
  type        = string
}

variable "compute_machine_type" {
  description = "Type of GCE machine type to use"
  type        = string
}

variable "compute_machine_image" {
  description = "Type of GCE image to use"
  type        = string
}
