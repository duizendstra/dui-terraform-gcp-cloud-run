variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "project_number" {
  description = "The number of the GCP project"
  type        = string
}

variable "region" {
  description = "The region where Cloud Run service will be deployed"
  type        = string
  default     = "europe-west1"
}

variable "cloud_run_services" {
  description = "List of Cloud Run services"
  type = list(object({
    name                  = string
    container_image       = string
    container_version     = string
    cpu_limit             = string
    memory_limit          = string
    log_level             = string
    container_concurrency = number
    service_account_email = string
    max_scale             = number
    env_vars = list(object({
      name  = string
      value = string
    }))
  }))
}

