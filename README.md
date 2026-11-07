# dsh-go-pick-goods

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![version](https://img.shields.io/github/package-json/v/melosic/dsh-go-pick-goods)](./package.json)
[![dsh-go plugin](https://img.shields.io/badge/dsh--go-plugin-4B8BBE)](https://github.com/ccch1mneyyy/dsh-Go)
[![DSH](https://img.shields.io/badge/DSH-%3E%3D0.2.1--rc.2%20%3C0.3.0-2F6FEB)](https://github.com/ccch1mneyyy/dsh-Go)

给 [dsh-go](https://github.com/ccch1mneyyy/dsh-Go) 用的选品插件 + 技能：**让 AI 真的会把商品查清楚，再给结论。**

装上之后，加号工具里多两个原生面板（「选品手册」「标准号速查」）；同时往 `$DSH_HOME/skills/` 放一份 `pick-goods` 技能，让 AI 在你说「帮我挑个 X」的时候自动按这套方法论走。

---

## 为什么做这个

起因很蠢：让 AI 在拼多多挑 A2 牛奶，它看完商品页的参数卡（生产日期 / 蛋白质含量 / 保质期），发现**没有配料表**，就回了一句「查不到」然后结束了。

其实配料表就在**商品详情往下滑的长图**里，倒数第 1～3 张有个「产品信息」小表格。再没有，问客服要包装背面实拍图也能拿到——但 AI 连问都没问。

所以这个插件干两件事：

1. **技能（真正起作用的部分）**：把「信息没查全不许下结论」这套方法论写死给 AI，包括四层信息漏斗、六张品类核验表、标准号事实卡、客服话术。
2. **插件（让它顺手）**：把方法论做成手机上能翻能点的原生面板，不用背。

---

## 安装

```sh
git clone https://github.com/melosic/dsh-go-pick-goods.git
cd dsh-go-pick-goods
sh install.sh
```

装完到 **[dsh-go](https://github.com/ccch1mneyyy/dsh-Go) → 设置 → 引擎 → 重启引擎**，面板才会出现。

手动装也行：

```sh
cp -r . "$HOME/.dsh/dsh-go/plugins/local-pick-goods"
mkdir -p "$HOME/.dsh/skills/pick-goods"
cp skill/pick-goods/SKILL.md "$HOME/.dsh/skills/pick-goods/SKILL.md"
dsh plugin --profile web add "$HOME/.dsh/dsh-go/plugins/local-pick-goods"
```

要求：[dsh-go](https://github.com/ccch1mneyyy/dsh-Go) + DSH `>=0.2.1-rc.2 <0.3.0`。

---

## 怎么用

### 两个面板（加号 → 工具）

**选品参谋**（输入框上方「插件」里点开的那张卡）—— 只放入口，不摆正文：

- 「选品手册」「标准号速查」两个按钮：跳到对应面板
- 「开始选品」「验一下已有商品」：塞一段完整请求进输入框

之前这本书整个塞在插件弹层里，一打开要翻五六屏；现在弹层只留入口，正文在单独的面板页里。

**选品手册** —— 照着做就不会漏：

- 第 0 步：**在哪个平台买**。六个平台按钮分两行（拼多多 / 淘宝天猫 / 京东 · 1688 / 闲鱼 / 抖音），点一下就把「就在这个平台买 + 这个平台要特别当心什么」塞进输入框
- 四层信息漏斗（参数卡 → 详情长图 → 客服 → 评价）
- 六个品类按钮：食品 / 电器 / 服装 / 化妆 / 家居 / 母婴，点一下列出该品类的必查项
- 「开始选品」/「验一下已有商品」按钮：塞一段完整请求进输入框（不会自动发送，可先改）
- 客服话术四条：要包装图、兜底问法、客服打太极时怎么说、要铭牌和 3C
- 营销话术对照表 + 到手价公式
- **结论怎么画**：一张「品类 → 比什么 → 怎么画」的表（食品比每 100ml，电器比功率和年电费，服装比面料和安全类别……），免得 AI 次次画成一样

**标准号速查** —— 报标准号之前先看这张表：

- 食品 12 条（灭菌乳 / 巴氏乳 / 婴配粉 / 酱油 / 食醋 / 蜂蜜 / 大米 / 植物油 / 饮用水 / A2 / 标签 / 营养标签）
- 电器、纺织、化妆品、家居 10 条（GB 44246-2024、CCC 目录、GB 18401、化妆品备案、GB 18580-2025 人造板等）
- 8 个官方查询入口（openstd / 食品国标 / 婴配粉注册 / CCC 证书 / 能效 / 化妆品备案 / 企业信用 / 团体标准）
- 一张「警戒线」：**「发布」不等于「生效」**，以及哪些营销词其实没有国标撑腰

> 表里日期是 **2026-11-07** 的快照。隔久了再用，先自己 `date` 确认今天几号。

### 技能

`skill/pick-goods/SKILL.md` 放进 `$DSH_HOME/skills/pick-goods/` 后会被自动发现（不用注册）。你说「帮我挑个吹风机」「这个靠谱吗」「比一下这几个」，AI 就会走:

**确认平台 → 需求五问 → 拉 3 个候选（覆盖三价位）→ 四层信息漏斗 → 品类核验 → 到手价/单位价 → 营销话术体检 → 带出处的结论 → 用 dsh-ui 画成图**

最后一步是重点：先定这个品类**可比单位**是什么（食品按每 100ml、生鲜按每斤含损耗、电器按功率容量年电费、服装按单件价+面料+安全类别、化妆品按每 ml、家居按每平米），再决定用 `chart` 横条、`compare` 还是 `metric`。图必须带单位和口径——「按券后到手价 ÷ 总毫升数，11 月 7 日实时价」这种，没出处的图等于装饰。

---

## 这套方法论里最关键的几条

1. **先确认平台，别默认。** 同一个东西不同平台差 20%+，闷头默认一个就是替用户做决定。
2. **参数卡永远没有配料表 / 材质成分 / 执行标准原文。** 这是模板字段，别指望。
3. **详情页必须滑到底**，产品信息块通常在倒数 1～3 张图。
4. **找不到就问客服，问要具体，问完必须回访。** 别问「有配料表吗」（客服会顺手回「没有」），要问「能发一下包装背面的产品信息图吗」。
5. **结论必须带证据。** 每个理由后面跟出处：参数卡 / 详情第几张图 / 客服原话 / 哪个评价。说不出出处就是猜。
6. **不替用户拍板超预算的东西。**
7. **结论要能一眼看完。** 先定可比单位再画图，不同品类比的东西不一样（牛奶比每升、电视比功率和年电费）；一条回复最多两张图，能一句话说清的就别画。

---

## 目录结构

```
.
├── package.json                  # 插件清单（dshGo 声明 + 依赖元信息）
├── cordis.patch.yml              # 让引擎加载本插件的 patch
├── lib/index.js                  # 两个面板的视图与点按处理
├── skill/pick-goods/SKILL.md     # 选品方法论技能
├── install.sh                    # 一键安装
└── README.md
```

## 兼容性

- 视图组件只用 v1 白名单（`stack` `text` `callout` `steps` `actions` `list` `table` `options`）。
- `options` 选平台走 `event.value.value`；平台键是 `pdd` `taobao` `jd` `ali1688` `xianyu` `douyin`。
- 本机实测环境：[dsh-go](https://github.com/ccch1mneyyy/dsh-Go) 1.0.12 / DSH 0.2.2-rc.1 / Android(proot)。
- 已用官方检查器验证：`node $DSH_HOME/skills/dsh-go-plugin/kit/bin/check.mjs . --load` → 8 个视图全部「能显示」。

## License

MIT
