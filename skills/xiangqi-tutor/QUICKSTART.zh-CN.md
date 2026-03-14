# 象棋导师 - 快速开始指南

> **中文** | **[English](QUICKSTART.md)**

## 这是什么？

一个面向美国高中生的语音互动中国象棋教学机器人，在 Mac 上使用 OpenClaw。

## 安装状态

✅ **技能已安装并准备就绪！**

位置：

- **Repo 内置：** `skills/xiangqi-tutor/`（OpenClaw 源码库中）
- **用户工作区：** `~/.openclaw/workspace/skills/xiangqi-tutor/`（可选，自定义版本）

## 如何使用

### 方式 1：Docker 命令行（当前设置）

如果你使用的是 Docker 版本的 OpenClaw：

```bash
# 使用 claw 别名（技能名称是 xiangqi_tutor，注意是下划线）
claw "Use the xiangqi_tutor skill to teach me Chinese chess"

# 或者让 OpenClaw 自动选择技能
claw "Teach me Chinese chess"
claw "Explain how the Cannon moves in Xiangqi"
claw "Show me the Xiangqi board"

# 继续对话
claw "How does the Horse move?"
claw "What's the difference between Cannon and Rook?"
```

**验证技能已加载：**

```bash
docker compose -f docker-compose.yml exec openclaw-gateway node dist/index.js skills list | grep xiangqi
# 应该显示：♟️ xiangqi_tutor
```

### 方式 2：Mac 应用 + 语音交互（可选）

如果你安装了 OpenClaw Mac 菜单栏应用（带语音功能）：

1. **启动 OpenClaw Mac 应用**
   - 在 Finder → 应用程序中找到 OpenClaw
   - 或从 `/Applications/OpenClaw.app` 启动
   - 应用会显示在 Mac 顶部菜单栏（状态栏）

2. **启用语音唤醒**
   - 点击菜单栏中的 OpenClaw 图标
   - 进入设置 → 语音
   - 打开"语音唤醒"开关
   - 如果提示，授予麦克风权限

3. **开始学习**
   - 说：**"Hey OpenClaw, teach me Chinese chess"**（教我中国象棋）
   - 或：**"Hey OpenClaw, use the xiangqi_tutor skill"**（使用象棋导师技能）

4. **按键说话替代方式**
   - 按住 **Cmd+Fn** 说话
   - 松开发送

### 方式 3：辅助工具（测试走法）

```bash
# 查看棋盘
cd ~/.openclaw/workspace/skills/xiangqi-tutor
python3 xiangqi-helper.py display

# 验证走法
python3 xiangqi-helper.py validate e4 e5

# 执行走法并查看结果
python3 xiangqi-helper.py move e4 e5
```

**注意：** 该技能专为通过 OpenClaw Mac 应用进行语音交互而设计。命令行测试需要 OpenClaw 网关正在运行。

### 方式 3：按键说话（替代语音）

1. 按住 Mac 键盘上的 **Cmd+Fn**
2. 按住时说话
3. 说完后松开
4. 覆盖层将显示你的转录内容并发送请求

## 学习路径

机器人将引导你完成 5 个模块：

1. **入门**（5-10 分钟）- 棋盘布局和目标
2. **棋子**（15-20 分钟）- 学习每个棋子的走法
3. **基本规则**（10 分钟）- 将军、将死、特殊规则
4. **简单战术**（15-20 分钟）- 牵制、双击、杀法
5. **练习对局**（20-30 分钟）- 指导对局

**总学习时间：** 基础部分约 45-60 分钟

## 语音命令示例

**开始时：**

- "Teach me Chinese chess from scratch"（从头教我中国象棋）
- "What is Xiangqi?"（什么是象棋？）
- "Start the first lesson"（开始第一课）

**课程中：**

- "How does the Horse move?"（马怎么走？）
- "What's the difference between Cannon and Rook?"（炮和车有什么区别？）
- "Why can't the Elephant cross the river?"（为什么象不能过河？）
- "Can you repeat that?"（能重复一遍吗？）
- "I don't understand"（我不明白）

**练习：**

- "Let's practice with the Soldier"（我们练习兵的走法）
- "Is e4 to e5 a valid move?"（e4 到 e5 是合法走法吗？）
- "Show me the board"（显示棋盘）
- "What can the Rook at a1 do?"（a1 的车能做什么？）

## 验证安装

运行测试脚本：

```bash
~/.openclaw/workspace/skills/xiangqi-tutor/test-skill.sh
```

你应该看到：

- ✅ 找到技能目录
- ✅ 找到 SKILL.md
- ✅ 辅助脚本可执行
- ✅ 测试 1 通过：检测到有效的兵走法
- ✅ 测试 2 通过：检测到被阻挡的车走法

## 疑难排解

### "找不到技能"

```bash
# 刷新 OpenClaw 技能
openclaw skills refresh

# 或重启网关
# （通过 OpenClaw Mac 应用菜单）
```

### 语音唤醒无响应

1. 检查麦克风权限：
   - 系统设置 → 隐私与安全 → 麦克风
   - 确保 OpenClaw 有访问权限

2. 测试按键说话：
   - 按住 Cmd+Fn 并说话
   - 如果这个可以，唤醒词可能需要调整

3. 检查唤醒词设置：
   - OpenClaw 应用 → 设置 → 语音
   - 确保唤醒词已配置

### 辅助脚本不工作

```bash
# 确保它是可执行的
chmod +x ~/.openclaw/workspace/skills/xiangqi-tutor/xiangqi-helper.py

# 测试 Python
python3 --version  # 应该是 3.7+
```

## 学习后的下一步

完成模块后：

1. **在线练习**
   - [Xiangqi.com](https://xiangqi.com) - 与他人对弈
   - [象棋俱乐部](https://clubxiangqi.com) - 谜题和教程

2. **移动应用**
   - 天天象棋（iOS/Android）
   - 象棋大师（Android）

3. **进阶学习**
   - 有具体问题时回到导师
   - 学习开局原则
   - 学习残局定式

## 包含的文件

```
xiangqi-tutor/
├── SKILL.md              # 教学指南和技能定义
├── README.md             # 英文完整文档
├── README.zh-CN.md       # 中文完整文档
├── QUICKSTART.md         # 英文快速开始
├── QUICKSTART.zh-CN.md   # 中文快速开始（本文件）
├── xiangqi-helper.py     # 走法验证工具
├── game-state.json       # 进度追踪器
└── test-skill.sh         # 安装测试
```

## 需要帮助？

**课程内：** 只需让机器人换个方式解释或重复

**技术问题：**

- 查看 OpenClaw 日志：`~/scripts/clawlog.sh --follow`
- 重启 OpenClaw Mac 应用
- 验证麦克风权限

**象棋规则问题：**

- 在课程中询问机器人
- 查看 README.md 中的棋子参考
- 在线资源：[维基百科 - 象棋](https://zh.wikipedia.org/wiki/中国象棋)

## 技术说明

虽然这个技能是用**英语**教学（面向美国高中生），但所有文档都提供中英双语版本，方便开发者和贡献者。

课程本身使用英语进行语音交互，因为目标学生是美国高中生。如果你需要中文语音教学版本，可以基于这个技能创建一个中文变体。

---

**准备好开始了吗？** 打开 OpenClaw 并说：**"Hey OpenClaw, teach me Chinese chess!"**

享受学习！象棋快乐！♟️
