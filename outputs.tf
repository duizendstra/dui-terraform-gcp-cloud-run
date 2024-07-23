output "api_hosts" {
  description = "The API host and name for the Cloud Run services"
  value = {
    for name, service in google_cloud_run_service.main : name => {
      url  = service.status[0].url
      name = name
    }
  }
}