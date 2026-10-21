packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.0"
    }
  }
}

source "docker" "python" {
  image  = "ubuntu:jammy"
  commit = true
  changes = [
    "WORKDIR /app"
  ]
}

build {
  sources = ["source.docker.python"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip python3-venv",
      "mkdir -p /app",
      "python3 -m venv /opt/flask-venv",
      "/opt/flask-venv/bin/pip install --no-cache-dir Flask",
      "ln -s /opt/flask-venv/bin/flask /usr/local/bin/flask"
    ]
  }

  post-processor "docker-tag" {
    repository = "ambiente-dev-python"
    tags       = ["v1"]
  }
}
