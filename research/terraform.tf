terraform {
  cloud {
    organization = "r2-org" #change to your HCP organization

    workspaces {
      name = "lloyds-airflow-research" #change to your HCP workspace
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

data "google_client_config" "current" {}