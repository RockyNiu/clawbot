# 🐳 OpenClaw Docker Complete Guide

> Simplify Docker operations with Just task manager

## 📖 Table of Contents

- [Quick Start](#quick-start)
- [Security Configuration](#security-configuration)
- [Common Commands](#common-commands)
- [Resolved Issues](#resolved-issues)
- [Complete Just Commands](#complete-just-commands)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Device Pairing](#device-pairing)
- [Channel Management](#channel-management)
- [Advanced Configuration](#advanced-configuration)
- [Maintenance & Backup](#maintenance--backup)

---

## 🚀 Quick Start

### Prerequisites

Install [just](https://github.com/casey/just):

```bash
# macOS
brew install just

# Linux
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Or use cargo
cargo install just
```

### ⚠️ Choose Installation Mode

#### Standard Mode (Development/Testing)

```bash
# 1. Quick setup (allows LAN access)
just setup

# 2. Open Web UI
just open

# 3. Approve devices
just devices
just approve <requestId>
```

**Note**: Standard mode allows LAN access (`GATEWAY_BIND=lan`), suitable for development.

#### 🔒 Hardened Security Mode (Recommended for Production)

```bash
# Use security hardened setup
just setup-secure
```

**Security measures**:

- ✅ **Localhost-only access** (`loopback` binding)
- ✅ **Mandatory token authentication** (auto-generated 64-char random token)
- ✅ **Docker sandbox isolation**
- ✅ **Strict directory permissions** (`chmod 700`)
- ✅ **Post-startup security verification**

**Access**: Only via `http://localhost:18789` or `http://127.0.0.1:18789`

### Verify Installation

```bash
# Check all services
just verify

# Check health
just health
# Should return: {"ok": true, "status": "live"}
```

---

## 🔒 Security Configuration

### Security Mode Comparison

| Mode              | Network Binding | Access Range  | Use Case   | Security Level |
| ----------------- | --------------- | ------------- | ---------- | -------------- |
| **Secure Mode**   | `loopback`      | Local only    | Production | ⭐⭐⭐⭐⭐     |
| **Standard Mode** | `lan`           | Local network | Dev/Test   | ⭐⭐⭐         |

### Switch Security Modes

#### 🔒 Lock to Secure Mode (localhost only)

```bash
just security-lock
```

**Effects**:

- Allows `localhost` access only
- Sets directory permissions to `700`
- Auto-restarts Gateway

**Access**: Only via `http://localhost:18789` or Tailscale/SSH tunnel

#### 🔓 Unlock to Development Mode (allow LAN)

```bash
just security-unlock
```

**Effects**:

- Allows LAN access
- Accessible from other devices on local network

**⚠️ Warning**: Only use in trusted network environments

### Check Security Status

```bash
just security-status
```

**Example output**:

```
=== Security Configuration Status ===

Network binding:
loopback

Directory permissions:
drwx------  10 user  staff   320 Mar 13 00:00 ~/.openclaw
drwx------   5 user  staff   160 Mar 13 00:00 ~/.openclaw/workspace

Token configuration:
dbdf19983316b54c024d...

Sandbox mode:
non-main
```

### Security Best Practices

#### ✅ Recommended

1. **Production**: Always use `just setup-secure` or `just security-lock`
2. **Token Management**:
   - Use strong random tokens (64+ characters)
   - Rotate tokens regularly
   - Never commit tokens to Git
3. **Network Isolation**:
   - Use `loopback` binding in production
   - Use Tailscale or SSH tunnels for remote access
4. **Directory Permissions**:
   ```bash
   chmod 700 ~/.openclaw
   chmod 700 ~/.openclaw/workspace
   ```
5. **Regular Audits**:
   ```bash
   just devices        # Check paired devices
   just security-status # Check security config
   ```

#### ❌ Avoid

1. ❌ Exposing ports (18789/18790) to public internet
2. ❌ Using weak or default tokens
3. ❌ Using `lan` binding on untrusted networks
4. ❌ Excessive directory permissions (like 755 or 777)
5. ❌ Disabling token authentication

### Secure Remote Access

For remote device access, use one of these methods:

#### Option 1: Tailscale (Recommended)

```bash
# 1. Install Tailscale on Gateway host
# 2. Use secure mode
just setup-secure

# 3. Access from other devices via Tailscale IP
# http://100.x.x.x:18789
```

#### Option 2: SSH Tunnel

```bash
# On local machine
ssh -L 18789:localhost:18789 user@gateway-host

# Then access http://localhost:18789
```

#### Option 3: Reverse Proxy (Advanced)

Use Nginx/Caddy + TLS with:

- HTTPS encryption
- Client certificate authentication
- IP whitelist

---

## 🎮 Common Commands

### 10 Core Daily Commands

```bash
just --list      # List all commands (recommended first)
just logs        # View logs (most used)
just health      # Check health
just devices     # View/approve devices
just restart     # Restart service

just up          # Start services
just down        # Stop services
just open        # Open Web UI
just token       # View Gateway Token
just diagnose    # Complete diagnostics
```

### Service Management

```bash
just up          # Start all services
just down        # Stop all services
just restart     # Restart Gateway
just ps          # View container status
just reup        # Full restart (stop -> start)
```

### Logging & Monitoring

```bash
just logs        # View realtime logs (Ctrl+C to exit)
just logs-tail   # View last 50 lines
just stats       # View resource usage
just check-bind  # Check Gateway binding address
```

### Health Checks

```bash
just health      # HTTP health check (JSON format)
just health-cli  # CLI health check
just verify      # Verify all services (recommended)
```

### CLI Operations

```bash
# Run any CLI command
just cli <args>

# Examples
just cli health
just cli channels status
just cli config get

# Execute in running container
just exec <args>

# Enter container shell
just shell
```

### Configuration Management

```bash
just config-get                           # View all config
just config-get-key gateway.bind          # View specific config
just config-set <key> <value>             # Set config

# Example: Set API Key
just config-set providers.openai.apiKey "sk-..."
just config-set providers.anthropic.apiKey "sk-ant-..."

# Token management
just token                                # Show Gateway Token
just sync-token                           # Sync Token
```

### Quick Functions

```bash
just open        # Open Web UI
just open-canvas # Open Canvas
just urls        # Show all access URLs
```

---

## ✨ Resolved Issues

### ✅ Issue 1: `claw` command not found

**Cause**: Container only has `openclaw` command, not `claw`

**Solution**:

```bash
# Use Just task manager
just cli health       # Run CLI command
just --list           # View all commands
```

### ✅ Issue 2: `openclaw gateway --force` fails

**Error**: `fuser not found; required for --force when lsof is unavailable`

**Cause**:

- Docker container uses minimal image, missing `fuser` tool
- Gateway already running via docker-compose

**Solution**:

```bash
just restart          # Restart Gateway
just logs             # View logs
```

### ✅ Issue 3: Token mismatch

**Error**: `unauthorized: gateway token mismatch`

**Cause**: CLI and Gateway tokens don't match

**Solution**:

```bash
# Method 1: One-click fix (recommended)
just fix-token

# Method 2: Manual fix
just token            # View Token
just sync-token       # Sync Token
```

### ✅ Issue 4: localhost:18789 unreachable

**Error**: `Connection refused`

**Cause**: Gateway bound to container's `127.0.0.1`, unreachable from host

**Solution**:

```bash
# Method 1: One-click fix (recommended)
just fix-bind

# Method 2: Manual fix
just config-set gateway.bind lan
just restart

# Verify (should see "listening on ws://0.0.0.0:18789")
just check-bind
just health
```

**Verify binding address**:

```bash
# ✅ Correct (accessible from host)
listening on ws://0.0.0.0:18789

# ❌ Wrong (container-only access)
listening on ws://127.0.0.1:18789
```

### ✅ Issue 5: Device pairing required

**Cause**: First browser access requires device pairing

**Solution**:

```bash
# 1. View pending devices
just devices

# 2. Approve device (use Request ID shown above)
just approve <requestId>

# Example
just approve 477e0a68-488c-4136-a6e8-5bd2c1ede17e

# 3. Verify device paired
just devices
```

**Auto-approve** (development only):

```bash
just auto-approve
```

---

## 📋 Complete Just Commands

### Service Management

- `just up` - Start all services
- `just down` - Stop all services
- `just restart` - Restart Gateway
- `just ps` - View container status
- `just reup` - Full restart (stop -> start)

### Build

- `just build` - Build Docker image
- `just rebuild` - Rebuild and start
- `just build-browser` - Build (with browser support, +300MB)
- `just build-sandbox` - Build (with Docker CLI for sandbox)

### Logging & Monitoring

- `just logs` - View realtime logs
- `just logs-tail` - View last 50 lines
- `just stats` - View resource usage
- `just check-bind` - Check Gateway binding address

### CLI Commands

- `just cli <args>` - Run any CLI command
- `just exec <args>` - Execute in running container
- `just shell` - Enter container shell

### Health Checks

- `just health` - HTTP health check (JSON)
- `just health-cli` - CLI health check
- `just verify` - Verify all services

### Configuration

- `just config-get` - View all config
- `just config-get-key <key>` - View specific config
- `just config-set <key> <value>` - Set config
- `just token` - Show Gateway Token
- `just sync-token` - Sync Token

### Device Management

- `just devices` - View device list
- `just approve <id>` - Approve device pairing
- `just auto-approve` - Enable auto-approve (dev only)

### Security Configuration

- `just setup-secure` - Hardened security setup (recommended for production)
- `just security-lock` - Lock to secure mode (localhost only)
- `just security-unlock` - Unlock to dev mode (allow LAN)
- `just security-status` - View security configuration status

### Channel Management

- `just channels` - View Channel status
- `just add-telegram <token>` - Add Telegram Channel
- `just add-discord <token>` - Add Discord Channel
- `just login-whatsapp` - Login WhatsApp (interactive)

### Troubleshooting

- `just fix-bind` - Fix localhost unreachable issue
- `just fix-token` - Fix token mismatch
- `just diagnose` - View complete diagnostics

### Quick Functions

- `just open` - Open Web UI (http://localhost:18789)
- `just open-canvas` - Open Canvas
- `just urls` - Show all access URLs

### Maintenance

- `just clean` - Clean unused Docker resources
- `just clean-all` - Full cleanup (including volumes)
- `just backup` - Backup config to `~/.openclaw.backup.YYYYMMDD_HHMMSS`
- `just cat-config` - View config file (JSON format)

### Development

- `just dev` - Development mode (start + realtime logs)
- `just setup` - Complete setup (first use)
- `just test` - Quick test (build -> verify)

---

## 🔧 Configuration

### Gateway Token

View Token:

```bash
just token
```

### Access URLs

```bash
just urls  # Show all URLs
```

- **Web UI**: http://localhost:18789
- **Health**: http://localhost:18789/healthz
- **Ready**: http://localhost:18789/readyz
- **Canvas**: http://localhost:18789/**openclaw**/canvas/

### Configuration File Locations

**On host**:

- Config: `~/.openclaw/openclaw.json`
- Workspace: `~/.openclaw/workspace/`
- Environment: `./.env`

**In container**:

- Config: `/home/node/.openclaw/openclaw.json`
- Workspace: `/home/node/.openclaw/workspace/`
- Binary: `/usr/local/bin/openclaw`

### Default Settings

```bash
# View current config
just config-get
```

Default configuration:

- **Gateway Bind**: `lan` (listens on all network interfaces)
- **Gateway Port**: `18789`
- **Bridge Port**: `18790`
- **Gateway Mode**: `local`
- **Sandbox**: Configurable

---

## 🐛 Troubleshooting

### Connection refused (localhost:18789 unreachable)

**Quick fix**:

```bash
just fix-bind
```

**Manual fix**:

```bash
# 1. Check binding address
just check-bind

# 2. Set to LAN mode
just config-set gateway.bind lan

# 3. Edit .env file
# Change OPENCLAW_GATEWAY_BIND=loopback to lan

# 4. Restart Gateway
just restart

# 5. Verify
just health
```

### Token mismatch

**Quick fix**:

```bash
just fix-token
```

**Manual fix**:

```bash
# 1. View Token
just token

# 2. Sync Token
just sync-token

# 3. Test connection
just health-cli
```

### Device pairing needed

```bash
# View pending devices
just devices

# Approve device
just approve <requestId>

# Or enable auto-approve (dev only)
just auto-approve
```

### Container won't start

```bash
# 1. View detailed logs
just logs

# 2. View diagnostics
just diagnose

# 3. Rebuild
just rebuild

# 4. Full cleanup and rebuild
just clean-all
just setup
```

### Complete Diagnostics

```bash
just diagnose
```

This shows:

- Docker container status
- Gateway binding address
- Gateway Token
- Token in config file
- Device list
- HTTP health check results

---

## 🔐 Device Pairing

When first accessing Gateway from browser or new device, device pairing is required.

### Approve Pairing Request

```bash
# 1. View pending devices
just devices

# Example output:
# Pending (1)
# ┌──────────────────────────────────────┬─────────────────────┬──────────┬────────────┐
# │ Request                              │ Device              │ Role     │ IP         │
# ├──────────────────────────────────────┼─────────────────────┼──────────┼────────────┤
# │ 477e0a68-488c-4136-a6e8-5bd2c1ede17e │ 11d18a8e6355e3c3... │ operator │ 172.21.0.1 │
# └──────────────────────────────────────┴─────────────────────┴──────────┴────────────┘

# 2. Approve device (use Request ID from above)
just approve 477e0a68-488c-4136-a6e8-5bd2c1ede17e

# 3. Verify device paired
just devices
```

### Auto-approve (Development)

To auto-approve all devices (**not recommended for production**):

```bash
just auto-approve
```

### Manage Paired Devices

```bash
# View all devices
just devices

# Remove device (use full docker compose command)
docker compose run --rm openclaw-cli devices remove <deviceId>

# View device details
docker compose run --rm openclaw-cli devices info <deviceId>
```

---

## 📡 Channel Management

### View Channel Status

```bash
just channels
```

### Add Telegram Channel

```bash
just add-telegram "YOUR_BOT_TOKEN"

# Example
just add-telegram "123456:ABCDEF..."
```

### Add Discord Channel

```bash
just add-discord "YOUR_BOT_TOKEN"
```

### Login WhatsApp (Interactive)

```bash
just login-whatsapp
# Displays QR code to scan with WhatsApp
```

### Manually Add Other Channels

```bash
# Use general CLI command
just cli channels add --channel <channel-name> --token <token>

# Example: Add Slack
just cli channels add --channel slack --token "xoxb-..."
```

---

## 🔧 Advanced Configuration

### Build Options

#### With Browser Support

```bash
just build-browser
# Or manually
docker build --build-arg OPENCLAW_INSTALL_BROWSER=1 -t openclaw:local .
```

- Adds ~300MB
- For browser automation
- Includes Chromium and Xvfb

#### With Sandbox Support

```bash
just build-sandbox
# Or manually
docker build --build-arg OPENCLAW_INSTALL_DOCKER_CLI=1 -t openclaw:local .
```

- Adds ~50MB
- For `agents.defaults.sandbox` functionality
- Includes Docker CLI

#### Install Additional System Packages

Edit `.env` file:

```bash
OPENCLAW_DOCKER_APT_PACKAGES="python3 wget curl vim"
```

Then rebuild:

```bash
just rebuild
```

#### Use Slim Variant (Smaller Image)

Manual build:

```bash
docker build --build-arg OPENCLAW_VARIANT=slim -t openclaw:local .
```

### Sandbox Mode Configuration

Sandbox mode is currently enabled with:

```bash
# View sandbox config
just config-get-key agents.defaults.sandbox.mode
just config-get-key agents.defaults.sandbox.scope
```

Sandbox mode requires:

1. Docker CLI in image (installed)
2. Docker socket mounted to container (configured)
3. Correct group permissions (set)

### Environment Variables

Edit `.env` file to configure:

```bash
# Gateway config
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_TOKEN=your-token-here

# API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# Other config
OPENCLAW_SANDBOX=1
```

After editing, restart:

```bash
just restart
```

---

## 💾 Maintenance & Backup

### Backup Configuration

```bash
# Auto-backup (recommended)
just backup

# Example output:
# ✅ Config backed up to: ~/.openclaw.backup.20260313_120000

# Manual backup
cp -r ~/.openclaw ~/.openclaw.backup.$(date +%Y%m%d)
cp .env .env.backup.$(date +%Y%m%d)
```

### Restore Configuration

```bash
# Restore config
cp -r ~/.openclaw.backup.20260313/* ~/.openclaw/

# Restart service
just restart
```

### Clean Resources

```bash
# Clean unused Docker resources
just clean

# Full cleanup (including volumes - deletes data!)
just clean-all
```

### Update Process

```bash
# 1. Backup config
just backup

# 2. Pull latest code
git pull

# 3. Rebuild and start
just rebuild

# 4. Verify
just verify
```

### View Config File

```bash
# View in JSON format
just cat-config

# Or directly view
cat ~/.openclaw/openclaw.json
```

---

## 📊 Monitoring & Debugging

### View Container Status

```bash
# View all containers
just ps

# View resource usage
just stats

# View realtime logs
just logs

# View recent logs
just logs-tail
```

### Enter Container for Debugging

```bash
# Enter container shell
just shell

# Inside container
$ openclaw --help
$ openclaw health
$ ps aux
$ cat /home/node/.openclaw/openclaw.json
```

### Network Debugging

```bash
# Check port listening (on host)
lsof -i :18789

# Test HTTP access
curl http://localhost:18789/healthz

# Check Gateway binding address
just check-bind
```

---

## 🎓 Next Steps

### 1. Configure API Key

```bash
# Configure Anthropic (Claude)
just config-set providers.anthropic.apiKey "sk-ant-..."

# Or configure OpenAI (GPT)
just config-set providers.openai.apiKey "sk-..."

# Or configure Google (Gemini)
just config-set providers.google.apiKey "..."
```

### 2. Add Channels

```bash
# Telegram
just add-telegram "BOT_TOKEN"

# Discord
just add-discord "BOT_TOKEN"

# WhatsApp
just login-whatsapp
```

### 3. Check Status

```bash
# Verify all services
just verify

# View Channels
just channels

# View config
just config-get
```

### 4. Start Using

Access Web UI:

```bash
just open
```

Or visit directly: http://localhost:18789

---

## 📞 Getting Help

### View Help

```bash
# View all Just commands
just --list

# View complete diagnostics
just diagnose

# View realtime logs
just logs
```

### Reference Resources

- **Justfile source**: [justfile](./justfile)
- **Docker Compose**: [docker-compose.yml](./docker-compose.yml)
- **Dockerfile**: [Dockerfile](./Dockerfile)
- **Official docs**: https://docs.openclaw.ai/install/docker
- **GitHub**: https://github.com/openclaw/openclaw

### Common Issues

If you encounter issues, troubleshoot in this order:

1. **View logs**: `just logs`
2. **Run diagnostics**: `just diagnose`
3. **Check health**: `just health`
4. **View docs**: This document's "Troubleshooting" section
5. **Rebuild**: `just rebuild`

---

## ✅ Verification Checklist

Before starting, run:

```bash
just verify    # Verify all services
```

Manual verification:

- [ ] Just installed (`just --version`)
- [ ] Docker running (`docker ps`)
- [ ] Gateway started (`just ps`)
- [ ] Gateway accessible (`just health`)
- [ ] Token generated (`just token`)
- [ ] Devices paired (`just devices`)
- [ ] CLI connected (`just health-cli`)

**All checks passed → Ready to use!** 🎉

---

## 💡 Tips

- Use `just` + Tab key for command auto-completion (shell support required)
- `just logs` to view logs, Ctrl+C to exit
- `just diagnose` shows complete system status - first step for troubleshooting
- All config saved in `~/.openclaw/` directory, can be edited directly
- After editing `.env` file, need `just restart` to apply
- Recommend `just backup` before important operations

---

**Last updated**: 2026-03-13

---

---

📖 **Related documentation**:

- [DOCKER.zh-CN.md](./DOCKER.zh-CN.md) - Chinese version
- [DOCKER-SECURITY.md](./DOCKER-SECURITY.md) - Security quick reference
