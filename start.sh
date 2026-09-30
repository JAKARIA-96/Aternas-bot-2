#!/bin/sh

# Setup state directories
mkdir -p /var/run/tailscale /var/lib/tailscale /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200 2>/dev/null || true
fi

# Start tailscaled in userspace mode
tailscaled --tun=userspace-networking --statedir=/var/lib/tailscale &

# Wait for socket to initialize
sleep 3

# Authenticate with Tailscale
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname=railway-bot

echo "Tailscale started successfully! Starting Minecraft bot..."

# Start the Node.js application
exec node index.js
