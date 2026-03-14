# Xiangqi Tutor - Voice-Interactive Chinese Chess Teacher

> **[中文文档](README.zh-CN.md)** | **English**

An OpenClaw skill for teaching Chinese Chess (Xiangqi) to complete beginners using voice interaction.

## Overview

This skill is designed to teach American high school students with no prior exposure to Chinese chess. The bot provides:

- **Step-by-step lessons** starting from the basics
- **Interactive practice** with move validation
- **Patient explanations** suitable for beginners
- **Voice-enabled interaction** via Mac microphone
- **Progressive learning** through structured modules

## Quick Start

### 1. Enable Voice Wake in OpenClaw

Make sure Voice Wake is enabled in your OpenClaw Mac app:

- Open OpenClaw menubar app
- Go to Settings → Voice
- Enable "Voice Wake"
- Test with push-to-talk (Cmd+Fn)

### 2. Start a Lesson

Use your voice to activate the tutor:

```
"Hey OpenClaw, teach me Chinese chess"
"Hey OpenClaw, use xiangqi tutor skill"
"Hey OpenClaw, I want to learn Xiangqi"
```

### 3. Follow the Lessons

The bot will guide you through:

**Module 1**: Introduction to Xiangqi (5-10 min)

- Board layout
- Basic terminology
- Game objective

**Module 2**: Learning the Pieces (15-20 min)

- Soldier (Pawn)
- Rook (Chariot)
- Cannon
- Horse (Knight)
- Elephant (Bishop)
- Advisor (Guard)
- General (King)

**Module 3**: Basic Rules (10 min)

- Turn order
- Check and checkmate
- Flying general rule
- Stalemate

**Module 4**: Simple Tactics (15-20 min)

- Pins, forks, discoveries
- Basic checkmate patterns

**Module 5**: Practice Game (20-30 min)

- Guided gameplay with feedback

## Helper Tools

### Board Visualization

View the current board state:

```bash
cd ~/.openclaw/workspace/skills/xiangqi-tutor
python3 xiangqi-helper.py display
```

Output:

```
   a b c d e f g h i
10 r h e a g a e h r ← Black
 9 . . . . . . . . .
 8 . c . . . . . c .
 7 s . s . s . s . s
 6 . . . . . . . . .
 5 . . . . . . . . .
 4 S . S . S . S . S
 3 . C . . . . . C .
 2 . . . . . . . . .
 1 R H E A G A E H R ← Red
```

### Move Validation

Check if a move is legal:

```bash
python3 xiangqi-helper.py validate e4 e5
# Output: Valid: True, Message: Valid forward move

python3 xiangqi-helper.py validate a1 a5
# Output: Valid: False, Message: Path blocked at a4
```

### Make a Move

Execute a move and see the result:

```bash
python3 xiangqi-helper.py move e4 e5
# Output: Moved S from e4 to e5
# [displays updated board]
```

## Voice Interaction Tips

### Clear Speech

- Speak clearly and at a moderate pace
- Use full notation: "Rook at a-1 to a-6"
- Pause briefly between commands

### Example Interactions

**Starting:**

- "Teach me Chinese chess from the beginning"
- "Explain the Xiangqi board"
- "What pieces are in Chinese chess?"

**During Lessons:**

- "How does the Cannon move?"
- "Can you repeat that?"
- "Show me an example"
- "I don't understand, explain it differently"

**Practice:**

- "Let's practice with the Soldier"
- "Is this move legal: e4 to e5?"
- "Can the Rook at a1 move to a6?"

**Questions:**

- "What's the difference from regular chess?"
- "Why can't the Elephant cross the river?"
- "What happens if the Generals face each other?"

## Progress Tracking

The skill tracks your learning progress in `game-state.json`:

```json
{
  "currentModule": "introduction",
  "learnedPieces": ["soldier", "rook", "cannon"],
  "completedModules": ["introduction"],
  "sessionCount": 3,
  "notes": ["Mastered soldier movement", "Needs practice with Horse blocking"]
}
```

