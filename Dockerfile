FROM node:20-bookworm

# Install Tailscale and dependencies from Debian Bookworm repositories
RUN apt-get update && apt-get install -y curl iptables tailscale && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Start tailscaled in userspace mode, authenticate, and run the bot
CMD tailscaled --tun=userspace-networking & sleep 2 && tailscale up --authkey=$TAILSCALE_AUTHKEY && node index.js
