# Xiangqi Tutor - Deployment Guide

Complete guide for deploying the voice-interactive Chinese chess tutor for students.

## 📋 Prerequisites

- OpenClaw installed (Mac app or CLI)
- WhatsApp account (Business or Personal)
- Microphone access (for Mac app voice features)

## 🚀 Quick Deployment

### Step 1: Copy Skill Files

```bash
# If using this repo
cp -r skills/xiangqi-tutor ~/.openclaw/workspace/skills/

# Or download and extract to:
~/.openclaw/workspace/skills/xiangqi-tutor/
```

### Step 2: Configure OpenClaw

**Option A: Via Mac App (Recommended)**

1. Open OpenClaw Mac app
2. Go to **Settings → Channels → WhatsApp**
3. Click **"Scan QR Code"**
4. Scan with your WhatsApp (phone)
5. Wait for connection confirmation

**Option B: Manual Configuration**

Edit `~/.openclaw/openclaw.json`:

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "dmPolicy": "pairing",
      "allowFrom": ["YOUR_PHONE_WITHOUT_PLUS"]
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

See `openclaw-config.example.json` for full configuration options.

### Step 3: Test the Skill

Send a WhatsApp message to your configured number:

```
Teach me Chinese chess
```

You should receive a voice message reply with the first lesson!

### Step 4: Deploy Student Access Page

**Option 1: GitHub Pages**

```bash
# Create a new repo or use existing
git add skills/xiangqi-tutor/index.html
git commit -m "Add xiangqi tutor landing page"
git push

# Enable GitHub Pages
# Settings → Pages → Source: main branch
# Your page will be at: https://USERNAME.github.io/REPO/skills/xiangqi-tutor/
```

**Option 2: Local Network**

```bash
# Serve locally for students on same network
cd skills/xiangqi-tutor
python3 -m http.server 8080

# Share: http://YOUR_LOCAL_IP:8080/index.html
```

**Option 3: Netlify/Vercel (Free)**

```bash
# Drag and drop the index.html file to:
# - netlify.com/drop
# - vercel.com
```

## 🎓 Student Onboarding

### Method 1: QR Code (Easiest)

1. Students visit your deployed `index.html`
2. Scan QR code with WhatsApp
3. Start chatting!

### Method 2: Direct Number

Students can:

1. Add your WhatsApp number: `+1 (XXX) XXX-XXXX`
2. Send: `"Hi! I want to learn Chinese chess"`

## ⚙️ Configuration Options

### Voice Selection

Recommended voices for high school students:

| Voice                     | Style               | Use Case                 |
| ------------------------- | ------------------- | ------------------------ |
| `en-US-EricNeural`        | Clear, professional | ✅ Default (recommended) |
| `en-US-AndrewNeural`      | Young, friendly     | More casual teaching     |
| `en-US-BrandonNeural`     | Energetic           | Very casual/fun          |
| `en-US-ChristopherNeural` | Warm, patient       | Slower-paced learning    |

Change in config:

```json
"edge": {
  "voice": "en-US-EricNeural"
}
```

### Access Control

**Pairing Mode (Recommended):**

```json
"dmPolicy": "pairing"
```

- Students send first message
- You approve their device
- They can continue chatting

**Open Mode (Testing Only):**

```json
"dmPolicy": "open"
```

- Anyone can message
- No approval needed
- ⚠️ Use only for testing!

**Allowlist Mode (Specific Students):**

```json
"dmPolicy": "allowlist",
"allowFrom": [
  "15551234567",
  "15559876543"
]
```

### Sandbox Mode

**For Teaching (Recommended):**

```json
"sandbox": { "mode": "off" }
```

- No Docker required
- Fast responses
- Suitable for educational use

**For Production:**

```json
"sandbox": { "mode": "non-main" }
```

- Requires Docker
- Better isolation
- Recommended for public deployment

## 🧪 Testing

### Test Skill Locally

```bash
cd ~/.openclaw/workspace/skills/xiangqi-tutor
./test-skill.sh
```

### Test Move Validation

```bash
python3 xiangqi-helper.py display
python3 xiangqi-helper.py validate e4 e5
python3 xiangqi-helper.py move e4 e5
```

