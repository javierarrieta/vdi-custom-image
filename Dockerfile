FROM registry.gitlab.com/linuxserver.io/docker-webtop/webtop:ubuntu-xfce-kasm-version-ee0aa013

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    htop \
    btop \
    wget \
    curl \
    gnupg2 \
    zip \
    xz-utils \
    unzip \
    libfuse2t64 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Create user with proper permissions
RUN groupadd -g $PGID abc || true && \
    useradd -u $PUID -g $PGID -d /config -s /bin/bash abc || true && \
    usermod -u $PUID abc || true && \
    groupmod -g $PGID abc || true


# Expose additional ports if needed
EXPOSE 3000 3001