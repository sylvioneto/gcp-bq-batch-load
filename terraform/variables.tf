locals {
  resource_labels = {
    terraform = "true"
    app       = "bq-batch-load"
    env       = "sandbox"
    repo      = "gcp-bq-batch-load"
  }
}

variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-east1"
}
