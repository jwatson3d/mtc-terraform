terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.15"
    }
  }
}

# download nodered image

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

