# GCP Composer Research

## Introduction
Cloud Composer is the GCP-managed distribution of Apache Airflow. You can specify the access of specific IP addresses or deny all.
There doesn't seem to be a way to _natively_ set the network access control to deny all traffic **using Terraform**.

## Tests:
1. Created a `test-environment` (with that name) in GCP using the UI console. It takes 25 minutes to create a composer environment.
2. Ran the following `gcloud` command to see what changes it makes:

```bash
gcloud composer environments update test-environment \
    --location us-central1 \
    --web-server-deny-all
```

The `Web server access control` configuration under the ENVIRONMENT CONFIGURATION tab shows this:
 
![Screenshot of web server AC configuration](/images/console_web_server_access_gcloud.png)

> Both the API and the UI generate the same behavior as the flag `--web-server-deny-all` in gcloud when you don't specify any IP range (or more accurately, when you leave the `webServerNetworkAccessControl` configuration empty). In the CLI we need to pass the flag `--web-server-deny-all` and in Terraform this does not appear to be implemented at all. 

We came up with a workaround described below.

3. Recreate this scenario using Terraform

In Terraform, you can deploy a Composer Environment with a configuration like the one in [composer.tf](./research/composer.tf). As you can see there's a `web_server_network_access_control` block within the configuration which uses a variable called `cidr_range`. 

This allows you to specify the IP addresses that have access to the environment.

### Workaround

If the variable mentioned above is set to `cidr_range` = `0.0.0.0/32` this will be detected as a _deny all access_ action and will create a `terraform_data` resource (the modern version of `null_resource`) which will make a call to the composer API with an empty configuration for `webServerNetworkAccessControl`. 

This will effectively set the network access to `deny_all` as explained in the [API reference](https://cloud.google.com/composer/docs/composer-3/access-airflow-web-interface#api).

## Result
The environment starts with an allowed IP range of `10.5.0.0/16` and we do a `terraform apply` with the `cidr_range` variable set to `0.0.0.0/32`. This is the result:

![Result video](./images/result.mov)

## Conclusion
The API specifies that in order to deny all access we must 
> "specify an empty `webServerNetworkAccessControl` element. The `webServerNetworkAccessControl` element must be present, but must not contain an `allowedIpRanges` element."

This structure is very similar in Terraform, however, when you leave the `web_server_network_access_control` block empty, it understands "nothing has changed" so it doesn't do anything. This seems like a missing piece in the [provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#argument-reference---cloud-composer-3).

The workaround explained above gets the job done but it utilizes a provisioner inside the `terraform_data` resource. This is not a best practice and I wouldn't recommend using in production.
