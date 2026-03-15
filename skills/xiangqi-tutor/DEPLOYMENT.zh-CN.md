# 象棋导师 - 部署指南

为学生部署语音互动中国象棋导师的完整指南。

## 📋 前置要求

- OpenClaw 已安装（Mac 应用或命令行）
- WhatsApp 账号（商业或个人）
- 麦克风权限（Mac 应用语音功能需要）

## 🚀 快速部署

### 步骤 1：复制技能文件

```bash
# 如果使用本仓库
cp -r skills/xiangqi-tutor ~/.openclaw/workspace/skills/

# 或下载并解压到：
~/.openclaw/workspace/skills/xiangqi-tutor/
```

### 步骤 2：配置 OpenClaw

**方式 A：通过 Mac 应用（推荐）**

1. 打开 OpenClaw Mac 应用
2. 进入 **设置 → Channels → WhatsApp**
3. 点击 **"Scan QR Code"**
4. 用手机 WhatsApp 扫描
5. 等待连接确认

**方式 B：手动配置**

编辑 `~/.openclaw/openclaw.json`：

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "dmPolicy": "pairing",
      "allowFrom": ["你的手机号不带加号"]
    }
  },
  "messages": {
    "tts": {
      "auto": "always",
      "provider": "edge",
      "edge": {
        "voice": "en-US-EricNeural"
      }
    }
  },
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "off"
      }
    }
  }
}
```

完整配置选项见 `openclaw-config.example.json`。

### 步骤 3：测试技能

发送 WhatsApp 消息到配置的号码：

```
Teach me Chinese chess
```

你应该会收到带语音的第一课回复！

### 步骤 4：部署学生访问页面

**方案 1：GitHub Pages**

```bash
# 创建新仓库或使用现有仓库
git add skills/xiangqi-tutor/index.html
git commit -m "Add xiangqi tutor landing page"
git push

# 启用 GitHub Pages
# Settings → Pages → Source: main branch
# 页面地址: https://用户名.github.io/仓库名/skills/xiangqi-tutor/
```

**方案 2：本地网络**

```bash
# 在本地网络提供访问（同一 WiFi 的学生）
cd skills/xiangqi-tutor
python3 -m http.server 8080

