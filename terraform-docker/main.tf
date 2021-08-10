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
  count   = 2
  length  = 8
  special = false
  upper   = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880 # docker will chose a random one
  }
}

# splat changes output to a list of elements instead of single (see count above)
output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "Name of the container"
}

output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "IP address and external port of the container"
}
