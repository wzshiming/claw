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

## Using the Docker Image

### Running the Container

```bash
# Pull the image
docker pull ghcr.io/wzshiming/claw/openclaw:latest

# Run the container
docker run -it --rm \
  -v ~/.openclaw:/root/.openclaw \
  -p 3000:3000 \
  ghcr.io/wzshiming/claw/openclaw:latest
```

For detailed setup and configuration instructions, please refer to the [official OpenClaw documentation](https://docs.openclaw.ai).

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
