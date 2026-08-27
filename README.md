# writingskill

一个写作 skill。以「能力」为单元——每个写作能力一个模块，`SKILL.md` 只做索引；把写作任务交给 AI 时，按需组合这些能力。

## 能力目录

| 能力 | 模块 |
|---|---|
| 写提示词（给 AI） | [writingskill/abilities/write-prompts.md](writingskill/abilities/write-prompts.md) |
| 去 AI 味 | [writingskill/abilities/de-ai-flavor.md](writingskill/abilities/de-ai-flavor.md) |
| 开脑洞 | [writingskill/abilities/brainstorm.md](writingskill/abilities/brainstorm.md) |
| 写标题 | [writingskill/abilities/titles.md](writingskill/abilities/titles.md) |

能力是插件、不是流程：需要哪个才调哪个，顺序由任务决定。每个能力模块带同一套契约（何时用 / 输入 / 怎么做 / 输出 / 正反例），可独立复用。

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
├── SKILL.md                    # 主干：能力索引 + 组合原则
└── abilities/
    ├── write-prompts.md        # 写提示词（给 AI）
    ├── de-ai-flavor.md         # 去 AI 味
    ├── brainstorm.md           # 开脑洞
    └── titles.md               # 写标题
```

## License

MIT
