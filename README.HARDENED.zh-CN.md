# 🦞 OpenClaw — 个人 AI 助手（Docker 加固版部署）

> **📚 想查看官方 OpenClaw 文档？**
> 请参阅 [README.md](README.md) 获取完整的上游文档。
>
> **🌐 English Version / 英文版:** [README.HARDENED.md](README.HARDENED.md)

<p align="center">
  <strong>Docker 部署的最大安全配置</strong>
</p>

---

## 📋 概述

本仓库包含在 Docker 中运行 [OpenClaw](https://github.com/openclaw/openclaw) 的**加固安全配置**，提供最大程度的隔离和保护。

**OpenClaw** 是你在自己设备上运行的个人 AI 助手。它可以在你已经使用的渠道（Telegram、WhatsApp、Slack、Discord、Signal 等）上回答你的问题，或通过命令行界面交互。

---

## 🔒 安全特性

此配置启用：

- ✅ **仅本机绑定**（无外部网络访问）
- ✅ **Docker-in-Docker 沙盒**（隔离代码执行）
- ✅ **64 字符 Token 认证**
- ✅ **最小文件系统挂载**（仅 workspace 可访问）
- ✅ **非 root 容器执行**
- ✅ **敏感目录 700 权限**

---

## 🚀 快速开始

### 前置要求

- 已安装 Docker 和 Docker Compose
- 可用的 `openssl` 命令
- macOS、Linux 或 Windows 上的 WSL2

### 安装

```bash
# 1. 克隆此仓库
git clone https://github.com/yourusername/clawbot.git
cd clawbot

# 2. 运行加固设置脚本
./secure-docker-setup.sh
```

脚本将会：
- 生成强随机 Token
- 配置严格的安全设置
- 运行交互式引导向导
- 验证安全配置
- 启动 OpenClaw Gateway

**请保存最后显示的 Token！** 您需要它进行身份验证。

---

## 📖 使用方法

### 理解 OpenClaw

**重要：** OpenClaw 不是传统的 Web 应用程序。它是一个 AI 助手后端，您可以通过以下方式与之交互：

1. **命令行界面（CLI）**
2. **聊天应用**（Telegram、WhatsApp、Discord 等）
3. **移动应用**（iOS/Android）

浏览器中**没有独立的 Web UI**。Gateway 作为 WebSocket 服务器运行。

---

### 方式 1：CLI（命令行）

#### 基本用法

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml \
  exec openclaw-gateway node dist/index.js agent \
  --agent main \
  --thinking low \
  --message "你的问题"
```

#### 创建方便的别名

添加到 `~/.zshrc` 或 `~/.bashrc`：

```bash
# 首先，获取你的仓库路径
cd /path/to/your/clawbot
CLAWBOT_PATH=$(pwd)

# 添加别名（将 /path/to/clawbot 替换为实际路径）
alias claw="docker compose -f /path/to/clawbot/docker-compose.yml -f /path/to/clawbot/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message"
```

**快速设置（自动检测路径）：**

```bash
# 在 clawbot 目录中运行
echo "alias claw='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc
source ~/.zshrc
```

**然后简单使用：**

```bash
claw "今天天气怎么样？"
claw "在 workspace 创建一个名为 test.txt 的文件"
claw "解释 Docker 网络"
```

---

### 方式 2：聊天应用（推荐）

配置消息渠道以便移动/桌面访问：

#### 选项 A：Telegram Bot

1. **创建 Telegram Bot：**
   - 打开 Telegram
   - 搜索 `@BotFather`
   - 发送 `/newbot`
   - 按照提示操作
   - 复制 Token（格式：`123456789:ABCdef...`）

2. **添加到 OpenClaw：**
   ```bash
   docker compose exec openclaw-gateway node dist/index.js channels add \
     --channel telegram \
     --token "你的_BOT_TOKEN"
   ```

3. **开始在 Telegram 中与你的 bot 聊天！**

#### 选项 B：WhatsApp（扫码）

```bash
docker compose exec openclaw-gateway node dist/index.js channels login
# 用手机上的 WhatsApp 扫描二维码
```

---

### 方式 3：获取您的 Token

如果需要访问您的认证 Token：

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml \
  exec openclaw-gateway node dist/index.js config get gateway.auth.token
```

---

## 🛠️ 管理命令

### 启动 Gateway

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml up -d openclaw-gateway
```

### 停止 Gateway

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml down
```

### 查看日志

```bash
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml logs -f openclaw-gateway
```

### 检查健康状态

```bash
docker compose exec openclaw-gateway node dist/index.js health
```

### 运行安全审计

```bash
./security-audit.sh
```

---

## 📂 文件结构

```
clawbot/
├── secure-docker-setup.sh          # 加固设置脚本（英文）
├── security-audit.sh               # 安全验证工具（英文）
├── SECURITY_CHECKLIST.md           # 完整安全指南（英文）
├── SECURITY_CHECKLIST.zh-CN.md     # 中英文对照安全指南
├── README.HARDENED.md              # 加固版说明（英文）
├── README.HARDENED.zh-CN.md        # 加固版说明（中文）
├── docker-compose.yml              # 基础 Docker 配置
├── docker-compose.sandbox.yml      # 沙盒隔离配置（自动生成）
├── docker-setup.sh                 # 官方 OpenClaw 设置脚本
├── Dockerfile                      # 容器镜像定义
└── .env                            # 环境变量（自动生成）
```

---

## 🔐 安全配置详情

### 受保护内容

| 目录/文件 | AI 访问 | 备注 |
|----------|--------|------|
| `~/.openclaw/workspace` | ✅ 可以 | AI 的预期工作区 |
| `~/Documents` | ❌ 不可以 | 完全隔离 |
| `~/Downloads` | ❌ 不可以 | 完全隔离 |
| `~/Desktop` | ❌ 不可以 | 完全隔离 |
| 系统目录 | ❌ 不可以 | 未挂载到容器 |

### 网络配置

- **Gateway 绑定：** `127.0.0.1`（仅本机）
- **端口映射：** `127.0.0.1:18789:18789`（非 `0.0.0.0`）
- **外部访问：** 默认阻止
- **Tailscale/VPN：** 如需要请单独配置

### 沙盒隔离

- **模式：** Docker-in-Docker
- **Workspace 访问：** `none`（AI 代码在嵌套容器中运行）
- **Docker socket：** 仅为沙盒功能挂载
- **用户：** 非 root（`node` 用户，UID 1000）

---

## 🔍 故障排除

### 容器无法启动

```bash
# 检查容器状态
docker compose ps

# 查看最近日志
docker compose logs --tail=50 openclaw-gateway
```

### "Empty Response" 错误

这是**正常的**！OpenClaw Gateway 作为 WebSocket 服务器运行，而不是 HTTP 服务器。请使用：
- CLI 命令（见[使用方法](#使用方法)）
- 聊天应用（Telegram、WhatsApp 等）

### 重置配置

```bash
# 警告：这会删除所有数据！
docker compose down
rm -rf ~/.openclaw
./secure-docker-setup.sh
```

### 检查安全状态

```bash
./security-audit.sh
```

**期望输出：** 所有项目应显示绿色 ✓

---

## 📚 文档

- **官方 OpenClaw 文档：** https://docs.openclaw.ai
- **入门指南：** https://docs.openclaw.ai/start/getting-started
- **Docker 安装：** https://docs.openclaw.ai/install/docker
- **渠道设置：** https://docs.openclaw.ai/channels
- **安全指南：** [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)
- **中文文档：** [SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md)

---

## 🆘 常见问题

### Q: Web UI 在哪里？

**A:** OpenClaw 没有传统的 Web UI。通过以下方式交互：
- 命令行（见 [CLI 使用](#方式-1cli命令行)）
- 消息应用如 Telegram
- 移动应用（iOS/Android）

### Q: 如何从手机访问？

**A:** 配置消息渠道（推荐 Telegram）：
```bash
docker compose exec openclaw-gateway node dist/index.js channels add --channel telegram --token "你的_TOKEN"
```

### Q: 我的数据安全吗？

**A:** 是的，使用此加固配置：
- AI 只能访问 `~/.openclaw/workspace`
- 网络访问限制为本机
- 代码执行在嵌套容器中沙盒化
- 需要强 Token 认证

### Q: 可以使用多个 AI 模型吗？

**A:** 可以！配置其他提供商：
```bash
docker compose exec openclaw-gateway node dist/index.js config set anthropic.apiKey "sk-ant-..."
docker compose exec openclaw-gateway node dist/index.js config set openai.apiKey "sk-..."
```

---

## 🔄 更新

### 更新 Docker 镜像

```bash
# 拉取最新镜像
docker pull openclaw:latest

# 使用新镜像重启
./secure-docker-setup.sh
```

### 更新配置

```bash
# 重新运行交互式设置
docker compose exec openclaw-gateway node dist/index.js configure
```

---

## 📊 每周维护清单

- [ ] 运行 `./security-audit.sh` 验证安全性
- [ ] 检查 workspace：`ls -lah ~/.openclaw/workspace`
- [ ] 查看日志：`docker compose logs --tail=100 openclaw-gateway`
- [ ] 备份配置：`tar -czf backup-$(date +%Y%m%d).tar.gz ~/.openclaw`

---

## 🤝 贡献

这是 OpenClaw 的安全聚焦部署配置。主项目：
- **上游：** https://github.com/openclaw/openclaw
- **Discord：** https://discord.gg/clawd

---

## 📄 许可证

此配置遵循与 OpenClaw 相同的 MIT 许可证。

---

## ⚠️ 免责声明

此设置专为**个人使用**设计，具有最大安全性。对于多用户或生产部署，可能需要额外的加固。始终：
- 保密您的 Token
- 定期运行安全审计
- 监控 workspace 内容
- 在执行前审查 AI 生成的代码

---

## 🎯 快速命令参考

```bash
# 与 AI 聊天
claw "你的问题"

# 添加 Telegram bot
docker compose exec openclaw-gateway node dist/index.js channels add --channel telegram --token "TOKEN"

# 查看渠道
docker compose exec openclaw-gateway node dist/index.js channels status

# 检查健康
docker compose exec openclaw-gateway node dist/index.js health

# 安全审计
./security-audit.sh

# 查看日志
docker compose logs -f openclaw-gateway

# 重启
docker compose restart openclaw-gateway
```

---

**享受您安全、私密的 AI 助手！** 🦞✨

有疑问或问题，请参考：
- [SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md) 详细安全指南
- [官方 OpenClaw 文档](https://docs.openclaw.ai)
