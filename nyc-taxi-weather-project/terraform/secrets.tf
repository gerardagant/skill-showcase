data "sops_file" "secrets" {
    source_file = "${path.module}/encrypted/secrets.enc.yaml"
}

locals {
  secrets = {
    subscription_id     = data.sops_file.secrets.data["azure.subscription_id"]
    tenant_id           = data.sops_file.secrets.data["azure.tenant_id"]
    sp_client_id        = data.sops_file.secrets.data["azure.service_principal.client_id"]
    sp_client_secret    = data.sops_file.secrets.data["azure.service_principal.client_secret"]
    storage_account_key = data.sops_file.secrets.data["azure.storage.account_key"]
    owm_api_key         = data.sops_file.secrets.data["openweathermap.api_key"]
  }
}
