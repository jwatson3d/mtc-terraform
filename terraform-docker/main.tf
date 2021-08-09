terraform {
  required_providers {
    docker = {
      #source = "terraform-providers/docker"
      #version = "~> 2.7.2"
      source  = "kreuzwerker/docker"
      version = "~> 2.14.0"
    }
  }
}

provider "docker" {}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880 # docker will chose a random one
  }
}

output "ip-address" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "IP address and external port of the container"
}

output "container-name" {
  value       = docker_container.nodered_container.name
  description = "Name of the container"
}