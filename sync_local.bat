@echo off
REM NodeSeek-Signin 本地同步脚本 (Windows)
REM 使用方法: sync_local.bat

echo ==========================================
echo   NodeSeek-Signin 本地同步脚本
echo ==========================================
echo.

REM 检查是否在 Git 仓库中
if not exist ".git" (
    echo [错误] 当前目录不是 Git 仓库
    echo 请先进入 NodeSeek-Signin1 项目目录
    pause
    exit /b 1
)

echo [1/5] 检查当前状态...
git status
echo.

echo [2/5] 获取远程更新...
git fetch origin
echo.

echo [3/5] 拉取最新代码...
git pull origin main
echo.

echo [4/5] 验证更新...

REM 检查关键文件
if exist "CLOUDFLARE_RETRY_UPDATE.md" (
    if exist "IMPLEMENTATION_SUMMARY.md" (
        if exist "QUICK_REFERENCE.md" (
            if exist "test_cloudflare_retry.py" (
                echo [OK] 新文件已成功同步
            )
        )
    )
) else (
    echo [警告] 部分文件可能未同步成功
)

REM 检查代码更新
findstr /C:"cf_retry_fingerprints" nodeseek_sign.py >nul
if %errorlevel%==0 (
    echo [OK] 代码已包含 CloudFlare 重试功能
) else (
    echo [警告] 代码可能未正确更新
)

echo.
echo [5/5] 运行测试脚本...
if exist "test_cloudflare_retry.py" (
    python test_cloudflare_retry.py
    echo [OK] 测试完成
) else (
    echo [警告] 测试脚本不存在，跳过测试
)

echo.
echo ==========================================
echo 同步完成！
echo ==========================================
echo.
echo 查看最新提交:
git log -1 --oneline
echo.
pause
