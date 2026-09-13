---
title: VS Code 优化和设置
published: 2026-09-13
description: "整理 VS Code 的常用设置和插件，按类别列出来，方便按需挑选。"
tags: [vscode]
category: 工具
image: ./images/vscode.webp
---

# VS Code 设置和插件整理

这份是整理，不是使用心得。我没法告诉你哪个插件“用起来多爽”，只能把常见的设置和插件按类别列出来，你自己判断需不需要。

## 为什么用它

免费，跨平台，插件多，内置终端和 Git，这几条是客观事实，也是大多数人选它的原因。

设置同步是个实用功能。登录账号后，换电脑不用重新配一遍。我换电脑的时候用了这个。

## 设置

加到 `settings.json` 里：

```json
{
  "files.autoSave": "afterDelay",
  "files.autoGuessEncoding": true,
  "editor.formatOnSave": true,
  "editor.wordWrap": "on",
  "editor.guides.bracketPairs": true,
  "editor.mouseWheelZoom": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "workbench.list.smoothScrolling": true,
  "editor.suggestSelection": "recentlyUsed"
}
```

各项作用：

- `files.autoSave`：自动保存，不用按 Ctrl+S
- `files.autoGuessEncoding`：自动猜文件编码，处理中文文件有用
- `editor.formatOnSave`：保存时格式化
- `editor.wordWrap`：长代码自动换行
- `editor.guides.bracketPairs`：括号加引导线
- `editor.mouseWheelZoom`：Ctrl+滚轮缩放字号
- `editor.cursorSmoothCaretAnimation`：光标移动加动画
- `workbench.list.smoothScrolling`：列表滚动更顺
- `editor.suggestSelection`：补全时默认选中最近用过的

## 字体

想换字体的话，JetBrains Mono 是比较常用的选择，装完在 `settings.json` 里配：

```json
{
  "editor.fontFamily": "'JetBrains Mono', 'Microsoft YaHei', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 15,
  "editor.lineHeight": 24
}
```

Fira Code 的连字更丰富，中文注释多的话 Maple Mono NF CN 中英文等宽，对得比较齐。

## 主题

- One Dark Pro：暗色主题，用的人多
- GitHub Theme：GitHub 配色
- Dracula Official：配色鲜明
- Material Icon Theme：文件图标

主题这块纯看个人喜好，装几个切着看，留一个顺眼的。

## 基础插件

- Chinese (Simplified)：中文语言包
- Error Lens：报错直接显示在代码行尾
- Path Intellisense：路径补全
- Image preview：在代码里预览图片
- Prettier：代码格式化
- ESLint：检查 JS/TS 代码问题
- GitLens：看某行代码是谁什么时候改的
- Git Graph：可视化查看分支和提交历史

Prettier 和 ESLint 建议配合用，一个管格式，一个管代码问题。团队项目里最好统一配置。

## AI 插件

这类插件近两年更新很快，我用过 Fitten Code 和 Copilot。

- Fitten Code：免费，补全速度很快，中文注释理解不错。基础版够个人用，专业版目前限时免费
- GitHub Copilot：补全质量高，学生和教师可以免费申请 Pro。普通用户有每月 2000 次补全的免费额度
- 通义灵码：阿里云出品，个人版免费，中文环境友好
- Cline：开源，可以接入自己的 API

不建议同时开两个，补全提示会重叠，反而干扰。

## 按需装

- Remote - SSH：连服务器开发
- Thunder Client：测 API
- Code Runner：一键跑代码片段，刷题方便
- Todo Tree：集中查看 TODO 和 FIXME
- Bookmarks：代码书签

## 关于插件数量

装太多会拖慢启动速度，这个是真的。我一开始什么都装，后来砍掉一批，启动快了些。具体多少个合适没有标准，看电脑配置和实际用得到多少。

设置也一样，挑需要的加，不用照搬别人的完整配置。