# 象棋导师 - 语音互动中国象棋教学机器人

> **中文** | **[English](README.md)**

一个 OpenClaw 技能，使用语音交互为零基础学习者教授中国象棋。

## 概述

这个技能专为从未接触过中国象棋的美国高中生设计。机器人提供：

- **循序渐进的课程**，从基础开始
- **互动练习**，包含走法验证
- **耐心的讲解**，适合初学者
- **语音交互**，通过 Mac 麦克风
- **渐进式学习**，结构化模块

## 快速开始

### 1. 在 OpenClaw 中启用语音唤醒

确保在 OpenClaw Mac 应用中启用了语音唤醒：

- 打开 OpenClaw 菜单栏应用
- 进入设置 → 语音
- 启用"语音唤醒"
- 用按键说话测试（Cmd+Fn）

### 2. 开始课程

使用语音激活导师：

```
"Hey OpenClaw, teach me Chinese chess"（教我中国象棋）
"Hey OpenClaw, use xiangqi tutor skill"（使用象棋导师技能）
"Hey OpenClaw, I want to learn Xiangqi"（我想学习象棋）
```

### 3. 跟随课程

机器人将引导你完成：

**模块 1**：象棋入门（5-10 分钟）

- 棋盘布局
- 基本术语
- 游戏目标

**模块 2**：学习棋子（15-20 分钟）

- 兵（Soldier）
- 车（Rook/Chariot）
- 炮（Cannon）
- 马（Horse）
- 相/象（Elephant/Bishop）
- 士/仕（Advisor/Guard）
- 将/帅（General/King）

**模块 3**：基本规则（10 分钟）

- 回合顺序
- 将军和将死
- 飞将规则
- 困毙

**模块 4**：简单战术（15-20 分钟）

- 牵制、双击、闪击
- 基本杀法

**模块 5**：练习对局（20-30 分钟）

- 带反馈的指导对局

## 辅助工具

### 棋盘可视化

查看当前棋盘状态：

```bash
cd ~/.openclaw/workspace/skills/xiangqi-tutor
python3 xiangqi-helper.py display
```

输出：

```
   a b c d e f g h i
10 r h e a g a e h r ← 黑方
 9 . . . . . . . . .
 8 . c . . . . . c .
 7 s . s . s . s . s
 6 . . . . . . . . .
 5 . . . . . . . . .
 4 S . S . S . S . S
 3 . C . . . . . C .
 2 . . . . . . . . .
 1 R H E A G A E H R ← 红方
```

### 走法验证

检查走法是否合法：

```bash
python3 xiangqi-helper.py validate e4 e5
# 输出: Valid: True, Message: Valid forward move

python3 xiangqi-helper.py validate a1 a5
# 输出: Valid: False, Message: Path blocked at a4
```

### 执行走法

执行一步棋并查看结果：

```bash
python3 xiangqi-helper.py move e4 e5
# 输出: Moved S from e4 to e5
# [显示更新后的棋盘]
```

## 语音交互提示

### 清晰发音

- 说话清晰，语速适中
- 使用完整记法："Rook at a-1 to a-6"
- 命令之间稍作停顿

### 交互示例

**开始时：**

- "Teach me Chinese chess from the beginning"（从头教我中国象棋）
- "Explain the Xiangqi board"（解释象棋棋盘）
- "What pieces are in Chinese chess?"（中国象棋有哪些棋子？）

**课程中：**

- "How does the Cannon move?"（炮怎么走？）
- "Can you repeat that?"（能重复一遍吗？）
- "Show me an example"（给我看个例子）
- "I don't understand, explain it differently"（我不明白，换个方式解释）

**练习：**

- "Let's practice with the Soldier"（我们练习兵的走法）
- "Is this move legal: e4 to e5?"（这步棋合法吗：e4 到 e5？）
- "Can the Rook at a1 move to a6?"（a1 的车能走到 a6 吗？）

**提问：**

- "What's the difference from regular chess?"（和国际象棋有什么区别？）
- "Why can't the Elephant cross the river?"（为什么象不能过河？）
- "What happens if the Generals face each other?"（如果将帅对面会怎样？）

## 进度追踪

技能会在 `game-state.json` 中追踪你的学习进度：

