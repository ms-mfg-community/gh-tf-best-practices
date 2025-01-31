data "azurerm_resource_group" "this" {
  name = var.resource_group_name
} # Data Lookup for resource group name passed in from parameter

locals {
  tags = merge(var.app_insights_additional_tags, data.azurerm_resource_group.this.tags)
  #resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
}

# -
# - Application Insights
# -
resource "azurerm_application_insights" "this" {
  for_each            = var.application_insights
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  #location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  #resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  application_type                      = coalesce(lookup(each.value, "application_type"), "web")
  retention_in_days                     = lookup(each.value, "retention_in_days", null)
  daily_data_cap_in_gb                  = lookup(each.value, "daily_data_cap_in_gb", null)
  daily_data_cap_notifications_disabled = lookup(each.value, "daily_data_cap_notifications_disabled", null)
  sampling_percentage                   = lookup(each.value, "sampling_percentage", null)
  disable_ip_masking                    = lookup(each.value, "disable_ip_masking", null)

  tags = local.tags
}
