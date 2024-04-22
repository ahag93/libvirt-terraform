# modules/vm/main.tf
terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

resource "random_pet" "vm_name" {
  length = 3
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    VM_USER  = var.VM_USER
    hostname = "${var.VM_HOSTNAME}-${random_pet.vm_name.id}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

resource "libvirt_pool" "vm" {
  name = "${var.VM_HOSTNAME}_pool"
  type = "dir"
  path = "/opt/vms/terraform-${var.VM_HOSTNAME}-libvirt-pool-ubuntu"
}

resource "libvirt_volume" "base" {
  name   = "ubuntu-base"
  pool   = libvirt_pool.vm.name
  source = var.VM_IMG_URL
  format = var.VM_IMG_FORMAT
}

resource "libvirt_volume" "vm" {
  count  = var.VM_COUNT
  name   = "${var.VM_HOSTNAME}-${count.index}_volume.${var.VM_IMG_FORMAT}"
  pool   = libvirt_pool.vm.name
  base_volume_id  = libvirt_volume.base.id
  size            = 107374182400
}

resource "libvirt_network" "vm_public_network" {
   name = "${var.VM_HOSTNAME}_network"
   mode = "nat"
   domain = "${var.VM_HOSTNAME}.local"
   addresses = ["${var.VM_CIDR_RANGE}"]
   dhcp {
    enabled = true
   }
   dns {
    enabled = true
   }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "${var.VM_HOSTNAME}_cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.vm.name
}

resource "random_string" "vm-name" {
  length = 6
  upper  = false
  numeric = false
  lower  = true
  special = false
}

resource "libvirt_domain" "vm" {
  count  = var.VM_COUNT
  name   = "${var.VM_HOSTNAME}-${count.index}-${random_string.vm-name.result}"
  memory = "4096"
  vcpu   = 2

  cloudinit = "${libvirt_cloudinit_disk.cloudinit.id}"

  network_interface {
    network_id = "${libvirt_network.vm_public_network.id}"
    network_name = "${libvirt_network.vm_public_network.name}"
  }
  
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = "${libvirt_volume.vm[count.index].id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}