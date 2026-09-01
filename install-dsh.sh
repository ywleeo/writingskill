#!/usr/bin/env bash
# install-dsh.sh — 一行命令把 Browser MCP 配置为 DeepSeek Harness (DSH) 的全局 MCP。
# 跨 macOS / Linux / Windows(未完全自动，需手动确认 uv.exe 路径)。
#
# 用法:
#   curl -fsSL <url>/install-dsh.sh | bash
#   bash install-dsh.sh [--profile <name>] [--uv <path>]
#
# 说明:
#   - 定位 DSH profile 目录: $DSH_HOME/profiles/<name>，默认 name=web。
#   - 动态解析 uv 可执行路径 (command -v uv)。
#   - 幂等：已存在 id=mcp-browser 则跳过，不重复插入。
#   - 写入到 profile 下的 cordis.patch.yml (DSH 热重载，无需重启)。

set -euo pipefail

error() { echo "[install-dsh] ERROR: $*" >&2; exit 1; }
info()  { echo "[install-dsh] $*"; }

# ---- 参数解析 ----
PROFILE_NAME="web"
UV_BIN=""
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE_NAME="$2"; shift 2 ;;
    --uv)      UV_BIN="$2"; shift 2 ;;
    *) error "未知参数: $1" ;;
  esac
done

# ---- 定位 uv ----
if [ -z "${UV_BIN:-}" ]; then
  UV_BIN="$(command -v uv || true)"
fi
if [ -z "${UV_BIN:-}" ]; then
  # 常见候选
  for c in "$HOME/.local/bin/uv" "/usr/local/bin/uv" "$(command -v uvx || true)"; do
    [ -n "$c" ] && [ -x "$c" ] && UV_BIN="$c" && break
  done
fi
[ -n "${UV_BIN:-}" ] || error "找不到 uv；请用 --uv <path> 指定，或运行 'pip install uv' / 用 uvx 兜底。"

# ---- 定位 browser-mcp 项目根 ----
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
# 若通过管道执行，dirname $0 = "."，尝试从脚本所在目录回退。
SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
if [ "$SCRIPT_PATH" = "install-dsh.sh" ] || [ "$SCRIPT_PATH" = "-" ]; then
  # 管道执行，无法确定源头；用户可 --project-dir 覆盖。
  PROJECT_DIR=""
else
  PROJECT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
fi
if [ -z "$PROJECT_DIR" ] || [ ! -d "$PROJECT_DIR/src" ]; then
  PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
[ -d "$PROJECT_DIR" ] || error "无法确定 browser-mcp 项目路径；请在此脚本旁执行，或用 --project-dir 指定。"

# ---- 定位 DSH profile ----
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
PROFILE_DIR="$DSH_HOME/profiles/$PROFILE_NAME"
[ -d "$PROFILE_DIR" ] || error "DSH profile 不存在: $PROFILE_DIR （可用 --profile <name> 指定）"

PATCH_FILE="$PROFILE_DIR/cordis.patch.yml"
[ -f "$PATCH_FILE" ] || error "缺少 cordis.patch.yml: $PATCH_FILE"

# ---- 幂等检查 ----
if grep -q "mcp-browser" "$PATCH_FILE" 2>/dev/null; then
  info "已配置 browser-mcp（id=mcp-browser 已存在于 $PATCH_FILE），跳过。"
  exit 0
fi

# ---- 用 python 安全插入 (处理 YAML 顶层 insert 列表) ----
UV_BIN_ESC="$(printf '%s' "$UV_BIN" | sed 's/\\/\\\\/g; s/"/\\"/g')"
PROJECT_DIR_ESC="$(printf '%s' "$PROJECT_DIR" | sed 's/\\/\\\\/g; s/"/\\"/g')"

python3 - "$PATCH_FILE" "$UV_BIN_ESC" "$PROJECT_DIR_ESC" <<'PY'
import sys, io
patch, uv_bin, project_dir = sys.argv[1], sys.argv[2], sys.argv[3]
out = []
with io.open(patch, 'r', encoding='utf-8') as f:
    out.append(f.read().rstrip('\n'))
out.append('')
out.append('# Browser MCP (ywleeo/browser-mcp): 通过真实 Chrome 读取/操作网页。')
out.append('# 工具以 mcp__browser__* 名字出现；首次需在 chrome://extensions 加载扩展。')
out.append('- insert:')
out.append('    - id: mcp-browser')
out.append("      name: '@deepseek-ai/dsh-mcp-client'")
out.append('      config:')
out.append('        serverName: browser')
out.append('        transport: stdio')
out.append('        command: "%s"' % uv_bin)
out.append('        args:')
out.append('          - --directory')
out.append('          - "%s"' % project_dir)
out.append('          - run')
out.append('          - browser-mcp')
out.append('        failOnStartupError: false')
out.append('')
with io.open(patch, 'w', encoding='utf-8') as f:
    f.write('\n'.join(out))
print('WROTE', patch)
PY

info "已写入 $PATCH_FILE。重启会话或由 DSH 热重载后生效。"
info "工具将出现为: mcp__browser__browser_read / mcp__browser__zhihu_content 等。"
