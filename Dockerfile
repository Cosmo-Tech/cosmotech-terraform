FROM hashicorp/terraform:1.1.4
COPY ./ /var/cosmotech-terraform
WORKDIR /var/cosmotech-terraform
