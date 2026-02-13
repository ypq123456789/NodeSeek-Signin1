# 🔄 VPS 同步修改指南

## 📌 GitHub 提交状态

✅ **已完成提交**
- 提交信息: `feat: 添加CloudFlare自动重试功能 - 支持14个Chrome指纹轮换，重试间隔60秒`
- 修改文件: `nodeseek_sign.py`
- 新增文件: 
  - `CLOUDFLARE_RETRY_UPDATE.md`
  - `IMPLEMENTATION_SUMMARY.md`
  - `QUICK_REFERENCE.md`
  - `test_cloudflare_retry.py`

---

## 🚀 方法一：直接 Git Pull（推荐）

### 1. SSH 登录到 VPS
```bash
ssh your_user@your_vps_ip
```

### 2. 进入项目目录
```bash
cd /path/to/NodeSeek-Signin1
```

### 3. 拉取最新代码
```bash
git pull origin main
```

### 4. 验证更新
```bash
git log -1
# 应该看到: feat: 添加CloudFlare自动重试功能...
```

### 5. 运行测试（可选）
```bash
python test_cloudflare_retry.py
```

---

## 🔧 方法二：重新克隆（如果遇到冲突）

### 1. 备份当前配置
```bash
# 备份环境变量或配置文件
cp .env .env.backup
# 或备份 cookie 文件
cp -r cookie cookie.backup
```

### 2. 删除旧目录
```bash
cd ..
rm -rf NodeSeek-Signin1
```

### 3. 重新克隆
```bash
git clone https://github.com/ypq123456789/NodeSeek-Signin1.git
cd NodeSeek-Signin1
```

### 4. 恢复配置
```bash
# 恢复环境变量或配置文件
cp ../NodeSeek-Signin1.backup/.env .env
# 或恢复 cookie 文件
cp -r ../NodeSeek-Signin1.backup/cookie ./
```

---

## 🐳 方法三：Docker 环境更新

### 如果使用 Docker Compose

#### 1. 进入项目目录
```bash
cd /path/to/NodeSeek-Signin1
```

#### 2. 拉取最新代码
```bash
git pull origin main
```

#### 3. 重新构建并启动
```bash
docker-compose down
docker-compose up -d --build
```

#### 4. 查看日志
```bash
docker-compose logs -f
```

### 如果使用 Docker 命令

#### 1. 停止容器
```bash
docker stop nodeseek-signin
docker rm nodeseek-signin
```

#### 2. 拉取最新代码
```bash
cd /path/to/NodeSeek-Signin1
git pull origin main
```

#### 3. 重新构建镜像
```bash
docker build -t nodeseek-signin .
```

#### 4. 启动新容器
```bash
docker run -d \
  --name nodeseek-signin \
  -v $(pwd)/cookie:/app/cookie \
  -e USER="your_username" \
  -e PASS="your_password" \
  -e SOLVER_TYPE="turnstile" \
  -e API_BASE_URL="your_api_url" \
  -e CLIENTT_KEY="your_client_key" \
  nodeseek-signin
```

---

## 📱 方法四：青龙面板更新

### 1. 登录青龙面板
访问: `http://your_vps_ip:5700`

### 2. 进入"订阅管理"
找到 NodeSeek-Signin 订阅

### 3. 点击"更新"按钮
系统会自动拉取最新代码

### 4. 查看脚本
确认 `nodeseek_sign.py` 已更新

### 5. 手动运行测试
```bash
# 在青龙面板的终端中
cd /ql/data/scripts/NodeSeek-Signin1
python test_cloudflare_retry.py
```

---

## ⚙️ 方法五：GitHub Actions 自动同步（高级）

### 1. 在 VPS 上设置定时拉取

#### 创建更新脚本
```bash
cat > /path/to/update_nodeseek.sh << 'EOF'
#!/bin/bash
cd /path/to/NodeSeek-Signin1
git fetch origin
git reset --hard origin/main
echo "Updated at $(date)"
EOF

chmod +x /path/to/update_nodeseek.sh
```

#### 添加 crontab 定时任务
```bash
crontab -e
```

添加以下行（每天凌晨2点更新）：
```
0 2 * * * /path/to/update_nodeseek.sh >> /var/log/nodeseek_update.log 2>&1
```

---

## 🔍 验证更新是否成功

### 检查文件是否存在
```bash
ls -la | grep -E "CLOUDFLARE|IMPLEMENTATION|QUICK|test_cloudflare"
```

应该看到：
```
-rw-r--r-- 1 user user  xxxx CLOUDFLARE_RETRY_UPDATE.md
-rw-r--r-- 1 user user  xxxx IMPLEMENTATION_SUMMARY.md
-rw-r--r-- 1 user user  xxxx QUICK_REFERENCE.md
-rw-r--r-- 1 user user  xxxx test_cloudflare_retry.py
```

### 查看代码是否包含新功能
```bash
grep -n "cf_retry_fingerprints" nodeseek_sign.py
```

应该看到多处匹配（第299、312、368、375、376、417、435行）

### 运行测试脚本
```bash
python test_cloudflare_retry.py
```

应该看到所有测试通过 ✅

---

## 🚨 常见问题

### 问题1: git pull 提示有冲突
**解决方案**:
```bash
# 方案A: 强制覆盖本地修改
git fetch origin
git reset --hard origin/main

# 方案B: 保存本地修改后再拉取
git stash
git pull origin main
git stash pop
```

### 问题2: 权限问题
**解决方案**:
```bash
# 修改文件所有者
sudo chown -R $USER:$USER /path/to/NodeSeek-Signin1

# 或使用 sudo
sudo git pull origin main
```

### 问题3: Docker 容器没有更新
**解决方案**:
```bash
# 完全重建（不使用缓存）
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### 问题4: 青龙面板订阅更新失败
**解决方案**:
```bash
# 手动进入容器更新
docker exec -it qinglong bash
cd /ql/data/scripts/NodeSeek-Signin1
git pull origin main
```

---

## 📊 更新后的新功能

✅ **CloudFlare 自动重试**
- 检测到阻拦时自动切换浏览器指纹
- 14个 Chrome 版本轮流尝试
- 每次重试间隔60秒
- 适用于签到、登录、查询统计

✅ **详细日志输出**
- 清晰显示重试过程
- 成功/失败状态明确
- 便于排查问题

✅ **智能检测**
- 只在必要时触发重试
- 避免不必要的等待
- 提高成功率

---

## 📞 需要帮助？

1. 查看文档: `QUICK_REFERENCE.md`
2. 查看实现: `IMPLEMENTATION_SUMMARY.md`
3. 运行测试: `python test_cloudflare_retry.py`

---

## ✅ 更新检查清单

- [ ] 已登录 VPS
- [ ] 已进入项目目录
- [ ] 已执行 `git pull origin main`
- [ ] 已验证新文件存在
- [ ] 已运行测试脚本
- [ ] 已重启服务（如使用 Docker/青龙）
- [ ] 已确认功能正常工作

**完成以上步骤后，VPS 上的代码就已经同步最新版本了！** 🎉
