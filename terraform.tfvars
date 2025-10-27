vpc_cidr_block = "10.1.0.0/16"
subnets = {
  subnet1 = {
    cidr_block = "10.1.0.0/24"
    az         = "us-east-1a"
  }
}

key_name          = "my-key"
private_key_path  = "~/.ssh/my-key.pem"
