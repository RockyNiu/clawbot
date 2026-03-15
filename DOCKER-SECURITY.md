# 🔒 OpenClaw Docker Security Guide

## Security Comparison

### `just setup` vs `just setup-secure`

| Item                      | `just setup`<br>(Standard Mode) | `just setup-secure`<br>(Hardened Security) |
| ------------------------- | ------------------------------- | ------------------------------------------ |
| **Network Binding**       | `lan` (0.0.0.0)                 | `loopback` (127.0.0.1)                     |
| **Access Range**          | All LAN devices                 | Local machine only                         |
| **Directory Permissions** | Default (may be 755)            | Enforced 700                               |
| **Token Generation**      | Use existing or manual          | Auto-generate 64-char random token         |
| **Security Verification** | None                            | Auto-verify after startup                  |
| **Use Case**              | Development/Testing             | Production                                 |
| **Security Level**        | ⭐⭐⭐                          | ⭐⭐⭐⭐⭐                                 |

## Quick Decision

```bash
# Developing/testing on your own computer?
just setup

# Deploying to server or production?
just setup-secure

# Already running, want to switch to secure mode?
just security-lock

# Need access from other devices (temporarily)?
just security-unlock
```

## Detailed Documentation

For complete security configuration, see [DOCKER.md - Security Configuration](./DOCKER.md#security-configuration)

---

📖 **Related documentation**:

- [DOCKER-SECURITY.zh-CN.md](./DOCKER-SECURITY.zh-CN.md) - Chinese version
- [DOCKER.md](./DOCKER.md) - Complete Docker guide
