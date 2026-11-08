#!/bin/sh
# 选品参谋 一键安装：把插件装进本机 dsh-go。
# 技能随插件一起注册，不再单独安装。
# 用法： sh install.sh
set -e

DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
HERE=$(cd "$(dirname "$0")" && pwd)
PLUGIN_DIR="$DSH_HOME/dsh-go/plugins/local-pick-goods"
LEGACY_SKILL_DIR="$DSH_HOME/skills/pick-goods"

echo "→ DSH_HOME = $DSH_HOME"

# 1. 插件（只拷需要的东西，别把 .git 也搬进去）
rm -rf "$PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR/lib" "$PLUGIN_DIR/skill/pick-goods"
cp "$HERE/package.json" "$PLUGIN_DIR/package.json"
cp "$HERE/cordis.patch.yml" "$PLUGIN_DIR/cordis.patch.yml"
cp "$HERE/lib/index.js" "$PLUGIN_DIR/lib/index.js"
cp "$HERE/skill/pick-goods/SKILL.md" "$PLUGIN_DIR/skill/pick-goods/SKILL.md"
echo "✓ 插件已复制到 $PLUGIN_DIR"

# 2. 清掉旧版本单独安装的技能副本，否则它会盖过插件注册的那份
if [ -d "$LEGACY_SKILL_DIR" ]; then
  rm -rf "$LEGACY_SKILL_DIR"
  echo "✓ 已移除旧版技能副本 $LEGACY_SKILL_DIR"
fi

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
echo "装完了。打开 dsh-go → 设置 → 引擎 → 重启引擎。"
echo "技能随插件加载：插件启用时 pick-goods 技能可用，关闭插件后技能一起消失。"
