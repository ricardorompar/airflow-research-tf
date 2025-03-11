# GCP Composer Research

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

This makes me believe the `--web-server-deny-all` option actually is a particular case for "Allow access only from specific IP addresses" with no value specified.

UPDATE: the both the API and the UI generate the same behavior as `--web-server-deny-all` in gcloud when you don't specify any IP range. For Terraform and the CLI is a different situation.

3. Recreate this scenario using Terraform
`WORK IN PROGRESS...`