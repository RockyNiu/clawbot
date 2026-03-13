# OpenClaw Docker Management with Just
# Usage: just <command>

# 默认显示帮助
default:
    @just --list

# ========== 服务管理 ==========

# 启动所有服务
up:
    docker compose up -d

# 停止所有服务
down:
    docker compose down

# 重启 Gateway
restart:
    docker compose restart openclaw-gateway

# 查看容器状态
ps:
    docker compose ps

# 完全重启（停止 -> 启动）
reup: down up

# ========== 构建 ==========

# 构建 Docker 镜像
build:
    docker build -t openclaw:local .

# 构建并启动
rebuild: down build up
    @echo "✅ 重新构建完成！"

# 构建（包含浏览器支持）
build-browser:
    docker build --build-arg OPENCLAW_INSTALL_BROWSER=1 -t openclaw:local .

# 构建（包含 Docker CLI，用于沙箱）
build-sandbox:
    docker build --build-arg OPENCLAW_INSTALL_DOCKER_CLI=1 -t openclaw:local .

# ========== 日志与监控 ==========

# 查看实时日志
logs:
    docker compose logs -f openclaw-gateway

# 查看最近 50 行日志
logs-tail:
    docker compose logs --tail 50 openclaw-gateway

# 查看资源使用
stats:
    docker stats clawbot-openclaw-gateway-1

# 查看绑定地址
check-bind:
    @docker compose logs openclaw-gateway | grep listening | tail -1

# ========== CLI 命令 ==========

# 运行 CLI 命令（示例：just cli health）
cli *ARGS:
    docker compose run --rm openclaw-cli {{ARGS}}

# 在运行中的容器执行命令
exec *ARGS:
    docker compose exec openclaw-gateway {{ARGS}}

# 进入容器 shell
shell:
    docker compose exec openclaw-gateway sh

# ========== 健康检查 ==========

# HTTP 健康检查
health:
    @curl -s http://localhost:18789/healthz | jq
    @echo ""

# CLI 健康检查
health-cli:
    @just cli health

# 验证所有服务
verify:
    @echo "=== 容器状态 ==="
    @just ps
    @echo ""
    @echo "=== 绑定地址 ==="
    @just check-bind
    @echo ""
    @echo "=== 健康检查 ==="
    @just health

# ========== 配置管理 ==========

# 查看所有配置
config-get:
    @just cli config get

# 查看特定配置（示例：just config-get-key gateway.bind）
config-get-key KEY:
    @just cli config get {{KEY}}

# 设置配置（示例：just config-set gateway.bind lan）
config-set KEY VALUE:
    @just cli config set {{KEY}} {{VALUE}}
    @echo "✅ 配置已更新，请重启 Gateway：just restart"

# 显示 Gateway Token
token:
    @docker compose exec openclaw-gateway printenv OPENCLAW_GATEWAY_TOKEN

# 同步 Token
sync-token:
    #!/usr/bin/env bash
    TOKEN=$(docker compose exec openclaw-gateway printenv OPENCLAW_GATEWAY_TOKEN | tr -d '\r')
    docker compose run --rm openclaw-cli openclaw config set gateway.auth.token "$TOKEN"
    echo "✅ Token 已同步"

# ========== 设备管理 ==========

# 查看设备列表
devices:
    @just cli devices list

# 批准设备配对（示例：just approve <requestId>）
approve REQUEST_ID:
    @just cli devices approve {{REQUEST_ID}}
    @echo "✅ 设备已批准"

# 启用自动批准（仅开发环境）
auto-approve:
    @just config-set gateway.pairing.autoApprove true
    @just restart
    @echo "⚠️  已启用自动批准（仅限开发环境使用）"

# ========== Channel 管理 ==========

# 查看 Channel 状态
channels:
    @just cli channels status

# 添加 Telegram Channel（示例：just add-telegram BOT_TOKEN）
add-telegram TOKEN:
    @just cli channels add --channel telegram --token {{TOKEN}}

# 添加 Discord Channel（示例：just add-discord BOT_TOKEN）
add-discord TOKEN:
    @just cli channels add --channel discord --token {{TOKEN}}

# 登录 WhatsApp（交互式）
login-whatsapp:
    docker compose exec openclaw-cli openclaw channels login

# ========== 安全配置 ==========

