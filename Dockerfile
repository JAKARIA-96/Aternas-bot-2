FROM node:18-bullseye

# Install Tailscale and curl
RUN apt-get update && apt-get install -y curl iptables && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && apt-get install -y tailscale

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Start tailscaled in userspace mode, log into Tailscale, and start the bot
CMD tailscaled --tun=userspace-networking & sleep 2 && tailscale up --authkey=$TAILSCALE_AUTHKEY && node index.js
