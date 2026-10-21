packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.0"
    }
  }
}

source "docker" "node" {
  image  = "ubuntu:jammy"
  commit = true
  changes = [
    "WORKDIR /app"
  ]
}

build {
  sources = ["source.docker.node"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs npm",
      "mkdir -p /app"
    ]
  }

  provisioner "file" {
    source      = "package.json"
    destination = "/app/package.json"
  }

  provisioner "shell" {
    inline = ["cd /app && npm install"]
  }

  post-processor "docker-tag" {
    repository = "ambiente-node"
    tags       = ["v1"]
  }
}
