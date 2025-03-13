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

variable "cidr_range" {
  description = "CIDR range to allow access to the web server. If want to deny all access set to `0.0.0.0/32`"
  type        = string
  default     = "0.0.0.0/32"
}