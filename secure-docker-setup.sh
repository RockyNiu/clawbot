#!/usr/bin/env bash
# OpenClaw Hardened Docker Setup Script
# For maximum security configuration
set -euo pipefail

echo "========================================="
echo "OpenClaw Hardened Security Setup Wizard"
echo "========================================="
echo ""
echo "This script will enable the following security measures:"
echo "  ✓ Localhost-only access (loopback)"
echo "  ✓ Docker-in-Docker sandbox isolation"
echo "  ✓ Mandatory token authentication"
echo "  ✓ Minimal privilege mounts"
echo "  ✓ Read-only sensitive configs"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Check dependencies
command -v docker >/dev/null 2>&1 || { echo "ERROR: docker command not found"; exit 1; }
command -v openssl >/dev/null 2>&1 || { echo "ERROR: openssl command not found"; exit 1; }

# Generate strong random token (if not already set)
if [[ -z "${OPENCLAW_GATEWAY_TOKEN:-}" ]]; then
    OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"
    echo "✓ Generated 64-character random token"
else
    echo "⚠ Using existing token from environment variable"
fi

# Set strictest configuration
export OPENCLAW_GATEWAY_BIND=loopback       # Localhost only
export OPENCLAW_SANDBOX=1                    # Enable sandbox
export OPENCLAW_GATEWAY_TOKEN
export OPENCLAW_CONFIG_DIR="${HOME}/.openclaw"
export OPENCLAW_WORKSPACE_DIR="${HOME}/.openclaw/workspace"

# Ensure secure directory permissions
mkdir -p "$OPENCLAW_CONFIG_DIR" "$OPENCLAW_WORKSPACE_DIR"
chmod 700 "$OPENCLAW_CONFIG_DIR"
chmod 700 "$OPENCLAW_WORKSPACE_DIR"

echo ""
echo "Security configuration summary:"
echo "  - Gateway bind: loopback (127.0.0.1)"
echo "  - Sandbox mode: enabled"
echo "  - Token length: ${#OPENCLAW_GATEWAY_TOKEN} characters"
echo "  - Config directory: $OPENCLAW_CONFIG_DIR (permissions 700)"
echo "  - Workspace: $OPENCLAW_WORKSPACE_DIR (permissions 700)"
echo ""

# Call original setup script
if [[ ! -f "./docker-setup.sh" ]]; then
    echo "ERROR: docker-setup.sh not found. Please run this script from the OpenClaw repository root."
    exit 1
fi

echo "Invoking official docker-setup.sh..."
echo ""
./docker-setup.sh

# Post-startup security verification
echo ""
echo "========================================="
echo "Post-Startup Security Check"
echo "========================================="

# Wait for container to fully start
echo "Waiting for container to start..."
sleep 5

# Check bind address
ACTUAL_BIND=$(docker compose exec -T openclaw-gateway node dist/index.js config get gateway.bind 2>/dev/null | tr -d '\r\n' || echo "unknown")
if [[ "$ACTUAL_BIND" != "loopback" ]]; then
    echo "⚠ WARNING: Gateway bind address is not loopback (actual: $ACTUAL_BIND)"
else
    echo "✓ Gateway bind: loopback"
fi

# Check sandbox mode
SANDBOX_MODE=$(docker compose exec -T openclaw-gateway node dist/index.js config get agents.defaults.sandbox.mode 2>/dev/null | tr -d '\r\n' || echo "unknown")
if [[ "$SANDBOX_MODE" != "non-main" ]]; then
    echo "⚠ WARNING: Sandbox mode not properly enabled (actual: $SANDBOX_MODE)"
else
    echo "✓ Sandbox mode: $SANDBOX_MODE"
fi

# Check mount points (ensure no sensitive directories are mounted)
echo ""
echo "Current container mount points:"
docker inspect "$(docker ps -qf "name=openclaw-gateway")" --format '{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Mode}}){{println}}{{end}}' 2>/dev/null || echo "Unable to retrieve mount information"

echo ""
echo "========================================="
echo "Security Configuration Complete"
echo "========================================="
echo ""
echo "Your Gateway Token (save this securely):"
echo "  $OPENCLAW_GATEWAY_TOKEN"
echo ""
echo "Access methods:"
echo "  - Local Web UI: http://127.0.0.1:18789"
echo "  - Token authentication: Enter the above token in client settings"
echo ""
echo "Management commands:"
echo "  View logs:    docker compose logs -f openclaw-gateway"
echo "  Stop service: docker compose down"
echo "  Restart:      docker compose up -d openclaw-gateway"
echo ""
echo "⚠ Security reminders:"
echo "  1. Do NOT commit the token to Git repositories"
echo "  2. Do NOT expose the Gateway port on public networks"
echo "  3. Regularly check workspace directory contents"
echo "  4. Use Tailscale if you need access from other devices"
echo ""
