# 🦞 OpenClaw — Personal AI Assistant (Docker Hardened Setup)

> **📚 Looking for the official OpenClaw documentation?**
> See [README.md](README.md) for the complete upstream documentation.
>
> **🌐 中文版 / Chinese Version:** [README.HARDENED.zh-CN.md](README.HARDENED.zh-CN.md)

<p align="center">
  <strong>Maximum security configuration for Docker deployment</strong>
</p>

---

## 📋 Overview

This repository contains a **hardened security configuration** for running [OpenClaw](https://github.com/openclaw/openclaw) in Docker with maximum isolation and protection.

**OpenClaw** is a personal AI assistant you run on your own devices. It answers you on the channels you already use (Telegram, WhatsApp, Slack, Discord, Signal, etc.) or via command-line interface.

---

## 🔒 Security Features

This configuration enables:

- ✅ **Localhost-only binding** (no external network access)
- ✅ **Docker-in-Docker sandbox** (isolated code execution)
- ✅ **64-character token authentication**
- ✅ **Minimal filesystem mounts** (only workspace accessible)
- ✅ **Non-root container execution**
- ✅ **700 permissions** on sensitive directories

---

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- `openssl` command available
- macOS, Linux, or WSL2 on Windows

### Installation

```bash
# 1. Clone this repository
git clone https://github.com/yourusername/clawbot.git
cd clawbot

# 2. Run the hardened setup script
./secure-docker-setup.sh
```

The script will:
- Generate a strong random token
- Configure strict security settings
- Run the interactive onboarding wizard
- Verify the security configuration
- Start the OpenClaw Gateway

**Save the token displayed at the end!** You'll need it for authentication.

---

## 📖 Usage

### Understanding OpenClaw

**Important:** OpenClaw is not a traditional web application. It's an AI assistant backend that you interact with through:

1. **Command-line interface (CLI)**
2. **Chat applications** (Telegram, WhatsApp, Discord, etc.)
3. **Mobile apps** (iOS/Android)

There is **no standalone web UI** in the browser. The Gateway runs as a WebSocket server.

---

### Method 1: CLI (Command-Line)

#### Basic Usage

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml \
  exec openclaw-gateway node dist/index.js agent \
  --agent main \
  --thinking low \
  --message "Your question here"
```

#### Create a Convenient Alias

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# First, get your repository path
cd /path/to/your/clawbot
CLAWBOT_PATH=$(pwd)

# Add the alias (replace /path/to/clawbot with actual path)
alias claw="docker compose -f /path/to/clawbot/docker-compose.yml -f /path/to/clawbot/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message"
```

**Quick setup (automatic path detection):**

```bash
# Run from clawbot directory
echo "alias claw='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc
source ~/.zshrc
```

**Then use it simply:**

```bash
claw "What's the weather today?"
claw "Create a file in workspace called test.txt"
claw "Explain Docker networking"
```

---

### Method 2: Chat Applications (Recommended)

Configure a messaging channel for mobile/desktop access:

#### Option A: Telegram Bot

1. **Create a Telegram Bot:**
   - Open Telegram
   - Search for `@BotFather`
   - Send `/newbot`
   - Follow the prompts
   - Copy the token (format: `123456789:ABCdef...`)

2. **Add to OpenClaw:**
   ```bash
   docker compose exec openclaw-gateway node dist/index.js channels add \
     --channel telegram \
     --token "YOUR_BOT_TOKEN"
   ```

3. **Start chatting with your bot in Telegram!**

#### Option B: WhatsApp (QR Code)

```bash
docker compose exec openclaw-gateway node dist/index.js channels login
# Scan the QR code with WhatsApp on your phone
```

---

### Method 3: Retrieve Your Token

If you need to access your authentication token:

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml \
  exec openclaw-gateway node dist/index.js config get gateway.auth.token
```

---

## 🛠️ Management Commands

### Start the Gateway

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml up -d openclaw-gateway
```

### Stop the Gateway

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml down
```

### View Logs

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml logs -f openclaw-gateway
```

### Check Health Status

```bash
docker compose exec openclaw-gateway node dist/index.js health
```

### Run Security Audit

```bash
./security-audit.sh
```

---

## 📂 File Structure

```
clawbot/
├── secure-docker-setup.sh          # Hardened setup script (English)
├── security-audit.sh               # Security verification tool (English)
├── SECURITY_CHECKLIST.md           # Complete security guide (English)
├── SECURITY_CHECKLIST.zh-CN.md     # 中英文对照安全指南
├── docker-compose.yml              # Base Docker configuration
├── docker-compose.sandbox.yml      # Sandbox isolation config (auto-generated)
├── docker-setup.sh                 # Official OpenClaw setup script
├── Dockerfile                      # Container image definition
└── .env                            # Environment variables (auto-generated)
```

---

## 🔐 Security Configuration Details

### What's Protected

| Directory/File | AI Access | Notes |
|---------------|-----------|-------|
| `~/.openclaw/workspace` | ✅ Yes | Intended workspace for AI |
| `~/Documents` | ❌ No | Completely isolated |
| `~/Downloads` | ❌ No | Completely isolated |
| `~/Desktop` | ❌ No | Completely isolated |
| System directories | ❌ No | Not mounted to container |

### Network Configuration

- **Gateway bind:** `127.0.0.1` (localhost only)
- **Port mapping:** `127.0.0.1:18789:18789` (not `0.0.0.0`)
- **External access:** Blocked by default
- **Tailscale/VPN:** Configure separately if needed

### Sandbox Isolation

- **Mode:** Docker-in-Docker
- **Workspace access:** `none` (AI code runs in nested containers)
- **Docker socket:** Mounted only for sandbox functionality
- **User:** Non-root (`node` user, UID 1000)

---

## 🔍 Troubleshooting

### Container Won't Start

```bash
# Check container status
docker compose ps

# View recent logs
docker compose logs --tail=50 openclaw-gateway
```

### "Empty Response" Error

This is **normal**! OpenClaw Gateway runs as a WebSocket server, not an HTTP server. Use:
- CLI commands (see [Usage](#usage))
- Chat applications (Telegram, WhatsApp, etc.)

### Reset Configuration

```bash
# Warning: This deletes all data!
docker compose down
rm -rf ~/.openclaw
./secure-docker-setup.sh
```

### Check Security Status

```bash
./security-audit.sh
```

**Expected output:** All items should show green ✓

---

## 📚 Documentation

- **Official OpenClaw Docs:** https://docs.openclaw.ai
- **Getting Started:** https://docs.openclaw.ai/start/getting-started
- **Docker Installation:** https://docs.openclaw.ai/install/docker
- **Channels Setup:** https://docs.openclaw.ai/channels
- **Security Guide:** [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)
- **中文文档:** [SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md)

---

## 🆘 Common Questions

### Q: Where is the Web UI?

**A:** OpenClaw does not have a traditional web UI. Interact via:
- Command-line (see [CLI Usage](#method-1-cli-command-line))
- Messaging apps like Telegram
- Mobile apps (iOS/Android)

### Q: How do I access from my phone?

**A:** Configure a messaging channel (Telegram recommended):
```bash
docker compose exec openclaw-gateway node dist/index.js channels add --channel telegram --token "YOUR_TOKEN"
```

### Q: Is my data safe?

**A:** Yes, with this hardened configuration:
- AI can only access `~/.openclaw/workspace`
- Network access limited to localhost
- Code execution sandboxed in nested containers
- Strong token authentication required

### Q: Can I use multiple AI models?

**A:** Yes! Configure additional providers:
```bash
docker compose exec openclaw-gateway node dist/index.js config set anthropic.apiKey "sk-ant-..."
docker compose exec openclaw-gateway node dist/index.js config set openai.apiKey "sk-..."
```

---

## 🔄 Updating

### Update Docker Image

```bash
# Pull latest image
docker pull openclaw:latest

# Restart with new image
./secure-docker-setup.sh
```

### Update Configuration

```bash
# Re-run interactive setup
docker compose exec openclaw-gateway node dist/index.js configure
```

---

## 📊 Weekly Maintenance Checklist

- [ ] Run `./security-audit.sh` to verify security
- [ ] Check workspace: `ls -lah ~/.openclaw/workspace`
- [ ] Review logs: `docker compose logs --tail=100 openclaw-gateway`
- [ ] Backup config: `tar -czf backup-$(date +%Y%m%d).tar.gz ~/.openclaw`

---

## 🤝 Contributing

This is a security-focused deployment configuration for OpenClaw. For the main project:
- **Upstream:** https://github.com/openclaw/openclaw
- **Discord:** https://discord.gg/clawd

---

## 📄 License

This configuration follows the same MIT License as OpenClaw.

---

## ⚠️ Disclaimer

This setup is designed for **personal use** with maximum security. For multi-user or production deployments, additional hardening may be required. Always:
- Keep your token secret
- Regularly run security audits
- Monitor workspace contents
- Review AI-generated code before execution

---

## 🎯 Quick Command Reference

```bash
# Chat with AI
claw "Your question"

# Add Telegram bot
docker compose exec openclaw-gateway node dist/index.js channels add --channel telegram --token "TOKEN"

# View channels
docker compose exec openclaw-gateway node dist/index.js channels status

# Check health
docker compose exec openclaw-gateway node dist/index.js health

# Security audit
./security-audit.sh

# View logs
docker compose logs -f openclaw-gateway

# Restart
docker compose restart openclaw-gateway
```

---

**Enjoy your secure, private AI assistant!** 🦞✨

For questions or issues, refer to:
- [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) for detailed security guide
- [Official OpenClaw Documentation](https://docs.openclaw.ai)
