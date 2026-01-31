#!/usr/bin/env bash
pkill -u "$USER" rofi && exit 0

emoji_data="$HOME/.local/share/emoji/emoji.db"
cache_dir="$HOME/.cache/emoji"
recent_data="$cache_dir/landing/show_emoji.recent"

print_log() { printf "%s\n" "$*" >&2; }

save_recent_entry() {
    local emoji_line="$1"
    mkdir -p "$(dirname "$recent_data")"
    touch "$recent_data"
    {
        echo "$emoji_line"
        cat "$recent_data"
    } | awk '!seen[$0]++' > "$recent_data.tmp" && mv "$recent_data.tmp" "$recent_data"
}

get_emoji_selection() {
    if [[ ! -f $emoji_data ]]; then
        print_log "[error] emoji DB not found: $emoji_data"
        exit 1
    fi

    awk '!seen[$0]++' "$recent_data" "$emoji_data" | rofi -dmenu -i "${ROFI_EMOJI_ARGS[@]}" -theme-str 'listview { margin: 10px 0px 0px -16px; columns: 1; } element { padding: 2px; }' -no-custom
}

paste_string() {
    # Try to type the emoji with wtype if available (Wayland), otherwise do nothing.
    if command -v wtype >/dev/null 2>&1; then
        wtype -- "$1"
    else
        print_log "[info] wtype not found; emoji copied to clipboard only"
    fi
}

main() {
    if [[ ! -f $recent_data ]]; then
        mkdir -p "$(dirname "$recent_data")"
        echo "😀 grinning face face smile happy joy :D grin" > "$recent_data"
    fi
    data_emoji=$(get_emoji_selection)
    [[ -z $data_emoji ]] && exit 0
    local selected_emoji_char
    selected_emoji_char=$(printf "%s" "$data_emoji" | cut -d' ' -f1 | xargs)
    if [[ -n $selected_emoji_char ]]; then
        if command -v wl-copy >/dev/null 2>&1; then
            printf "%s" "$selected_emoji_char" | wl-copy
        else
            print_log "[warn] wl-copy not found; printing emoji instead"
            printf "%s\n" "$selected_emoji_char"
        fi
        save_recent_entry "$data_emoji"
        paste_string "$selected_emoji_char"
    fi
}

main "$@"