```json
{
  "currentModule": "introduction",
  "learnedPieces": ["soldier", "rook", "cannon"],
  "completedModules": ["introduction"],
  "sessionCount": 3,
  "notes": ["已掌握兵的走法", "马的蹩脚需要多练习"]
}
```

## 棋子快速参考

| 棋子             | 字母 | 走法     | 特殊规则               |
| ---------------- | ---- | -------- | ---------------------- |
| 将/帅 (General)  | G/g  | 直线一格 | 只能在九宫内，不能对面 |
| 士/仕 (Advisor)  | A/a  | 斜线一格 | 只能在九宫内           |
| 相/象 (Elephant) | E/e  | 斜线两格 | 不能过河，可被塞象眼   |
| 马 (Horse)       | H/h  | 日字形   | 可被蹩马腿             |
| 车 (Rook)        | R/r  | 任意直线 | 不能跳子               |
| 炮 (Cannon)      | C/c  | 同车走法 | 吃子必须隔一子         |
| 兵/卒 (Soldier)  | S/s  | 向前一格 | 过河后可横走           |

**大写字母 = 红方（先走）**
**小写字母 = 黑方**

## 常见问题

**Q: 学会需要多长时间？**
A: 基本规则 45-60 分钟。熟练需要练习！

**Q: 比国际象棋难吗？**
A: 学习曲线类似，但有些概念（如炮）是独特的。机器人会让学习变得简单！

**Q: 能和机器人对弈吗？**
A: 目前机器人专注于教学。练习对局请试试在线平台如 xiangqi.com。

**Q: 如果搞混了怎么办？**
A: 尽管问！机器人会重新措辞解释并提供更多例子。学习是循序渐进的。

## 课程建议

**第一节（45-60 分钟）：**

- 涵盖入门 + 3-4 个基本棋子
- 需要时休息
- 多提问

**后续课程（每节 30-45 分钟）：**

- 快速复习
- 学习 2-3 个新棋子
- 练习谜题

**完成模块 5 后：**

- 在在线平台练习对局
- 遇到具体问题时回到机器人
- 探索高级战术

## 疑难排解

### 语音唤醒不工作

1. 检查麦克风权限：
   - 系统设置 → 隐私与安全 → 麦克风
   - 为 OpenClaw 启用

2. 测试按键说话：
   - 按住 Cmd+Fn 并说话
   - 覆盖层应该出现

3. 检查唤醒词设置：
   - OpenClaw 应用 → 设置 → 语音
   - 确保唤醒词已配置

### 技能无响应

1. 刷新技能：

   ```bash
   openclaw skills refresh
   ```

2. 检查技能是否已安装：

   ```bash
   ls ~/.openclaw/workspace/skills/xiangqi-tutor/
   ```

3. 查看日志：
   ```bash
   ~/scripts/clawlog.sh --follow
   ```

## 进一步学习资源

### 在线平台

- [天天象棋](https://xiangqi.com) - 在线对弈
- [象棋俱乐部](https://clubxiangqi.com) - 社区和教程
- [中国象棋在线](https://www.chinesechessonline.net) - 练习谜题

### YouTube 频道

- Xiangqi Channel
- Chinese Chess School
- WXF Xiangqi（世界象棋联合会）

### 书籍推荐

- 《中国象棋入门》
- 《象棋战术》
- 《象棋残局大全》

### 移动应用

- 天天象棋（iOS/Android）
- 象棋大师（Android）
- Chinese Chess - Co Tuong（iOS）

## 贡献

发现了 bug 或想改进教学材料？

1. 报告技能问题
2. 为难懂的概念建议更好的解释
3. 分享成功的教学策略

## 技能文件

```
xiangqi-tutor/
├── SKILL.md              # 主技能定义和教学指南
├── README.md             # 英文文档
├── README.zh-CN.md       # 中文文档（本文件）
├── QUICKSTART.md         # 快速开始指南
├── xiangqi-helper.py     # 走法验证和棋盘显示工具
├── game-state.json       # 学生进度追踪器
└── test-skill.sh         # 测试脚本
```

## 致谢

为从未接触过中国象棋的美国高中生创建。设计用于 macOS 上 OpenClaw 的语音交互系统。

## 许可证

本技能按原样提供用于教育目的。象棋规则和术语是传统的，属于公共领域。

---

**准备好学习了吗？** 说：_"Hey OpenClaw, teach me Chinese chess!"_

象棋快乐！♟️
