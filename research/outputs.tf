# NOTE: if you set the cidr_range variable to 0.0.0.0/32 the output `web_server_network_access_control` will reflect this value
# However, the API call from the terraform_data resource happens after the modification and *it will take precedence*
# IF you want to reflect the change in this output run a `terraform refresh` after the apply
output "web_server_network_access_control" {
  value = google_composer_environment.test.config[0].web_server_network_access_control
}

output "full_url" {
  value = "${local.base_url}${local.composer_api_path}?${local.query_string}"
}

#outputs for debugging
output "token" {
  value     = data.google_client_config.current.access_token
  sensitive = true
}

output "project_id" {
  value = data.google_client_config.current.project
}