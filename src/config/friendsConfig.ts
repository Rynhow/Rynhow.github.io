import type { FriendLink, FriendsPageConfig } from "../types/config";

// 可以在src/content/spec/friends.md中编写友链页面下方的自定义内容

// 友链页面配置
export const friendsPageConfig: FriendsPageConfig = {
	// 页面标题，如果留空则使用 i18n 中的翻译
	title: "",

	// 页面描述文本，如果留空则使用 i18n 中的翻译
	description: "",

	// 是否显示底部自定义内容（friends.mdx 中的内容）
	showCustomContent: true,

	// 是否显示评论区，需要先在commentConfig.ts启用评论系统
	showComment: true,

	// 是否开启随机排序配置，如果开启，就会忽略权重，构建时进行一次随机排序
	randomizeSort: false,
};

// 友链配置
export const friendsConfig: FriendLink[] = [
	{
		title: "廖老师的教程",
		imgurl:
			"http://thirdqq.qlogo.cn/ek_qqapp/AQVJKMtqeFCGNEZqicOj7qb7mnpcJiaZNlEOf0iasx2DicuEycbIG9cQktWUBxWR1dFWfLMI2Ilt/100",
		desc: "资深软件开发工程师,提供Python、Java等零基础教程",
		siteurl: "https://liaoxuefeng.com/index.html",
		tags: ["编程"],
		weight: 10, // 权重，数字越大排序越靠前
		enabled: true, // 是否启用
	},
	{
		title: "菜鸟教程",
		imgurl: "https://www.runoob.com/wp-content/uploads/2013/06/runoob.jpeg",
		desc: "全栈技术零基础教程，内容详实干货满满",
		siteurl: "https://www.runoob.com/",
		tags: ["编程"],
		weight: 9,
		enabled: true,
	},
	{
		title: "程序员常用在线工具合集",
		imgurl: "",
		desc: "格式转换、加密解密、代码格式化等实用工具",
		siteurl: "https://tool.lu/",
		tags: ["工具"],
		weight: 8,
		enabled: true,
	},
	{
		title: "在线图像工具箱",
		imgurl: "https://phototool.cn/assets/images/favicon.png",
		desc: "提供格式转换，无损压缩等",
		siteurl: "https://phototool.cn/",
		tags: ["工具"],
		weight: 7,
		enabled: true,
	},
];

// 获取启用的友链并进行排序
export const getEnabledFriends = (): FriendLink[] => {
	const friends = friendsConfig.filter((friend) => friend.enabled);

	if (friendsPageConfig.randomizeSort) {
		return friends.sort(() => Math.random() - 0.5);
	}

	return friends.sort((a, b) => b.weight - a.weight);
};
