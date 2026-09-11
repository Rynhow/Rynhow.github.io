@echo off
chcp 65001 >nul
title Git Auto Update
setlocal enabledelayedexpansion

:: ============================================
:: Git 一键提交推送脚本
:: 用法:
::   git-update.bat          只提交 + 推送
::   git-update.bat sync     先拉取，再提交 + 推送
:: ============================================

cd /d "%~dp0"

:: ---------- 解析参数 ----------
set DO_SYNC=0
if /i "%~1"=="sync" set DO_SYNC=1


:: ---------- 1. 检查 Git 仓库 ----------
git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 (
    echo.
    echo [错误] 当前目录不是 Git 仓库！
    echo        请把此文件放到 Git 项目目录。
    echo.
    pause
    exit /b 1
)


:: ---------- 2. 获取真实 Git 目录 ----------
set GIT_DIR=

for /f "delims=" %%i in ('git rev-parse --absolute-git-dir 2^>nul') do (
    set GIT_DIR=%%i
)

if "!GIT_DIR!"=="" (
    echo.
    echo [错误] 无法获取 Git 目录
    echo.
    pause
    exit /b 1
)


:: ---------- 3. 检查 Git 当前状态 ----------

git status --porcelain=v1 | findstr /r "^UU ^AA ^DD ^AU ^UA ^DU ^UD" >nul

if not errorlevel 1 (
    echo.
    echo [错误] 检测到未解决冲突！
    echo.
    echo 请执行:
    echo git status
    echo git add 文件
    echo git commit
    echo.
    pause
    exit /b 1
)


if exist "!GIT_DIR!\rebase-merge" (
    echo.
    echo [错误] 当前正在 rebase
    echo.
    echo 继续:
    echo git rebase --continue
    echo.
    echo 取消:
    echo git rebase --abort
    echo.
    pause
    exit /b 1
)


if exist "!GIT_DIR!\rebase-apply" (
    echo.
    echo [错误] 当前正在 rebase / am
    echo.
    echo 继续:
    echo git rebase --continue
    echo.
    echo 取消:
    echo git rebase --abort
    echo.
    pause
    exit /b 1
)


if exist "!GIT_DIR!\MERGE_HEAD" (
    echo.
    echo [错误] 当前正在 merge
    echo.
    echo 完成:
    echo git commit
    echo.
    echo 取消:
    echo git merge --abort
    echo.
    pause
    exit /b 1
)


if exist "!GIT_DIR!\CHERRY_PICK_HEAD" (
    echo.
    echo [错误] 当前正在 cherry-pick
    echo.
    echo 继续:
    echo git cherry-pick --continue
    echo.
    echo 取消:
    echo git cherry-pick --abort
    echo.
    pause
    exit /b 1
)



:: ---------- 4. 检查 Git 用户配置 ----------

set GIT_NAME=
set GIT_EMAIL=

for /f "delims=" %%i in ('git config user.name 2^>nul') do (
    set GIT_NAME=%%i
)

for /f "delims=" %%i in ('git config user.email 2^>nul') do (
    set GIT_EMAIL=%%i
)


if "!GIT_NAME!"=="" (
    echo.
    echo [错误] 未配置 Git 用户名
    echo.
    echo git config --global user.name "你的名字"
    echo.
    pause
    exit /b 1
)


if "!GIT_EMAIL!"=="" (
    echo.
    echo [错误] 未配置 Git 邮箱
    echo.
    echo git config --global user.email "你的邮箱"
    echo.
    pause
    exit /b 1
)



:: ---------- 5. 获取分支 ----------

set BRANCH=

for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD 2^>nul') do (
    set BRANCH=%%i
)


if "!BRANCH!"=="" (
    echo.
    echo [错误] 无法获取当前分支
    echo.
    pause
    exit /b 1
)



:: ---------- 6. 获取远程 ----------

set HAS_REMOTE=0
set REMOTE=

for /f "delims=" %%i in ('git remote') do (
    set REMOTE=%%i
    set HAS_REMOTE=1
    goto :remote_done
)

:remote_done



:: ---------- 标题 ----------

echo ==========================
echo       Git Auto Update
echo ==========================
echo 分支: !BRANCH!
echo 用户: !GIT_NAME! ^<!GIT_EMAIL!^>

if "!HAS_REMOTE!"=="1" (
    echo 远程: !REMOTE!
) else (
    echo 远程: 未配置
)

if "!DO_SYNC!"=="1" (
    echo 模式: 拉取 + 提交 + 推送
) else (
    echo 模式: 提交 + 推送
)

echo.



:: ---------- 7. 同步远程（仅传 sync 参数时执行） ----------

if "!DO_SYNC!"=="1" (

    if "!HAS_REMOTE!"=="1" (

        git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1

        if errorlevel 1 (

            echo [提示] 当前分支未绑定远程

        ) else (

            echo [同步] 拉取远程更新...

            git pull --rebase --autostash

            if errorlevel 1 (
                echo.
                echo [错误] 同步失败
                echo.
                echo git rebase --continue
                echo git rebase --abort
                echo.
                pause
                exit /b 1
            )
        )
    )

    echo.
)



:: ---------- 8. 提交修改 ----------

set MSG=

git status --porcelain | findstr /r "." >nul


if errorlevel 1 (

    echo [跳过] 没有需要提交的改动

) else (

    echo [改动文件]
    git status --short

    echo.


    for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do (
        set MSG=Update %%i
    )


    echo [提交] !MSG!
    echo.


    git add -A

    git commit -m "!MSG!"


    if errorlevel 1 (
        echo.
        echo [错误] 提交失败
        pause
        exit /b 1
    )

)



:: ---------- 9. 推送 ----------

if "!HAS_REMOTE!"=="1" (

    set NEED_PUSH=0
    set HAS_UPSTREAM=0


    git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1


    if errorlevel 1 (

        set NEED_PUSH=1

    ) else (

        set HAS_UPSTREAM=1


        for /f %%i in ('git log @{u}..HEAD --oneline 2^>nul ^| find /c /v ""') do (

            if %%i GTR 0 set NEED_PUSH=1

        )
    )


    if "!NEED_PUSH!"=="1" (

        echo.
        echo [推送] 正在上传...


        if "!HAS_UPSTREAM!"=="1" (

            git push

        ) else (

            git push -u !REMOTE! !BRANCH!

        )


        if errorlevel 1 (
            echo.
            echo [错误] 推送失败
            echo.
            echo 可能原因:
            echo   1. 远程有新提交，需要先同步
            echo      解决: git-update.bat sync
            echo   2. 网络 / 权限问题
            echo.
            pause
            exit /b 1
        )


    ) else (

        echo [跳过] 没有需要推送的提交

    )
)



:: ---------- 完成 ----------

echo.
echo ==========================

if defined MSG (

    echo 更新完成！
    echo !MSG!

) else (

    echo 完成（无改动）

)

echo ==========================
echo.

pause
endlocal