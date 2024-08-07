terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.40.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.40.0"
    }
  }
}

resource "google_cloud_run_service" "main" {
  for_each = { for service in var.cloud_run_services : service.name => service }

  project  = var.project_id
  name     = each.value.name
  location = var.region

  template {
    spec {
      service_account_name = each.value.service_account_email

      containers {
        image = "${each.value.container_image}:${each.value.container_version}"
        resources {
          limits = {
            cpu    = each.value.cpu_limit
            memory = each.value.memory_limit
          }
        }
        env {
          name  = "GCP_PROJECT"
          value = var.project_id
        }
        env {
          name  = "GOOGLE_CLOUD_REGION"
          value = var.region
        }
        dynamic "env" {
          for_each = each.value.log_level != "" ? [1] : []
          content {
            name  = "LOG_LEVEL"
            value = each.value.log_level
          }
        }
        dynamic "env" {
          for_each = each.value.env_vars
          content {
            name  = env.value.name
            value = env.value.value
          }
        }
      }

      container_concurrency = each.value.container_concurrency
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = tostring(each.value.max_scale)
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}