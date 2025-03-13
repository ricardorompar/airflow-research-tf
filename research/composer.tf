resource "google_composer_environment" "test" {
  name   = "research-composer-env"
  region = var.region
  config {
    software_config {
      image_version = "composer-3-airflow-2"
    }

    web_server_network_access_control {
      allowed_ip_range {
        description = "Deny all"
        value       = var.cidr_range
      }
    }

    environment_size = "ENVIRONMENT_SIZE_SMALL"
    # This service account runs the pods of your environment and performs environment operations such as upgrading your environment to a new version.
    node_config {
      service_account = google_service_account.test.name
    }
  }
}

resource "google_service_account" "test" {
  account_id   = "composer-env-account"
  display_name = "Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  project = var.project_id
  role    = "roles/composer.worker" #required role for node 
  member  = "serviceAccount:${google_service_account.test.email}"
}
