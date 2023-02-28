terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }


    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }


    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }


    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }


    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
        docker = {
      source = "terraform-providers/docker"
    }
  }


  required_version = ">= 0.14"
}


provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}