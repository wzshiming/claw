# OpenClaw Docker Image Builder

This repository contains a GitHub Actions workflow that builds and publishes a Docker image for [OpenClaw](https://github.com/openclaw/openclaw), a reverse-engineered implementation of the classic Captain Claw (1997) game.

## About OpenClaw

OpenClaw is an open-source reimplementation of the Captain Claw game engine, allowing the game to run on modern systems. The project aims to recreate the original game's behavior while adding cross-platform support.

## Docker Image

The Docker image is automatically built and pushed to GitHub Container Registry (ghcr.io) when changes are made to this repository.

### Image Location

```
ghcr.io/wzshiming/claw/openclaw:latest
```

## Using the Docker Image

### Prerequisites

You need the original Captain Claw game assets to run OpenClaw. These assets are not included in this image due to copyright restrictions.

### Running the Container

```bash
# Pull the image
docker pull ghcr.io/wzshiming/claw/openclaw:latest

# Run with game assets mounted
docker run -it --rm \
  -v /path/to/captain/claw/assets:/openclaw/ASSETS \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  ghcr.io/wzshiming/claw/openclaw:latest
```

### Notes

- The container requires X11 for display. On macOS, you'll need XQuartz. On Windows, you'll need an X server like VcXsrv.
- Game assets must be mounted to `/openclaw/ASSETS` in the container
- The container runs as a non-root user (UID 1000) for security

## CI/CD Workflow

The GitHub Actions workflow automatically:
- Builds the OpenClaw Docker image from source
- Supports both linux/amd64 and linux/arm64 architectures
- Pushes images to GitHub Container Registry
- Runs on:
  - Push to main/master branch
  - Pull requests (build only, no push)
  - Manual workflow dispatch
  - Weekly schedule (Sundays at 00:00 UTC)

## Building Locally

To build the image locally:

```bash
docker build -t openclaw .
```

## License

This repository's build scripts and Dockerfile are provided as-is. OpenClaw and Captain Claw have their own respective licenses. Please refer to the [OpenClaw repository](https://github.com/openclaw/openclaw) for more information.