# 分享: http://你的本地IP:8080/index.html
```

**方案 3：Netlify/Vercel（免费）**

直接拖拽 `index.html` 到以下网站：

- netlify.com/drop
- vercel.com

## 🎓 学生入门

### 方式 1：扫描 QR 码（最简单）

1. 学生访问你部署的 `index.html`
2. 用 WhatsApp 扫描二维码
3. 开始聊天！

### 方式 2：直接添加号码

学生可以：

1. 添加你的 WhatsApp 号码
2. 发送：`"Hi! I want to learn Chinese chess"`

## ⚙️ 配置选项

### 语音选择

适合高中生的推荐语音：

| 语音                      | 风格       | 使用场景        |
| ------------------------- | ---------- | --------------- |
| `en-US-EricNeural`        | 清晰、专业 | ✅ 默认（推荐） |
| `en-US-AndrewNeural`      | 年轻、友好 | 更轻松的教学    |
| `en-US-BrandonNeural`     | 有活力     | 非常随意/有趣   |
| `en-US-ChristopherNeural` | 温暖、耐心 | 慢节奏学习      |

修改配置：

```json
"edge": {
  "voice": "en-US-EricNeural"
}
```

### 访问控制

**配对模式（推荐）：**

```json
"dmPolicy": "pairing"
```

- 学生发送第一条消息
- 你批准他们的设备
- 之后可以继续聊天

**开放模式（仅测试）：**

```json
"dmPolicy": "open"
```

- 任何人都可以发消息
- 无需批准
- ⚠️ 仅用于测试！

**白名单模式（特定学生）：**

```json
"dmPolicy": "allowlist",
"allowFrom": [
  "15551234567",
  "15559876543"
]
```

### 沙箱模式

**教学场景（推荐）：**

```json
"sandbox": { "mode": "off" }
```

- 不需要 Docker
- 响应快
- 适合教育使用

**生产环境：**

```json
"sandbox": { "mode": "non-main" }
```

- 需要 Docker
- 更好的隔离
- 建议用于公开部署

## 🧪 测试

### 本地测试技能

```bash
cd ~/.openclaw/workspace/skills/xiangqi-tutor
./test-skill.sh
```

### 测试走法验证

```bash
python3 xiangqi-helper.py display
python3 xiangqi-helper.py validate e4 e5
python3 xiangqi-helper.py move e4 e5
```

### 测试 WhatsApp 集成

1. 发送：`"Teach me Chinese chess"`
2. 预期：带介绍的语音消息
3. 发送：`"How does the Cannon move?"`
4. 预期：炮的走法语音解释

## 📊 监控

### 检查网关状态

```bash
# Mac 应用：点击图标 → 状态
# 或查看日志：
tail -f ~/.openclaw/logs/gateway.log
```

### WhatsApp 连接

```bash
# 查找：
[whatsapp] connected: true
[whatsapp] Inbound message +1XXX...
```

### 技能加载

```bash
# 检查技能是否加载：
grep -i "xiangqi" ~/.openclaw/logs/gateway.log
```

## 🔧 常见问题

### WhatsApp 连接失败

1. **检查二维码扫描：** 在设置 → Channels 重新扫描
2. **手机断线：** 保持 WhatsApp 手机在线
3. **会话过期：** 在 Mac 应用重新认证

### 无语音回复

1. **检查 TTS 配置：**

   ```bash
   cat ~/.openclaw/openclaw.json | grep -A5 "tts"
   ```

2. **验证语音设置：**
   ```json
   "auto": "always",
   "provider": "edge"
   ```

### 技能无响应

1. **验证技能已安装：**

   ```bash
   ls ~/.openclaw/workspace/skills/xiangqi-tutor/SKILL.md
   ```

2. **检查技能名称：** `xiangqi_tutor`（下划线，不是连字符）

3. **重启网关：** 点击 OpenClaw 图标 → Restart

### 沙箱错误

```
Error: Sandbox mode requires Docker...
```

**解决：**

```json
"sandbox": { "mode": "off" }
```

然后重启网关。

## 🔒 隐私与安全

### 数据存储

- 所有对话：`~/.openclaw/sessions/`
- 无外部服务器（除了 TTS API）
- 本地 AI 处理

### 学生隐私

- 无需注册
- 电话号码本地存储
- 删除会话：`rm -rf ~/.openclaw/sessions/*`

### 推荐设置

**学校使用：**

```json
{
  "dmPolicy": "allowlist",
  "allowFrom": ["已批准的学生"],
  "sandbox": { "mode": "off" }
}
```

**公开演示：**

```json
{
  "dmPolicy": "pairing",
  "sandbox": { "mode": "non-main" }
}
```

## 📈 扩展

### 多个学生

- WhatsApp 支持多个并发聊天
- 每个学生独立会话
- 无需特殊配置

### 速率限制

- WhatsApp 个人：~100 条消息/天
- WhatsApp Business：更高限制
- 大班级建议升级

## 🆘 支持

### 查看日志

```bash
# 最近活动
tail -100 ~/.openclaw/logs/gateway.log

# WhatsApp 相关
grep "whatsapp" ~/.openclaw/logs/gateway.log | tail -50

# 错误
grep -i "error" ~/.openclaw/logs/gateway.log | tail -20
```

### 常见问题

| 问题            | 解决方案                                                |
| --------------- | ------------------------------------------------------- |
| "技能未找到"    | 检查 `~/.openclaw/workspace/skills/xiangqi-tutor/` 存在 |
| "需要 Docker"   | 设置 `sandbox.mode` 为 `off`                            |
| "Token 不匹配"  | 重启网关                                                |
| "WhatsApp 断开" | 重新扫描二维码                                          |

## 🎯 快速参考

**启动网关：**

```bash
# Mac 应用：点击菜单栏图标
# 或通过 CLI：
openclaw gateway
```

**检查技能：**

```bash
ls ~/.openclaw/workspace/skills/xiangqi-tutor/
```

**测试 WhatsApp：**

```
发送: "Teach me Chinese chess"
```

**更新配置：**

```bash
vim ~/.openclaw/openclaw.json
# 然后重启网关
```

---

**准备好部署了吗？** 按照上述步骤，你的学生就可以通过 WhatsApp 开始学习象棋了！🎓♟️
