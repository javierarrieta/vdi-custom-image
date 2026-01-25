FROM registry.gitlab.com/linuxserver.io/docker-webtop/webtop:ubuntu-xfce-kasm-version-ee0aa013

# Install Chromium and Avirato client
USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    chromium \
    chromium-driver \
    htop \
    btop \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Download and install Orca Slicer
RUN wget -O /tmp/orca-slicer.AppImage https://github.com/SoftFever/OrcaSlicer/releases/latest/download/OrcaSlicer_Ubuntu_2204.AppImage || \
    wget -O /tmp/orca-slicer.AppImage https://github.com/SoftFever/OrcaSlicer/releases/download/v2.1.0/OrcaSlicer_Ubuntu_2204.AppImage && \
    chmod +x /tmp/orca-slicer.AppImage && \
    mv /tmp/orca-slicer.AppImage /usr/local/bin/orca-slicer && \
    ln -s /usr/local/bin/orca-slicer /usr/bin/orca-slicer

# Install Avirato client (adjust installation method based on actual Avirato requirements)
RUN wget -O /tmp/avirato-client.deb https://releases.avirato.com/avirato-client_latest_amd64.deb || \
    echo "Avirato client download failed - please provide correct URL" && \
    (dpkg -i /tmp/avirato-client.deb || apt-get install -f -y) && \
    rm -f /tmp/avirato-client.deb

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

# Switch back to default user
USER abc

# Expose additional ports if needed
EXPOSE 3000 3001

# Set environment variables for Chromium
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROME_PATH=/usr/bin/chromium