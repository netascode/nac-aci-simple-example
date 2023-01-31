terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.6.0"
    }
  }
}

provider "aci" {
  username = "username"
  password = "password"
  url      = "https://apic.url"
}

locals {
  model = yamldecode(file("${path.module}/data/tenant_DEV.yaml"))
}

module "tenant" {
  source  = "netascode/nac-tenant/aci"
  version = "0.4.2"

  for_each    = { for tenant in try(local.model.apic.tenants, []) : tenant.name => tenant }
  model       = local.model
  tenant_name = each.value.name
}
