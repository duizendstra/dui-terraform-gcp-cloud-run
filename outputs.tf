output "services" {
  description = "The Cloud Run services"
  value = {
    for name, service in google_cloud_run_service.main : name => {
      url                   = service.status[0].url
      name                  = name
      project               = service.project
      location              = service.location
      service_account_name  = service.template[0].spec[0].service_account_name
      image                 = service.template[0].spec[0].containers[0].image
      cpu_limit             = service.template[0].spec[0].containers[0].resources[0].limits.cpu
      memory_limit          = service.template[0].spec[0].containers[0].resources[0].limits.memory
      container_concurrency = service.template[0].spec[0].container_concurrency
      env_vars              = [for env in service.template[0].spec[0].containers[0].env : { name = env.name, value = env.value }]
    }
  }
}

# Deprecated output
output "api_hosts" {
  description = "(DEPRECATED) The API host and name for the Cloud Run services"
  value = {
    for name, service in google_cloud_run_service.main : name => {
      url  = service.status[0].url
      name = name
    }
  }
}