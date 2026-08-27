---
name: writingskill
description: 写作场景的 skill。用户需要为 AI 写一条提示词/prompt、给文字去 AI 味、开脑洞找写作角度、或写标题时使用，也用于把写作任务交出去时组合这些能力。不适用于直接代写正文、闲聊、或回答与写作手法无关的问题。
---

# Writing Skill：写作能力

这是一个写作 skill。每个写作能力 = 一个模块，`SKILL.md` 只做索引；具体怎么做，进对应能力的模块读。

能力是**插件，不是流程**：任务需要哪个就调哪个，不需要就不套；顺序由任务决定。模块是指导，不是固定模板。

## 能力目录

| 能力 | 模块 | 说明 |
|---|---|---|
| 写提示词（给 AI） | [abilities/write-prompts.md](abilities/write-prompts.md) | 写出短、信号密的提示词 |
| 去 AI 味 | [abilities/de-ai-flavor.md](abilities/de-ai-flavor.md) | 把机器腔剥掉，让文字像人写的 |
| 开脑洞 | [abilities/brainstorm.md](abilities/brainstorm.md) | 跳出第一反应，找非常规角度 |
| 写标题 | [abilities/titles.md](abilities/titles.md) | 给留白、有态度的标题 |

新增能力：往 `abilities/` 加一个 5 段契约的模块（何时用 / 输入 / 怎么做 / 输出 / 正反例），再在表里补一行。
