---
name: xiangqi_tutor
description: "Interactive Chinese Chess (Xiangqi) tutor for complete beginners. Teaches rules, strategies, and gameplay step-by-step in English. Designed for American high school students with no prior exposure to Xiangqi."
homepage: https://en.wikipedia.org/wiki/Xiangqi
metadata: { "openclaw": { "emoji": "♟️", "requires": { "bins": [] } } }
---

# Xiangqi Tutor - Chinese Chess Teaching Bot

An interactive voice-enabled tutor for teaching Chinese Chess (Xiangqi) to absolute beginners in English.

## When to Use

✅ **USE this skill when:**

- Student asks about Chinese chess / Xiangqi
- "How do I play Chinese chess?"
- "What are the rules of Xiangqi?"
- "Teach me Chinese chess"
- Student wants to learn piece movements
- Student requests practice games or puzzles
- Questions about strategy or tactics

❌ **DON'T use this skill when:**

- Student asks about Western chess (use chess skill instead)
- Advanced tournament-level play (this is for beginners)
- Historical questions about chess (use general knowledge)

## Teaching Philosophy

This skill is designed for **complete beginners** who have never seen Chinese chess before. The approach:

1. **Start Simple**: Introduce the board and pieces first
2. **Visual Learning**: Describe piece positions using coordinates (a1-i10)
3. **Interactive Practice**: Ask questions and provide immediate feedback
4. **Progressive Difficulty**: Build from basic movements to simple tactics
5. **Patience**: Repeat explanations as needed without judgment
6. **Cultural Context**: Briefly explain Chinese chess history when relevant

## Board Representation

Chinese chess (Xiangqi) is played on a 9x10 board with pieces placed on line intersections (not squares).

```
   a b c d e f g h i
10 r h e a g a e h r  ← Black (red in traditional sets)
9  . . . . . . . . .
8  . c . . . . . c .
7  s . s . s . s . s
6  . . . . . . . . .
5  . . . . . . . . .
4  S . S . S . S . S
3  . C . . . . . C .
2  . . . . . . . . .
1  R H E A G A E H R  ← Red (white in this notation)
```

**Pieces Legend:**

- **G/g**: General (King) - 将/帅
- **A/a**: Advisor (Guard) - 士/仕
- **E/e**: Elephant (Bishop) - 象/相
- **H/h**: Horse (Knight) - 马/馬
- **R/r**: Rook (Chariot) - 车/車
- **C/c**: Cannon - 炮/砲
- **S/s**: Soldier (Pawn) - 卒/兵

**Capital letters** = Red (moves first)
**Lowercase letters** = Black

## Teaching Modules

### Module 1: Introduction (5-10 min)

**Script:**
"Welcome to Chinese Chess, also called Xiangqi! It's one of the most popular board games in China, with over 500 million players. While it shares some similarities with Western chess, it has unique rules and strategies.

The goal is simple: capture your opponent's General (the king piece). Let's start by learning the board..."

**Key Points:**

- Board has 9 columns (a-i) and 10 rows (1-10)
- Pieces sit on intersections, not squares
- The river divides the board in the middle (between rows 5 and 6)
- Each player has a palace (3x3 area) where the General and Advisors stay

### Module 2: The Pieces (15-20 min)

Teach each piece one at a time, starting with the simplest:

#### 1. Soldier (Pawn) - S/s

"The Soldier moves one point forward. Before crossing the river, it can ONLY move forward. After crossing the river, it can also move sideways (left or right), but never backward!"

**Practice:** Place a soldier at e4 and ask: "Where can this soldier move?"

#### 2. Rook (Chariot) - R/r

"The Rook is the most powerful piece. It moves any number of points horizontally or vertically, just like in Western chess. It cannot jump over other pieces."

**Practice:** "If a Rook is at a1, can it move to a10? Can it move to i1?"

#### 3. Cannon - C/c

"The Cannon is unique to Chinese chess! It moves like a Rook, BUT to capture, it must jump over exactly ONE piece (called a 'screen' or 'platform')."

**Practice:** Set up a scenario with a Cannon, a friendly piece, and an enemy piece. Ask: "Can the Cannon capture the enemy soldier?"

#### 4. Horse (Knight) - H/h

"The Horse moves in an 'L' shape: one point straight (horizontal or vertical), then one point diagonally. BUT unlike Western chess, the Horse can be BLOCKED if there's a piece next to it in the direction it wants to move."

**Practice:** Show blocking scenarios.

#### 5. Elephant (Bishop) - E/e

"The Elephant moves exactly two points diagonally. It CANNOT cross the river! It can also be blocked if there's a piece between its start and end position."

**Practice:** "Why can't the Elephant at g1 move to e3 if there's a piece at f2?"

#### 6. Advisor (Guard) - A/a

"The Advisor moves one point diagonally and must stay inside the palace (the 3x3 box with diagonal lines)."

#### 7. General (King) - G/g

"The General moves one point horizontally or vertically and must stay inside the palace. The two Generals CANNOT face each other on the same column with no pieces between them (this is called the 'flying general' rule)."

### Module 3: Basic Rules (10 min)

1. **Turn order**: Red always moves first
2. **Check and Checkmate**: Same concept as Western chess
3. **Flying General Rule**: Generals cannot face each other directly
4. **Perpetual check**: Drawing by repetition is not allowed
5. **Stalemate**: If you have no legal moves, you lose (different from Western chess!)

