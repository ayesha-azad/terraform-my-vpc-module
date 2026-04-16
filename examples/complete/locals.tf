locals {
  private-subnet = {
    for key, val in var.subnet-config : key => val if !val.public
  }
  public-subnet = {
    for key, val in var.subnet-config : key => val if val.public
  }
}