# OpenClaw Security Configuration Checklist

## 🔒 Pre-Launch Checks

### 1. Environment Preparation
- [ ] Docker and Docker Compose installed
- [ ] `openssl` command available (for token generation)
- [ ] Current user is in the `docker` group (or has Docker permissions)

### 2. Sensitive File Protection
- [ ] Confirm `~/.openclaw/workspace` does not contain existing sensitive files
- [ ] Confirm you will not accidentally mount `~/Documents`, `~/Downloads`, etc.
- [ ] Check environment variables before setting: `echo $OPENCLAW_EXTRA_MOUNTS` (should be empty)

### 3. Network Security Configuration
- [ ] Decide if external access is needed (if not, force `loopback`)
- [ ] If external access needed, prepare Tailscale or VPN solution

---

## 🚀 Launch Procedure (Maximum Security Configuration)

### Option A: Using Hardened Script (Recommended)
```bash
# 1. Run hardened setup script
./secure-docker-setup.sh

# 2. Save the output token (important!)
# Example output:
#   Your Gateway Token (save this securely):
#   a1b2c3d4e5f6... (64 characters)

# 3. Save token to password manager
```

### Option B: Manual Configuration
```bash
# 1. Set environment variables
export OPENCLAW_GATEWAY_BIND=loopback
export OPENCLAW_SANDBOX=1
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)

# 2. Run official script
./docker-setup.sh

# 3. Save token
echo "Token: $OPENCLAW_GATEWAY_TOKEN" > ~/.openclaw/TOKEN.txt
chmod 600 ~/.openclaw/TOKEN.txt
```

---

## ✅ Post-Launch Verification

### 1. Run Security Audit
```bash
./security-audit.sh
```

**Expected output (all items should be green ✓):**
```
✓ Container status: Running
✓ Gateway bind: loopback (localhost only)
✓ Actual listen: 127.0.0.1:18789 (localhost)
✓ Token length: 64 characters (secure)
✓ Sandbox mode: non-main (enabled)
✓ Docker socket: Mounted (required for sandbox)
✓ No sensitive system directories mounted
✓ Workspace permissions: 700 (owner access only)
✓ Running user: node (non-root)
```

### 2. Manual Verification of Key Settings

#### Check Network Binding
```bash
docker compose exec openclaw-gateway node dist/index.js config get gateway.bind
# Expected output: loopback
```

#### Check Sandbox Mode
```bash
docker compose exec openclaw-gateway node dist/index.js config get agents.defaults.sandbox.mode
# Expected output: non-main
```

#### Check Mount Points (should not include sensitive directories)
```bash
docker inspect $(docker ps -qf "name=openclaw-gateway") \
  --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
```

**Expected output example (only these paths):**
```
/Users/yourname/.openclaw -> /home/node/.openclaw
/Users/yourname/.openclaw/workspace -> /home/node/.openclaw/workspace
/var/run/docker.sock -> /var/run/docker.sock
```

#### Check Listening Ports
```bash
docker exec $(docker ps -qf "name=openclaw-gateway") ss -tlnp | grep 18789
# Expected to include: 127.0.0.1:18789 (not 0.0.0.0:18789)
```

### 3. Test Access Control

#### Test Local Access (should succeed)
```bash
curl -H "Authorization: Bearer $OPENCLAW_GATEWAY_TOKEN" \
  http://127.0.0.1:18789/healthz
# Expected output: {"status":"ok"}
```

#### Test Unauthorized Access (should fail)
```bash
curl http://127.0.0.1:18789/healthz
# Expected output: 401 Unauthorized
```

#### Test External Access (should refuse connection)
```bash
# From another device (e.g., phone) via LAN IP
curl http://YOUR_MAC_IP:18789/healthz
# Expected result: Connection refused (if configured correctly)
```

---

## 🛡️ Runtime Security Practices

### Weekly Checks
- [ ] Run `./security-audit.sh` to check for configuration drift
- [ ] Check workspace directory: `ls -lah ~/.openclaw/workspace`
- [ ] Review container logs: `docker compose logs --tail=100 openclaw-gateway`

### Monthly Checks
- [ ] Update Docker image: `docker pull openclaw:latest && ./secure-docker-setup.sh`
- [ ] Review API key usage
- [ ] Backup configuration: `tar -czf openclaw-config-backup-$(date +%Y%m%d).tar.gz ~/.openclaw`

### Before File Operations
Before letting AI handle files, confirm:
- [ ] File path is within `~/.openclaw/workspace`
- [ ] Does not contain passwords, keys, or private keys
- [ ] If handling sensitive data, consider using temporary copies

---

## 🚨 Security Incident Response

### If Configuration Tampering is Suspected
```bash
# 1. Immediately stop containers
docker compose down

# 2. Check configuration files
cat ~/.openclaw/openclaw.json | jq '.gateway'

# 3. Reset to secure configuration
rm -rf ~/.openclaw/openclaw.json
./secure-docker-setup.sh
```

### If Token is Compromised
```bash
# 1. Generate new token
NEW_TOKEN=$(openssl rand -hex 32)

# 2. Update configuration
docker compose exec openclaw-gateway node dist/index.js \
  config set gateway.auth.token "$NEW_TOKEN"

# 3. Restart gateway
docker compose restart openclaw-gateway

# 4. Update token on all clients
```

### If Abnormal Processes are Detected
```bash
# 1. View processes running in container
docker exec $(docker ps -qf "name=openclaw-gateway") ps aux

# 2. If suspicious processes found, export logs then destroy container
docker compose logs openclaw-gateway > incident-$(date +%Y%m%d-%H%M%S).log
docker compose down
docker rmi openclaw:local

# 3. Rebuild from official source
git pull origin main
./secure-docker-setup.sh
```

---

## 📋 Configuration File Inventory

### Files That Should Exist
```
~/.openclaw/
├── openclaw.json          # Main config (contains token)
├── identity/              # Gateway identity
├── agents/                # Agent session history
└── workspace/             # AI-accessible workspace
    └── .openclaw/         # Workspace metadata (auto-generated)
```

### Files That Should Be Protected
```bash
# Ensure these files have 600 or 700 permissions
chmod 600 ~/.openclaw/openclaw.json
chmod 700 ~/.openclaw/identity
chmod 700 ~/.openclaw/workspace
```

### Files That Should NOT Exist
- `~/.openclaw/.env` (sensitive vars should pass through Docker Compose)
- `~/.openclaw/credentials.json` (legacy version remnant)
- Any `.pem`, `.key` files (unless you explicitly placed them)

---

## 🔗 Related Resources

- Official security docs: https://docs.openclaw.ai/gateway/sandboxing
- Docker security best practices: https://docs.docker.com/engine/security/
- Troubleshooting: `docker compose logs -f openclaw-gateway`

---

## 📞 Getting Help

If you encounter security issues:
1. Run `./security-audit.sh` and save the output
2. Check last 100 lines of `docker compose logs openclaw-gateway`
3. When asking on GitHub Issues, **do NOT** include tokens or API keys
