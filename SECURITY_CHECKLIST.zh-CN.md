# OpenClaw 安全配置检查清单 / OpenClaw Security Configuration Checklist

## 🔒 启动前检查 / Pre-Launch Checks

### 1. 环境准备 / Environment Preparation
- [ ] 已安装 Docker 和 Docker Compose / Docker and Docker Compose installed
- [ ] 已安装 `openssl` 命令（生成 Token）/ `openssl` command available (for token generation)
- [ ] 当前用户在 `docker` 组中（或有 Docker 权限）/ Current user is in the `docker` group (or has Docker permissions)

### 2. 敏感文件保护 / Sensitive File Protection
- [ ] 确认 `~/.openclaw/workspace` 不包含现有敏感文件 / Confirm `~/.openclaw/workspace` does not contain existing sensitive files
- [ ] 确认不会意外挂载 `~/Documents`、`~/Downloads` 等目录 / Confirm you will not accidentally mount `~/Documents`, `~/Downloads`, etc.
- [ ] 设置环境变量前检查：`echo $OPENCLAW_EXTRA_MOUNTS`（应为空）/ Check environment variables before setting: `echo $OPENCLAW_EXTRA_MOUNTS` (should be empty)

### 3. 网络安全配置 / Network Security Configuration
- [ ] 决定是否需要外部访问（如不需要，强制使用 `loopback`）/ Decide if external access is needed (if not, force `loopback`)
- [ ] 如需外部访问，准备好 Tailscale 或 VPN 方案 / If external access needed, prepare Tailscale or VPN solution

---

## 🚀 启动流程（最保守配置）/ Launch Procedure (Maximum Security Configuration)

### 方式 A：使用加固脚本（推荐）/ Option A: Using Hardened Script (Recommended)
```bash
# 1. 运行加固版设置脚本 / Run hardened setup script
./secure-docker-setup.sh

# 2. 保存输出的 Token（重要！）/ Save the output token (important!)
# 示例输出 / Example output:
#   您的 Gateway Token（请妥善保存）/ Your Gateway Token (save this securely):
#   a1b2c3d4e5f6...（64 字符 / 64 characters）

# 3. 将 Token 保存到密码管理器 / Save token to password manager
```

### 方式 B：手动配置 / Option B: Manual Configuration
```bash
# 1. 设置环境变量 / Set environment variables
export OPENCLAW_GATEWAY_BIND=loopback
export OPENCLAW_SANDBOX=1
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)

# 2. 运行官方脚本 / Run official script
./docker-setup.sh

# 3. 保存 Token / Save token
echo "Token: $OPENCLAW_GATEWAY_TOKEN" > ~/.openclaw/TOKEN.txt
chmod 600 ~/.openclaw/TOKEN.txt
```

---

## ✅ 启动后验证 / Post-Launch Verification

### 1. 运行安全审计 / Run Security Audit
```bash
./security-audit.sh
```

**期望输出（所有项目应为绿色 ✓）/ Expected output (all items should be green ✓):**
```
✓ 容器运行状态: 正常 / Container status: Running
✓ Gateway 绑定: loopback (仅本机访问) / Gateway bind: loopback (localhost only)
✓ 实际监听: 127.0.0.1:18789 (本机) / Actual listen: 127.0.0.1:18789 (localhost)
✓ Token 长度: 64 字符 (安全) / Token length: 64 characters (secure)
✓ 沙盒模式: non-main (已启用) / Sandbox mode: non-main (enabled)
✓ Docker socket: 已挂载 (沙盒需要) / Docker socket: Mounted (required for sandbox)
✓ 未检测到敏感系统目录挂载 / No sensitive system directories mounted
✓ Workspace 权限: 700 (仅所有者可访问) / Workspace permissions: 700 (owner access only)
✓ 运行用户: node (非 root) / Running user: node (non-root)
```

### 2. 手动验证关键配置 / Manual Verification of Key Settings

#### 检查网络绑定 / Check Network Binding
```bash
docker compose exec openclaw-gateway node dist/index.js config get gateway.bind
# 期望输出 / Expected output: loopback
```

#### 检查沙盒模式 / Check Sandbox Mode
```bash
docker compose exec openclaw-gateway node dist/index.js config get agents.defaults.sandbox.mode
# 期望输出 / Expected output: non-main
```

#### 检查挂载点（不应包含敏感目录）/ Check Mount Points (should not include sensitive directories)
```bash
docker inspect $(docker ps -qf "name=openclaw-gateway") \
  --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
```

**期望输出示例（仅这些路径）/ Expected output example (only these paths):**
```
/Users/yourname/.openclaw -> /home/node/.openclaw
/Users/yourname/.openclaw/workspace -> /home/node/.openclaw/workspace
/var/run/docker.sock -> /var/run/docker.sock
```

#### 检查监听端口 / Check Listening Ports
```bash
docker exec $(docker ps -qf "name=openclaw-gateway") ss -tlnp | grep 18789
# 期望包含 / Expected to include: 127.0.0.1:18789 (而不是 / not 0.0.0.0:18789)
```

### 3. 测试访问控制 / Test Access Control

#### 测试本机访问（应该成功）/ Test Local Access (should succeed)
```bash
curl -H "Authorization: Bearer $OPENCLAW_GATEWAY_TOKEN" \
  http://127.0.0.1:18789/healthz
# 期望输出 / Expected output: {"status":"ok"}
```

