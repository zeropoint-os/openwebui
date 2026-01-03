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
curl -X POST http://<zeropoint-node-name>:2370/modules/install \
  -H "Content-Type: application/json" \
  -d '{
    "source": "https://github.com/zeropoint-os/openwebui.git", 
    "module_id": "openwebui"
  }'
```

### Manual (for testing)

### Manual (for testing)

Use Run task (Shift+Alt+T)
1. Full test - setup and apply
2. Full test - cleanup

The install will be performed using Docker-in-Docker.

## Inputs

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `zp_module_id` | string | Unique identifier for this app instance (injected by zeropoint) | `"openwebui"` |
| `zp_network_name` | string | Pre-created Docker network name (injected by zeropoint) | (required) |
| `zp_arch` | string | Target architecture: amd64, arm64, etc. (injected by zeropoint) | `"amd64"` |
| `zp_module_storage` | string | Host path for persistent storage (injected by zeropoint) | (required) |
| `ollama_endpoint` | string | Ollama API endpoint URL (e.g., http://ollama-main:11434) | `""` (optional) |
| `webui_secret_key` | string | Secret key for session encryption and JWT signing | `"your-secret-here"` |

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
