#!/bin/sh
# 选品参谋 一键安装：把插件和技能装进本机 dsh-go。
# 用法： sh install.sh
set -e

DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
HERE=$(cd "$(dirname "$0")" && pwd)
PLUGIN_DIR="$DSH_HOME/dsh-go/plugins/local-pick-goods"
SKILL_DIR="$DSH_HOME/skills/pick-goods"

echo "→ DSH_HOME = $DSH_HOME"

# 1. 插件（只拷需要的东西，别把 .git 也搬进去）
rm -rf "$PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR/lib" "$PLUGIN_DIR/skill/pick-goods"
cp "$HERE/package.json" "$PLUGIN_DIR/package.json"
cp "$HERE/cordis.patch.yml" "$PLUGIN_DIR/cordis.patch.yml"
cp "$HERE/lib/index.js" "$PLUGIN_DIR/lib/index.js"
cp "$HERE/skill/pick-goods/SKILL.md" "$PLUGIN_DIR/skill/pick-goods/SKILL.md"
echo "✓ 插件已复制到 $PLUGIN_DIR"

# 2. 技能（技能目录自动发现，不用注册）
mkdir -p "$SKILL_DIR"
cp "$HERE/skill/pick-goods/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "✓ 技能已复制到 $SKILL_DIR"

# 3. 注册到当前 profile
if command -v dsh >/dev/null 2>&1; then
  dsh plugin --profile web add "$PLUGIN_DIR" || {
    echo "! 自动注册失败，请手动执行：dsh plugin --profile web add $PLUGIN_DIR"
    exit 1
  }
  echo "✓ 已注册到 web profile"
else
  echo "! 没找到 dsh 命令，装好后手动执行：dsh plugin --profile web add $PLUGIN_DIR"
fi

echo
echo "装完了。打开 dsh-go → 设置 → 引擎 → 重启引擎，加号工具里就会出现「选品手册」「标准号速查」。"
