# Dockerfile for building OpenClaw game engine
# OpenClaw is a reimplementation of Captain Claw (1997)
# Source: https://github.com/openclaw/openclaw

FROM ubuntu:22.04 AS builder

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libsdl2-gfx-dev \
    zlib1g-dev \
    libtinyxml-dev \
    libpcre3-dev \
    libfreetype6-dev \
    libpng-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone OpenClaw repository
WORKDIR /build
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git

# Build OpenClaw
WORKDIR /build/openclaw/Build_Release
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . --config Release

# Create runtime image
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libsdl2-ttf-2.0-0 \
    libsdl2-gfx-1.0-0 \
    zlib1g \
    libtinyxml2.6.2v5 \
    libpcre3 \
    libfreetype6 \
    libpng16-16 \
    && rm -rf /var/lib/apt/lists/*

# Copy built binaries from builder
WORKDIR /openclaw
COPY --from=builder /build/openclaw/Build_Release/openclaw /openclaw/
COPY --from=builder /build/openclaw/Build_Release/*.so* /openclaw/

# Set up directory structure expected by OpenClaw
RUN mkdir -p /openclaw/ASSETS /openclaw/config

# Add a note about game assets
RUN echo "OpenClaw requires the original Captain Claw game assets to run." > /openclaw/README.txt && \
    echo "Please mount the game assets to /openclaw/ASSETS when running this container." >> /openclaw/README.txt && \
    echo "Example: docker run -v /path/to/assets:/openclaw/ASSETS ..." >> /openclaw/README.txt

# Create non-root user for running the game
RUN useradd -m -u 1000 openclaw && \
    chown -R openclaw:openclaw /openclaw

USER openclaw

# Set environment variables
ENV SDL_VIDEODRIVER=x11

WORKDIR /openclaw

# Default command shows help/version info
CMD ["./openclaw", "--help"]
