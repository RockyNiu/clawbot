# 📖 OpenClaw 使用指南 / Usage Guide

## 🗂️ 文档索引 / Documentation Index

本仓库包含以下文档 / This repository contains the following documentation:

| 文件 / File | 用途 / Purpose | 语言 / Language |
|------------|---------------|----------------|
| **[README.md](README.md)** | 官方 OpenClaw 完整文档<br/>Official OpenClaw documentation | English |
| **[README.HARDENED.md](README.HARDENED.md)** | Docker 加固版部署指南<br/>Hardened Docker deployment guide | English |
| **[SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)** | 安全配置检查清单<br/>Security configuration checklist | English |
| **[SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md)** | 安全配置检查清单（中英对照）<br/>Security checklist (CN/EN) | 中英对照<br/>Bilingual |

---

## 🚀 快速开始 / Quick Start

### 如果你想要最保守的安全配置 / For maximum security setup

➡️ **阅读 / Read:** [README.HARDENED.md](README.HARDENED.md)

```bash
./secure-docker-setup.sh
```

### 如果你想了解 OpenClaw 的完整功能 / For full OpenClaw features

➡️ **阅读 / Read:** [README.md](README.md)

---

## 💬 OpenClaw 的使用方式 / How to Use OpenClaw

**重要 / Important:** OpenClaw **不是**传统的 Web 应用 / OpenClaw is **not** a traditional web application.

### 交互方式 / Interaction Methods

#### 1️⃣ 命令行 / Command-Line (CLI)

```bash
# 基本用法 / Basic usage
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml \
  exec openclaw-gateway node dist/index.js agent \
  --agent main --thinking low \
  --message "Your question here"

# 创建别名后使用 / After creating alias
claw "Hello!"
```

**设置别名 / Set up alias:**
```bash
# 在 clawbot 目录运行 / Run from clawbot directory
cd /path/to/clawbot
echo "alias claw='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc

# 重新加载 / Reload
source ~/.zshrc
```

#### 2️⃣ 聊天应用 / Chat Applications

**推荐 / Recommended:** Telegram, WhatsApp, Discord, Signal...

```bash
# 添加 Telegram
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --token "YOUR_BOT_TOKEN"

# WhatsApp QR 扫码
docker compose exec openclaw-gateway node dist/index.js channels login
```

详细步骤见 / Detailed steps in: [README.HARDENED.md](README.HARDENED.md)

---

## 🔐 安全性说明 / Security Notes

### 本仓库的加固配置包含 / This hardened setup includes:

- ✅ 仅本机访问（127.0.0.1）/ Localhost-only binding
- ✅ Docker-in-Docker 沙盒 / Docker-in-Docker sandbox
- ✅ 64 字符 Token 认证 / 64-character token authentication
- ✅ 最小权限挂载 / Minimal privilege mounts
- ✅ 非 root 用户运行 / Non-root container execution

### 你的数据隔离情况 / Your Data Isolation

| 目录 / Directory | AI 可访问？ / AI Access | 说明 / Notes |
|-----------------|---------------------|-------------|
| `~/.openclaw/workspace` | ✅ 可以 / Yes | AI 工作区 / AI workspace |
| `~/Documents` | ❌ **不可以** / No | 完全隔离 / Isolated |
| `~/Downloads` | ❌ **不可以** / No | 完全隔离 / Isolated |
| `~/Desktop` | ❌ **不可以** / No | 完全隔离 / Isolated |

---

## 🛠️ 常用命令 / Common Commands

```bash
# 启动 / Start
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml up -d

# 停止 / Stop
docker compose down

# 查看日志 / View logs
docker compose logs -f openclaw-gateway

# 安全审计 / Security audit
./security-audit.sh

# 健康检查 / Health check
docker compose exec openclaw-gateway node dist/index.js health
```

---

## 📚 更多资源 / More Resources

- 官方文档 / Official Docs: https://docs.openclaw.ai
- Discord 社区 / Discord: https://discord.gg/clawd
- GitHub 上游 / Upstream: https://github.com/openclaw/openclaw

---

## ❓ 常见问题 / FAQ

### Q: 为什么浏览器访问显示 "Empty Response"?

**A:** 这是正常的！OpenClaw Gateway 是 WebSocket 服务器，不是 HTTP 服务器。

请使用：
- 命令行（见上方）
- 聊天应用（Telegram 等）

### Q: 如何从手机访问？

**A:** 配置聊天渠道（推荐 Telegram）：

```bash
docker compose exec openclaw-gateway node dist/index.js channels add \
  --channel telegram --token "YOUR_TOKEN"
```

### Q: 我的数据安全吗？

**A:** 是的！使用本仓库的加固配置：
- AI 只能访问 `~/.openclaw/workspace`
- 网络限制为本机
- 代码执行在沙盒容器中
- 需要强 Token 认证

---

**需要帮助？ / Need Help?**

参考详细文档 / See detailed documentation:
- [README.HARDENED.md](README.HARDENED.md) - 加固版设置 / Hardened setup
- [SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md) - 中英文安全清单 / Bilingual security guide
