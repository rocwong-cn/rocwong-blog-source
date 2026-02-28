# Hexo 博客自动化更新指南

## 📋 配置完成

已配置以下自动化流程：

### 1. 更新脚本

**位置**: `/root/.openclaw/workspace-code/project/rocwong-blog-source/update-blog.sh`

**功能**:
- 清理旧文件
- 生成静态文件
- 同步到 Nginx 目录
- 设置文件权限

### 2. Git 钩子

**位置**: `.git/hooks/post-commit`

**功能**: 每次 Git 提交后自动触发更新

---

## 🚀 使用方法

### 方式一：手动执行更新脚本

```bash
# 完整路径
/root/.openclaw/workspace-code/project/rocwong-blog-source/update-blog.sh

# 或者进入目录后执行
cd /root/.openclaw/workspace-code/project/rocwong-blog-source
./update-blog.sh
```

### 方式二：Git 提交后自动更新

```bash
# 修改博客内容
hexo new post "新文章标题"

# 添加并提交
git add .
git commit -m "feat: 新增文章"

# 自动触发更新（通过 post-commit 钩子）
```

### 方式三：添加命令别名（推荐）

```bash
# 添加到 ~/.bashrc
echo 'alias blog-update="/root/.openclaw/workspace-code/project/rocwong-blog-source/update-blog.sh"' >> ~/.bashrc
source ~/.bashrc

# 之后可以直接执行
blog-update
```

---

## 📝 完整工作流程

### 发布新文章

```bash
# 1. 进入博客目录
cd /root/.openclaw/workspace-code/project/rocwong-blog-source

# 2. 创建新文章
hexo new post "文章标题"

# 3. 编辑文章（在 source/_posts/ 目录）
vim source/_posts/文章标题.md

# 4. 提交更改
git add .
git commit -m "feat: 新增文章《文章标题》"
# 自动触发更新！

# 5. 推送到 GitHub（可选）
git push origin master
```

### 修改现有内容

```bash
# 1. 修改文件
vim source/_posts/xxx.md

# 2. 提交
git add .
git commit -m "fix: 更新 xxx 文章"
# 自动触发更新！

# 3. 推送
git push origin master
```

---

## 🔧 脚本输出示例

```
🚀 开始更新博客...

📁 工作目录：/root/.openclaw/workspace-code/project/rocwong-blog-source
📝 生成静态文件...
INFO  Generated: index.html
INFO  Generated: style.css
INFO  165 files generated in 590 ms

📦 同步文件到 Web 目录...
🔐 设置文件权限...

✅ 博客更新完成！

📊 统计信息:
   - 生成文件数：165
   - 更新时间：2026-02-28 16:22:56

🌐 访问地址：http://106.54.4.84/blog/
```

---

## ⚠️ 注意事项

### 1. Git 钩子仅在本地提交时触发
- `git commit` 会触发自动更新
- `git push` 不会触发（远程仓库没有钩子）

### 2. 如果需要远程自动更新
可以配置 GitHub Actions，在 push 到 master 分支后自动部署。

### 3. 权限问题
脚本会自动设置正确的文件权限（nginx:nginx）

### 4. Nginx 配置
更新后通常不需要重新加载 Nginx，除非修改了配置文件

---

## 🎯 快速命令参考

```bash
# 更新博客
blog-update

# 创建新文章
hexo new post "标题"

# 本地预览
hexo server

# 提交并自动更新
git add . && git commit -m "message"

# 推送到 GitHub
git push origin master
```

---

## 📞 有问题？

如果更新脚本执行失败，检查：
1. Node.js 和 npm 是否正常
2. 博客目录是否正确
3. Nginx 目录权限是否正确

可以手动执行脚本查看详细错误信息。
