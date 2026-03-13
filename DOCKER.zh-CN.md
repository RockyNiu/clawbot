# 🐳 OpenClaw Docker 完整指南

> 使用 Just 任务管理器简化 Docker 操作

## 📖 目录

- [快速开始](#快速开始)
- [安全配置](#安全配置)
- [常用命令](#常用命令)
- [已解决的问题](#已解决的问题)
- [Just 命令完整列表](#just-命令完整列表)
- [配置信息](#配置信息)
- [故障排查](#故障排查)
- [设备配对](#设备配对)
- [Channel 管理](#channel-管理)
- [高级配置](#高级配置)
- [维护与备份](#维护与备份)

---

## 🚀 快速开始

### 前置要求

安装 [just](https://github.com/casey/just)：

```bash
# macOS
brew install just

# Linux
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# 或使用 cargo
cargo install just
```

### ⚠️ 选择安装模式

#### 标准模式（开发/测试）

```bash
# 1. 快速设置（允许 LAN 访问）
just setup

# 2. 打开 Web UI
just open

# 3. 批准设备
just devices
just approve <requestId>
```

**注意**: 标准模式允许 LAN 访问（`GATEWAY_BIND=lan`），适合开发环境。

#### 🔒 安全强化模式（推荐生产环境）

```bash
# 使用安全强化脚本
just setup-secure
```

**安全措施**:
- ✅ **仅 localhost 访问** (`loopback` 绑定)
- ✅ **强制 Token 认证** (自动生成 64 字符随机 Token)
- ✅ **Docker 沙箱隔离**
- ✅ **严格目录权限** (`chmod 700`)
- ✅ **启动后安全验证**

**访问方式**: 只能通过 `http://localhost:18789` 或 `http://127.0.0.1:18789` 访问

### 验证安装

```bash
# 查看所有服务状态
just verify

# 检查健康
just health
# 应该返回：{"ok": true, "status": "live"}
```

---

## 🔒 安全配置

### 安全模式对比

| 模式 | 网络绑定 | 访问范围 | 适用场景 | 安全级别 |
|------|----------|----------|----------|----------|
| **安全模式** | `loopback` | 仅本机 | 生产环境 | ⭐⭐⭐⭐⭐ |
| **标准模式** | `lan` | 本地网络 | 开发测试 | ⭐⭐⭐ |

### 切换安全模式

#### 🔒 锁定为安全模式（仅 localhost）

```bash
just security-lock
```

**效果**:
- 仅允许 `localhost` 访问
- 设置目录权限为 `700`
- 自动重启 Gateway

**访问**: 只能通过 `http://localhost:18789` 或 Tailscale/SSH 隧道

#### 🔓 解锁为开发模式（允许 LAN）

```bash
just security-unlock
```

**效果**:
- 允许 LAN 访问
- 可从局域网其他设备访问

**⚠️ 警告**: 仅在可信网络环境使用

### 查看安全状态

```bash
just security-status
```

**输出示例**:
```
=== 安全配置状态 ===

网络绑定:
loopback

目录权限:
drwx------  10 user  staff   320 Mar 13 00:00 ~/.openclaw
drwx------   5 user  staff   160 Mar 13 00:00 ~/.openclaw/workspace

Token 配置:
dbdf19983316b54c024d...

沙箱模式:
non-main
```

### 安全最佳实践

#### ✅ 推荐做法

1. **生产环境**: 始终使用 `just setup-secure` 或 `just security-lock`
2. **Token 管理**:
   - 使用强随机 Token（64+ 字符）
   - 定期轮换 Token
   - 不要将 Token 提交到 Git
3. **网络隔离**:
   - 生产环境使用 `loopback` 绑定
   - 需要远程访问时使用 Tailscale 或 SSH 隧道
4. **目录权限**:
   ```bash
   chmod 700 ~/.openclaw
   chmod 700 ~/.openclaw/workspace
   ```
5. **定期审计**:
   ```bash
   just devices        # 检查已配对设备
   just security-status # 检查安全配置
   ```

#### ❌ 避免做法

1. ❌ 在公网暴露端口（18789/18790）
2. ❌ 使用弱 Token 或默认 Token
3. ❌ 在不可信网络使用 `lan` 绑定
4. ❌ 配置目录权限过宽（如 755 或 777）
5. ❌ 禁用 Token 认证

### 远程安全访问

如需从其他设备访问，推荐以下方式：

#### 方案 1: Tailscale（推荐）

```bash
# 1. 在 Gateway 主机安装 Tailscale
# 2. 使用安全模式
just setup-secure

# 3. 从其他设备通过 Tailscale IP 访问
# http://100.x.x.x:18789
```

#### 方案 2: SSH 隧道

```bash
# 在本地机器
ssh -L 18789:localhost:18789 user@gateway-host

# 然后访问 http://localhost:18789
```

#### 方案 3: Reverse Proxy（高级）

使用 Nginx/Caddy + TLS，配置：
- HTTPS 加密
- 客户端证书认证
- IP 白名单

---

## 🎮 常用命令

### 日常使用的 10 个核心命令

```bash
just --list      # 查看所有命令（推荐先看这个）
just logs        # 查看日志（最常用）
just health      # 检查健康状态
just devices     # 查看/批准设备
just restart     # 重启服务

just up          # 启动服务
just down        # 停止服务
just open        # 打开 Web UI
just token       # 查看 Gateway Token
just diagnose    # 完整诊断信息
```

### 服务管理

```bash
just up          # 启动所有服务
just down        # 停止所有服务
just restart     # 重启 Gateway
just ps          # 查看容器状态
just reup        # 完全重启（停止 -> 启动）
```

### 日志与监控

```bash
just logs        # 查看实时日志（Ctrl+C 退出）
just logs-tail   # 查看最近 50 行日志
just stats       # 查看资源使用情况
just check-bind  # 查看 Gateway 绑定地址
```

### 健康检查

```bash
just health      # HTTP 健康检查（JSON 格式）
just health-cli  # CLI 健康检查
just verify      # 验证所有服务状态（推荐）
```

### CLI 操作

```bash
# 运行任意 CLI 命令
just cli <args>

# 示例
just cli health
just cli channels status
just cli config get

# 在运行的容器中执行
just exec <args>

# 进入容器 shell
just shell
```

### 配置管理

```bash
just config-get                           # 查看所有配置
just config-get-key gateway.bind          # 查看特定配置
just config-set <key> <value>             # 设置配置

# 示例：设置 API Key
just config-set providers.openai.apiKey "sk-..."
just config-set providers.anthropic.apiKey "sk-ant-..."

# Token 管理
just token                                # 显示 Gateway Token
just sync-token                           # 同步 Token
```

### 快捷功能

```bash
just open        # 打开 Web UI
just open-canvas # 打开 Canvas
just urls        # 显示所有访问地址
```

---

## ✨ 已解决的问题

### ✅ 问题 1: `claw` 命令不存在

**原因**: 容器内只有 `openclaw` 命令，没有 `claw`

**解决方案**:
```bash
# 使用 Just 任务管理
just cli health       # 运行 CLI 命令
just --list           # 查看所有可用命令
```

### ✅ 问题 2: `openclaw gateway --force` 失败

**错误信息**: `fuser not found; required for --force when lsof is unavailable`

**原因**:
- Docker 容器使用精简镜像，缺少 `fuser` 工具
- Gateway 已经通过 docker-compose 运行

**解决方案**:
```bash
just restart          # 重启 Gateway
just logs             # 查看日志
```

### ✅ 问题 3: Token 不匹配

**错误信息**: `unauthorized: gateway token mismatch`

**原因**: CLI 和 Gateway 的 Token 不一致

**解决方案**:
```bash
# 方法 1: 一键修复（推荐）
just fix-token

# 方法 2: 手动修复
just token            # 查看 Token
just sync-token       # 同步 Token
```

### ✅ 问题 4: localhost:18789 无法访问

**错误信息**: `Connection refused`

**原因**: Gateway 绑定到容器内的 `127.0.0.1`，无法从宿主机访问

**解决方案**:
```bash
# 方法 1: 一键修复（推荐）
just fix-bind

# 方法 2: 手动修复
just config-set gateway.bind lan
just restart

# 验证（应该看到 "listening on ws://0.0.0.0:18789"）
just check-bind
just health
```

**验证绑定地址**:
```bash
# ✅ 正确（可以从宿主机访问）
listening on ws://0.0.0.0:18789

# ❌ 错误（只能容器内访问）
listening on ws://127.0.0.1:18789
```

### ✅ 问题 5: 设备配对 (Pairing required)

**原因**: 首次从浏览器访问需要设备配对

**解决方案**:
```bash
# 1. 查看待批准的设备
just devices

# 2. 批准设备（使用上面显示的 Request ID）
just approve <requestId>

# 示例
just approve 477e0a68-488c-4136-a6e8-5bd2c1ede17e

# 3. 验证设备已配对
just devices
```

**自动批准**（仅开发环境）:
```bash
just auto-approve
```

---

## 📋 Just 命令完整列表

### 服务管理
- `just up` - 启动所有服务
- `just down` - 停止所有服务
- `just restart` - 重启 Gateway
- `just ps` - 查看容器状态
- `just reup` - 完全重启（停止 -> 启动）

### 构建
- `just build` - 构建 Docker 镜像
- `just rebuild` - 重新构建并启动
- `just build-browser` - 构建（包含浏览器支持，+300MB）
- `just build-sandbox` - 构建（包含 Docker CLI，用于沙箱）

### 日志与监控
- `just logs` - 查看实时日志
- `just logs-tail` - 查看最近 50 行日志
- `just stats` - 查看资源使用统计
- `just check-bind` - 查看 Gateway 绑定地址

### CLI 命令
- `just cli <args>` - 运行任意 CLI 命令
- `just exec <args>` - 在运行的容器中执行命令
- `just shell` - 进入容器 shell

### 健康检查
- `just health` - HTTP 健康检查（JSON 格式）
- `just health-cli` - CLI 健康检查
- `just verify` - 验证所有服务状态

### 配置管理
- `just config-get` - 查看所有配置
- `just config-get-key <key>` - 查看特定配置
- `just config-set <key> <value>` - 设置配置
- `just token` - 显示 Gateway Token
- `just sync-token` - 同步 Token

### 设备管理
- `just devices` - 查看设备列表
- `just approve <id>` - 批准设备配对
- `just auto-approve` - 启用自动批准（仅开发环境）

### 安全配置
- `just setup-secure` - 安全强化设置（推荐生产环境）
- `just security-lock` - 锁定为安全模式（仅 localhost）
- `just security-unlock` - 解锁为开发模式（允许 LAN）
- `just security-status` - 查看安全配置状态

### Channel 管理
- `just channels` - 查看 Channel 状态
- `just add-telegram <token>` - 添加 Telegram Channel
- `just add-discord <token>` - 添加 Discord Channel
- `just login-whatsapp` - 登录 WhatsApp（交互式）

### 故障排查
- `just fix-bind` - 修复 localhost 无法访问问题
- `just fix-token` - 修复 Token 不匹配问题
- `just diagnose` - 查看完整诊断信息

### 快捷功能
- `just open` - 打开 Web UI (http://localhost:18789)
- `just open-canvas` - 打开 Canvas
- `just urls` - 显示所有访问地址

### 维护
- `just clean` - 清理未使用的 Docker 资源
- `just clean-all` - 完全清理（包括 volumes）
- `just backup` - 备份配置到 `~/.openclaw.backup.YYYYMMDD_HHMMSS`
- `just cat-config` - 查看配置文件（JSON 格式）

### 开发
- `just dev` - 开发模式（启动 + 实时日志）
- `just setup` - 完整设置（首次使用）
- `just test` - 快速测试（构建 -> 验证）

---

## 🔧 配置信息

### Gateway Token

查看 Token:
```bash
just token
```

### 访问地址

```bash
just urls  # 显示所有地址
```

- **Web UI**: http://localhost:18789
- **Health**: http://localhost:18789/healthz
- **Ready**: http://localhost:18789/readyz
- **Canvas**: http://localhost:18789/__openclaw__/canvas/

### 配置文件位置

**在宿主机**:
- 配置文件: `~/.openclaw/openclaw.json`
- 工作区: `~/.openclaw/workspace/`
- 环境变量: `./.env`

**在容器内**:
- 配置文件: `/home/node/.openclaw/openclaw.json`
- 工作区: `/home/node/.openclaw/workspace/`
- 二进制: `/usr/local/bin/openclaw`

### 默认设置

```bash
# 查看当前配置
just config-get
```

默认配置:
- **Gateway Bind**: `lan` (监听所有网络接口)
- **Gateway Port**: `18789`
- **Bridge Port**: `18790`
- **Gateway Mode**: `local`
- **Sandbox**: 可配置

---

## 🐛 故障排查

### Connection refused（无法访问 localhost:18789）

**快速修复**:
```bash
just fix-bind
```

**手动修复**:
```bash
# 1. 检查绑定地址
just check-bind

# 2. 设置为 LAN 模式
just config-set gateway.bind lan

# 3. 修改 .env 文件
# 编辑 .env，将 OPENCLAW_GATEWAY_BIND=loopback 改为 lan

# 4. 重启 Gateway
just restart

# 5. 验证
just health
```

### Token 不匹配

**快速修复**:
```bash
just fix-token
```

**手动修复**:
```bash
# 1. 查看 Token
just token

# 2. 同步 Token
just sync-token

# 3. 测试连接
just health-cli
```

### 设备需要配对

```bash
# 查看待批准设备
just devices

# 批准设备
just approve <requestId>

# 或启用自动批准（仅开发环境）
just auto-approve
```

### 容器无法启动

```bash
# 1. 查看详细日志
just logs

# 2. 查看诊断信息
just diagnose

# 3. 重新构建
just rebuild

# 4. 完全清理后重建
just clean-all
just setup
```

### 完整诊断

```bash
just diagnose
```

这会显示:
- Docker 容器状态
- Gateway 绑定地址
- Gateway Token
- 配置文件中的 Token
- 设备列表
- HTTP 健康检查结果

---

## 🔐 设备配对

当首次从浏览器或新设备访问 Gateway 时，需要进行设备配对。

### 批准配对请求

```bash
# 1. 查看待批准的设备
just devices

# 输出示例：
# Pending (1)
# ┌──────────────────────────────────────┬─────────────────────┬──────────┬────────────┐
# │ Request                              │ Device              │ Role     │ IP         │
# ├──────────────────────────────────────┼─────────────────────┼──────────┼────────────┤
# │ 477e0a68-488c-4136-a6e8-5bd2c1ede17e │ 11d18a8e6355e3c3... │ operator │ 172.21.0.1 │
# └──────────────────────────────────────┴─────────────────────┴──────────┴────────────┘

# 2. 批准设备（使用上面的 Request ID）
just approve 477e0a68-488c-4136-a6e8-5bd2c1ede17e

# 3. 验证设备已配对
just devices
```

### 自动批准（开发环境）

如果你想自动批准所有设备（**不推荐生产环境**）：

```bash
just auto-approve
```

### 管理已配对设备

```bash
# 查看所有设备
just devices

# 移除设备（使用完整的 docker compose 命令）
docker compose run --rm openclaw-cli openclaw devices remove <deviceId>

# 查看设备详情
docker compose run --rm openclaw-cli openclaw devices info <deviceId>
```

---

## 📡 Channel 管理

### 查看 Channel 状态

```bash
just channels
```

### 添加 Telegram Channel

```bash
just add-telegram "YOUR_BOT_TOKEN"

# 示例
just add-telegram "123456:ABCDEF..."
```

### 添加 Discord Channel

```bash
just add-discord "YOUR_BOT_TOKEN"
```

### 登录 WhatsApp（交互式）

```bash
just login-whatsapp
# 会显示 QR 码，用 WhatsApp 扫描
```

### 手动添加其他 Channels

```bash
# 使用通用 CLI 命令
just cli channels add --channel <channel-name> --token <token>

# 示例：添加 Slack
just cli channels add --channel slack --token "xoxb-..."
```

---

## 🔧 高级配置

### 构建选项

#### 包含浏览器支持

```bash
just build-browser
# 或手动
docker build --build-arg OPENCLAW_INSTALL_BROWSER=1 -t openclaw:local .
```

- 增加约 300MB
- 用于浏览器自动化
- 包含 Chromium 和 Xvfb

#### 包含沙箱支持

```bash
just build-sandbox
# 或手动
docker build --build-arg OPENCLAW_INSTALL_DOCKER_CLI=1 -t openclaw:local .
```

- 增加约 50MB
- 用于 `agents.defaults.sandbox` 功能
- 包含 Docker CLI

#### 安装额外的系统包

修改 `.env` 文件：
```bash
OPENCLAW_DOCKER_APT_PACKAGES="python3 wget curl vim"
```

然后重新构建：
```bash
just rebuild
```

#### 使用 Slim 变体（更小的镜像）

手动构建：
```bash
docker build --build-arg OPENCLAW_VARIANT=slim -t openclaw:local .
```

### 沙箱模式配置

当前已启用沙箱模式，配置如下：

```bash
# 查看沙箱配置
just config-get-key agents.defaults.sandbox.mode
just config-get-key agents.defaults.sandbox.scope
```

沙箱模式需要：
1. Docker CLI 在镜像中（已安装）
2. Docker socket 挂载到容器（已配置）
3. 正确的组权限（已设置）

### 环境变量配置

编辑 `.env` 文件来配置环境变量：

```bash
# Gateway 配置
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_TOKEN=your-token-here

# API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# 其他配置
OPENCLAW_SANDBOX=1
```

修改后重启服务：
```bash
just restart
```

---

## 💾 维护与备份

### 备份配置

```bash
# 自动备份（推荐）
just backup

# 输出示例：
# ✅ 配置已备份到: ~/.openclaw.backup.20260313_120000

# 手动备份
cp -r ~/.openclaw ~/.openclaw.backup.$(date +%Y%m%d)
cp .env .env.backup.$(date +%Y%m%d)
```

### 恢复配置

```bash
# 恢复配置
cp -r ~/.openclaw.backup.20260313/* ~/.openclaw/

# 重启服务
just restart
```

### 清理资源

```bash
# 清理未使用的 Docker 资源
just clean

# 完全清理（包括 volumes，会删除数据！）
just clean-all
```

### 更新流程

```bash
# 1. 备份配置
just backup

# 2. 拉取最新代码
git pull

# 3. 重新构建并启动
just rebuild

# 4. 验证
just verify
```

### 查看配置文件

```bash
# JSON 格式查看
just cat-config

# 或直接查看
cat ~/.openclaw/openclaw.json
```

---

## 📊 监控与调试

### 查看容器状态

```bash
# 查看所有容器
just ps

# 查看资源使用
just stats

# 查看实时日志
just logs

# 查看最近日志
just logs-tail
```

### 进入容器调试

```bash
# 进入容器 shell
just shell

# 在容器内
$ openclaw --help
$ openclaw health
$ ps aux
$ cat /home/node/.openclaw/openclaw.json
```

### 网络调试

```bash
# 检查端口监听（在宿主机）
lsof -i :18789

# 测试 HTTP 访问
curl http://localhost:18789/healthz

# 查看 Gateway 绑定地址
just check-bind
```

---

## 🎓 下一步

### 1. 配置 API Key

```bash
# 配置 Anthropic (Claude)
just config-set providers.anthropic.apiKey "sk-ant-..."

# 或配置 OpenAI (GPT)
just config-set providers.openai.apiKey "sk-..."

# 或配置 Google (Gemini)
just config-set providers.google.apiKey "..."
```

### 2. 添加 Channels

```bash
# Telegram
just add-telegram "BOT_TOKEN"

# Discord
just add-discord "BOT_TOKEN"

# WhatsApp
just login-whatsapp
```

### 3. 查看状态

```bash
# 查看所有服务
just verify

# 查看 Channels
just channels

# 查看配置
just config-get
```

### 4. 开始使用

访问 Web UI:
```bash
just open
```

或直接访问: http://localhost:18789

---

## 📞 获取帮助

### 查看帮助

```bash
# 查看所有 Just 命令
just --list

# 查看完整诊断信息
just diagnose

# 查看实时日志
just logs
```

### 参考资源

- **Justfile 源码**: [justfile](./justfile)
- **Docker Compose**: [docker-compose.yml](./docker-compose.yml)
- **Dockerfile**: [Dockerfile](./Dockerfile)
- **官方文档**: https://docs.openclaw.ai/install/docker
- **GitHub**: https://github.com/openclaw/openclaw

### 常见问题

如遇到问题，请按以下顺序排查：

1. **查看日志**: `just logs`
2. **运行诊断**: `just diagnose`
3. **检查健康**: `just health`
4. **查看文档**: 本文档的"故障排查"章节
5. **重新构建**: `just rebuild`

---

## ✅ 验证清单

在开始使用前，请运行以下命令验证：

```bash
just verify    # 验证所有服务
```

手动验证项目：
- [ ] Just 已安装 (`just --version`)
- [ ] Docker 正在运行 (`docker ps`)
- [ ] Gateway 已启动 (`just ps`)
- [ ] 可以访问 Gateway (`just health`)
- [ ] Token 已生成 (`just token`)
- [ ] 设备已配对 (`just devices`)
- [ ] CLI 可以连接 (`just health-cli`)

**所有检查通过后即可开始使用！** 🎉

---

## 💡 Tips

- 使用 `just` + Tab 键可以自动补全命令（需要 shell 支持）
- `just logs` 查看日志，按 Ctrl+C 退出
- `just diagnose` 可以看到完整的系统状态，是排查问题的第一步
- 所有配置都保存在 `~/.openclaw/` 目录，可以直接编辑
- 修改 `.env` 文件后需要 `just restart` 才能生效
- 重要操作前建议先 `just backup` 备份配置

---

**文档最后更新**: 2026-03-13

---

📖 **相关文档**:
- [DOCKER.md](./DOCKER.md) - English version
- [DOCKER-SECURITY.zh-CN.md](./DOCKER-SECURITY.zh-CN.md) - 安全配置快速参考
