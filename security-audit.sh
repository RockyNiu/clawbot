#!/usr/bin/env bash
# OpenClaw Security Audit Script
# Verify security configuration of a running OpenClaw instance
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

fail() {
    echo -e "${RED}✗${NC} $1"
}

echo "========================================="
echo "OpenClaw Security Audit Report"
echo "========================================="
echo ""

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q openclaw-gateway; then
    fail "OpenClaw Gateway container is not running"
    exit 1
fi
pass "Container status: Running"

# Get container ID
CONTAINER_ID=$(docker ps -qf "name=openclaw-gateway")

# 1. Network binding check
echo ""
echo "[1] Network Binding Security"
BIND_CONFIG=$(docker compose exec -T openclaw-gateway node dist/index.js config get gateway.bind 2>/dev/null | tr -d '\r\n' || echo "unknown")
if [[ "$BIND_CONFIG" == "loopback" ]]; then
    pass "Gateway bind: loopback (localhost only)"
elif [[ "$BIND_CONFIG" == "lan" ]]; then
    warn "Gateway bind: lan (accessible from LAN) - consider changing to loopback"
else
    fail "Gateway bind: $BIND_CONFIG (unknown configuration)"
fi

# Check actual listening ports
LISTENING_PORTS=$(docker exec "$CONTAINER_ID" ss -tlnp 2>/dev/null | grep :18789 || echo "")
if echo "$LISTENING_PORTS" | grep -q "127.0.0.1:18789"; then
    pass "Actual listen: 127.0.0.1:18789 (localhost)"
elif echo "$LISTENING_PORTS" | grep -q "0.0.0.0:18789"; then
    warn "Actual listen: 0.0.0.0:18789 (all interfaces) - exposure risk"
fi

# 2. Token authentication check
echo ""
echo "[2] Authentication Security"
if [[ -n "${OPENCLAW_GATEWAY_TOKEN:-}" ]]; then
    TOKEN_LENGTH=${#OPENCLAW_GATEWAY_TOKEN}
    if [[ $TOKEN_LENGTH -ge 32 ]]; then
        pass "Token length: $TOKEN_LENGTH characters (secure)"
    else
        warn "Token length: $TOKEN_LENGTH characters (recommend at least 32 characters)"
    fi
else
    CONFIG_TOKEN=$(docker compose exec -T openclaw-gateway node dist/index.js config get gateway.auth.token 2>/dev/null | tr -d '\r\n' || echo "")
    if [[ -n "$CONFIG_TOKEN" && "$CONFIG_TOKEN" != "null" ]]; then
        pass "Token authentication: Configured"
    else
        fail "Token authentication: Not configured - strongly recommended"
    fi
fi

# 3. Sandbox mode check
echo ""
echo "[3] Sandbox Isolation"
SANDBOX_MODE=$(docker compose exec -T openclaw-gateway node dist/index.js config get agents.defaults.sandbox.mode 2>/dev/null | tr -d '\r\n' || echo "off")
case "$SANDBOX_MODE" in
    "non-main")
        pass "Sandbox mode: $SANDBOX_MODE (enabled)"
        ;;
    "all")
        pass "Sandbox mode: $SANDBOX_MODE (full isolation)"
        ;;
    "off"|"null")
        warn "Sandbox mode: disabled - recommend enabling for enhanced isolation"
        ;;
    *)
        warn "Sandbox mode: $SANDBOX_MODE (unknown configuration)"
        ;;
esac

# Check Docker socket mount
if docker inspect "$CONTAINER_ID" --format '{{range .Mounts}}{{.Source}}{{println}}{{end}}' | grep -q "/var/run/docker.sock"; then
    if [[ "$SANDBOX_MODE" != "off" && "$SANDBOX_MODE" != "null" ]]; then
        pass "Docker socket: Mounted (required for sandbox)"
    else
        warn "Docker socket: Mounted but sandbox not enabled - potential risk"
    fi
else
    if [[ "$SANDBOX_MODE" != "off" && "$SANDBOX_MODE" != "null" ]]; then
        fail "Docker socket: Not mounted but sandbox is configured - sandbox will not work"
    fi
fi

