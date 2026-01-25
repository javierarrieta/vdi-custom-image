FROM registry.gitlab.com/linuxserver.io/docker-webtop/webtop:ubuntu-xfce-kasm-version-ee0aa013

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    htop \
    btop \
    wget \
    curl \
    gnupg2 \
    libfuse2t64 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/* \
    && snap install chromium

# Download and install Orca Slicer
RUN wget -O /tmp/orca-slicer.AppImage https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.3.1/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.3.1.AppImage && \
    chmod +x /tmp/orca-slicer.AppImage && \
    mv /tmp/orca-slicer.AppImage /usr/local/bin/orca-slicer && \
    ln -s /usr/local/bin/orca-slicer /usr/bin/orca-slicer

# Install Avirato client (adjust installation method based on actual Avirato requirements)
# RUN wget -O /tmp/avirato-client.deb https://releases.avirato.com/avirato-client_latest_amd64.deb || \
#     echo "Avirato client download failed - please provide correct URL" && \
#     (dpkg -i /tmp/avirato-client.deb || apt-get install -f -y) && \
#     rm -f /tmp/avirato-client.deb

# Create desktop shortcuts
RUN mkdir -p /config/desktop/applications && \
    echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Chromium\n\
Comment=Chromium Web Browser\n\
Exec=/usr/bin/chromium --no-sandbox --disable-dev-shm-usage\n\
Icon=chromium\n\
Terminal=false\n\
Categories=Network;WebBrowser;" > /config/desktop/applications/chromium.desktop && \
    \
    echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Avirato Client\n\
Comment=Avirato Client Application\n\
Exec=/usr/bin/avirato-client\n\
Icon=avirato\n\
Terminal=false\n\
Categories=Application;" > /config/desktop/applications/avirato-client.desktop

# Set permissions
RUN chmod +x /config/desktop/applications/*.desktop

# Create user with proper permissions
RUN groupadd -g $PGID abc || true && \
    useradd -u $PUID -g $PGID -d /config -s /bin/bash abc || true && \
    usermod -u $PUID abc || true && \
    groupmod -g $PGID abc || true

# Expose additional ports if needed
EXPOSE 3000 3001