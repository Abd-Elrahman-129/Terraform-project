#create subnets map 
variable "subnets" {
  type = map
  default = {
   subnet1 =  {
    cidr_block = "10.0.0.0/24"
    az = "us-east-1a"
   } 
   subnet2 = {
    cidr_block = "10.0.1.0/24"
    az = "us-east-1b"
   }
    
  }    
}
#create vpc cidr variable
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}