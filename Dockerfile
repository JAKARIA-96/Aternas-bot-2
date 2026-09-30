FROM node:24-bookworm

# Install build dependencies and Tailscale
RUN apt-get update && apt-get install -y \
    curl iptables gnupg python3 make g++ cmake \
    && mkdir -p /usr/share/keyrings \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update && apt-get install -y tailscale \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN chmod +x start.sh

CMD ["/app/start.sh"]
