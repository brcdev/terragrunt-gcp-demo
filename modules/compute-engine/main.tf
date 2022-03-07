resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = "example-gce-sa-${var.environment_name}"
  display_name = "Service Account"
}

resource "google_compute_instance" "default" {
  project      = var.project_id
  name         = "instance-${var.environment_name}"
  machine_type = var.compute_machine_type
  zone         = var.compute_engine_zone

  boot_disk {
    initialize_params {
      image = var.compute_machine_image
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
