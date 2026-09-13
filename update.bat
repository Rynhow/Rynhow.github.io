@echo off
chcp 65001 >nul
title Git Auto Update
setlocal enabledelayedexpansion

:: ============================================
:: Git 一键提交推送脚本
::
:: 用法:
::   git-update.bat                    提交 + 推送（默认，不拉取）
::   git-update.bat sync               先拉取 + 提交 + 推送
::   git-update.bat "自定义信息"        用自定义信息提交
::   git-update.bat sync "自定义信息"   先拉取 + 自定义信息提交
::   git-update.bat ... nopause        跳过结尾 pause（自动化用）
:: ============================================

cd /d "%~dp0"

:: ---------- 解析参数 ----------
set DO_SYNC=0
set NO_PAUSE=0
set CUSTOM_MSG=

:parse_args
if "%~1"=="" goto args_done

if /i "%~1"=="sync" (
    set DO_SYNC=1
    shift
    goto parse_args
)

if /i "%~1"=="nopause" (
    set NO_PAUSE=1
    shift
    goto parse_args
)

set CUSTOM_MSG=%~1
shift
goto parse_args

:args_done

:: pause 宏：需要时执行 pause，否则空操作
set "DO_PAUSE=pause"
if "!NO_PAUSE!"=="1" set "DO_PAUSE=rem"


:: ---------- 1. 检查 Git 仓库 ----------
git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 (
    echo.
    echo   [X] 当前目录不是 Git 仓库
    echo       请把此文件放到 Git 项目目录
    echo.
    !DO_PAUSE!
    exit /b 1
)

:: 关闭路径转义，让中文文件名正常显示
git config core.quotepath false >nul 2>&1


:: ---------- 2. 获取 Git 目录 ----------
set GIT_DIR=

for /f "delims=" %%i in ('git rev-parse --absolute-git-dir 2^>nul') do (
    set GIT_DIR=%%i
)

if "!GIT_DIR!"=="" (
    echo.
    echo   [X] 无法获取 Git 目录
    echo.
    !DO_PAUSE!
    exit /b 1
)


:: ---------- 3. 检查当前是否处于中断状态 ----------

git status --porcelain=v1 | findstr /r "^UU ^AA ^DD ^AU ^UA ^DU ^UD" >nul

if not errorlevel 1 (
    echo.
    echo   [!] 检测到未解决冲突
    echo.
    echo   请执行:
    echo     git status
    echo     git add 文件
    echo     git commit
    echo.
    !DO_PAUSE!
    exit /b 1
)


if exist "!GIT_DIR!\rebase-merge" (
    echo.
    echo   [!] 当前正在 rebase
    echo.
    echo   继续:  git rebase --continue
    echo   取消:  git rebase --abort
    echo.
    !DO_PAUSE!
    exit /b 1
)


if exist "!GIT_DIR!\rebase-apply" (
    echo.
    echo   [!] 当前正在 rebase / am
    echo.
    echo   继续:  git rebase --continue
    echo   取消:  git rebase --abort
    echo.
    !DO_PAUSE!
    exit /b 1
)


if exist "!GIT_DIR!\MERGE_HEAD" (
    echo.
    echo   [!] 当前正在 merge
    echo.
    echo   完成:  git commit
    echo   取消:  git merge --abort
    echo.
    !DO_PAUSE!
    exit /b 1
)


if exist "!GIT_DIR!\CHERRY_PICK_HEAD" (
    echo.
    echo   [!] 当前正在 cherry-pick
    echo.
    echo   继续:  git cherry-pick --continue
    echo   取消:  git cherry-pick --abort
    echo.
    !DO_PAUSE!
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
    echo   [X] 未配置 Git 用户名
    echo       git config --global user.name "你的名字"
    echo.
    !DO_PAUSE!
    exit /b 1
)


if "!GIT_EMAIL!"=="" (
    echo.
    echo   [X] 未配置 Git 邮箱
    echo       git config --global user.email "你的邮箱"
    echo.
    !DO_PAUSE!
    exit /b 1
)



:: ---------- 5. 获取分支和远程 ----------

set BRANCH=

for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD 2^>nul') do (
    set BRANCH=%%i
)

