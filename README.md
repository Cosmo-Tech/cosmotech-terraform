# cosmotech-terraform

Terraform configuration for Cosmo Tech platform devops.

## OCI image for automation
Run the image with the terraform action you want to do like this (example with azure/new-workspace and tfvars in /tmp/tfvars):
```bash
podman run --mount type=bind,source=/tmp/tfvars,target=/var/tfvars ghcr.io/cosmo-tech/cosmotech-terraform -chdir=/var/cosmotech-terraform/azure/new-workspace plan -var-file=/var/tfvars/local.tfvars
```
