locals {
  base_url          = "https://composer.googleapis.com/v1"
  composer_api_path = "/projects/${data.google_client_config.current.project}/locations/${var.region}/environments/${google_composer_environment.test.name}"
  query_string      = "updateMask=config.webServerNetworkAccessControl"
}

resource "terraform_data" "network_access_deny_all" {
  triggers_replace = timestamp()    #always replace the resource

  count = var.cidr_range == "0.0.0.0/32" ? 1 : 0 #If you require to deny all access set the desired cidr range to 0.0.0.0/32

  # This makes a call to the API with an empty networkAccessControl which means deny all access: 
  # https://cloud.google.com/composer/docs/composer-3/access-airflow-web-interface#api
  provisioner "local-exec" {
    command = <<EOF
      curl -XPATCH '${local.base_url}${local.composer_api_path}?${local.query_string}' \
      -H 'Authorization: Bearer ${data.google_client_config.current.access_token}' \
      -H "Content-type: application/json" \
      -d '{"config" : {"webServerNetworkAccessControl" : {} } }' 
    EOF
  }

  depends_on = [google_composer_environment.test]
}