# 4. Filesystem mount check
echo ""
echo "[4] Filesystem Security"
echo "Current mount points:"
MOUNTS=$(docker inspect "$CONTAINER_ID" --format '{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Mode}}){{println}}{{end}}')
echo "$MOUNTS"

# Check for sensitive directory mounts
SENSITIVE_DIRS=("/Users" "/home" "/root" "/etc" "/var" "/tmp")
MOUNTED_SENSITIVE=false
for dir in "${SENSITIVE_DIRS[@]}"; do
    if echo "$MOUNTS" | grep -q "^${dir}[^/]"; then
        warn "Detected sensitive directory mount: $dir"
        MOUNTED_SENSITIVE=true
    fi
done

if [[ "$MOUNTED_SENSITIVE" == false ]]; then
    pass "No sensitive system directories mounted"
fi

# Check workspace permissions
WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
if [[ -d "$WORKSPACE_DIR" ]]; then
    WORKSPACE_PERMS=$(stat -f "%Lp" "$WORKSPACE_DIR" 2>/dev/null || stat -c "%a" "$WORKSPACE_DIR" 2>/dev/null)
    if [[ "$WORKSPACE_PERMS" == "700" ]]; then
        pass "Workspace permissions: $WORKSPACE_PERMS (owner access only)"
    else
        warn "Workspace permissions: $WORKSPACE_PERMS (recommend 700)"
    fi
fi

# 5. Container security configuration check
echo ""
echo "[5] Container Security Configuration"
# Check if running as root
CONTAINER_USER=$(docker inspect "$CONTAINER_ID" --format '{{.Config.User}}')
if [[ "$CONTAINER_USER" == "node" || "$CONTAINER_USER" == "1000" ]]; then
    pass "Running user: $CONTAINER_USER (non-root)"
else
    warn "Running user: ${CONTAINER_USER:-root} (recommend non-root user)"
fi

# Check capabilities
CAPABILITIES=$(docker inspect "$CONTAINER_ID" --format '{{.HostConfig.CapDrop}}')
if [[ "$CAPABILITIES" == *"NET_RAW"* ]]; then
    pass "Capabilities: Restricted (includes NET_RAW)"
else
    warn "Capabilities: Not sufficiently restricted"
fi

# 6. Environment variable security
echo ""
echo "[6] Environment Variable Security"
SENSITIVE_ENV_VARS=(
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY"
    "GEMINI_API_KEY"
    "OPENCLAW_GATEWAY_TOKEN"
)

for var in "${SENSITIVE_ENV_VARS[@]}"; do
    if docker inspect "$CONTAINER_ID" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep -q "^${var}="; then
        VALUE=$(docker inspect "$CONTAINER_ID" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep "^${var}=" | cut -d= -f2)
        if [[ -n "$VALUE" && "$VALUE" != "null" ]]; then
            pass "$var: Configured (length ${#VALUE} characters)"
        fi
    fi
done

# 7. Network isolation check
echo ""
echo "[7] Network Isolation"
NETWORK_MODE=$(docker inspect "$CONTAINER_ID" --format '{{.HostConfig.NetworkMode}}')
pass "Network mode: $NETWORK_MODE"

# Check for unnecessary exposed ports
EXPOSED_PORTS=$(docker ps --format '{{.Ports}}' --filter "name=openclaw-gateway")
if echo "$EXPOSED_PORTS" | grep -q "0.0.0.0"; then
    warn "Port exposure: Bound to 0.0.0.0 - accessible from all interfaces"
elif echo "$EXPOSED_PORTS" | grep -q "127.0.0.1"; then
    pass "Port exposure: Bound to 127.0.0.1 only"
fi

# Summary
echo ""
echo "========================================="
echo "Audit Complete"
echo "========================================="
echo ""
echo "Recommendations:"
echo "  1. If Gateway bind is not loopback, run:"
echo "     docker compose exec openclaw-gateway node dist/index.js config set gateway.bind loopback"
echo ""
echo "  2. If sandbox is not enabled, re-run:"
echo "     OPENCLAW_SANDBOX=1 ./docker-setup.sh"
echo ""
echo "  3. Regularly check workspace directory contents:"
echo "     ls -lah ${WORKSPACE_DIR:-~/.openclaw/workspace}"
echo ""
