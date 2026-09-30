FROM node:20-bookworm

# Install prerequisite tools
RUN apt-get update && apt-get install -y curl iptables gnupg && rm -rf /var/lib/apt/lists/*

# Add Tailscale's official repository key and package list
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

# Install Tailscale
RUN apt-get update && apt-get install -y tailscale && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Start tailscaled in userspace mode, authenticate, and run the bot
CMD tailscaled --tun=userspace-networking & sleep 2 && tailscale up --authkey=$TAILSCALE_AUTHKEY && node index.js