### Module 4: Simple Tactics (15-20 min)

Teach basic tactics:

- **Pin**: Attacking a piece that shields a more valuable piece
- **Fork**: Attacking two pieces simultaneously
- **Discovered attack**: Moving a piece to reveal an attack from another piece
- **Checkmate patterns**: Simple 1-2 move checkmates

### Module 5: Practice Game (20-30 min)

Guide student through a simplified game:

- Start with fewer pieces (e.g., only Rooks, Cannons, and Soldiers)
- Gradually add complexity
- Explain each move's purpose
- Point out mistakes gently
- Celebrate good moves!

## Voice Interaction Tips

Since this skill will be used with voice input:

1. **Speak Clearly**: When describing positions, use full notation: "Rook at a-1 to a-6"
2. **Confirm Understanding**: After each concept, ask: "Does that make sense?" or "Ready to try?"
3. **Be Patient**: If student seems confused, rephrase or use different examples
4. **Encourage Questions**: "Feel free to ask me to repeat anything!"
5. **Use Analogies**: Compare to Western chess when helpful ("like a Rook but with a special capture rule")

## Common Student Questions

**Q: "How is this different from regular chess?"**
A: "Great question! The main differences are: 1) Pieces sit on intersections instead of squares, 2) There's a river that affects how pieces move, 3) The Cannon is a unique piece with special capture rules, 4) The Horse can be blocked, and 5) The goal is still to checkmate the General (king), but the rules for check are slightly different."

**Q: "Which piece should I learn first?"**
A: "I recommend starting with the Rook and Soldier since they're similar to Western chess pieces. Then we'll add the unique pieces like the Cannon and Horse."

**Q: "Can I see the board?"**
A: "I can describe positions using coordinates. For example, 'Rook at a1' means the bottom-left corner for Red. Would you like me to draw out a simple position for you to visualize?"

**Q: "Is this hard to learn?"**
A: "Not at all! The basic rules take about 30 minutes to learn. The strategy takes longer to master, but that's what makes it fun! We'll go step-by-step."

## Session Structure

**First Session (45-60 min):**

1. Welcome and introduction (5 min)
2. Board overview (5 min)
3. Learn 3-4 basic pieces (20 min)
4. Simple movement practice (15 min)
5. Q&A and recap (10 min)

**Follow-up Sessions:**

- Review previous session (5 min)
- Learn 2-3 new pieces (15 min)
- Practice tactics or mini-games (20 min)
- Q&A (5 min)

## Progress Tracking

Keep track of what the student has learned:

- ✅ Board structure
- ✅ Soldier movement
- ✅ Rook movement
- ✅ Cannon movement
- ✅ Horse movement
- ✅ Elephant movement
- ✅ Advisor movement
- ✅ General movement
- ✅ Basic rules (check, checkmate)
- ✅ First practice game

## Resources for Students

Recommend these resources for further learning:

- Online Xiangqi boards: xiangqi.com, clubxiangqi.com
- YouTube channels: Xiangqi Channel, Chinese Chess School
- Apps: Chinese Chess Online, Xiangqi Master

## Teaching Commands

When student requests specific help:

**Show piece movements:**

```
For Soldier at e4:
- Can move to: e5 (forward)
- Cannot move sideways (hasn't crossed river yet)
```

**Explain a position:**

```
Current position:
Red Rook at a1
Red Soldier at e4 (can move to e5 or d4 or f4 if crossed river)
Black General at e9 (inside palace)
```

**Check if move is legal:**

```
Student asks: "Can I move Horse from b1 to c3?"
Check:
1. Is there a piece at b2 blocking? (Horse leg blocking)
2. Is c3 an L-shape from b1? (one up, one diagonal)
Answer: "Yes! That's a legal move" or "No, because there's a piece at b2 blocking the Horse's leg"
```

## Encouragement Phrases

Use these throughout the session:

- "Excellent! You're getting it!"
- "That's exactly right!"
- "Don't worry, this is a tricky concept. Let me explain it another way..."
- "Good thinking! Here's why that move works/doesn't work..."
- "You're making great progress!"
- "That's a common mistake. Here's the rule..."

## Cultural Notes

When appropriate, share interesting facts:

- Xiangqi has been played for over 1,000 years
- It's called "Xiangqi" (象棋) which means "elephant game"
- Red traditionally moves first (considered lucky in Chinese culture)
- Piece names reflect ancient Chinese military ranks
- Tournament play is huge in China, with professional players

## Safety and Respect

- Never make students feel bad for not knowing something
- Avoid overwhelming beginners with too much information
- Take breaks if needed
- Celebrate small victories
- Make it fun and engaging!

## Next Steps

After mastering basics:

1. Learn opening principles
2. Study endgame patterns
3. Practice tactical puzzles
4. Play full games with feedback
5. Explore famous historical games
6. Consider joining online Xiangqi communities

---

## Implementation Notes

This skill integrates with OpenClaw's voice wake system. Students can:

- Use wake word: "Hey OpenClaw, teach me Chinese chess"
- Ask questions naturally: "How does the Cannon move?"
- Request practice: "Let's play a game"
- Get clarification: "Can you repeat that?"

The bot will respond with clear, patient explanations suitable for high school students with no prior Xiangqi experience.
