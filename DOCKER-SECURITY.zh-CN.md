# 🔒 OpenClaw Docker 安全指南

## 安全性对比

### `just setup` vs `just setup-secure`

| 项目 | `just setup`<br>(标准模式) | `just setup-secure`<br>(安全强化) |
|------|----------------------------|----------------------------------|
| **网络绑定** | `lan` (0.0.0.0) | `loopback` (127.0.0.1) |
| **访问范围** | 局域网所有设备 | 仅本机 |
| **目录权限** | 默认（可能 755） | 强制 700 |
| **Token 生成** | 使用现有或手动 | 自动生成 64 字符随机 Token |
| **安全验证** | 无 | 启动后自动验证配置 |
| **适用场景** | 开发/测试环境 | 生产环境 |
| **安全级别** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 快速决策

```bash
# 在自己电脑上开发测试？
just setup

# 部署到服务器或生产环境？
just setup-secure

# 已经在运行，想切换到安全模式？
just security-lock

# 需要从其他设备访问（临时）？
just security-unlock
```

## 详细文档

完整的安全配置说明请查看 [DOCKER.zh-CN.md - 安全配置章节](./DOCKER.zh-CN.md#安全配置)

---

📖 **相关文档**:
- [DOCKER-SECURITY.md](./DOCKER-SECURITY.md) - English version
- [DOCKER.zh-CN.md](./DOCKER.zh-CN.md) - Docker 完整指南
