terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "029DA-DevOps24"

    workspaces {
      prefix = "network-"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
        }
      }
    }

    provider "aws" {}

    resource "aws_vpc" "main" {
      cidr_block = "10.0.0.0/16"
    }

    variable "security_group_name" {
      description = "Name of the security group"
      type        = string
      default     = "my-security-group"
    }


   resource "aws_security_group" "main" {
      name        = var.security_group_name
      description = "Security group for my application"
      vpc_id      = aws_vpc.main.id
   }   

    module "security-group-29" {
      source  = "app.terraform.io/029DA-DevOps24/security-group-29/aws"
      version = "5.0.0"


      security_group_name = var.security_group_name
      security_group_id = aws_security_group.main.id
      vpc_id = aws_vpc.main.id
      tags = {
        Name    = $(var.security_group_name)
      }
    

      ingress_rules = {
        http = {
      cidr_ipv4   = ["0.0.0.0/0"]
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "Allow HTTP traffic"
        }
        https = {
      cidr_ipv4   = ["0.0.0.0/0"]
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "Allow HTTPS traffic"
        }
      }

      egress_rules = {
        all_traffic = {
      cidr_ipv4   = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      ip_protocol = "-1"
      description = "Allow all traffic"
        }
      }
    }
