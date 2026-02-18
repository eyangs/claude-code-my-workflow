# GitHub Pages 快速部署指南

## 前置条件

- 已完成 OpenCode 工作流复现的第三步（本地部署）
- 有 GitHub 账号
- 有推送权限到仓库：`https://github.com/pedrohcgs/claude-code-my-workflow`

---

## 步骤 1: 配置 GitHub 身份验证

### 方案 A: 使用 SSH 密钥（推荐）

```bash
# 1. 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 启动 ssh-agent
eval "$(ssh-agent -s)"

# 3. 添加密钥到 ssh-agent
ssh-add ~/.ssh/id_ed25519

# 4. 复制公钥
cat ~/.ssh/id_ed25519.pub

# 5. 在 GitHub 添加公钥
#    访问：https://github.com/settings/keys
#    点击：New SSH key
#    标题：OpenCode Ubuntu
#    粘贴公钥内容
#    点击：Add SSH key

# 6. 更改远程仓库 URL（在项目目录）
cd /home/yang/.openclaw/workspace/claude-code-my-workflow
git remote set-url origin git@github.com:pedrohcgs/claude-code-my-workflow.git

# 7. 测试连接
ssh -T git@github.com

# 8. 推送到 GitHub
git push origin main
```

### 方案 B: 使用 GitHub CLI

```bash
# 1. 登录 GitHub
gh auth login

# 2. 按照提示选择：
#    - What account do you want to log into? → GitHub.com
#    - What is your preferred protocol for Git operations? → HTTPS
#    - Authenticate with a GitHub.com device code → Enter

# 3. 测试登录
gh auth status

# 4. 推送到 GitHub
cd /home/yang/.openclaw/workspace/claude-code-my-workflow
git push origin main
```

### 方案 C: 使用 Personal Access Token（PAT）

```bash
# 1. 生成 token
#    访问：https://github.com/settings/tokens
#    点击：Generate new token (classic)
#    勾选：repo (控制私有仓库)
#    点击：Generate token
#    复制生成的 token（只显示一次！）

# 2. 使用 token 推送
cd /home/yang/.openclaw/workspace/claude-code-my-workflow
git push https://YOUR_TOKEN@github.com/pedrohcgs/claude-code-my-workflow.git main
```

---

## 步骤 2: 启用 GitHub Pages

### 通过网页配置

1. 访问仓库：https://github.com/pedrohcgs/claude-code-my-workflow
2. 点击 `Settings` 标签
3. 在左侧菜单中找到 `Pages`（在 "Code and automation" 下）
4. 在 `Build and deployment` 部分：
   - `Source` 选择：`Deploy from a branch`
   - `Branch` 选择：`main` 和 `/ (root)`（或 `/docs`）
   - 点击 `Save`

### 等待部署

- GitHub 会自动构建和部署
- 通常需要 1-3 分钟
- 可以在 `Pages` 设置页面查看部署状态
- 成功后会显示访问 URL

---

## 步骤 3: 验证部署

### 访问在线版本

根据你的配置，访问以下 URL 之一：

1. **如果从根目录部署:**
   - `https://pedrohcgs.github.io/claude-code-my-workflow/`

2. **如果从 docs 目录部署:**
   - `https://pedrohcgs.github.io/claude-code-my-workflow/docs/`

### 检查内容

- [ ] 首页可以访问
- [ ] 链接可以点击
- [ ] 幻灯片可以查看
- [ ] 样式正确显示
- [ ] 数学公式渲染正确

---

## 步骤 4: 配置自定义域名（可选）

### 设置域名

1. 在 `Pages` 设置页面
2. 找到 `Custom domain`
3. 输入你的域名（如：`slides.example.com`）
4. 点击 `Save`

### 配置 DNS

在你的域名提供商（如 Cloudflare、阿里云）添加 DNS 记录：

| 类型 | 名称 | 值 | TTL |
|------|------|-----|-----|
| CNAME | slides | pedrohcgs.github.io. | 3600 |
| CNAME | www | pedrohcgs.github.io. | 3600 |

### 启用 HTTPS

1. 在 `Pages` 设置页面
2. 勾选 `Enforce HTTPS`
3. 等待证书颁发（通常 5-10 分钟）

---

## 常见问题

### Q1: 推送失败，提示权限错误

**A:** 检查：
- 是否有仓库的写入权限
- SSH 密钥是否正确添加
- Token 是否有 `repo` 权限

### Q2: GitHub Pages 部署失败

**A:** 检查：
- `docs/` 目录是否存在于根目录
- `index.html` 文件是否存在
- GitHub Actions 日志是否有错误

### Q3: 访问 404 Not Found

**A:** 检查：
- 部署是否完成（等待 1-3 分钟）
- URL 是否正确
- 浏览器缓存（尝试 Ctrl+Shift+R 强制刷新）

### Q4: 样式显示异常

**A:** 检查：
- Quarto 渲染是否成功
- RevealJS 库文件是否上传
- 浏览器控制台是否有错误（F12）

---

## 自动化部署（高级）

### 使用 GitHub Actions

创建 `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 自动化脚本

创建 `scripts/deploy.sh`:

```bash
#!/bin/bash

# 编译 Beamer
cd Slides
make Demo_Simple.pdf
cd ..

# 渲染 Quarto
cd Quarto
quarto render Demo_Simple.qmd
cd ..

# 同步到 docs
./scripts/sync_to_docs.sh Demo_Simple

# 推送到 GitHub
git add docs/
git commit -m "Auto deploy: $(date)"
git push origin main
```

---

## 快速参考

### 推送命令

```bash
# 从项目目录
cd /home/yang/.openclaw/workspace/claude-code-my-workflow

# 添加所有更改
git add .

# 提交
git commit -m "Update content"

# 推送
git push origin main
```

### 检查部署状态

```bash
# 查看 GitHub Actions 运行状态
gh run list --limit 5

# 查看特定运行
gh run view <run-id>

# 查看部署日志
gh run view <run-id> --log
```

---

**最后更新:** 2026-02-18
**维护者:** AI Assistant (OpenCode)
