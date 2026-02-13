#!/bin/bash
# NodeSeek-Signin VPS 一键同步脚本
# 使用方法: bash sync_vps.sh

set -e

echo "=========================================="
echo "  NodeSeek-Signin VPS 同步脚本"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检测项目目录
if [ ! -d ".git" ]; then
    echo -e "${RED}错误: 当前目录不是 Git 仓库${NC}"
    echo "请先进入 NodeSeek-Signin1 项目目录"
    exit 1
fi

echo -e "${YELLOW}[1/5] 检查当前状态...${NC}"
git status

echo ""
echo -e "${YELLOW}[2/5] 获取远程更新...${NC}"
git fetch origin

echo ""
echo -e "${YELLOW}[3/5] 拉取最新代码...${NC}"
git pull origin main

echo ""
echo -e "${YELLOW}[4/5] 验证更新...${NC}"

# 检查关键文件
if [ -f "CLOUDFLARE_RETRY_UPDATE.md" ] && \
   [ -f "IMPLEMENTATION_SUMMARY.md" ] && \
   [ -f "QUICK_REFERENCE.md" ] && \
   [ -f "test_cloudflare_retry.py" ]; then
    echo -e "${GREEN}✓ 新文件已成功同步${NC}"
else
    echo -e "${RED}✗ 部分文件可能未同步成功${NC}"
fi

# 检查代码更新
if grep -q "cf_retry_fingerprints" nodeseek_sign.py; then
    echo -e "${GREEN}✓ 代码已包含 CloudFlare 重试功能${NC}"
else
    echo -e "${RED}✗ 代码可能未正确更新${NC}"
fi

echo ""
echo -e "${YELLOW}[5/5] 运行测试脚本...${NC}"
if [ -f "test_cloudflare_retry.py" ]; then
    python3 test_cloudflare_retry.py || python test_cloudflare_retry.py
    echo -e "${GREEN}✓ 测试完成${NC}"
else
    echo -e "${YELLOW}! 测试脚本不存在，跳过测试${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}同步完成！${NC}"
echo "=========================================="
echo ""
echo "查看最新提交:"
git log -1 --oneline
echo ""
echo "如果使用 Docker，请运行:"
echo "  docker-compose down && docker-compose up -d --build"
echo ""
echo "如果使用青龙面板，请在面板中重新运行脚本"
echo ""
