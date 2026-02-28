#!/bin/bash

# Hexo 博客自动化更新脚本
# 用途：生成静态文件并同步到 Nginx 目录

set -e

# 配置
BLOG_SOURCE="/root/.openclaw/workspace-code/project/rocwong-blog-source"
BLOG_PUBLIC="/usr/share/nginx/html/blog"

echo "🚀 开始更新博客..."
echo ""

# 1. 进入博客目录
cd "$BLOG_SOURCE"
echo "📁 工作目录：$BLOG_SOURCE"

# 2. 清理并生成静态文件
echo "📝 生成静态文件..."
npx hexo clean
npx hexo generate

# 3. 同步到 Nginx 目录
echo "📦 同步文件到 Web 目录..."
rm -rf "$BLOG_PUBLIC"/*
cp -r "$BLOG_SOURCE/public/"* "$BLOG_PUBLIC/"

# 4. 设置权限
echo "🔐 设置文件权限..."
chown -R nginx:nginx "$BLOG_PUBLIC"
chmod -R 755 "$BLOG_PUBLIC"

# 5. 重新加载 Nginx（可选，通常不需要）
# echo "🔄 重新加载 Nginx..."
# /usr/sbin/nginx -s reload

echo ""
echo "✅ 博客更新完成！"
echo ""
echo "📊 统计信息:"
echo "   - 生成文件数：$(find $BLOG_PUBLIC -type f | wc -l)"
echo "   - 更新时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "🌐 访问地址：http://106.54.4.84/blog/"
