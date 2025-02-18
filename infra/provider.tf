provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/W11/.aws/credentials"]
  
  default_tags {
    tags = {
      Environment = "Development"
      Project     = "DevopsTest"
      Owner       = "admin_deca"
      ManagedBy   = "Terraform"
    }
  }
}