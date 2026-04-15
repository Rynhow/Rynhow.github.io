---
title: Kali基础
published: 2026-04-06
image: ./images/kali.webp
description: 一些工具和资源
category: kali
tags: [kali]
---

# Kali Linux

## 常用工具
- nmap
- msfconsole
- hydra
- wireshark

## 推荐资源
- kali官方:https://www.kali.org/
- VMmare:https://github.com/201853910/VMwareWorkstation(自2024年11月11日、版本 17.6.2 开始，VMware Workstation Pro 将免费供所有用户使用。)

## 必背・渗透最常用端口（8 个足够）

    21 → FTP 文件传输
    22 → SSH 连 Linux
    53 → DNS 域名解析（扫内网经常见）
    80 → HTTP 普通网站
    443 → HTTPS 加密网站
    445 → Windows 共享（漏洞超多）
    3306 → MySQL 数据库（网站必开）
    3389 → Windows 远程桌面

## 超短记忆口诀（一遍记住）

    传文件：21
    连 Linux：22
    找网址：53
    看网页：80、443
    网站数据库：3306
    Windows 相关：445、3389