## Piece Quick Reference

| Piece             | Letter | Movement                 | Special Rules                          |
| ----------------- | ------ | ------------------------ | -------------------------------------- |
| General (King)    | G/g    | 1 point orthogonal       | Palace only, no flying general         |
| Advisor (Guard)   | A/a    | 1 point diagonal         | Palace only                            |
| Elephant (Bishop) | E/e    | 2 points diagonal        | Cannot cross river, can be blocked     |
| Horse (Knight)    | H/h    | L-shape (1 + 1 diagonal) | Can be blocked ("hobbled")             |
| Rook (Chariot)    | R/r    | Any orthogonal           | Cannot jump                            |
| Cannon            | C/c    | Moves like Rook          | Must jump to capture                   |
| Soldier (Pawn)    | S/s    | 1 forward                | Can move sideways after crossing river |

**Capital = Red (moves first)**
**Lowercase = Black**

## Common Questions

**Q: How long does it take to learn?**
A: Basic rules take 45-60 minutes. Proficiency comes with practice!

**Q: Is this harder than Western chess?**
A: The learning curve is similar, but some concepts (like the Cannon) are unique. The bot makes it easy!

**Q: Can I play against the bot?**
A: Currently, the bot focuses on teaching. For practice games, try online platforms like xiangqi.com.

**Q: What if I get confused?**
A: Just ask! The bot will rephrase explanations and provide more examples. Learning is iterative.

## Session Recommendations

**First Session (45-60 min):**

- Cover introduction + 3-4 basic pieces
- Take breaks if needed
- Ask lots of questions

**Follow-up Sessions (30-45 min each):**

- Quick review
- Learn 2-3 new pieces
- Practice with puzzles

**After Module 5:**

- Play practice games on online platforms
- Return to the bot for specific questions
- Explore advanced tactics

## Troubleshooting

### Voice Wake Not Working

1. Check microphone permissions:
   - System Settings → Privacy & Security → Microphone
   - Enable for OpenClaw

2. Test push-to-talk:
   - Hold Cmd+Fn and speak
   - Overlay should appear

3. Check wake word settings:
   - OpenClaw app → Settings → Voice
   - Ensure wake words are configured

### Skill Not Responding

1. Refresh skills:

   ```bash
   openclaw skills refresh
   ```

2. Check skill is installed:

   ```bash
   ls ~/.openclaw/workspace/skills/xiangqi-tutor/
   ```

3. View logs:
   ```bash
   ~/scripts/clawlog.sh --follow
   ```

## Resources for Further Learning

### Online Platforms

- [Xiangqi.com](https://xiangqi.com) - Play online
- [Club Xiangqi](https://clubxiangqi.com) - Community and tutorials
- [Chinese Chess Online](https://www.chinesechessonline.net) - Practice puzzles

### YouTube Channels

- Xiangqi Channel
- Chinese Chess School
- WXF Xiangqi (World Xiangqi Federation)

### Books

- "Chinese Chess for Beginners" by Sam Sloan
- "The Tao of Chinese Chess" by Zhang Qiang

### Apps

- Chinese Chess Online (iOS/Android)
- Xiangqi Master (Android)
- Chinese Chess - Co Tuong (iOS)

## Contributing

Found a bug or want to improve the teaching materials?

1. Report issues with the skill
2. Suggest better explanations for tricky concepts
3. Share successful teaching strategies

## Files in This Skill

```
xiangqi-tutor/
├── SKILL.md              # Main skill definition and teaching guide
├── README.md             # This file
├── xiangqi-helper.py     # Move validation and board display tool
└── game-state.json       # Student progress tracker
```

## Credits

Created for teaching American high school students with no prior exposure to Chinese chess. Designed to work with OpenClaw's voice interaction system on macOS.

## License

This skill is provided as-is for educational purposes. Xiangqi rules and terminology are traditional and in the public domain.

---

**Ready to learn?** Say: _"Hey OpenClaw, teach me Chinese chess!"_
