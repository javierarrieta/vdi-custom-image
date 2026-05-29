FROM registry.gitlab.com/linuxserver.io/docker-webtop/webtop:ubuntu-xfce-kasm-version-ee0aa013

ARG PUID=1000
ARG PGID=1000

# Ensure base image is up-to-date with security patches
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    htop \
    btop \
    wget \
    curl \
    gnupg2 \
    zip \
    xz-utils \
    unzip \
    libfuse2t64 \
    tmux \
    fish \
    zsh \
    git \
    neovim \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Create user with proper permissions
RUN groupadd -g $PGID abc || true && \
    useradd -u $PUID -g $PGID -d /config -s /bin/bash abc || true && \
    usermod -u $PUID abc || true && \
    groupmod -g $PGID abc || true

# Switch to non-root user
USER abc

# Expose additional ports if needed
EXPOSE 3000 3001
