# cosmotech-terraform

Terraform configuration for Cosmo Tech platform devops.

## OCI image for automation
Run the image with the terraform action you want to do like this (example with azure/new-workspace):
```bash
podman run -e TF_VAR_terraform_var=value [-e TF_VAR_...] ghcr.io/cosmo-tech/cosmotech-terraform -chdir=/var/cosmotech-terraform/azure/new-workspace plan
```
