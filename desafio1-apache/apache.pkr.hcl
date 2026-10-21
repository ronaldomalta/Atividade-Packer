packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.0"
    }
  }
}

source "docker" "apache" {
  image  = "ubuntu:jammy"
  commit = true
  changes = [
    "EXPOSE 80",
    "CMD [\"apache2ctl\", \"-D\", \"FOREGROUND\"]"
  ]
}

build {
  sources = ["source.docker.apache"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y apache2",
      "mkdir -p /var/www/html"
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "meu-apache-packer"
    tags       = ["latest"]
  }
}
