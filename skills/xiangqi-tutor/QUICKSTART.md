# Xiangqi Tutor - Quick Start Guide

> **[中文](QUICKSTART.zh-CN.md)** | **English**

## What is This?

A voice-interactive Chinese chess (Xiangqi) teaching bot for American high school students using OpenClaw on Mac.

## Installation Status

✅ **Skill is installed and ready!**

Location:

- **Built-in:** `skills/xiangqi-tutor/` (in OpenClaw repository)
- **User workspace:** `~/.openclaw/workspace/skills/xiangqi-tutor/` (optional, for customization)

## How to Use

### Option 1: Docker CLI (Current Setup)

If you're using the Docker version of OpenClaw (your current setup):

```bash
# Using the claw alias (skill name is xiangqi_tutor with underscore)
claw "Use the xiangqi_tutor skill to teach me Chinese chess"

# Or let OpenClaw auto-select the skill
claw "Teach me Chinese chess"
claw "Explain how the Cannon moves in Xiangqi"
claw "Show me the Xiangqi board"

# Continue the conversation
claw "How does the Horse move?"
claw "What's the difference between Cannon and Rook?"
```

**Verify skill is loaded:**

```bash
docker compose -f docker-compose.yml exec openclaw-gateway node dist/index.js skills list | grep xiangqi
# Should show: ♟️ xiangqi_tutor
```

### Option 2: Mac App + Voice Interaction (Optional)

If you have the OpenClaw Mac menubar app installed (with voice features):

1. **Start OpenClaw Mac App**
   - Find OpenClaw in Finder → Applications
   - Or launch from `/Applications/OpenClaw.app`
   - App appears in Mac menu bar (status bar at top)

2. **Enable Voice Wake**
   - Click OpenClaw icon in menu bar
   - Go to Settings → Voice
   - Toggle "Voice Wake" ON
   - Grant microphone permissions if prompted

3. **Start Learning**
   - Say: **"Hey OpenClaw, teach me Chinese chess"**
   - Or: **"Hey OpenClaw, use the xiangqi_tutor skill"**

4. **Push-to-Talk Alternative**
   - Hold **Cmd+Fn** while speaking
   - Release to send

### Option 3: Helper Tools (Testing Moves)

1. Hold **Cmd+Fn** on your Mac keyboard
2. Speak your request while holding
3. Release when done
4. The overlay will show your transcript and send the request

## Learning Path

The bot will guide you through 5 modules:

1. **Introduction** (5-10 min) - Board layout and objectives
2. **The Pieces** (15-20 min) - Learn each piece's movement
3. **Basic Rules** (10 min) - Check, checkmate, special rules
4. **Simple Tactics** (15-20 min) - Pins, forks, patterns
5. **Practice Game** (20-30 min) - Guided gameplay

**Total learning time:** ~45-60 minutes for basics

## Example Voice Commands

**Starting:**

- "Teach me Chinese chess from scratch"
- "What is Xiangqi?"
- "Start the first lesson"

**During Lessons:**

- "How does the Horse move?"
- "What's the difference between Cannon and Rook?"
- "Why can't the Elephant cross the river?"
- "Can you repeat that?"
- "I don't understand"

**Practice:**

- "Let's practice with the Soldier"
- "Is e4 to e5 a valid move?"
- "Show me the board"
- "What can the Rook at a1 do?"

## Verify Installation

Run the test script:

```bash
~/.openclaw/workspace/skills/xiangqi-tutor/test-skill.sh
```

You should see:

- ✅ Skill directory found
- ✅ SKILL.md found
- ✅ Helper script is executable
- ✅ Test 1 passed: Valid soldier move detected
- ✅ Test 2 passed: Blocked rook move detected

## Troubleshooting

### "Skill not found"

```bash
# Refresh OpenClaw skills
openclaw skills refresh

# Or restart the gateway
# (via OpenClaw Mac app menu)
```

### Voice Wake not responding

1. Check microphone permissions:
   - System Settings → Privacy & Security → Microphone
   - Ensure OpenClaw has access

2. Test push-to-talk:
   - Hold Cmd+Fn and speak
   - If this works, wake word might need adjustment

3. Check wake word settings:
   - OpenClaw app → Settings → Voice
   - Ensure wake words are configured

### Helper script not working

```bash
# Make sure it's executable
chmod +x ~/.openclaw/workspace/skills/xiangqi-tutor/xiangqi-helper.py

# Test Python
python3 --version  # Should be 3.7+
```

## Next Steps After Learning

Once you've completed the modules:

1. **Practice Online**
   - [Xiangqi.com](https://xiangqi.com) - Play against others
   - [Club Xiangqi](https://clubxiangqi.com) - Puzzles and tutorials

2. **Mobile Apps**
   - Chinese Chess Online (iOS/Android)
   - Xiangqi Master (Android)

3. **Advanced Learning**
   - Return to the tutor for specific questions
   - Study opening principles
   - Learn endgame patterns

## Files Included

```
xiangqi-tutor/
├── SKILL.md           # Teaching guide and skill definition
├── README.md          # Full documentation
├── QUICKSTART.md      # This file
├── xiangqi-helper.py  # Move validation tool
├── game-state.json    # Progress tracker
└── test-skill.sh      # Installation test
```

## Need Help?

**Within lessons:** Just ask the bot to explain differently or repeat

**Technical issues:**

- Check OpenClaw logs: `~/scripts/clawlog.sh --follow`
- Restart OpenClaw Mac app
- Verify microphone permissions

**Xiangqi rules questions:**

- Ask the bot during a session
- Check the piece reference in README.md
- Online resources: [Wikipedia - Xiangqi](https://en.wikipedia.org/wiki/Xiangqi)

---

**Ready to start?** Open OpenClaw and say: **"Hey OpenClaw, teach me Chinese chess!"**

Enjoy learning! 象棋快乐! (Happy chess!)
