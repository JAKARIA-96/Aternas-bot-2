FROM node:24-bookworm

# Install system build dependencies, C++ compiler, and Tailscale prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    iptables \
    gnupg \
    python3 \
    make \
    g++ \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Add Tailscale repository and install Tailscale
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && apt-get install -y tailscale && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Start Tailscale background daemon, join network, and start the bot
CMD tailscaled --tun=userspace-networking & sleep 2 && tailscale up --authkey=$TAILSCALE_AUTHKEY && node index.js
