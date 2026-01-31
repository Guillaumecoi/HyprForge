#!/usr/bin/env bash
pkill -u "$USER" rofi && exit 0

glyph_data="$HOME/.local/share/emoji/glyph.db"
cache_dir="$HOME/.cache/emoji"
recent_data="$cache_dir/landing/show_glyph.recent"

print_log() { printf "%s\n" "$*" >&2; }

save_recent_entry() {
    local glyph_line="$1"
    mkdir -p "$(dirname "$recent_data")"
    touch "$recent_data"
    {
        echo "$glyph_line"
        cat "$recent_data"
    } | awk '!seen[$0]++' > "$recent_data.tmp" && mv "$recent_data.tmp" "$recent_data"
}

get_glyph_selection() {
    if [[ ! -f $glyph_data ]]; then
        print_log "[error] glyph DB not found: $glyph_data"
        exit 1
    fi

    awk '!seen[$0]++' "$recent_data" "$glyph_data" | rofi -dmenu -i "${ROFI_EMOJI_ARGS[@]}" -theme-str 'listview { margin: 10px 0px 0px -16px; columns: 1;} element { padding: 2px; }' -no-custom
}

paste_string() {
    if command -v wtype >/dev/null 2>&1; then
        wtype -- "$1"
    else
        print_log "[info] wtype not found; glyph copied to clipboard only"
    fi
}

main() {
    if [[ ! -f $recent_data ]]; then
        mkdir -p "$(dirname "$recent_data")"
        if [[ -f $glyph_data ]]; then
            head -n1 "$glyph_data" > "$recent_data"
        else
            echo "glyph placeholder" > "$recent_data"
        fi
    fi
    data_glyph=$(get_glyph_selection)
    [[ -z $data_glyph ]] && exit 0
    local selected_glyph_char
    selected_glyph_char=$(printf "%s" "$data_glyph" | cut -d' ' -f1 | xargs)
    if [[ -n $selected_glyph_char ]]; then
        if command -v wl-copy >/dev/null 2>&1; then
            printf "%s" "$selected_glyph_char" | wl-copy
        else
            print_log "[warn] wl-copy not found; printing glyph instead"
            printf "%s\n" "$selected_glyph_char"
        fi
        save_recent_entry "$data_glyph"
        paste_string "$selected_glyph_char"
    fi
}

main "$@"
