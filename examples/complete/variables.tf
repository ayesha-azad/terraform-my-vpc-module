variable "vpc-config" {
  type = object({
    cidr_block = string 
    name = string 
  })

  validation {
    condition = can(cidrnetmask(var.vpc-config.cidr_block))
    error_message = "Invalid VPC CIDR Block - ${var.vpc-config.cidr_block}"
  }
}

variable "subnet-config" {
  type = map(object({
      cidr_block = string 
      name = string
      public = optional(bool, false)
      az = string
  }))

  validation {
    condition = alltrue([ for subnet in var.subnet-config : can(cidrnetmask(subnet.cidr_block)) ])
    error_message = "Invalid CIDR Block"
  }
}