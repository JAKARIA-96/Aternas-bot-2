#!/bin/bash

# Start tailscaled in userspace mode with local SOCKS5 proxy
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --statedir=/tmp/tailscale &

# Wait for tailscaled socket to boot
sleep 3

# Log into Tailscale
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname=railway-bot

echo "Tailscale proxy ready! Starting bot..."

# Start Node application
exec node index.js
