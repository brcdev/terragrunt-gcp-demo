resource "random_string" "instance_id" {
  length  = 8
  special = false
  upper   = false
}

resource "google_sql_database_instance" "master" {
  name                = "db-${var.environment_name}-${random_string.instance_id.id}"
  database_version    = var.database_version
  region              = var.location
  project             = var.project_id
  deletion_protection = false

  settings {
    tier = var.database_tier
  }
}
