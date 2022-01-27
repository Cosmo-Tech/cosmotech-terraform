FROM hashicorp/terraform:1.1.4
COPY ./ /var/cosmotech-terraform
COPY ./azure/new-workspace/.terraform /var/cosmotech-terraform/azure/new-workspace/.terraform
WORKDIR /var/cosmotech-terraform
