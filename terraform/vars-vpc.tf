variable "cidr" {
  type    = string
  default = "145.0.0.0/16"
  description = "VPC CIDR"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
    
  ]
  description = "List of avalibilty zone"
}

variable "public-subnets-ip" {
  type = list(string)
  default = [
    "145.0.1.0/24",
    "145.0.2.0/24"
  ]
  description = "Public Subnets CIDR"

}

variable "nated-subnets-ip" {
  type = list(string)
  default = [
    "145.0.3.0/24",
    "145.0.4.0/24"
  ]
 description = "Nated Subnets CIDR"
}

variable "private-subnets-ip" {
  type = list(string)
  default = [
    "145.0.5.0/24",
    "145.0.6.0/24"
  ]
 description = "Private Subnets CIDR"
}


