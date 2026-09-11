---
title: git常用命令集
published: 2026-04-16
description: "涵盖日常开发使用的 Git 常用命令，包括提交、推送、分支、撤销等操作。"
tags: [git]
category: git
---

# Git 常用命令完整版

> 覆盖日常开发 95% 以上场景，包含基础操作、团队协作、冲突处理、历史整理、误操作恢复等。

## 目录

1. 配置
2. 创建与克隆仓库
3. 日常提交
4. 查看差异与历史
5. 分支操作
6. 远程仓库
7. 撤销与回退
8. 标签
9. 暂存工作区 stash
10. 清理工作区
11. 子模块
12. .gitignore 相关
13. 常见工作流
14. 冲突解决
15. 高级操作
16. 安全与恢复
17. 帮助命令

------

## 1. 配置

bash

```
# 设置用户名和邮箱
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 查看配置
git config --list
git config --global --list
git config --local --list

# 设置默认编辑器
git config --global core.editor "vim"

# 设置别名
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --oneline --graph --decorate --all"
```



## 2. 创建与克隆仓库

bash

```
# 初始化本地仓库
git init

# 克隆远程仓库
git clone <url>

# 克隆指定分支
git clone -b <branch> <url>

# 浅克隆（只拉取最近一次提交）
git clone --depth 1 <url>
```



## 3. 日常提交

bash

```
# 查看状态
git status
git status -s

# 添加到暂存区
git add <file>
git add .
git add -A
git add -p                     # 交互式选择部分修改

# 提交
git commit -m "message"
git commit -am "message"       # 仅对已跟踪文件有效
git commit --amend             # 修改上一次提交
git commit --amend --no-edit   # 修改上一次提交但不改提交信息
```



## 4. 查看差异与历史

bash

```
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
git log -S "text"              # 查找添加/删除该字符串的提交
git log -G "regex"             # 查找匹配正则的提交

# 搜索代码
git grep "keyword"

# 查看引用日志
git reflog
```



## 5. 分支操作

bash

```
# 查看分支
git branch
git branch -a
git branch -vv

# 创建分支
git branch <name>

# 切换分支
git switch <branch>
git checkout <branch>
git switch -                   # 切换回上一个分支
git checkout -                 # 旧写法

# 创建并切换分支
git switch -c <new-branch>
git checkout -b <new-branch>

# 删除分支
git branch -d <branch>
git branch -D <branch>         # 强制删除

# 重命名分支
git branch -m <old> <new>
git branch -M main             # 强制重命名当前分支为 main

# 合并
git merge <branch>
git merge --no-ff <branch>

# 变基
git rebase <branch>
git rebase -i HEAD~3

# 拣选提交
git cherry-pick <commit>
```



## 6. 远程仓库

bash

```
# 查看远程
git remote -v
git remote show origin

# 添加远程
git remote add origin <url>

# 修改远程地址
git remote set-url origin <url>

# 删除远程
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

# 安全强推（推荐）
git push --force-with-lease

# 强制推送（慎用）
git push --force

# 删除远程分支
git push origin --delete <branch>

# 推送标签
git push --tags
```



## 7. 撤销与回退

bash

```
# 丢弃工作区修改
git restore <file>
git checkout -- <file>          # 旧写法

# 取消暂存
git restore --staged <file>
git reset HEAD <file>           # 旧写法

# 从指定提交恢复文件
git restore --source=<commit> <file>

# 回退提交
git reset --soft HEAD~1         # 保留修改，保留暂存
git reset --mixed HEAD~1        # 保留修改，取消暂存（默认）
git reset --hard HEAD~1         # 丢弃修改，慎用

# 反做某次提交
git revert <commit>
```



## 8. 标签

bash

```
# 查看标签
git tag

# 创建附注标签
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



## 9. 暂存工作区 stash

bash

```
# 保存当前修改
git stash
git stash push -m "message"
git stash save "message"

# 查看 stash
git stash list
git stash show

# 恢复
git stash apply
git stash pop

# 删除
git stash drop stash@{0}
git stash clear
```



## 10. 清理工作区

bash

```
# 预览将要删除的未跟踪文件
git clean -n

# 删除未跟踪文件
git clean -f

# 删除未跟踪文件和目录
git clean -fd

# 包括 .gitignore 忽略的文件（慎用）
git clean -fdx
```



> `git clean -fdx` 和 `git reset --hard` 会丢失数据，慎用。

## 11. 子模块

bash

```
# 添加子模块
git submodule add <url> <path>

# 查看子模块
git submodule status

# 初始化并更新子模块
git submodule update --init --recursive

# 更新子模块到远程最新
git submodule update --remote
```



## 12. .gitignore 相关

bash

```
# 创建 .gitignore
echo "node_modules/" >> .gitignore
echo "dist/" >> .gitignore

# 停止跟踪已提交文件，但保留本地文件
git rm -r --cached <file>
git rm -r --cached .

git add .
git commit -m "update .gitignore"
```



## 13. 常见工作流

### 初始化并推送到远程

bash

```
git init
git add .
git commit -m "init"
git branch -M main
git remote add origin <url>
git push -u origin main
```



### 同步远程主分支

bash

```
git fetch --all --prune
git switch main
git pull --rebase
```



### 合并远程主分支到当前分支

bash

```
git fetch origin
git merge origin/main

# 或
git rebase origin/main
```



### 临时保存当前修改

bash

```
git stash push -m "wip"
git switch main
git pull
git switch -
git stash pop
```



### 安全强推

bash

```
git push --force-with-lease
```



## 14. 冲突解决

### 合并冲突

bash

```
git status                     # 查看冲突文件
# 手动编辑冲突文件，保留需要的代码
git add <file>
git merge --continue
# 或
git commit
```



### 变基冲突

bash

```
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

bash

```
git status
# 手动编辑冲突文件
git add <file>
git cherry-pick --continue
# 中止
git cherry-pick --abort
```



### 中止合并

bash

```
git merge --abort
```



## 15. 高级操作

### 交互式 rebase

bash

```
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

bash

```
git commit --fixup <commit>
git rebase -i --autosquash <commit>~1
```



### 二分查找问题提交

bash

```
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

bash

```
git worktree add ../hotfix main
git worktree list
git worktree remove ../hotfix
```



### 补丁协作

bash

```
# 生成补丁
git format-patch -1 <commit>
git format-patch <commit1>..<commit2>

# 应用补丁
git am < patch-file
git apply < patch-file
```



### 大文件 LFS

bash

```
git lfs install
git lfs track "*.psd"
git add .gitattributes
```



### 仓库维护

bash

```
git gc
git fsck
git count-objects -vH
```



### 钩子与规范

bash

```
# 本地钩子目录
.git/hooks

# 常用工具
pre-commit
husky
commitlint
```



## 16. 安全与恢复

bash

```
# 查看所有操作记录
git reflog

# 恢复到某个操作之前
git reset --hard HEAD@{1}

# 为某次提交创建救援分支
git branch rescue <commit>

# 安全强推
git push --force-with-lease
```



> 误操作后不要慌，先 `git reflog`，大多数提交都能找回。

## 17. 帮助命令

bash

```
git help <command>
git <command> -h
```



------

## 慎用命令

- `git reset --hard`
- `git clean -fdx`
- `git push --force`
- `git rebase` 已推送到远端的公共分支

> 建议：提交前先 `git status`，推送前先 `git pull --rebase`，强推优先用 `--force-with-lease`。
