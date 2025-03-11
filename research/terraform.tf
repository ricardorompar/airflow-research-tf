terraform {
  cloud {
    organization = "r2-org"

    workspaces {
      name = "lloyds-airflow-research"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.24.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = var.gcp-creds
}