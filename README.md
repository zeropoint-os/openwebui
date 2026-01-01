# OpenWebUI zeropoint app

This module defines the OpenWebUI app for zeropoint os using Terraform and the Docker provider.

## Resources Created

- **Docker Image**: Builds from local `Dockerfile` with platform-specific targeting
- **Docker Container**: OpenWebUI web interface for interacting with LLMs

## Requirements

- Terraform >= 1.0
- Docker provider ~> 3.0
- Optional: Ollama or other LLM service for backend connectivity

## Usage

### Via zeropoint API

```bash
curl -X POST http://localhost:8080/apps/install \
  -H "Content-Type: application/json" \
  -d '{
    "module_path": "/workspaces/zeropoint-agent/apps/openwebui",
    "app_id": "openwebui",
    "arch": "arm64"
  }'
```

### Manual (for testing)

```bash
cd /workspaces/zeropoint-agent/apps/openwebui

# Initialize Terraform
terraform init

# Plan (preview changes)
terraform plan \
  -var app_id=openwebui \
  -var network_name=zeropoint-app-openwebui \
  -var arch=amd64

# Apply (create resources)
terraform apply \
  -var app_id=openwebui \
  -var network_name=zeropoint-app-openwebui \
  -var arch=amd64

# Destroy (clean up)
terraform destroy \
  -var app_id=openwebui \
  -var network_name=zeropoint-app-openwebui
```

## Inputs

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `app_id` | string | Unique identifier for this app instance (injected by zeropoint) | `"openwebui"` |
| `network_name` | string | Pre-created Docker network name (injected by zeropoint) | (required) |
| `arch` | string | Target architecture: amd64, arm64, etc. (injected by zeropoint) | `"amd64"` |
| `app_storage` | string | Host path for persistent storage (injected by zeropoint) | (required) |

## Outputs

| Name | Description |
|------|-------------|
| `main` | Main OpenWebUI container resource (docker_container) |
| `main_ports` | Service ports for external access configuration |

## Features

- **Web Interface**: Modern web UI for interacting with LLMs
- **Multi-Model Support**: Connect to various LLM backends (Ollama, OpenAI, etc.)
- **User Management**: Built-in authentication and user management
- **Persistent Storage**: User data and configurations persist across container restarts
- **Service Discovery**: DNS-based discovery within zeropoint networks

## Network & Service Discovery

- **Internal Port**: 8080 (OpenWebUI web interface)
- **Network**: Uses pre-created network provided by zeropoint via `network_name`
- **No Host Ports**: Service discovery via DNS only
- **Container Name**: `${app_id}-main` (e.g., `openwebui-main`)

## Accessing OpenWebUI

### From Other Containers (Service Discovery)

Other apps can access OpenWebUI via DNS:

```bash
curl http://openwebui-main:8080/health
```

### From Host (via Exposure)

External access requires creating an exposure through zeropoint API.

### Configuration

Once running, you can:
1. Access the web interface to create an admin account
2. Configure LLM backends (Ollama, OpenAI, etc.) in settings
3. Start chatting with your preferred models
