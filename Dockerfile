FROM registry.gitlab.com/linuxserver.io/docker-webtop/webtop:ubuntu-xfce-kasm-version-ee0aa013

# Install Chromium and Avirato client
USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    chromium \
    chromium-driver \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

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
EXPOSE 3000
EXPOSE 3001

# Set environment variables for Chromium
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROME_PATH=/usr/bin/chromium