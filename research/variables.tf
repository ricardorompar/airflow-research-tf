variable "gcp-creds" {
  description = "GCP JSON key to authenticate with GCP using a service account."
  type        = string
}

variable "region" {
  description = "GCP region to deploy resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone to deploy resources."
  type        = string
  default     = "us-central1-a"
}

variable "project_id" {
  description = "GCP project ID."
  type        = string
}