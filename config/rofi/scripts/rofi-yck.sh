#!/usr/bin/env bash

word=$(rofi -dmenu -p "yck: ")
[ -z "$word" ] && exit 0

trans=$($HOME/.supertools/yck "${word}")

phonetic=$(echo "$trans" | grep -oP '\[.*?\]' | head -1)
definition=$(echo "$trans" | sed -E "s/.*\[$phonetic\] ?"//)


while true; do
    menu="📢 speech\n➕ add to anki\n$trans"
    sel=$(echo -e "$menu" | rofi -dmenu -p "yck: ")

    case "$sel" in
        "📢 speech")
            echo "$word" | festival --tts > /dev/null 2>&1 &
            ;;
        "➕ add to anki")
json=$(jq -n \
  --arg word "$word" \
  --arg phonetic "$phonetic" \
  --arg definition "$definition" \
  '{
    action: "addNote",
    version: 6,
    params: {
      note: {
        deckName: "EnglishWords",
        modelName: "YCK Vocabulary",
        fields: {
          Word: $word,
          Phonetic: $phonetic,
          Definition: $definition
        },
        tags: ["yck"]
      }
    }
  }')

            # 调用 AnkiConnect
            curl -s localhost:8765 -X POST -d "$json" >/dev/null
            notify-send "Anki" "Added: $word"
            ;;
        "")
            # 用户按了 Esc 或关闭 rofi，退出循环
            break
            ;;
        *)
            # 选择释义本身或其他情况 → 不做操作
            ;;
    esac
done
