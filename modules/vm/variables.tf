# modules/vm/variables.tf
variable "VM_COUNT" {
  type = number
}

variable "VM_USER" {
  type = string
}

variable "VM_HOSTNAME" {
  type = string
}

variable "VM_IMG_URL" {
  type = string
}

variable "VM_IMG_FORMAT" {
  type = string
}

variable "VM_CIDR_RANGE" {
  type = string
}