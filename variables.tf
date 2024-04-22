# modules/vm/variables.tf
variable "VM_COUNT" {
  default = 4
  type    = number
}

variable "VM_USER" {
  default = "ahag"
  type    = string
}

variable "VM_HOSTNAME" {
  default = "swarm-lab"
  type    = string
}

variable "VM_IMG_URL" {
  default = "https://cloud-images.ubuntu.com/releases/22.04/release-20231211/ubuntu-22.04-server-cloudimg-amd64.img"
  type    = string
}

variable "VM_IMG_FORMAT" {
  default = "qcow2"
  type    = string
}

variable "VM_CIDR_RANGE" {
  default = "10.10.99.0/24"
  type    = string
}