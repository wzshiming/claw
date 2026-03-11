# OpenClaw Docker Image Builder

This repository contains a GitHub Actions workflow that builds and publishes a Docker image for [OpenClaw](https://github.com/openclaw/openclaw), a personal AI assistant.

## About OpenClaw

OpenClaw is a personal AI assistant you can run on your own devices. It connects to various messaging platforms (WhatsApp, Telegram, Slack, Discord, etc.) and provides an AI-powered assistant experience.

## Docker Image

The Docker image is automatically built from the official OpenClaw repository and pushed to GitHub Container Registry (ghcr.io).

### Image Location

```
ghcr.io/wzshiming/claw/openclaw:latest
```

## Quick Start

### Prerequisites

Before running OpenClaw, you'll need:
- An OpenAI API key (or other supported AI model provider)
- (Optional) Credentials for messaging platforms you want to connect (WhatsApp, Telegram, Slack, Discord, etc.)

### Step 1: Pull the Image

```bash
docker pull ghcr.io/wzshiming/claw/openclaw:latest
```

### Step 2: Run the Container

```bash
docker run -d \
  --name openclaw \
  -v ~/.openclaw:/home/node/.openclaw \
  -p 18789:18789 \
  --restart unless-stopped \
  ghcr.io/wzshiming/claw/openclaw:latest \
  openclaw gateway --bind lan --allow-unconfigured
```

This will:
- Run OpenClaw in detached mode
- Mount `~/.openclaw` for persistent configuration
- Expose port 18789 (Gateway WebSocket control plane and Web UI)
- Bind to all interfaces (`--bind lan`) so it's accessible from the host
- Automatically restart the container unless manually stopped

**Note:** The `--bind lan` flag is required to make the gateway accessible from outside the container. For production use, configure authentication credentials.

### Step 3: Initial Setup

After starting the container, run the onboarding wizard:

```bash
docker exec -it openclaw openclaw onboard
```

The wizard will guide you through:
1. Configuring your AI model (OpenAI, Anthropic, etc.)
2. Setting up messaging channels
3. Configuring workspace and skills

### Step 4: Access the Control UI

Once configured, access the OpenClaw Control UI at:
```
http://localhost:18789
```

The Gateway serves both the WebSocket control plane and the Web UI (Control UI and WebChat) on the same port.

### Basic Usage

**Send a message to the assistant:**
```bash
docker exec -it openclaw openclaw agent --message "Hello, how are you?"
```

**Check gateway status:**
```bash
docker exec -it openclaw openclaw gateway status
```

**View logs:**
```bash
docker logs openclaw -f
```

### Environment Variables

You can configure OpenClaw using environment variables:

```bash
docker run -d \
  --name openclaw \
  -v ~/.openclaw:/home/node/.openclaw \
  -p 18789:18789 \
  -e OPENAI_API_KEY=your_api_key_here \
  --restart unless-stopped \
  ghcr.io/wzshiming/claw/openclaw:latest \
  node openclaw.mjs gateway --bind lan --allow-unconfigured
```

### Stopping and Removing

```bash
# Stop the container
docker stop openclaw

# Remove the container
docker rm openclaw

# Your configuration in ~/.openclaw will be preserved
```

For detailed setup and advanced configuration, please refer to the [official OpenClaw documentation](https://docs.openclaw.ai).

## CI/CD Workflow

The GitHub Actions workflow automatically:
- Clones the official OpenClaw repository
- Builds the Docker image using OpenClaw's Dockerfile
- Supports both linux/amd64 and linux/arm64 architectures
- Pushes images to GitHub Container Registry
- Runs on:
  - Push to main/master branch (when workflow changes)
  - Pull requests (build only, no push)
  - Manual workflow dispatch
  - Weekly schedule (Sundays at 00:00 UTC) to keep the image up to date

## Building Locally

To build the image locally using OpenClaw's Dockerfile:

```bash
git clone https://github.com/openclaw/openclaw.git
cd openclaw
docker build -t openclaw .
```

## License

This repository's build scripts and workflow are provided as-is. OpenClaw has its own license. Please refer to the [OpenClaw repository](https://github.com/openclaw/openclaw) for more information.
