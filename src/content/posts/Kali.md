---
title: Kali基础
published: 2026-04-06
image: ./images/kali.webp
description: 常用工具、资源、端口速查
category: kali
tags: [kali]
---

# Kali Linux

Kali 是一个预装了安全测试工具的 Linux 发行版，用来做渗透测试、CTF、安全学习。不要装在主力电脑上，用虚拟机或专用设备跑。

## 安装方式

- **虚拟机**：VMware 或 VirtualBox 装镜像，最推荐，方便拍快照
- **物理机**：可以装双系统，但风险较高，谨慎操作
- **WSL**：Windows 上跑，部分工具受限，不太适合做完整测试
- **Live USB**：U 盘启动，不留痕迹，适合临时用

官方镜像下载：https://www.kali.org/get-kali/

## 常用工具

| 工具 | 用途 |
|:---|:---|
| **nmap** | 端口扫描、服务识别、操作系统识别 |
| **msfconsole** | Metasploit 框架，漏洞利用和渗透测试 |
| **hydra** | 在线密码爆破，支持 SSH、FTP、HTTP 等 |
| **wireshark** | 抓包和分析网络流量 |
| **burpsuite** | Web 抓包、改包、重放 |
| **dirsearch** | 网站目录扫描 |
| **sqlmap** | SQL 注入自动化工具 |
| **john / hashcat** | 密码哈希破解 |
| **aircrack-ng** | WiFi 密码破解 |
| **netdiscover** | 局域网设备发现 |
| **gobuster** | 目录和子域名爆破 |
| **nikto** | Web 服务器漏洞扫描 |

安装工具：

```bash
apt update
apt install <工具名> -y
```

查看某工具用法：

```bash
<工具名> -h
man <工具名>
```

## 推荐资源

- Kali 官网：https://www.kali.org/
- Kali 官方文档：https://www.kali.org/docs/
- Kali 工具列表：https://www.kali.org/tools/
- VMware Workstation：https://github.com/201853910/VMwareWorkstation

> 自 2024 年 11 月 11 日（版本 17.6.2）起，VMware Workstation Pro 对所有用户免费。

其他常用资源：

- 靶场平台：[HackTheBox](https://www.hackthebox.com/)、[TryHackMe](https://tryhackme.com/)、[VulnHub](https://www.vulnhub.com/)
- Web 靶场：DVWA、Pikachu、SQLi-Labs
- 在线练习：[PortSwigger Web Security Academy](https://portswigger.net/web-security)

## 必背端口

下面这 8 个端口，日常渗透测试出现频率最高：

| 端口 | 服务 | 说明 |
|:---|:---|:---|
| 21 | FTP | 文件传输 |
| 22 | SSH | 连接 Linux 服务器 |
| 53 | DNS | 域名解析，扫内网经常见 |
| 80 | HTTP | 普通网站 |
| 443 | HTTPS | 加密网站 |
| 445 | SMB | Windows 文件共享，漏洞较多 |
| 3306 | MySQL | 数据库，网站常开 |
| 3389 | RDP | Windows 远程桌面 |

补充几个常见的：

| 端口 | 服务 | 说明 |
|:---|:---|:---|
| 23 | Telnet | 明文远程登录，已很少用 |
| 25 | SMTP | 邮件发送 |
| 110 | POP3 | 邮件接收 |
| 143 | IMAP | 邮件接收 |
| 1433 | MSSQL | 微软 SQL 数据库 |
| 1521 | Oracle | Oracle 数据库 |
| 5432 | PostgreSQL | PostgreSQL 数据库 |
| 6379 | Redis | 键值数据库，未授权访问常见 |
| 8080 | HTTP 代理 | Tomcat、Jenkins 等常用 |
| 27017 | MongoDB | 文档数据库，未授权访问常见 |

## 记忆口诀

```
传文件：21
连 Linux：22
找网址：53
看网页：80、443
网站数据库：3306
Windows 共享：445
Windows 远程：3389
```

## 常用命令速查

```bash
# 系统信息
uname -a                    # 查看内核版本
cat /etc/os-release         # 查看系统版本
whoami                      # 当前用户
id                          # 当前用户和组

# 网络
ip a                        # 查看 IP
ifconfig                    # 旧写法，需要 net-tools
netstat -tuln               # 查看监听端口
ss -tuln                    # 更现代的写法
ping <目标>                 # 测试连通性
traceroute <目标>           # 路由追踪

# 文件与目录
ls -la                      # 列出所有文件
cd <目录>                   # 切换目录
pwd                         # 当前路径
find / -name "*.txt"        # 查找文件
grep -r "关键词" <目录>     # 搜索内容

# 权限
chmod 755 <文件>            # 修改权限
chown user:group <文件>     # 修改所有者

# 服务
systemctl start <服务>      # 启动
systemctl stop <服务>       # 停止
systemctl status <服务>     # 查看状态

# 压缩与解压
tar -czvf a.tar.gz <目录>   # 打包压缩
tar -xzvf a.tar.gz          # 解压
unzip a.zip                 # 解压 zip
```

## 日常维护

```bash
# 更新系统
apt update && apt upgrade -y

# 清理不需要的包
apt autoremove -y
apt autoclean

# 查看磁盘占用
df -h
du -sh <目录>

# 查看内存和进程
free -h
top
htop                        # 需要先安装
```

## 安全提醒

- 只在本地虚拟机或授权靶场练习
- 不要扫描、攻击任何不属于你的设备
- 不要传播恶意工具，不要入侵他人系统
- 学安全是为了防御，不是为了搞破坏