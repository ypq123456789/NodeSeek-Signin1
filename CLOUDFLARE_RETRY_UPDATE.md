# CloudFlare 自动重试功能更新说明

## 更新内容

已成功实现当签到或登录被 CloudFlare 阻拦时,自动切换浏览器指纹重试的功能。

## 主要改进

### 1. 指纹列表
系统会按顺序尝试以下 Chrome 浏览器指纹:
- chrome99
- chrome100
- chrome101
- chrome104
- chrome107
- chrome110
- chrome116
- chrome119
- chrome120
- chrome123
- chrome124
- chrome131
- chrome133a
- chrome136

### 2. 重试策略
- **重试间隔**: 每次切换指纹前等待 **60秒** (1分钟)
- **重试触发**: 当检测到 CloudFlare 挑战页面 (403状态码且包含特征字符串) 时自动触发
- **重试顺序**: 
  1. 首先尝试环境变量 `NS_IMPERSONATE` 配置的版本
  2. 如果失败,依次轮流尝试上述指纹列表

### 3. 修改的函数

#### 3.1 `sign()` - 签到函数
- 首次尝试使用默认配置
- 如遇到 CloudFlare 阻拦,自动切换指纹重试
- 每次重试前等待60秒
- 成功绕过后立即执行签到

#### 3.2 `session_login()` - 登录函数
- 首次尝试使用初始指纹
- 如遇到 CloudFlare 阻拦,自动切换指纹重试
- 每次重试前等待60秒
- 每次重试会重新创建 Session 并获取页面

#### 3.3 `_request_with_impersonate_fallback()` - 通用请求函数
- 用于 `get_signin_stats()` 等其他需要请求的函数
- 自动检测 CloudFlare 阻拦并切换指纹
- 添加了1分钟的重试间隔

## 工作原理

1. **CloudFlare 检测**: 通过检查响应状态码(403)和页面内容特征来识别 CloudFlare 挑战页
2. **指纹切换**: 使用 curl_cffi 的 impersonate 功能模拟不同版本的 Chrome 浏览器
3. **智能重试**: 只在确认是 CloudFlare 阻拦时才进行重试,避免不必要的等待

## 日志输出示例

```
[INFO] 检测到CloudFlare阻拦,开始轮流尝试不同指纹...
[INFO] 等待60秒后使用指纹 chrome99 重试...
[INFO] 正在使用指纹 chrome99 进行签到...
[WARN] 指纹 chrome99 仍被CloudFlare阻拦,继续尝试下一个...
[INFO] 等待60秒后使用指纹 chrome100 重试...
[INFO] 正在使用指纹 chrome100 进行签到...
[SUCCESS] 使用指纹 chrome100 成功绕过CloudFlare!
```

## 注意事项

1. 重试过程可能需要较长时间(最多约14分钟,如果所有指纹都需要尝试)
2. 成功绕过后,系统会立即执行签到操作
3. 如果所有指纹都失败,系统会返回失败状态
4. 环境变量 `NS_IMPERSONATE` 仍然有效,会作为第一个尝试的指纹

## 兼容性

- ✅ Docker 环境
- ✅ 青龙面板
- ✅ GitHub Actions
- ✅ 本地运行

## 更新时间

2026年2月13日
