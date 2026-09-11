---
title: VMware的一些使用问题
published: 2026-09-11
category: VMware
tags: [VMware]
image:./images/VMware.webp
---

对于**Pro版本**（包括Workstation Pro和Fusion Pro），免费是一个逐步推进的过程：

- **个人免费**：自 **2024年5月14日**（版本17.5.2）起，Workstation Pro和Fusion Pro开始对**个人用户**免费。
- **全面免费**：自 **2024年11月11日**（版本17.6.2）起，免费范围扩大至**所有用户**，包括商业、教育和个人用途，且无需许可证密钥。同时，原有的Player版本宣布停产。

## 关于无权限的问题

这个需要自己打命令，他不像windows那样直观，需要自己去提权

```bash
sudo su
```



## 主机和虚拟机复制粘贴不互通

这个情况是因为没有安装vm-tools-desktop这个工具

```bash
sudo apt update
sudo apt install open-vm-tools open-vm-tools-desktop
```

安装完成后需要重启才能用