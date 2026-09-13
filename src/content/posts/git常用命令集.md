---
title: git常用命令集
published: 2026-09-11
description: "涵盖日常开发使用的 Git 常用命令，包括提交、推送、分支、撤销、SSH 与令牌等操作。"
tags: [git]
category: git
image: ./images/git.webp
---

# Git 常用命令完整版

> 覆盖日常开发 95% 以上场景，包含基础操作、团队协作、冲突处理、SSH 与令牌、误操作恢复等。

## 目录

1. 配置
2. 创建与克隆仓库
3. 日常提交
4. 查看差异与历史
5. 分支操作
6. 远程仓库
7. SSH 密钥配置
8. Personal Access Token
9. 凭证管理
10. 撤销与回退
11. 标签
12. 暂存工作区 stash
13. 清理工作区
14. .gitignore 相关
15. 子模块
16. 常见工作流
17. 冲突解决
18. 高级操作
19. 安全与恢复
20. 帮助命令

---

## 1. 配置

```bash
# 设置用户名和邮箱
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 查看配置
git config --list
git config --global --list
git config --local --list

# 设置默认编辑器
git config --global core.editor "vim"

# 设置默认分支名为 main
git config --global init.defaultBranch main

# 设置快捷别名
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --oneline --graph --decorate --all"
```

---

## 2. 创建与克隆仓库

```bash
# 在当前目录初始化一个新仓库
git init

# 克隆远程仓库到本地
git clone <url>

# 克隆指定分支
git clone -b <branch> <url>

# 浅克隆（只拉取最近一次提交，速度快）
git clone --depth 1 <url>
```

---

## 3. 日常提交

```bash
# 查看当前状态
git status
git status -s

# 把文件添加到暂存区
git add <file>
git add .
git add -A
git add -p                     # 交互式选择要提交的修改片段

# 提交
git commit -m "message"
git commit -am "message"       # 只对已经跟踪过的文件有效（新文件要先 add）
git commit --amend             # 修改上一次提交
git commit --amend --no-edit   # 修改上一次提交但不改提交信息
```

---

## 4. 查看差异与历史

```bash
# 查看差异
git diff
git diff --staged
git diff <branch1>..<branch2>
git diff <commit1> <commit2>

# 查看历史
git log
git log --oneline
git log --oneline --graph --decorate --all
git log -p <file>
git show <commit>
git blame <file>
git blame -L 10,20 <file>      # 查看指定行范围

# 搜索提交
git log -S "text"              # 查找添加或删除该字符串的提交
git log -G "regex"             # 查找匹配正则的提交

# 搜索代码
git grep "keyword"

# 查看所有操作记录（包括提交、重置等）
git reflog
```

---

## 5. 分支操作

```bash
# 查看分支
git branch
git branch -a
git branch -vv

# 创建分支
git branch <name>

# 切换分支
git switch <branch>
git checkout <branch>
git switch -                   # 切换到上一个分支
git checkout -                 # 旧写法

# 创建并切换分支
git switch -c <new-branch>
git checkout -b <new-branch>

# 删除分支
git branch -d <branch>
git branch -D <branch>         # 强制删除（即使未合并）

# 重命名分支
git branch -m <old> <new>
git branch -M main             # 强制把当前分支重命名为 main

# 合并分支
git merge <branch>
git merge --no-ff <branch>

# 变基
git rebase <branch>
git rebase -i HEAD~3

# 拣选某个提交
git cherry-pick <commit>
```

---

## 6. 远程仓库

```bash
# 查看远程仓库
git remote -v
git remote show origin

# 添加远程仓库
git remote add origin <url>

# 修改远程仓库地址
git remote set-url origin <url>

# 删除远程仓库
git remote remove origin

# 拉取
git fetch
git fetch --all --prune
git pull
git pull --rebase

# 推送
git push
git push -u origin <branch>
git push origin <branch>

# 安全强制推送（推荐，避免覆盖别人提交）
git push --force-with-lease

# 强制推送（慎用，会覆盖远程）
git push --force

# 删除远程分支
git push origin --delete <branch>

# 推送标签
git push --tags
```

---

## 7. SSH 密钥配置

> 用 SSH 方式连接，不用每次输入账号密码。

