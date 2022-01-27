FROM hashicorp/terraform:1.1.4
COPY ./ /var/cosmotech-terraform
WORKDIR /var/cosmotech-terraform/azure/new-workspace
RUN terraform init
WORKDIR /var/cosmotech-terraform
