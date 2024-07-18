
# Standard AWS Provider Block
terraform {
    required_version = ">= 1.0"
    backend "s3" {
      
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }

        cloudflare = {
            source  = "cloudflare/cloudflare"
            version = "~> 4.0"
        }
    }
}

# Provider Data
locals {
    AWS_PROFILE = "${var.AWS_PROFILE_NAME}"
    AWS_REGIONs = [
        {
            NAME = "Seoul"
            CODE = "ap-northeast-2"
        }
    ]
    AWS_PROFILEs = {
        for EACH, AWS_REGION in local.AWS_REGIONs:
            EACH => {
                NAME = "${local.AWS_PROFILE}-${AWS_REGION.NAME}"
            }
    }
}

provider "aws" {
    region = local.AWS_REGIONs[0].CODE
    profile = local.AWS_PROFILEs[0].NAME
    alias = "Seoul"
}

provider "cloudflare" {

}