import type { AnnouncementConfig } from "../types/announcementConfig";

export const announcementConfig: AnnouncementConfig = {
	// 公告标题，留空则走i18n默认标题
	title: "",

	// 公告内容
	content: "✧。٩(ˊωˋ)و✧*。 旅人，欢迎来到雁梦の部屋～这里存放着代码魔法、漏洞秘境与游戏异闻。更新随缘，愿星光指引你拾取有用的碎片",

	// 是否允许用户关闭公告
	closable: true,

	link: {
		// 启用链接
		enable: true,
		// 链接文本
		text: "了解更多",
		// 链接 URL
		url: "/about/",
		// 内部链接
		external: false,
	},
};
