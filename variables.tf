variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnets" {
  type = map(any)
  default = {
    subnet1 = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-1a"
    }
  }
}

variable "azs" {
  default = ["us-east-1a"]
}

variable "key_name" {
  default = "my-key"
}
variable "private_key_path" {
  default = "~/.ssh/my-key.pem"
}
