---
title: 30 分钟搭建你的第一个 AI Agent——OpenClaw 快速入门
date: 2026-02-28 16:30:00
tags: [AI, Agent, OpenClaw, 自动化，教程]
categories: [AI 应用，项目部署]
description: 从零开始，30 分钟搭建属于你的第一个 AI Agent 系统，支持飞书、WhatsApp 等多平台通讯。
---

# 30 分钟搭建你的第一个 AI Agent——OpenClaw 快速入门

> **系列文章**：本文是《OpenClaw 多 Agent 系统实战指南》系列的第一篇，后续将深入讲解多 Agent 协作、底层架构和生产部署。

---

## 一、为什么需要自建 AI Agent？

在这个 AI 爆发的时代，你可能已经用过 ChatGPT、Claude、文心一言等各种大模型产品。但有没有想过，**拥有一个专属的、7×24 小时在线的 AI 助手**是什么体验？

想象一下这些场景：

- 📱 **随时待命**：在飞书/WhatsApp 上直接发消息，AI 立即响应
- 🔗 **无缝集成**：连接你的代码仓库、数据库、内部系统
- 🤖 **多 Agent 协作**：让不同的 AI 专家各司其职，协同工作
- 🔒 **数据私密**：所有数据掌握在自己手中

这就是 **OpenClaw** 能带给你的能力。

### OpenClaw 是什么？

**OpenClaw** 是一个开源的多 Agent 协作框架，核心特点：

- 🎯 **零门槛**：30 分钟快速上手
- 🔌 **多平台**：支持飞书、WhatsApp、Telegram、微信等
- 🧠 **多模型**：支持 OpenAI、Claude、Qwen 等主流模型
- 🛠️ **可扩展**：自定义工具、技能、工作流
- 📦 **生产级**：支持高可用部署、监控、日志

本系列文章将带你从零开始，搭建一个完整的多 Agent AI 系统。

---

## 二、环境准备

### 系统要求

| 组件 | 要求 | 说明 |
|------|------|------|
| Node.js | 22.0+ | 必须，推荐使用 nvm 管理 |
| 操作系统 | Linux/macOS/Windows | 推荐 Linux 服务器 |
| 内存 | 2GB+ | 建议 4GB 以上 |
| 磁盘 | 1GB+ | 用于安装和存储 |

**检查 Node.js 版本**：

```bash
node -v
# 输出：v22.x.x
```

如果版本过低，使用 nvm 升级：

```bash
# 安装 nvm（如果尚未安装）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 Node.js 22
nvm install 22
nvm use 22
```

### 准备 API Key

OpenClaw 需要连接大模型提供商。推荐使用 **Qwen（通义千问）**，性价比高，中文支持好。

**获取 Qwen API Key**：

