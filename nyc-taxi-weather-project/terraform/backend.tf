terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "terraformstatestoragegg"   # ← replace with your actual storage account name
    container_name       = "tfstate"
    key                  = "nyc-taxi-analytics/terraform.tfstate"

    # Authentication: the same ARM_* environment variables used for the
    # azurerm provider work here too — no extra config needed in CI/CD.
    # Locally, `az login` is sufficient if your account has Blob Contributor
    # on the state storage account.
  }
}