if "!BRANCH!"=="" (
    echo.
    echo   [X] 无法获取当前分支
    echo.
    !DO_PAUSE!
    exit /b 1
)


set HAS_REMOTE=0
set REMOTE=

for /f "delims=" %%i in ('git remote') do (
    set REMOTE=%%i
    set HAS_REMOTE=1
    goto :remote_done
)

:remote_done



:: ---------- 标题 ----------
echo.
echo   +==========================================+
echo   ^|            G I T   A U T O               ^|
echo   ^|            U P D A T E                   ^|
echo   +==========================================+
echo   ^|  branch : !BRANCH!
echo   ^|  user   : !GIT_NAME!

if "!HAS_REMOTE!"=="1" (
    echo   ^|  remote : !REMOTE!
) else (
    echo   ^|  remote : (none)
)

if "!DO_SYNC!"=="1" (
    echo   ^|  mode   : pull + commit + push
) else (
    echo   ^|  mode   : commit + push
)

echo   +==========================================+
echo.



:: ---------- 6. 同步远程（仅传 sync 参数时执行） ----------

if "!DO_SYNC!"=="1" (

    if "!HAS_REMOTE!"=="1" (

        git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1

        if errorlevel 1 (

            echo   [~] 当前分支未绑定远程，跳过拉取

        ) else (

            echo   [~] 拉取远程更新...
            echo.

            git pull --rebase --autostash

            if errorlevel 1 (
                echo.
                echo   [X] 同步失败
                echo.
                echo   继续:  git rebase --continue
                echo   取消:  git rebase --abort
                echo.
                echo   注意: 如果之前有未提交的改动，检查一下:
                echo         git stash list
                echo         git stash pop
                echo.
                !DO_PAUSE!
                exit /b 1
            )

            echo.
            echo   [OK] 同步完成
        )
    ) else (
        echo   [!] 未配置远程仓库，跳过拉取
    )

    echo.
)



:: ---------- 7. 提交修改 ----------

set MSG=
set HAS_COMMIT=0

git status --porcelain | findstr /r "." >nul


if errorlevel 1 (

    echo   [-] 没有需要提交的改动

) else (

    echo   [*] 改动文件:
    echo   ------------------------------------------
    git status --short
    echo   ------------------------------------------
    echo.


    if "!CUSTOM_MSG!"=="" (

        for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do (
            set MSG=Update %%i
        )

    ) else (

        set MSG=!CUSTOM_MSG!

    )


    echo   [^>] 提交: !MSG!
    echo.


    git add -A

    git commit -m "!MSG!"


    if errorlevel 1 (
        echo.
        echo   [X] 提交失败
        !DO_PAUSE!
        exit /b 1
    )

    set HAS_COMMIT=1
    echo.
    echo   [OK] 提交完成

)



:: ---------- 8. 推送 ----------

if "!HAS_REMOTE!"=="0" (
    echo.
    echo   [!] 未配置远程仓库，跳过推送
    goto :done
)


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


if "!NEED_PUSH!"=="0" (

    echo   [-] 没有需要推送的提交
    goto :done

)


echo.
echo   [^>] 推送到远程...
echo       (如果卡住，可能是需要输入密码或 SSH 认证)
echo.


if "!HAS_UPSTREAM!"=="1" (

    git push

) else (

    git push -u !REMOTE! !BRANCH!

)


if errorlevel 1 (
    echo.
    echo   [X] 推送失败
    echo.
    echo   可能原因:
    echo     1. 网络 / 权限问题
    echo     2. SSH key 未配置
    echo     3. 远程分支被保护
    echo.
    echo   排查:
    echo     ssh -T git@github.com
    echo     git remote -v
    echo.
    !DO_PAUSE!
    exit /b 1
)

echo.
echo   [OK] 推送完成



:: ---------- 完成 ----------
:done

echo.
echo   +==========================================+
echo   ^|                                          ^|

if "!HAS_COMMIT!"=="1" (

    echo   ^|            * 更新完成 *                  ^|
    echo   ^|            !MSG!

) else (

    echo   ^|            - 无改动 -                    ^|

)

echo   ^|                                          ^|
echo   +==========================================+
echo.

!DO_PAUSE!
endlocal