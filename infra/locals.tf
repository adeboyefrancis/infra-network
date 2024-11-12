#############################################
# Dynamic Prefix for Tagging Resources
#############################################
locals {
  prefix = "${var.prefix}-${terraform.workspace}"

}
