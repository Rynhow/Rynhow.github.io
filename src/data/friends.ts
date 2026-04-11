// 友情链接数据配置
// 用于管理友情链接页面的数据

export interface FriendItem {
	id: number;
	title: string;
	imgurl: string;
	desc: string;
	siteurl: string;
	tags: string[];
}

// 友情链接数据
export const friendsData: FriendItem[] = [
	/*{
		id: 1顺序,
		title: "名称：GitHub",
		imgurl: "图片https://avatars.githubusercontent.com/u/9919?v=4&s=640",
		desc: "描述Where the world builds software",
		siteurl: "网址https://github.com",
		tags: ["标签Development，Platform"],
	},*/

	{
		id: 1,
		title: "廖老师的教程",
		imgurl: "",
		desc: "资深软件开发工程师，提供Python、Java等零基础教程",
		siteurl: "https://liaoxuefeng.com/index.html",
		tags: ["编程"],
	},
	{
		id: 2,
		title: "菜鸟教程",
		imgurl: "",
		desc: "全栈技术零基础教程，内容详实干货满满",
		siteurl: "https://www.runoob.com",
		tags: ["编程,Linux"],
	},
	{
		id: 3,
		title: "程序员常用在线工具合集",
		imgurl: "",
		desc: "格式转换、加密解密、代码格式化等实用工具",
		siteurl: "https://tool.lu/",
		tags: ["工具"],
	},
	{
		id: 4,
		title: "在线图像工具箱",
		imgurl: "",
		desc: "提供格式转换，无损压缩等",
		siteurl: "https://phototool.cn/",
		tags: ["工具"],
	},
];

// 获取所有友情链接数据
export function getFriendsList(): FriendItem[] {
	return friendsData;
}

// 获取随机排序的友情链接数据
export function getShuffledFriendsList(): FriendItem[] {
	const shuffled = [...friendsData];
	for (let i = shuffled.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
	}
	return shuffled;
}
