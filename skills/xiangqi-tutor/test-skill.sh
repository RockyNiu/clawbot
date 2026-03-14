#!/bin/bash
# Test script for Xiangqi Tutor skill

echo "=========================================="
echo "Xiangqi Tutor - Skill Test"
echo "=========================================="
echo ""

# Check if skill directory exists
if [ ! -d "$HOME/.openclaw/workspace/skills/xiangqi-tutor" ]; then
    echo "❌ Skill directory not found!"
    echo "Expected: $HOME/.openclaw/workspace/skills/xiangqi-tutor"
    exit 1
fi

echo "✅ Skill directory found"

# Check if SKILL.md exists
if [ ! -f "$HOME/.openclaw/workspace/skills/xiangqi-tutor/SKILL.md" ]; then
    echo "❌ SKILL.md not found!"
    exit 1
fi

echo "✅ SKILL.md found"

# Check if helper script exists and is executable
if [ ! -x "$HOME/.openclaw/workspace/skills/xiangqi-tutor/xiangqi-helper.py" ]; then
    echo "⚠️  Helper script not executable, fixing..."
    chmod +x "$HOME/.openclaw/workspace/skills/xiangqi-tutor/xiangqi-helper.py"
fi

echo "✅ Helper script is executable"

# Test helper script
echo ""
echo "Testing move validation helper..."
cd "$HOME/.openclaw/workspace/skills/xiangqi-tutor"

# Test 1: Valid soldier move
result=$(python3 xiangqi-helper.py validate e4 e5 2>&1)
if echo "$result" | grep -q "Valid: True"; then
    echo "✅ Test 1 passed: Valid soldier move detected"
else
    echo "❌ Test 1 failed: Valid soldier move not detected"
    echo "$result"
fi

# Test 2: Invalid rook move (blocked)
result=$(python3 xiangqi-helper.py validate a1 a5 2>&1)
if echo "$result" | grep -q "Valid: False"; then
    echo "✅ Test 2 passed: Blocked rook move detected"
else
    echo "❌ Test 2 failed: Blocked rook move not detected"
    echo "$result"
fi

# Test 3: Display board
echo ""
echo "Testing board display..."
python3 xiangqi-helper.py display 2>&1 | head -5

echo ""
echo "=========================================="
echo "Skill Tests Complete!"
echo "=========================================="
echo ""
echo "To use the skill with OpenClaw:"
echo "1. Make sure OpenClaw Mac app is running"
echo "2. Enable Voice Wake in Settings → Voice"
echo "3. Say: 'Hey OpenClaw, teach me Chinese chess'"
echo ""
echo "Or test without voice:"
echo "  openclaw agent --message 'Teach me Chinese chess using the xiangqi tutor skill'"
echo ""
echo "View README for more info:"
echo "  cat $HOME/.openclaw/workspace/skills/xiangqi-tutor/README.md"
echo ""
