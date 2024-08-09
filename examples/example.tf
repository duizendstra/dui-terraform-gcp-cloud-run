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

module "cloud_run" {
  source = "./.."
  
  project = {
    project_id = "your-project-id"
    project_services = {
      "secretmanager.googleapis.com" = {
        "disable_on_destroy" = false
      }
    }
  }

  cloud_run_services = [
    {
      name                  = "your-service-name"
      service_account_email = "your-sa@your-project-id.iam.gserviceaccount.com"
      container_image       = "europe-west1-docker.pkg.dev/your-project-id/your-services/your-container-image"
      container_version     = "your-container-version"
      cpu_limit             = "1"
      memory_limit          = "512Mi"
      log_level             = "INFO"
      container_concurrency = 80
      max_scale             = 10
      env_vars = [
        {
          name  = "GOOGLE_CLOUD_PROJECT"
          value = "your-google-cloud-project"
        },
        {
          name  = "GOOGLE_CLOUD_REGION"
          value = "europe-west1"
        },
        {
          name  = "API_PASSWORD"
          value = "your-api-password"
        },
        {
          name  = "API_EMAIL"
          value = "api@example.com"
        },
        {
          name  = "API_HOST"
          value = "https://api.example.com"
        }
      ]
    }
  ]
}

output "services" {
  description = "The Cloud Run services"
  value       = module.cloud_run.services
}
