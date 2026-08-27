# writingskill

一个写作 skill，核心就一句话：**唤醒 AI 的母语表达，而不是走平均概率。**

## 写作观（写在 SKILL.md 开头）

> **人味在于多变、创新、杂糅；客观是写作的敌人。**

AI 生成默认落**平均概率**——取众数，于是天然是"均匀、端平、谁也不得罪"的壳，这就是那股 AI 味。所以这个 skill 不去"禁止 AI 味"，而是**唤起母语尾巴**：把模型参数里那些真实、具体、多变、带口音的母语，用一个"身份/场合锚点 + 一句真实母语"给它调出来。

## 方法统一：唤起式（给锚，不列禁词）

每个能力都用同一套手法——**给真实母语锚点，让模型往人话那条路走，而不是列一堆"别用 X / 不要 Y"。**

- **身份 / 场景锚点**：一个具体的人、具体的场合（"像被甲方改了八版、蹲便利店买冰饮料的文案"）。
- **真实母语锚**：一段来自真实平台高赞内容的母语，让模型照着那个声口写，而不是发明"平均"中文。
- **检验尺子**：**母语者会原样说出这句话吗？** 像"重新拼出来的"就是 AI 味。

## 能力目录

每个能力一个模块，`SKILL.md` 只做索引与组合原则。能力是插件、不是流程：需要哪个才调哪个，顺序由任务决定。

| 能力 | 模块 | 说明 |
|---|---|---|
| 写提示词（给 AI） | [ability write-prompts](writingskill/abilities/write-prompts.md) | 给身份锚 + 一段真实母语锚，让 AI 写出人味的提示词 |
| 去 AI 味 | [ability de-ai-flavor](writingskill/abilities/de-ai-flavor.md) | 唤起母语声口，替换"拼出来"的机器腔 |
| 开脑洞 | [ability brainstorm](writingskill/abilities/brainstorm.md) | 换身份/场合，找非常规角度 |
| 写标题 | [ability titles](writingskill/abilities/titles.md) | 留白、有态度的标题（三平台真实高赞锚点） |
| 营销文案 | [ability marketing](writingskill/abilities/marketing.md) | 一句话卖点/slogan/广告词/段子/帖子/口播/剧情短视频（国内外真实案例锚点） |

各能力内置**真实母语锚点库**，覆盖多个平台：知乎（真实回答）、豆瓣（高赞短评）、小红书（高赞评论）、微博（真实叙述）、B站（视频文案/标题）。锚点取**真实、有机、非投放**的内容。

## 安装

把整个 `writingskill/` 文件夹拷到下面任一位置即可（skill 名取自 SKILL.md 的 `name` 字段，为 `writingskill`）：

| 位置 | 作用域 | 路径 |
| --- | --- | --- |
| 项目级（本仓库） | 仅该项目 | `<your-project>/.agents/skills/` 或 `<your-project>/.dsh/skills/` |
| 用户级（全局） | 所有项目 | `~/.agents/skills/` 或 `~/.dsh/skills/` |

拷贝后，skill 会被自动发现并出现在可用 skill 目录里，可通过名称 `writingskill` 调用。

```bash
# 用户级安装示例（全局可用）
mkdir -p ~/.agents/skills
cp -r writingskill ~/.agents/skills/
```

## 结构

```
writingskill/
├── SKILL.md                    # 主干：写作观 + 能力索引 + 组合原则
└── abilities/
    ├── write-prompts.md        # 写提示词（给 AI）
    ├── de-ai-flavor.md         # 去 AI 味（含锚点库）
    ├── brainstorm.md           # 开脑洞（含角度锚点库）
    ├── titles.md               # 写标题（含三平台锚点库）
    └── marketing.md            # 营销文案（含国内外案例锚点库）
```

## License

MIT
