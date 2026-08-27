# writingskill

一个给 AI **写提示词** 的写作 skill。专注「给 AI 写作」这一子类型：产出面向通用大语言模型、不绑定具体厂商的提示词。

提示词不是越长越好。这个 skill 教的是短、信号密、以例带理的写法——先给模型身份，再给任务，再给一条好例子，够了就停。

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

在任务匹配到该 skill 的描述时调用它，或直接点名 `writingskill`。它会按「你是谁 / 要做什么 / 素材在哪 / 别做什么 / 做成什么样」帮你写出一条节省、信号密的提示词。

## 结构

```
writingskill/
└── SKILL.md   # 技能定义与指导（本体）
```

## License

MIT