### Test WhatsApp Integration

1. Send: `"Teach me Chinese chess"`
2. Expected: Voice message with introduction
3. Send: `"How does the Cannon move?"`
4. Expected: Voice explanation of Cannon piece

## 📊 Monitoring

### Check Gateway Status

```bash
# Mac App: Click icon → Status
# Or check logs:
tail -f ~/.openclaw/logs/gateway.log
```

### WhatsApp Connection

```bash
# Look for:
[whatsapp] connected: true
[whatsapp] Inbound message +1XXX...
```

### Skill Loading

```bash
# Check if skill is loaded:
grep -i "xiangqi" ~/.openclaw/logs/gateway.log
```

## 🔧 Troubleshooting

### WhatsApp Not Connecting

1. **Check QR code scan:** Re-scan in Settings → Channels
2. **Phone disconnected:** Keep WhatsApp phone online
3. **Session expired:** Re-authenticate in Mac app

### No Voice Replies

1. **Check TTS config:**

   ```bash
   cat ~/.openclaw/openclaw.json | grep -A5 "tts"
   ```

2. **Verify voice setting:**
   ```json
   "auto": "always",
   "provider": "edge"
   ```

### Skill Not Responding

1. **Verify skill installed:**

   ```bash
   ls ~/.openclaw/workspace/skills/xiangqi-tutor/SKILL.md
   ```

2. **Check skill name in config:** `xiangqi_tutor` (underscore, not hyphen)

3. **Restart gateway:** Click OpenClaw icon → Restart

### Sandbox Errors

```
Error: Sandbox mode requires Docker...
```

**Fix:**

```json
"sandbox": { "mode": "off" }
```

Then restart gateway.

## 🔒 Privacy & Security

### Data Storage

- All conversations: `~/.openclaw/sessions/`
- No external servers (except TTS API)
- Local AI processing

### Student Privacy

- No registration required
- Phone numbers stored locally
- Delete sessions: `rm -rf ~/.openclaw/sessions/*`

### Recommended Settings

**For Schools:**

```json
{
  "dmPolicy": "allowlist",
  "allowFrom": ["APPROVED_STUDENTS"],
  "sandbox": { "mode": "off" }
}
```

**For Public Demo:**

```json
{
  "dmPolicy": "pairing",
  "sandbox": { "mode": "non-main" }
}
```

## 📈 Scaling

### Multiple Students

- WhatsApp handles multiple concurrent chats
- Each student gets isolated session
- No special configuration needed

### Rate Limits

- WhatsApp: ~100 messages/day (personal account)
- WhatsApp Business: Higher limits
- Consider upgrading for large classes

## 🆘 Support

### Check Logs

```bash
# Recent activity
tail -100 ~/.openclaw/logs/gateway.log

# WhatsApp specific
grep "whatsapp" ~/.openclaw/logs/gateway.log | tail -50

# Errors
grep -i "error" ~/.openclaw/logs/gateway.log | tail -20
```

### Common Issues

| Issue                   | Solution                                                   |
| ----------------------- | ---------------------------------------------------------- |
| "Skill not found"       | Check `~/.openclaw/workspace/skills/xiangqi-tutor/` exists |
| "Docker required"       | Set `sandbox.mode` to `off`                                |
| "Token mismatch"        | Restart gateway                                            |
| "WhatsApp disconnected" | Re-scan QR code                                            |

## 📚 Resources

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [WhatsApp Business API](https://business.whatsapp.com)
- [Xiangqi Rules](https://en.wikipedia.org/wiki/Xiangqi)

---

## 🎯 Quick Reference

**Start Gateway:**

```bash
# Mac app: Click icon in menubar
# Or via CLI:
openclaw gateway
```

**Check Skill:**

```bash
ls ~/.openclaw/workspace/skills/xiangqi-tutor/
```

**Test WhatsApp:**

```
Send: "Teach me Chinese chess"
```

**Update Config:**

```bash
vim ~/.openclaw/openclaw.json
# Then restart gateway
```

---

**Ready to deploy?** Follow the steps above and your students can start learning Xiangqi via WhatsApp! 🎓♟️
