bucket_name = "dev-proj-1-apidev-remote-state-bucket"
name        = "environment"
environment = "dev-1"

vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-proj-us-east-vpc-1"
cidr_public_subnet   = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet  = ["10.0.3.0/24", "10.0.4.0/24"]
us_availability_zone = ["us-east-1a", "us-east-1b"]

public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJSiXLTHtXiWcFJgwk2U5flkU+/dF5llxW0/LKMkXdS w11@W11PC"
ec2_ami_id     = "ami-04b4f1a9cf54c11d0"

ec2_user_data_install_apache = ""

domain_name = "apidecateca.com" ##you must use the main domain apidecateca.com