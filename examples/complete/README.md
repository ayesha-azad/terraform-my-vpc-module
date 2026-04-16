# VPC Module

A reusable Terraform module for creating AWS VPC infrastructure with public and private subnets.

## Overview

This module creates a complete VPC setup including:
- **VPC** with configurable CIDR block
- **Subnets** with support for both public and private subnets across multiple availability zones
- **Internet Gateway** (automatically created when public subnets exist)
- **Route Table** with internet route for public subnets
- **Route Table Associations** for all public subnets

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Provider

- **AWS Region**: `eu-north-1` (configured in the module)

## Usage

```hcl
module "vpc" {
  source = "./module/vpc"

  vpc-config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
  }

  subnet-config = {
    "public-subnet-1" = {
      cidr_block = "10.0.1.0/24"
      name       = "public-subnet-1"
      az         = "eu-north-1a"
      public     = true
    }
    "private-subnet-1" = {
      cidr_block = "10.0.2.0/24"
      name       = "private-subnet-1"
      az         = "eu-north-1b"
      public     = false
    }
  }
}
```

## Input Variables

### vpc-config
**Type:** `object`  
**Required:** `true`

VPC configuration object with the following attributes:
- `cidr_block` (string, required): CIDR block for the VPC. Must be a valid CIDR notation.
- `name` (string, required): Name tag for the VPC.

**Validation:** CIDR block must be a valid CIDR notation.

**Example:**
```hcl
vpc-config = {
  cidr_block = "10.0.0.0/16"
  name       = "my-vpc"
}
```

### subnet-config
**Type:** `map(object)`  
**Required:** `true`

Map of subnet configurations where the key is the subnet name and value contains:
- `cidr_block` (string, required): CIDR block for the subnet. Must be a valid CIDR notation.
- `name` (string, required): Name tag for the subnet.
- `az` (string, required): Availability zone for the subnet (e.g., `eu-north-1a`).
- `public` (bool, optional): Set to `true` for public subnets, `false` for private. Defaults to `false`.

**Validation:** All CIDR blocks must be valid CIDR notation.

**Example:**
```hcl
subnet-config = {
  "public-subnet-1" = {
    cidr_block = "10.0.1.0/24"
    name       = "public-subnet-1"
    az         = "eu-north-1a"
    public     = true
  }
  "private-subnet-1" = {
    cidr_block = "10.0.2.0/24"
    name       = "private-subnet-1"
    az         = "eu-north-1b"
    public     = false
  }
}
```

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `vpc-id` | string | The ID of the VPC |
| `vpc-cidr` | string | The CIDR block of the VPC |
| `public-subnet` | map | Map of public subnets with their configurations |
| `private-subnet` | map | Map of private subnets with their configurations |
| `internet-gateway-id` | string | The ID of the Internet Gateway (null if no public subnets exist) |
| `route-table-id` | string | The ID of the route table for public subnets (null if no public subnets exist) |

**Example Output:**
```hcl
vpc-id = "vpc-0a1b2c3d4e5f6g7h8"

vpc-cidr = "10.0.0.0/16"

public-subnet = {
  "public-subnet-1" = {
    az         = "eu-north-1a"
    cidr_block = "10.0.1.0/24"
    name       = "public-subnet-1"
    public     = true
  }
}

private-subnet = {
  "private-subnet-1" = {
    az         = "eu-north-1b"
    cidr_block = "10.0.2.0/24"
    name       = "private-subnet-1"
    public     = false
  }
}

internet-gateway-id = "igw-0a1b2c3d4e5f6g7h8"

route-table-id = "rtb-0a1b2c3d4e5f6g7h8"
```

## How It Works

1. **VPC Creation**: Creates a VPC with the specified CIDR block.
2. **Subnet Creation**: Creates all subnets defined in `subnet-config`, placing them in specified availability zones.
3. **Subnet Classification**: Uses local values to separate subnets into public and private based on the `public` flag.
4. **Internet Connectivity**: 
   - If public subnets exist, an Internet Gateway is created and attached to the VPC.
   - A route table is created with a default route (`0.0.0.0/0`) pointing to the Internet Gateway.
   - All public subnets are associated with this route table.
5. **Private Subnets**: Private subnets are created but not associated with any route table, allowing for custom routing configuration.

## Conditional Resource Creation

- **Internet Gateway** and **Route Table** are only created when at least one public subnet is defined.
- Uses `count = length(local.public-subnet) > 0 ? 1 : 0` to conditionally create these resources.

## Notes

- All subnets require a valid CIDR block and must be within the VPC CIDR range.
- Public subnets are automatically routed to the Internet Gateway.
- Private subnets can be configured separately for NAT gateway or VPN access.
- The module uses `for_each` for dynamic subnet creation, making it scalable for multiple subnets.
