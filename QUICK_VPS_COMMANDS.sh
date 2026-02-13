#!/bin/bash
# VPS 快速同步命令
# 复制并在 VPS 上执行

# 📌 最简单的方法（推荐）
git pull origin main

# 📊 查看更新内容
git log -3 --oneline

# ✅ 验证更新（运行测试）
python3 test_cloudflare_retry.py

# 🐳 如果使用 Docker
docker-compose down && docker-compose up -d --build

# 📝 查看容器日志
docker-compose logs -f

# ========================================
# 详细同步步骤（可选）
# ========================================

# 1. 备份当前配置（可选）
# cp .env .env.backup

# 2. 拉取最新代码
# git pull origin main

# 3. 检查新文件
# ls -la | grep -E "CLOUDFLARE|sync|test"

# 4. 验证代码更新
# grep -n "cf_retry_fingerprints" nodeseek_sign.py

# 5. 运行完整测试
# bash sync_vps.sh

# 6. 重启服务
# Docker: docker-compose restart
# 青龙: 在面板中重新运行
# 直接: python3 nodeseek_sign.py

# ========================================
# 快速故障排除
# ========================================

# 如果拉取时有冲突：
# git fetch origin && git reset --hard origin/main

# 如果 Docker 没更新：
# docker-compose down && docker-compose build --no-cache && docker-compose up -d

# 如果权限问题：
# sudo chown -R $USER:$USER .