```bash
# 1. 查看是否已有 SSH 密钥
ls -al ~/.ssh
# 常见文件名：id_rsa、id_ed25519

# 2. 生成新的 SSH 密钥（推荐用 ed25519 算法）
ssh-keygen -t ed25519 -C "your_email@example.com"
# 一路回车就行，也可以设置密码短语

# 3. 启动 ssh-agent（Linux/macOS）
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Windows PowerShell 启动 ssh-agent
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519

# 4. 查看公钥内容
cat ~/.ssh/id_ed25519.pub
# Windows
type $env:USERPROFILE\.ssh\id_ed25519.pub
```

把公钥内容复制到 GitHub → **Settings → SSH and GPG keys → New SSH key**。

```bash
# 5. 测试连接
ssh -T git@github.com
# 成功会显示：Hi <username>! You've successfully authenticated...

# 6. 把远程仓库地址改成 SSH 格式
git remote set-url origin git@github.com:<user>/<repo>.git
git remote -v                  # 确认已切换

# 7. 多个账号时：配置 ~/.ssh/config
# Host github-work
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/id_ed25519_work

# 8. 临时指定某次提交使用的密钥
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519" git clone git@github.com:...
```

---

## 8. Personal Access Token

> 用 HTTPS 推送时，GitHub 已不再支持密码，需要用 Token 代替。

```bash
# 1. 生成 Token
# GitHub → Settings → Developer settings
#       → Personal access tokens → Tokens (classic)
# 勾选 repo 权限（如果需要 workflow 再勾 workflow）

# 2. 用 Token 来推送
# 用户名：GitHub 用户名
# 密码：粘贴 Token（不是登录密码）

# 3. 把 Token 缓存起来，不用每次都输入
git config --global credential.helper store
# Linux 也可以用：
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

# Windows 下用 Git Credential Manager
git config --global credential.helper manager

# 4. 查看或清除已保存的凭证
git config --global --get credential.helper
# Windows
cmdkey /list | findstr git
cmdkey /delete:git:https://github.com

# 5. 临时把 Token 写在 URL 里（不推荐长期用）
git clone https://<token>@github.com/<user>/<repo>.git

# 6. 细粒度 Token（Fine-grained tokens，权限更细）
# Settings → Developer settings → Fine-grained tokens
# 可以只授权某个仓库、某类权限，更安全
```

---

## 9. 凭证管理

```bash
# 查看当前使用的凭证助手
git config --global credential.helper

# 列出已保存的凭证
# macOS
git credential-osxkeychain get
# Linux
cat ~/.git-credentials
# Windows
cmdkey /list

# 删除已保存的凭证（换账号或 Token 失效时）
# Linux
rm ~/.git-credentials
# macOS
git credential-osxkeychain erase
# Windows
cmdkey /delete:git:https://github.com

# 建议统一使用一种认证方式，避免混乱
```

---

## 10. 撤销与回退

```bash
# 丢弃工作区里还没暂存的修改
git restore <file>
git checkout -- <file>          # 旧写法

# 把文件从暂存区撤回到工作区
git restore --staged <file>
git reset HEAD <file>           # 旧写法

# 从指定提交恢复文件
git restore --source=<commit> <file>

# 回退提交
git reset --soft HEAD~1         # 回退一次提交，保留修改和暂存
git reset --mixed HEAD~1        # 回退一次提交，保留修改但取消暂存（默认）
git reset --hard HEAD~1         # 回退一次提交，丢弃所有修改（慎用）

# 生成一个新提交来撤销某次提交的改动
git revert <commit>
```

---

## 11. 标签

```bash
# 查看标签
git tag

# 创建带说明的标签
git tag -a v1.0.0 -m "release v1.0.0"

# 查看标签详情
git show v1.0.0

# 推送标签
git push origin v1.0.0
git push origin --tags

# 删除本地标签
git tag -d v1.0.0

# 删除远程标签
git push origin --delete tag v1.0.0
```

---

## 12. 暂存工作区 stash

```bash
# 保存当前修改到暂存区，并加说明
git stash
git stash push -m "message"
git stash save "message"

# 查看 stash 列表
git stash list
git stash show

# 恢复
git stash apply
git stash pop

# 删除
git stash drop stash@{0}
git stash clear
```

---

## 13. 清理工作区

```bash
# 预览会删除哪些未跟踪文件
git clean -n

# 删除未跟踪的文件
git clean -f

# 删除未跟踪的文件和目录
git clean -fd

# 连 .gitignore 忽略的文件也删除（慎用）
git clean -fdx
```

