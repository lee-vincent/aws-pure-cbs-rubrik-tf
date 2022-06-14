terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cbs = {
      source  = "PureStorage-OpenConnect/cbs"
      version = "0.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    # manually download rubrik terraform provider from github
    # https://github.com/rubrikinc/terraform-provider-rubrik/releases
    # using version 1.0.4
    # rename executable to terraform-provider-rubrik
    # move to $HOME/.terraform.d/plugins/github.com/rubrikinc/rubrik/1.0.4/linux_amd64/
    # add required_providers rubrik block to .terraform/modules/rubrik-cloud-cluster/main.tf
    # rubrik = {
    #   source  = "github.com/rubrikinc/rubrik"
    #   version = "= 1.0.4"
    # }
  }
}