1. 访问 [阿里云百炼](https://bailian.console.aliyun.com/)
2. 注册/登录账号
3. 创建 API Key
4. 复制保存（后续配置要用）

> 💡 **提示**：也可以使用 OpenAI、Claude 等其他模型，配置方式类似。

### 选择通讯平台

OpenClaw 支持多种通讯渠道，本系列以 **飞书** 为例（国内最常用）：

- ✅ 飞书（推荐）
- WhatsApp
- Telegram
- 企业微信
- 钉钉

如果你有其他偏好，后续文章会补充配置方法。

---

## 三、快速安装

### 步骤 1：安装 OpenClaw

```bash
# 全局安装 OpenClaw
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

### 步骤 2：初始化配置

```bash
# 启动交互式配置向导
openclaw onboard
```

配置向导会提示你输入：

- **模型提供商**：选择 Qwen/OpenAI/Claude 等
- **API Key**：粘贴刚才准备的 Key
- **通讯渠道**：选择飞书/WhatsApp 等
- **工作空间**：默认 `~/.openclaw/workspace`

配置完成后，会在 `~/.openclaw/` 目录生成配置文件。

### 步骤 3：启动 Gateway

```bash
# 启动 OpenClaw 守护进程
openclaw gateway
```

看到以下输出表示启动成功：

```
✅ Gateway started on port 18789
🌐 Control UI: http://localhost:18789/openclaw/
```

> 💡 **提示**：Gateway 是 OpenClaw 的核心服务，负责消息路由、会话管理、Agent 调度等。

### 配置文件位置

```
~/.openclaw/
├── config.json          # 主配置文件
├── workspace/           # 工作空间
│   ├── SOUL.md         # Agent 人格定义
│   ├── USER.md         # 用户信息
│   ├── AGENTS.md       # 团队说明
│   └── MEMORY.md       # 长期记忆
└── logs/               # 日志目录
```

---

## 四、连接飞书渠道

### 步骤 1：创建飞书应用

1. 访问 [飞书开放平台](https://open.feishu.cn/)
2. 登录企业账号
3. 点击 **创建应用**
4. 填写应用信息：
   - 名称：`我的 AI 助手`
   - 图标：随便选一个
   - 描述：`个人 AI 助理`

### 步骤 2：配置应用权限

在 **权限管理** 页面，添加以下权限：

```
im:message          # 发送和接收消息
im:chat             # 访问会话信息
contact:user:readonly  # 读取用户信息
```

### 步骤 3：获取凭证

在 **凭证与基础信息** 页面，复制：

- **App ID**：`cli_xxxxxxxxx`
- **App Secret**：`xxxxxxxxxxxxxxxx`

### 步骤 4：配置 OpenClaw

编辑 `~/.openclaw/config.json`，添加飞书配置：

```json
{
  "channels": {
    "feishu": {
      "appId": "cli_xxxxxxxxx",
      "appSecret": "xxxxxxxxxxxxxxxx",
      "encryptKey": "",
      "verificationToken": ""
    }
  },
  "bindings": [
    {
      "channel": "feishu",
      "agent": "main"
    }
  ]
}
```

### 步骤 5：配置飞书回调

在飞书应用后台的 **事件订阅** 页面：

1. 填写回调 URL：`http://你的服务器 IP:18789/feishu`
2. 复制 **Verification Token** 填入 OpenClaw 配置
3. 启用事件订阅

### 步骤 6：测试消息收发

1. 在飞书搜索你的应用名称
2. 发送消息：`你好`
3. 如果收到回复，说明配置成功！🎉

> ❗ **常见问题**：
> 
> **Q1: 收不到消息**
> - 检查回调 URL 是否正确
> - 确认服务器防火墙开放 18789 端口
> - 查看 OpenClaw 日志：`tail -f ~/.openclaw/logs/gateway.log`
> 
> **Q2: 配置不生效**
> - 重启 Gateway：`openclaw gateway restart`
> - 检查 JSON 格式是否正确

---

## 五、定制你的 Agent 人格

OpenClaw 的强大之处在于可以**深度定制 Agent 的行为和人格**。

### 编辑 SOUL.md（人格定义）

```bash
vim ~/.openclaw/workspace/SOUL.md
```

示例内容：

```markdown
# SOUL.md - 你的 AI 人格

你是 **智能助手**，一位专业、友好的 AI 伙伴。

## 核心特质

- **专业**：提供准确、有深度的回答
- **友好**：语气温和，善于倾听
- **高效**：直击问题核心，不啰嗦

## 沟通风格

- 使用简洁清晰的语言
- 复杂问题分点说明
- 适当使用 emoji 增加亲和力

## 能力范围

- 技术咨询与解答
- 代码编写与审查
- 文档撰写与润色
- 数据分析与总结
```

### 编辑 USER.md（用户信息）

```bash
vim ~/.openclaw/workspace/USER.md
```

示例内容：

```markdown
# USER.md - 关于你的用户

## 基本信息

- **称呼**：鹏哥
- **职业**：全栈开发者
- **技术栈**：Vue.js, Node.js, Python

## 偏好

- 喜欢简洁直接的回答
- 代码示例要完整可执行
- 重要配置需要详细注释

## 项目背景

- 正在搭建 OpenClaw 多 Agent 系统
- 部署在腾讯云服务器
- 使用飞书作为主要沟通渠道
```

### 编辑 AGENTS.md（角色说明）

```bash
vim ~/.openclaw/workspace/AGENTS.md
```

示例内容：

```markdown
# AGENTS.md - 你的 AI 团队

## 当前配置

- **Agent ID**: main
- **角色**: 全能助手
- **职责**: 处理用户的各类请求

## 未来规划

后续将扩展为多 Agent 团队：
- AIBoss：团队主管
- AIContent：内容专家
- AINews：资讯助手
- AICode：代码助手
- AITask：任务管家
```

### 实战：创建一个技术助手

基于以上配置，你的 Agent 现在是一个**专业的技术助手**，可以：

- 解答编程问题
- 编写和审查代码
- 设计系统架构
- 撰写技术文档

---

## 六、验证与测试

### 发送测试消息

在飞书中向你的 Agent 发送：

```
你好，请介绍一下你自己
```

预期回复：

```
你好！我是你的智能助手，一位专业、友好的 AI 伙伴。😊

我可以帮你：
- 解答技术问题
- 编写和审查代码
- 撰写文档
- 分析数据

有什么可以帮你的吗？
```

### 查看会话状态

```bash
# 查看当前会话列表
openclaw sessions list

# 查看会话详情
openclaw sessions status
```

### 基础故障排查

| 问题 | 可能原因 | 解决方案 |
|------|---------|---------|
| 无响应 | Gateway 未启动 | `openclaw gateway start` |
| 回复慢 | 模型 API 延迟 | 检查网络和 API Key |
| 回复错误 | 配置有误 | 查看日志排查 |
| 权限错误 | 飞书权限不足 | 补充所需权限 |

**查看日志**：

```bash
# 实时查看日志
tail -f ~/.openclaw/logs/gateway.log

# 查看最近 100 行
tail -100 ~/.openclaw/logs/gateway.log
```

---

## 七、小结与预告

### 本篇要点回顾

✅ **环境准备**：Node.js 22+、API Key、飞书应用  
✅ **快速安装**：`npm install` → `onboard` → `gateway`  
✅ **渠道配置**：飞书应用创建与回调配置  
✅ **人格定制**：SOUL.md、USER.md、AGENTS.md  
✅ **验证测试**：消息收发与故障排查

### 下篇预告

**第二篇**：《从单兵到团队——OpenClaw 多 Agent 协作系统搭建》

你将学到：

- 🎭 **5 Agent 团队设计**：AIBoss、AIContent、AINews、AICode、AITask
- 📬 **消息路由机制**：按渠道、按任务类型智能分发
- 🔄 **Agent 间通信**：任务分解、协作、结果汇总
- 📊 **完整协作示例**：从需求到交付的全流程

---

## 系列文章导航

- 📖 **第一篇**：[30 分钟搭建你的第一个 AI Agent](/blog/) ← 当前
- 📖 **第二篇**：多 Agent 协作系统搭建（待发布）
- 📖 **第三篇**：底层架构与通信机制解析（待发布）
- 📖 **第四篇**：架构设计最佳实践（待发布）

---

**有问题？** 欢迎在评论区留言交流！👇

**下一篇**：我们将深入多 Agent 协作，打造一个 AI 团队！🚀
