# 🚀 Quick Alias Setup Guide / 快速别名设置指南

This guide helps you set up the `claw` command for easy CLI access to OpenClaw.

本指南帮助你设置 `claw` 命令，以便轻松通过命令行访问 OpenClaw。

---

## 📝 Setup Steps / 设置步骤

### Step 1: Navigate to clawbot directory / 第 1 步：进入 clawbot 目录

```bash
cd /path/to/your/clawbot
```

---

### Step 2: Run automatic setup / 第 2 步：运行自动设置

**For Zsh (macOS default) / Zsh（macOS 默认）:**

```bash
echo "alias claw='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc
```

**For Bash / Bash:**

```bash
echo "alias claw='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.bashrc
```

**💡 Tip:** The `$(pwd)` automatically captures your current directory path!

**💡 提示：** `$(pwd)` 会自动获取当前目录路径！

---

### Step 3: Reload your shell / 第 3 步：重新加载 shell

```bash
# For Zsh
source ~/.zshrc

# For Bash
source ~/.bashrc
```

---

### Step 4: Test it! / 第 4 步：测试！

```bash
claw "Hello! Can you hear me?"
```

Expected output / 期望输出:
```
Hey. I just came online...
```

---

## 🎯 Usage Examples / 使用示例

```bash
# Ask questions / 提问
claw "What's the weather today?"

# File operations / 文件操作
claw "Create a file test.txt in workspace with content 'Hello World'"

# Code help / 代码帮助
claw "Explain how Docker networking works"

# Math / 数学
claw "What's 123 * 456?"
```

---

## 🔍 Troubleshooting / 故障排除

### Command not found / 命令未找到

```bash
# Check if alias is set / 检查别名是否设置
alias | grep claw

# If nothing shows, repeat Step 2 and 3
# 如果没有显示，重复第 2 和第 3 步
```

### Gateway not running / Gateway 未运行

```bash
# Check container status / 检查容器状态
docker compose ps

# Start gateway / 启动 gateway
docker compose -f docker-compose.yml -f docker-compose.sandbox.yml up -d openclaw-gateway
```

### Permission denied / 权限被拒绝

```bash
# Make sure Docker is running
# 确保 Docker 正在运行
docker ps

# Check you're in the correct directory
# 检查你是否在正确的目录
pwd
```

---

## 📚 More Information / 更多信息

- Full setup guide / 完整设置指南: [README.HARDENED.md](README.HARDENED.md)
- Chinese version / 中文版: [README.HARDENED.zh-CN.md](README.HARDENED.zh-CN.md)
- Security checklist / 安全清单: [SECURITY_CHECKLIST.zh-CN.md](SECURITY_CHECKLIST.zh-CN.md)
- Quick reference / 快速参考: [README.USAGE.md](README.USAGE.md)

---

## 💡 Pro Tips / 专业提示

### Custom alias name / 自定义别名

Don't like `claw`? Use any name you want:

不喜欢 `claw`？使用任何你想要的名字：

```bash
# From clawbot directory
echo "alias ai='docker compose -f $(pwd)/docker-compose.yml -f $(pwd)/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc
```

### Using environment variable / 使用环境变量

Make it easier to manage:

更容易管理：

```bash
# From clawbot directory
echo "export CLAWBOT_DIR=\"$(pwd)\"" >> ~/.zshrc
echo "alias claw='docker compose -f \$CLAWBOT_DIR/docker-compose.yml -f \$CLAWBOT_DIR/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'" >> ~/.zshrc
source ~/.zshrc
```

### Shorter aliases for common tasks / 常用任务的简短别名

```bash
# Quick workspace file creation
alias clawmkfile='claw "Create a file in workspace"'

# Quick search
alias clawsearch='claw "Search for"'
```

---

## 🔧 Manual Setup (Alternative) / 手动设置（替代方案）

If you prefer manual editing / 如果你喜欢手动编辑：

1. Open your shell config / 打开 shell 配置:
   ```bash
   # For Zsh
   vim ~/.zshrc

   # For Bash
   vim ~/.bashrc
   ```

2. Add this line (replace `/absolute/path/to/clawbot` with actual path) / 添加这一行（替换为实际路径）:
   ```bash
   alias claw='docker compose -f /absolute/path/to/clawbot/docker-compose.yml -f /absolute/path/to/clawbot/docker-compose.sandbox.yml exec openclaw-gateway node dist/index.js agent --agent main --thinking low --message'
   ```

3. Save and reload / 保存并重新加载:
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

---

**Enjoy your simplified OpenClaw CLI! / 享受简化的 OpenClaw 命令行！** 🦞✨
