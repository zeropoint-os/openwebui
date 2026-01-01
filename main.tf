terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "zp_app_id" {
  type        = string
  default     = "openwebui"
  description = "Unique identifier for this app instance (user-defined, freeform)"
}

 variable "zp_network_name" {
  type        = string
  description = "Pre-created Docker network name for this app (managed by zeropoint)"
}

variable "zp_arch" {
  type        = string
  default     = "amd64"
  description = "Target architecture - amd64, arm64, etc. (injected by zeropoint)"
}

variable "zp_gpu_vendor" {
  type        = string
  default     = ""
  description = "GPU vendor - nvidia, amd, intel, or empty for no GPU (injected by zeropoint)"
}

variable "zp_app_storage" {
  type        = string
  description = "Host path for persistent storage (injected by zeropoint)"
}

# Build OpenWebUI image from local Dockerfile
resource "docker_image" "openwebui" {
  name = "${var.zp_app_id}:latest"
  build {
    context    = path.module
    dockerfile = "Dockerfile"
    platform   = "linux/${var.zp_arch}"  # Uses injected zp_arch variable
  }
  keep_locally = true
}

# Main OpenWebUI container (no host port binding)
resource "docker_container" "openwebui_main" {
  name  = "${var.zp_app_id}-main"
  image = docker_image.openwebui.image_id

  # Network configuration (provided by zeropoint)
  networks_advanced {
    name = var.zp_network_name
  }

  # Restart policy
  restart = "unless-stopped"

  # Environment variables
  env = [
    "WEBUI_SECRET_KEY=your-secret-key-here",
  ]

  # Persistent storage
  volumes {
    host_path      = "${var.zp_app_storage}/data"
    container_path = "/app/backend/data"
  }

  # Ports exposed internally (no host binding)
  # Port 8080 is accessible via service discovery (DNS)
}

# Outputs for zeropoint (container resource only)
output "main" {
  value       = docker_container.openwebui_main
  description = "Main OpenWebUI container"
}

# Service ports for external access (defined but not bound to host)
output "main_ports" {
  value = {
    web = {
      port        = 8080                    # OpenWebUI web interface port
      protocol    = "http"                  # The protocol used
      transport   = "tcp"                   # Transport layer
      description = "OpenWebUI web interface" # Description of the port
      default     = true                    # Default port for the service
    }
  }
  description = "Service ports for external access"
}