terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.5.2"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.2"
    }
  }
}

provider "aci" {
  username = "username"
  password = "password"
  url      = "https://apic.url"
}

locals {
  model = yamldecode(data.utils_yaml_merge.model.output)
}

data "utils_yaml_merge" "model" {
  input = concat([for file in fileset(path.module, "data/*.yaml") : file(file)], [file("${path.module}/defaults/defaults.yaml")])
}

module "tenant" {
  source  = "netascode/nac-tenant/aci"
  version = "0.3.3"

  for_each    = toset([for tenant in lookup(local.model.apic, "tenants", {}) : tenant.name])
  model       = local.model
  tenant_name = each.value
}