> `git clean -fdx` 和 `git reset --hard` 会丢失数据，慎用。

---

## 14. .gitignore 相关

```bash
# 创建 .gitignore
echo "node_modules/" >> .gitignore
echo "dist/" >> .gitignore

# 停止跟踪已提交的文件，但保留本地文件
git rm -r --cached <file>
git rm -r --cached .

git add .
git commit -m "update .gitignore"
```

---

## 15. 子模块

```bash
# 添加子模块
git submodule add <url> <path>

# 查看子模块状态
git submodule status

# 初始化并递归更新子模块
git submodule update --init --recursive

# 更新子模块到远程最新
git submodule update --remote
```

---

## 16. 常见工作流

### 初始化并推送到远程

```bash
git init
git add .
git commit -m "init"
git branch -M main
git remote add origin <url>
git push -u origin main
```

### 同步远程主分支

```bash
git fetch --all --prune
git switch main
git pull --rebase
```

### 合并远程主分支到当前分支

```bash
git fetch origin
git merge origin/main

# 或者
git rebase origin/main
```

### 临时保存当前修改

```bash
git stash push -m "wip"
git switch main
git pull
git switch -
git stash pop
```

### 安全强制推送

```bash
git push --force-with-lease
```

### 首次用 SSH 推送

```bash
git init
git add .
git commit -m "init"
git branch -M main
git remote add origin git@github.com:<user>/<repo>.git
git push -u origin main
```

---

## 17. 冲突解决

### 合并冲突

```bash
git status                     # 查看冲突文件
# 手动编辑冲突文件，保留需要的代码
git add <file>
git merge --continue
# 或者
git commit
```

### 变基冲突

```bash
git status
# 手动编辑冲突文件
git add <file>
git rebase --continue
# 跳过当前提交
git rebase --skip
# 中止变基
git rebase --abort
```

### 拣选冲突

```bash
git status
# 手动编辑冲突文件
git add <file>
git cherry-pick --continue
# 中止
git cherry-pick --abort
```

### 中止合并

```bash
git merge --abort
```

---

## 18. 高级操作

### 交互式 rebase

```bash
git rebase -i HEAD~n
# 常用操作：
# pick   保留提交
# reword 修改提交信息
# edit   修改提交内容
# squash 合并到上一个提交并保留信息
# fixup  合并到上一个提交并丢弃信息
# drop   删除提交
```

### 修复旧提交

```bash
git commit --fixup <commit>
git rebase -i --autosquash <commit>~1
```

### 二分查找问题提交

```bash
git bisect start
git bisect bad                  # 当前版本有问题
git bisect good <commit>        # 已知正常版本
# Git 会自动切换到中间提交，测试后标记
git bisect good
git bisect bad
# 找到后重置
git bisect reset
```

### 多工作区

```bash
git worktree add ../hotfix main
git worktree list
git worktree remove ../hotfix
```

### 补丁协作

```bash
# 生成补丁
git format-patch -1 <commit>
git format-patch <commit1>..<commit2>

# 应用补丁
git am < patch-file
git apply < patch-file
```

### 大文件 LFS

```bash
git lfs install
git lfs track "*.psd"
git add .gitattributes
```

### 仓库维护

```bash
git gc
git fsck
git count-objects -vH
```

### 钩子与规范

```bash
# 本地钩子目录
.git/hooks

# 常用工具
pre-commit
husky
commitlint
```

---

## 19. 安全与恢复

```bash
# 查看所有操作记录
git reflog

# 恢复到某个操作之前
git reset --hard HEAD@{1}

# 为某次提交创建救援分支
git branch rescue <commit>

# 安全强制推送
git push --force-with-lease

# SSH 相关排查
ssh -vT git@github.com         # 查看详细连接过程
ssh-add -l                     # 列出已加载的密钥
```

> 误操作别着急，先 `git reflog`，大多数提交都能找回。

---

## 20. 帮助命令

```bash
git help <command>
git <command> -h
```

---

## 慎用命令

- `git reset --hard`
- `git clean -fdx`
- `git push --force`
- `git rebase` 已经推送到远端的公共分支

> 建议：提交前先 `git status`，推送前先 `git pull --rebase`，强制推送优先用 `--force-with-lease`。