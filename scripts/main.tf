module "resource_groups" {
    source          = "git@github.com:/ms-mfg-community/gh-tf-modules-1//Resource_Groups?ref=v2"
    resource_groups = var.resource_groups
}

module "app_insights" {
  source                        = "git@github.com:/ms-mfg-community.git/gh-tf-modules-1//AppInsights?ref=v1"
  resource_group_name           = var.app_insights_resource_group_name
  app_insights_additional_tags  = var.app_insights_additional_tags
  application_insights          = var.application_insights
  depends_on                    = [module.resource_groups]
}

resource "azurerm_service_plan" "example" {
  name                = "${var.app_service_plan_name}-${var.env}"
  resource_group_name = var.resource_groups["resource_group_1"].name
  location            = var.resource_groups["resource_group_1"].location
  os_type             = var.asp_os_type
  sku_name            = var.asp_sku
  depends_on          = [module.app_insights]
}