# 切换到安全模式（仅 localhost 访问）
security-lock:
    @echo "🔒 切换到安全模式..."
    @just config-set gateway.bind loopback
    @chmod 700 ~/.openclaw
    @chmod 700 ~/.openclaw/workspace
    @just restart
    @echo ""
    @echo "✅ 安全模式已启用："
    @echo "  - 仅 localhost 访问"
    @echo "  - 目录权限: 700"
    @echo ""
    @echo "访问方式: http://localhost:18789"
    @just check-bind

# 切换到开发模式（LAN 访问）
security-unlock:
    @echo "⚠️  切换到开发模式..."
    @just config-set gateway.bind lan
    @just restart
    @echo ""
    @echo "⚠️  开发模式已启用："
    @echo "  - 允许 LAN 访问"
    @echo "  - 请确保网络环境安全"
    @echo ""
    @just check-bind

# 查看安全状态
security-status:
    @echo "=== 安全配置状态 ==="
    @echo ""
    @echo "网络绑定："
    @just config-get-key gateway.bind
    @echo ""
    @echo "目录权限："
    @ls -ld ~/.openclaw ~/.openclaw/workspace
    @echo ""
    @echo "Token 配置："
    @just config-get-key gateway.auth.token | head -c 20 && echo "..."
    @echo ""
    @echo "沙箱模式："
    @just config-get-key agents.defaults.sandbox.mode

# ========== 故障排查 ==========

# 修复 localhost 无法访问问题
fix-bind:
    @echo "正在设置 Gateway 为 LAN 模式..."
    @echo "⚠️  这会允许 LAN 访问，请确保网络安全"
    @just config-set gateway.bind lan
    @just restart
    @sleep 3
    @echo ""
    @echo "验证绑定地址："
    @just check-bind
    @echo ""
    @echo "测试访问："
    @just health

# 修复 Token 不匹配
fix-token: sync-token restart

# 查看完整诊断信息
diagnose:
    @echo "=== Docker 容器状态 ==="
    @docker compose ps
    @echo ""
    @echo "=== Gateway 绑定地址 ==="
    @docker compose logs openclaw-gateway | grep listening | tail -3
    @echo ""
    @echo "=== Gateway Token ==="
    @just token
    @echo ""
    @echo "=== 配置文件中的 Token ==="
    @just config-get-key gateway.auth.token
    @echo ""
    @echo "=== 设备列表 ==="
    @just devices
    @echo ""
    @echo "=== HTTP 健康检查 ==="
    @curl -s http://localhost:18789/healthz || echo "❌ 无法访问"
    @echo ""

# ========== 快捷功能 ==========

# 打开 Web UI
open:
    @open http://localhost:18789

# 打开 Canvas
open-canvas:
    @open http://localhost:18789/__openclaw__/canvas/

# 显示访问地址
urls:
    @echo "Web UI:  http://localhost:18789"
    @echo "Health:  http://localhost:18789/healthz"
    @echo "Ready:   http://localhost:18789/readyz"
    @echo "Canvas:  http://localhost:18789/__openclaw__/canvas/"

# ========== 维护 ==========

# 清理未使用的 Docker 资源
clean:
    docker system prune -f

# 完全清理（包括 volumes）
clean-all:
    docker compose down -v
    docker system prune -af

# 备份配置
backup:
    #!/usr/bin/env bash
    BACKUP_DIR=~/.openclaw.backup.$(date +%Y%m%d_%H%M%S)
    cp -r ~/.openclaw "$BACKUP_DIR"
    echo "✅ 配置已备份到: $BACKUP_DIR"

# 查看配置文件
cat-config:
    @cat ~/.openclaw/openclaw.json | jq

# ========== 开发 ==========

# 开发模式：实时日志
dev: up logs

# 完整设置（首次使用）- 标准模式
setup: build up
    @echo ""
    @echo "✅ OpenClaw Docker 已启动！"
    @echo ""
    @echo "⚠️  安全提示："
    @echo "当前使用标准配置 (GATEWAY_BIND=lan)"
    @echo "如需更高安全性，使用: just setup-secure"
    @echo ""
    @echo "下一步："
    @echo "1. 访问 Web UI: just open"
    @echo "2. 批准设备:    just devices"
    @echo "3. 查看日志:    just logs"
    @echo ""
    @echo "完整命令列表:   just --list"