#### 测试未授权访问（应该失败）/ Test Unauthorized Access (should fail)
```bash
curl http://127.0.0.1:18789/healthz
# 期望输出 / Expected output: 401 Unauthorized
```

#### 测试外部访问（应该拒绝连接）/ Test External Access (should refuse connection)
```bash
# 从另一台设备（如手机）通过局域网 IP 访问
# From another device (e.g., phone) via LAN IP
curl http://YOUR_MAC_IP:18789/healthz
# 期望结果 / Expected result: Connection refused (如果配置正确 / if configured correctly)
```

---

## 🛡️ 运行时安全实践 / Runtime Security Practices

### 每周检查 / Weekly Checks
- [ ] 运行 `./security-audit.sh` 检查配置漂移 / Run `./security-audit.sh` to check for configuration drift
- [ ] 检查 workspace 目录 / Check workspace directory: `ls -lah ~/.openclaw/workspace`
- [ ] 查看容器日志 / Review container logs: `docker compose logs --tail=100 openclaw-gateway`

### 每月检查 / Monthly Checks
- [ ] 更新 Docker 镜像 / Update Docker image: `docker pull openclaw:latest && ./secure-docker-setup.sh`
- [ ] 审查 API 密钥使用情况 / Review API key usage
- [ ] 备份配置 / Backup configuration: `tar -czf openclaw-config-backup-$(date +%Y%m%d).tar.gz ~/.openclaw`

### 文件操作前确认 / Before File Operations
在让 AI 处理文件之前，确认 / Before letting AI handle files, confirm:
- [ ] 文件路径在 `~/.openclaw/workspace` 内 / File path is within `~/.openclaw/workspace`
- [ ] 不包含密码、密钥或私钥 / Does not contain passwords, keys, or private keys
- [ ] 如需处理敏感数据，考虑使用临时副本 / If handling sensitive data, consider using temporary copies

---

## 🚨 安全事件响应 / Security Incident Response

### 如果怀疑配置被篡改 / If Configuration Tampering is Suspected
```bash
# 1. 立即停止容器 / Immediately stop containers
docker compose down

# 2. 检查配置文件 / Check configuration files
cat ~/.openclaw/openclaw.json | jq '.gateway'

# 3. 重置为安全配置 / Reset to secure configuration
rm -rf ~/.openclaw/openclaw.json
./secure-docker-setup.sh
```

### 如果 Token 泄露 / If Token is Compromised
```bash
# 1. 生成新 Token / Generate new token
NEW_TOKEN=$(openssl rand -hex 32)

# 2. 更新配置 / Update configuration
docker compose exec openclaw-gateway node dist/index.js \
  config set gateway.auth.token "$NEW_TOKEN"

# 3. 重启 Gateway / Restart gateway
docker compose restart openclaw-gateway

# 4. 更新所有客户端的 Token / Update token on all clients
```

### 如果发现异常进程 / If Abnormal Processes are Detected
```bash
# 1. 查看容器内运行的进程 / View processes running in container
docker exec $(docker ps -qf "name=openclaw-gateway") ps aux

# 2. 如果发现可疑进程，导出日志后销毁容器
# If suspicious processes found, export logs then destroy container
docker compose logs openclaw-gateway > incident-$(date +%Y%m%d-%H%M%S).log
docker compose down
docker rmi openclaw:local

# 3. 从官方重新构建 / Rebuild from official source
git pull origin main
./secure-docker-setup.sh
```

---

## 📋 配置文件清单 / Configuration File Inventory

### 应该存在的文件 / Files That Should Exist
```
~/.openclaw/
├── openclaw.json          # 主配置（包含 Token）/ Main config (contains token)
├── identity/              # Gateway 身份 / Gateway identity
├── agents/                # Agent 会话历史 / Agent session history
└── workspace/             # AI 可访问的工作区 / AI-accessible workspace
    └── .openclaw/         # Workspace 元数据（自动生成）/ Workspace metadata (auto-generated)
```

### 应该保护的文件 / Files That Should Be Protected
```bash
# 确保这些文件权限为 600 或 700
# Ensure these files have 600 or 700 permissions
chmod 600 ~/.openclaw/openclaw.json
chmod 700 ~/.openclaw/identity
chmod 700 ~/.openclaw/workspace
```

### 不应该存在的文件 / Files That Should NOT Exist
- `~/.openclaw/.env` （敏感变量应通过 Docker Compose 传递）/ (sensitive vars should pass through Docker Compose)
- `~/.openclaw/credentials.json` （旧版本残留）/ (legacy version remnant)
- 任何 `.pem`、`.key` 文件（除非你明确放置）/ Any `.pem`, `.key` files (unless you explicitly placed them)

---

## 🔗 相关资源 / Related Resources

- 官方安全文档 / Official security docs: https://docs.openclaw.ai/gateway/sandboxing
- Docker 安全最佳实践 / Docker security best practices: https://docs.docker.com/engine/security/
- 问题排查 / Troubleshooting: `docker compose logs -f openclaw-gateway`

---

## 📞 获取帮助 / Getting Help

如果遇到安全问题 / If you encounter security issues:
1. 运行 `./security-audit.sh` 并保存输出 / Run `./security-audit.sh` and save the output
2. 检查 `docker compose logs openclaw-gateway` 最后 100 行 / Check last 100 lines of `docker compose logs openclaw-gateway`
3. 在 GitHub Issues 提问时**不要**包含 Token 或 API 密钥 / When asking on GitHub Issues, **do NOT** include tokens or API keys
