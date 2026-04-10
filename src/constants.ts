import type { Props } from "astro";
import IconMail from "@/assets/icons/IconMail.svg";
import IconGitHub from "@/assets/icons/IconGitHub.svg";
import IconBrandX from "@/assets/icons/IconBrandX.svg";
import { SITE } from "@/config";

interface Social {
  name: string;
  href: string;
  linkTitle: string;
  icon: (_props: Props) => Element;
}

// 底部社交：仅保留 GitHub
export const SOCIALS: Social[] = [
  {
    name: "GitHub",
    href: "https://github.com/Rynhow",
    linkTitle: `${SITE.title} on GitHub`,
    icon: IconGitHub,
  },
  {
    name: "Mail",
    href: "mailto:yourmail@gmail.com",
    linkTitle: `Send an email to ${SITE.title}`,
    icon: IconMail,
  },
] as const;

// 文章分享：仅保留 微博、QQ、微信
export const SHARE_LINKS: Social[] = [
  {
    name: "微博",
    href: "https://service.weibo.com/share/share.php?url=",
    linkTitle: `分享到微博`,
    icon: IconBrandX,
  },
  {
    name: "QQ",
    href: "https://connect.qq.com/widget/shareqq/index.html?url=",
    linkTitle: `分享到QQ`,
    icon: IconBrandX,
  },
  {
    name: "微信",
    href: "javascript:alert('复制链接后分享到微信')",
    linkTitle: `分享到微信`,
    icon: IconBrandX,
  },
] as const;
