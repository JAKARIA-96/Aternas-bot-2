#!/bin/bash

# Start tailscaled in userspace mode
tailscaled --tun=userspace-networking --statedir=/tmp/tailscale &
sleep 3

# Authenticate with Tailscale
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname=railway-bot

echo "Tailscale ready! Starting bot..."
exec node index.js
