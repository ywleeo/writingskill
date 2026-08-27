# writingskill

一个面向多场景的写作 skill。写作能力按「一个能力一个模块」组织，`SKILL.md` 只做主路由，每个能力的详细指导放在 `references/` 下。

当前**已实现第一个能力：写提示词（给 AI）**。其余写作能力（写稿、起标题、立意、表达……）按同样方式陆续补充。

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

## 使用

任务匹配到能力描述时调用对应能力模块：

- **写提示词（给 AI）** → 读 `references/write-prompts.md`，按「你是谁 / 要做什么 / 素材在哪 / 别做什么 / 做成什么样」写出一条节省、信号密的提示词。

`SKILL.md` 里的能力路由表标明每个能力的模块与实现状态。

## 结构

```
writingskill/
├── SKILL.md                    # 主干：能力路由 + 触发
└── references/
    └── write-prompts.md        # 能力一：写提示词（给 AI）
```

## License

MIT
