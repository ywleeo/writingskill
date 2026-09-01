#!/usr/bin/env python3
"""install-dsh.py — 一行命令把 Browser MCP 配置为 DeepSeek Harness (DSH) 的全局 MCP。

跨 macOS / Linux / Windows。用法：
    python3 install-dsh.py [--profile web] [--uv /path/to/uv] [--project-dir /path/to/browser-mcp]

功能：
  1. 定位 DSH profile 目录: $DSH_HOME/profiles/<name>（默认 name=web，可用 DSH_HOME 覆盖）。
  2. 自动解析 uv 可执行路径（command -v uv，或 --uv）。
  3. 幂等：id=mcp-browser 已存在则跳过，不重复插入。
  4. 写入 profile 下的 cordis.patch.yml（DSH 热重载，无需重启）。
"""
from __future__ import annotations

import argparse
import os
import shutil
import sys

PLUGIN_ID = "mcp-browser"
PLUGIN_NAME = "@deepseek-ai/dsh-mcp-client"
SERVER_NAME = "browser"
PATCH_FILENAME = "cordis.patch.yml"


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Register Browser MCP with DeepSeek Harness.")
    p.add_argument("--profile", default=os.environ.get("DSH_PROFILE", "web"))
    p.add_argument("--uv", default=os.environ.get("UV_BIN", ""))
    p.add_argument(
        "--project-dir",
        default=os.environ.get("BROWSER_MCP_DIR", ""),
        help="browser-mcp 项目根目录（含 src/ 与 pyproject.toml）。",
    )
    return p.parse_args()


def find_uv(explicit: str) -> str:
    if explicit:
        return explicit
    for name in ("uv", "uvx"):
        p = shutil.which(name)
        if p:
            return p
    for c in (
        os.path.expanduser("~/.local/bin/uv"),
        "/usr/local/bin/uv",
        "/opt/homebrew/bin/uv",
    ):
        if os.path.isfile(c) and os.access(c, os.X_OK):
            return c
    sys.exit("找不到 uv；请用 --uv <path> 指定，或先安装 uv（pip install uv）。")


def find_project_dir(explicit: str) -> str:
    if explicit and not os.path.isdir(explicit):
        sys.exit(f"--project-dir 不存在: {explicit}")
    if explicit:
        return explicit
    # 脚本所在目录 = browser-mcp 项目根
    here = os.path.dirname(os.path.abspath(__file__))
    for cand in (here, os.path.dirname(here)):
        if os.path.isfile(os.path.join(cand, "pyproject.toml")) or os.path.isdir(os.path.join(cand, "src")):
            return cand
    sys.exit("无法确定 browser-mcp 项目根；请用 --project-dir 指定。")

def find_profile(profile: str) -> str:
    home = os.environ.get("DSH_HOME") or os.path.expanduser("~/.dsh")
    prof_dir = os.path.join(home, "profiles", profile)
    if not os.path.isdir(prof_dir):
        sys.exit(f"DSH profile 不存在: {prof_dir}（可用 --profile <name> 指定或先创建）")
    return os.path.join(prof_dir, PATCH_FILENAME)


def main() -> None:
    args = parse_args()
    uv = find_uv(args.uv)
    project = find_project_dir(args.project_dir)
    patch_file = find_profile(args.profile)

    if not os.path.isfile(patch_file):
        sys.exit(f"缺少 {patch_file}；请先让 DSH 初始化该 profile。")

    with open(patch_file, "r", encoding="utf-8") as f:
        content = f.read()

    if PLUGIN_ID in content:
        print(f"已配置 (id={PLUGIN_ID} 存在于 {patch_file})，跳过。")
        return

    block_lines = [
        "# Browser MCP (ywleeo/browser-mcp): 通过真实 Chrome 读取/操作网页。",
        "# 工具以 mcp__browser__* 名字出现；首次需在 chrome://extensions 加载扩展。",
        "- insert:",
        f"    - id: {PLUGIN_ID}",
        f"      name: '{PLUGIN_NAME}'",
        "      config:",
        f"        serverName: {SERVER_NAME}",
        "        transport: stdio",
        f"        command: \"{uv}\"",
        "        args:",
        "          - --directory",
        f"          - \"{project}\"",
        "          - run",
        "          - browser-mcp",
        "        failOnStartupError: false",
    ]

    stripped = content.strip()
    # 去掉注释行后是否只剩一个空文档 `[]`
    body_lines = [ln for ln in stripped.splitlines() if ln.strip() and not ln.lstrip().startswith("#")]
    is_empty_doc = body_lines == ["[]"]

    if is_empty_doc:
        # 全新 profile：用 insert 列表替换空文档，保留原头部注释
        header = "\n".join([ln for ln in stripped.splitlines() if ln.strip().startswith("#")])
        new_content = (header + "\n" if header else "") + "\n".join(block_lines) + "\n"
    else:
        # 已是顶层列表：追加一个新的 - insert 条目
        new_content = content.rstrip("\n") + "\n" + "\n".join(block_lines) + "\n"

    with open(patch_file, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"已写入 {patch_file}。")
    print("重启会话或由 DSH 热重载后生效；工具将出现为 mcp__browser__* 。")


if __name__ == "__main__":
    main()
