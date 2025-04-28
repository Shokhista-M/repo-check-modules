terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "029DA-DevOps24"
    
    workspaces {
        prefix = "network-"
    }
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

provider "aws" {}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
} 
module "security-group-29" {
    source  = "app.terraform.io/029DA-DevOps24/security-group-29/aws"
    version = "2.0.0"

    vpc_id = aws_vpc.main.id

    ingress_rules = {
        http = {
            cidr_ipv4   = ["0.0.0.0/0"]
            from_port   = 80
            to_port     = 80
            ip_protocol = "tcp"
            desciption  = "Allow HTTP traffic"
        }
        https = {
            cidr_ipv4   = ["0.0.0.0/0"]
            from_port   = 443
            to_port     = 443
            ip_protocol = "tcp"
            desciption  = "Allow HTTPS traffic"
        }
    }
}
