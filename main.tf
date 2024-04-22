# main.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  alias = "system"
  uri = "qemu:///system"
}

module "vm" {
  source = "./modules/vm"

  providers = {
    libvirt = libvirt.system
  }

  VM_COUNT       = var.VM_COUNT
  VM_USER        = var.VM_USER
  VM_HOSTNAME    = var.VM_HOSTNAME
  VM_IMG_URL     = var.VM_IMG_URL
  VM_IMG_FORMAT  = var.VM_IMG_FORMAT
  VM_CIDR_RANGE  = var.VM_CIDR_RANGE
}