# 安全强化设置（推荐生产环境）
setup-secure:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "========================================="
    echo "OpenClaw 安全强化设置"
    echo "========================================="
    echo ""
    echo "安全措施："
    echo "  ✓ Localhost-only 访问 (loopback)"
    echo "  ✓ Docker 沙箱隔离"
    echo "  ✓ 强制 Token 认证 (64字符随机)"
    echo "  ✓ 严格目录权限 (700)"
    echo "  ✓ 启动后安全验证"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi

    # 检查依赖
    command -v docker >/dev/null 2>&1 || { echo "ERROR: docker not found"; exit 1; }
    command -v openssl >/dev/null 2>&1 || { echo "ERROR: openssl not found"; exit 1; }

    # 生成强随机 Token（如果 .env 中没有或为空）
    if [[ ! -f .env ]] || ! grep -q "^OPENCLAW_GATEWAY_TOKEN=.\+" .env 2>/dev/null; then
        NEW_TOKEN="$(openssl rand -hex 32)"
        echo "✓ Generated 64-character random token"
        # 更新 .env 文件
        if [[ -f .env ]]; then
            sed -i.bak "s|^OPENCLAW_GATEWAY_TOKEN=.*|OPENCLAW_GATEWAY_TOKEN=$NEW_TOKEN|" .env
        else
            echo "OPENCLAW_GATEWAY_TOKEN=$NEW_TOKEN" >> .env
        fi
    else
        echo "⚠ Using existing token from .env"
    fi

    # 设置安全配置
    sed -i.bak 's|^OPENCLAW_GATEWAY_BIND=.*|OPENCLAW_GATEWAY_BIND=loopback|' .env
    sed -i.bak 's|^OPENCLAW_SANDBOX=.*|OPENCLAW_SANDBOX=1|' .env

    # 创建并设置目录权限
    mkdir -p ~/.openclaw ~/.openclaw/workspace
    chmod 700 ~/.openclaw
    chmod 700 ~/.openclaw/workspace

    echo ""
    echo "✓ 安全配置完成"
    echo ""

    # 构建并启动
    just build
    just up

    # 等待启动
    echo ""
    echo "等待服务启动..."
    sleep 8

    # 安全验证
    echo ""
    echo "========================================="
    echo "安全验证"
    echo "========================================="

    BIND_ADDR=$(docker compose exec -T openclaw-gateway node dist/index.js config get gateway.bind 2>/dev/null | tr -d '\r\n' || echo "unknown")
    if [[ "$BIND_ADDR" == "loopback" ]]; then
        echo "✓ Gateway bind: loopback"
    else
        echo "⚠ WARNING: Gateway bind is $BIND_ADDR (expected: loopback)"
    fi

    SANDBOX=$(docker compose exec -T openclaw-gateway node dist/index.js config get agents.defaults.sandbox.mode 2>/dev/null | tr -d '\r\n' || echo "unknown")
    if [[ "$SANDBOX" == "non-main" ]] || [[ "$SANDBOX" == "always" ]]; then
        echo "✓ Sandbox mode: $SANDBOX"
    else
        echo "⚠ WARNING: Sandbox mode is $SANDBOX"
    fi

    PERMS=$(stat -f "%OLp" ~/.openclaw 2>/dev/null || stat -c "%a" ~/.openclaw 2>/dev/null || echo "unknown")
    if [[ "$PERMS" == "700" ]]; then
        echo "✓ Directory permissions: 700"
    else
        echo "⚠ WARNING: Directory permissions are $PERMS (expected: 700)"
    fi

    echo ""
    echo "========================================="
    echo "安全设置完成"
    echo "========================================="
    echo ""
    TOKEN=$(grep "^OPENCLAW_GATEWAY_TOKEN=" .env | cut -d= -f2)
    echo "Gateway Token (请妥善保存):"
    echo "  $TOKEN"
    echo ""
    echo "访问方式:"
    echo "  http://localhost:18789"
    echo "  http://127.0.0.1:18789"
    echo ""
    echo "管理命令:"
    echo "  just logs          # 查看日志"
    echo "  just devices       # 管理设备"
    echo "  just security-status # 检查安全状态"
    echo ""
    echo "⚠️  安全提醒:"
    echo "  1. 不要将 Token 提交到 Git"
    echo "  2. 不要在公网暴露端口"
    echo "  3. 需要远程访问请使用 Tailscale 或 SSH 隧道"
    echo ""

# 快速测试（构建 -> 启动 -> 验证）
test: rebuild verify
    @echo "✅ 测试完成！"
