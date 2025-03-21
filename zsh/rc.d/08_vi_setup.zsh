#   ,
#  / \               _
#  \  \          ___(_)
#   \  \        /  /__
#    \  \      /  /|  |
#     \  \    /  / |  |
#      \  \  /  /  |  |
#       \  \/  /   |  |
#        \    /    |  |
#         \  /     |__| setup
# ======== \/ ================================================================ #

# See: `man zshzle`

bindkey -v
export KEYTIMEOUT=1


# REMOVE DEFAULT KEYMAPS
# ---------------------------------------------------------------------------- #
# NOTE: You can unbind all of the 'viins' keys too (which is quite nice as it
# effectively grants an entirely clean slate to build upon), but it removes
# literally every key; a-z, 0-9, everything... This wouldn't be a problem as
# they can be explicitly redeclared like so:
#
# bindkey -R -M viins "a"-"z" self-insert
# etc...
#
# But this approach causes fzf-tab to break, and even manually redeclaring all
# of the alphanumeric keys / special characters still doesn't fix the issue.
# (I'm assuming it relies on some zsh widgets being tied to default bindings
# which are getting wiped but this is a yacht problem and I'm eating porridge).
bindkey -rp -M vicmd ''
bindkey -rp -M visual ''
bindkey -rp -M viopp ''

# Hack to disable ctrl + PageUp / PageDown and a bunch of modifier + arrow key
# combinations. Most / all of these aren't bound to anything by default causing
# the leading escape in the sequence '^[' to be interpreted literally (as an
# escape key input) followed by whatever the rest of the sequence is. In other
# words, scuffed inputs often result in a trainwreck.
local function _noop() {return}; zle -N _noop
local escape_sequences=( \
    '^[[6;5~' '^[[5;5~' '^[[5;6~' '^[[6;6~' '^[[1;2A' '^[[1;2B' '^[[1;2C' \
    '^[[1;2D' '^[[1;5A' '^[[1;5B' '^[[1;5C' '^[[1;5D' '^[[1;6A' '^[[1;6B' \
    '^[[1;6C' '^[[1;6D' '^[[1;7A' '^[[1;7B' '^[[1;7C' '^[[1;7D' '^[[1;8A' \
    '^[[1;8B' '^[[1;8C' '^[[1;8D' '^[[1;3A' '^[[1;3B' '^[[1;3C' '^[[1;3D' \
    '^[[1;4A' '^[[1;4B' '^[[1;4C' '^[[1;4D' \
)

for m in viins vicmd visual viopp; do
    for k in "${escape_sequences[@]}"; do
        bindkey -M $m $k _noop
    done
done


# HIGHLIGHTS / CURSOR STYLE
# ---------------------------------------------------------------------------- #
zle_highlight+=(paste:none)               # Prevent text highlight on paste
zle_highlight+=(region:bg=blue,fg=white)  # Set highlight color in visual mode

# Set cursor style (DECSCUSR), VT520.
# See: https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html
# 0  =  blinking block (slower).
# 1  =  blinking block (faster).
# 2  =  steady block.
# 3  =  blinking underline.
# 4  =  steady underline.
# 5  =  blinking bar, xterm.
# 6  =  steady bar, xterm.

local block_cursor='\e[2 q'
local underline_cursor='\e[3 q'
local beam_cursor='\e[5 q'

# Adjust cursor style on mode switch
local function zle-keymap-select() {
    emulate -L zsh
    case "${KEYMAP}" in
        viins|main)
            # Overwrite cursor shape in replace mode
            if [[ "${ZLE_STATE}" == *overwrite* ]]; then
                echo -ne $underline_cursor
            else
                echo -ne $beam_cursor
            fi
            ;;
        *)
            echo -ne $block_cursor
            ;;
    esac
}
zle -N zle-keymap-select


# DEACTIVATE / REACTIVATE REGION
# ---------------------------------------------------------------------------- #
local cursor_point cursor_mark

local function _deactivate_region() {
    emulate -L zsh

    # TODO: move this to zle-keymap-select
    # Don't save region coords when exiting visual line mode
    if (( "${REGION_ACTIVE}" == 1 )); then
        cursor_point="${CURSOR}"
        cursor_mark="${MARK}"
    fi
    zle deactivate-region
}
zle -N _deactivate_region

# Loosely emulate the functionality of a `gv` vim motion. Doesn't track point
# and mark across line changes as that goes far beyond the scope of what I
# need from command line vi mode.
local function _reactivate_region() {
    emulate -L zsh
    zle visual-mode
    CURSOR="${cursor_point}"
    MARK="${cursor_mark}"
}
zle -N _reactivate_region


# LINE NAVIGATION
# ---------------------------------------------------------------------------- #
local function _jump_forward_word() {
    emulate -L zsh
    zle vi-forward-word-end
    zle vi-forward-char  # Prevent the cursor landing left of the final letter
}
zle -N _jump_forward_word

# Line navigation widgets that handle wrapped lines properly.
#
# NOTE: 'in bounds' checks aren't really needed as ZLE appears to handle
# cursor boundaries automatically. e.g. Setting CURSOR to a value less
# than 1 or greater than the number of characters held in BUFFER,
# positions the cursor at the start, or end of BUFFER without issue.
local function _up_line() {
    emulate -L zsh
    CURSOR=$(( CURSOR - COLUMNS ))
}
zle -N _up_line

local function _down_line() {
    emulate -L zsh
    CURSOR=$(( CURSOR + COLUMNS ))
}
zle -N _down_line

local function _line_start() {
    emulate -L zsh
    CURSOR=$(( CURSOR - ( (CURSOR + 4) % COLUMNS ) ))
}
zle -N _line_start

local function _line_end() {
    emulate -L zsh
    CURSOR=$(( CURSOR - ( (CURSOR + 4) % COLUMNS ) + COLUMNS - 1 ))
}
zle -N _line_end


# DELETE MOTIONS
# ---------------------------------------------------------------------------- #
zmodload zsh/deltochar

# Invoked by `_delete_motions`
local function _zap_backwards() {
    emulate -L zsh
    zle zap-to-char -n -1
}
zle -N _zap_backwards
bindkey -M vicmd 'ZB' _zap_backwards
bindkey -M vicmd 'ZF' zap-to-char

local function _delete_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Make widget repeatable with the dot operator
    zle -f vichange

    # Read next typed keystroke
    local key
    read -k 1 key
    case "${key}" in
        't')                               # wt = Delete in word
            _select_in_word
            zle kill-region
            ;;
        'u')                               # wu = Delete word left
            zle backward-kill-word
            ;;
        'o')                               # wo = Delete word right
            zle kill-word
            ;;
        'l')                               # wl = Delete whole line
            zle kill-whole-line
            ;;
        ',')                               # w, = Delete to line start
            zle backward-kill-line
            ;;
        '.')                               # w. = Delete to line end
            zle kill-line
            ;;
        ';')                               # w; = Delete to next typed char
            local pos next_char
            pos="${BUFFER[$CURSOR+1]}"
            read -k 1 next_char
            [[ "$pos" == "$next_char" ]] && \
                zle delete-char
            zle -U ZF"$next_char"
            ;;
        'h')                               # wh = Delete to previous typed char
            local pos prev_char
            pos="${BUFFER[$CURSOR]}"
            read -k 1 prev_char
            [[ "$pos" == "$prev_char" ]] && \
                zle backward-delete-char
            zle -U ZB"$prev_char"
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac

    echo -ne $block_cursor
}
zle -N _delete_motions


# REPLACE CHARS
# ---------------------------------------------------------------------------- #
local function _replace_chars() {
    emulate -L zsh
    echo -ne $underline_cursor
    zle vi-replace-chars
    echo -ne $block_cursor
}
zle -N _replace_chars


# SELECT IN WORD / LINE
# ---------------------------------------------------------------------------- #
local function _select_in_word() {
    emulate -L zsh
    zle visual-mode
    zle select-in-word
}
zle -N _select_in_word


# CLIPBOARD RING
# ---------------------------------------------------------------------------- #
local function _copy_to_clipboard() {
    emulate -L zsh
    zle vi-yank
    echo -n "${CUTBUFFER}" | pbcopy -i
    echo "${CUTBUFFER}" >> "${VI_CLIPBOARD_RING}"

    if [[ $(wc -l < "${VI_CLIPBOARD_RING}") -gt 100 ]]; then
        sed -i '1d' "${VI_CLIPBOARD_RING}"
    fi
}
zle -N _copy_to_clipboard

local function _cut_to_clipboard() {
    emulate -L zsh
    zle vi-delete
    echo -n "${CUTBUFFER}" | pbcopy -i
    echo "${CUTBUFFER}" >> "${VI_CLIPBOARD_RING}"

    if [[ $(wc -l < "${VI_CLIPBOARD_RING}") -gt 100 ]]; then
        sed -i '1d' "${VI_CLIPBOARD_RING}"
    fi
}
zle -N _cut_to_clipboard

local function _clipboard_ring_paste() {
    emulate -L zsh
    local selection=$( \
        cat "${VI_CLIPBOARD_RING}" \
        | fzf \
            --tac \
            --no-preview \
            --header-border=top \
            --header='󱓦 Vi clipboard ring.'
    )

    if [[ "${selection}" ]]; then
        if [[ "${CURSOR}" < 1 ]]; then
            LBUFFER+="${selection}"
            CURSOR=$(( "${CURSOR}" - 1 ))
        else
            BUFFER[CURSOR]+="$selection"
            CURSOR+=$(( "${#selection}" - 1 ))
        fi

        echo -n "$selection" | pbcopy -i
        POSTDISPLAY=
        zle redisplay
    fi
}
zle -N _clipboard_ring_paste

local function _clipboard_ring_paste_over() {
    emulate -L zsh
    local selection=$( \
        cat "${VI_CLIPBOARD_RING}" \
        | fzf \
            --tac \
            --no-preview
            --header-border=top \
            --header='󱓦 Vi clipboard ring.' \
    )

    if [[ "${selection}" ]]; then
        zle kill-region

        if [[ "${CURSOR}" < 1 ]]; then
            LBUFFER+="${selection}"
            CURSOR=$(( "${CURSOR}" - 1 ))
        else
            BUFFER[CURSOR]+="${selection}"
            CURSOR+=$(( "${#selection}" - 1 ))
        fi

        echo -n "$selection" | pbcopy -i
        POSTDISPLAY=
        zle redisplay
    fi
}
zle -N _clipboard_ring_paste_over


# COPY MOTIONS
# ---------------------------------------------------------------------------- #
# Invoked by copy, cut, and change motion functions
bindkey -M vicmd 'TN' vi-find-next-char-skip
bindkey -M vicmd 'TP' vi-find-prev-char-skip

local function _copy_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case "${key}" in
        't')                               # ct = Copy in word
            local mark=$CURSOR
            _select_in_word
            _copy_to_clipboard
            CURSOR=$mark
            ;;
        'u')                               # cu = Copy word left
            local mark=$CURSOR
            zle vi-backward-char
            zle visual-mode
            zle vi-backward-word
            _copy_to_clipboard
            CURSOR=$mark
            ;;
        'o')                               # co = Copy word right
            zle visual-mode
            zle vi-forward-word-end
            _copy_to_clipboard
            ;;
        'l')                               # cl = Copy whole line
            zle visual-line-mode
            _copy_to_clipboard
            ;;
        ',')                               # c, = Copy to line start
            local mark=$CURSOR
            zle vi-backward-char
            zle visual-mode
            _line_start
            _copy_to_clipboard
            CURSOR=$mark
            ;;
        '.')                               # c. = Copy to line end
            zle visual-mode
            _line_end
            _copy_to_clipboard
            ;;
        ';')                               # c; = Copy to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _copy_to_clipboard
            ;;
        'h')                               # ch = Copy to previous typed char
            local mark=$CURSOR
            local prev_char
            read -k 1 prev_char
            zle -U "TP${prev_char}"
            _copy_to_clipboard
            CURSOR=$mark
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac

    echo -ne $block_cursor
}
zle -N _copy_motions


# CUT MOTIONS
# ---------------------------------------------------------------------------- #
local function _cut_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case "${key}" in
        't')                               # xt = Cut in word
            _select_in_word
            _cut_to_clipboard
            ;;
        'u')                               # xu = Cut word left
            zle vi-backward-char
            zle visual-mode
            zle vi-backward-word
            _cut_to_clipboard
            ;;
        'o')                               # xo = Cut word right
            zle visual-mode
            zle vi-forward-word-end
            _cut_to_clipboard
            ;;
        'l')                               # xl = Cut whole line
            zle visual-line-mode
            _cut_to_clipboard
            ;;
        ',')                               # x, = Cut to line start
            zle visual-mode
            _line_start
            _cut_to_clipboard
            ;;
        '.')                               # x. = Cut to line end
            zle visual-mode
            _line_end
            _cut_to_clipboard
            ;;
        ';')                               # x; = Cut to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _cut_to_clipboard
            ;;
        'h')                               # xh = Cut to previous typed char
            local prev_char
            read -k 1 prev_char
            zle -U "TP${prev_char}"
            _cut_to_clipboard
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac

    echo -ne $block_cursor
}
zle -N _cut_motions


# CHANGE MOTIONS
# ---------------------------------------------------------------------------- #
local function _change_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case "${key}" in
        't')                               # yt = Change in word
            _select_in_word
            zle vi-change
            ;;
        'u')                               # yu = Change word left
            zle backward-kill-word
            zle vi-insert
            ;;
        'o')                               # yo = Change word right
            zle kill-word
            zle vi-insert
            ;;
        'l')                               # yl = Change whole line
            zle vi-change-whole-line
            ;;
        ',')                               # y, = Change to line start
            zle backward-kill-line
            zle vi-insert
            ;;
        '.')                               # y. = Change to line end
            zle vi-change-eol
            ;;
        ';')                               # y; = Change to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            zle vi-change
            [[ $RBUFFER != *"${next_char}"* ]] \
                && echo -ne $block_cursor
            ;;
        'h')                               # yh = Change to previous typed char
            local prev_char
            read -k 1 prev_char
            zle -U "TP${prev_char}"
            zle vi-change
            [[ $LBUFFER != *"${prev_char}"* ]] \
                && echo -ne $block_cursor
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac
}
zle -N _change_motions


# PASTE
# ---------------------------------------------------------------------------- #
local function _paste_from_clipboard() {
    emulate -L zsh
    CUTBUFFER=$(pbpaste)
    zle vi-put-before
}
zle -N _paste_from_clipboard

local function _paste_from_clipboard_visual() {
    emulate -L zsh
    zle kill-region
    CUTBUFFER=$(pbpaste)
    zle vi-put-before
}
zle -N _paste_from_clipboard_visual


# INCREMENT / DECREMENT INTEGERS
# ---------------------------------------------------------------------------- #
autoload -Uz incarg
zle -N incarg
bindkey -M vicmd 'NU' incarg

local function _increment_integers() {
    emulate -L zsh
    incarg=1
    zle -U 'NU'
}
zle -N _increment_integers

local function _decrement_integers() {
    emulate -L zsh
    incarg=-1
    zle -U 'NU'
}
zle -N _decrement_integers


# SURROUND
# ---------------------------------------------------------------------------- #
autoload -Uz select-quoted select-bracketed surround
zle -N select-quoted
zle -N select-bracketed
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround


# CHANGE / DELETE SURROUNDING
# ---------------------------------------------------------------------------- #
# Called by `_manipulate_surrounding` function
bindkey -M vicmd 'CS' change-surround
bindkey -M vicmd 'DS' delete-surround

local function _manipulate_surrounding() {
    emulate -L zsh
    local characters=(\' \" \` \{ \( \[ \<)
    local key1 key2
    local found_key1=false
    local found_key2=false

    echo -ne $underline_cursor
    read -k 1 key1
    read -k 1 key2
    echo -ne $block_cursor

    # Check if both inputs exist in the characters array
    for k in "${characters[@]}"; do
        [[ "${k}" == "${key1}" ]] && found_key1=true
        [[ "${k}" == "${key2}" ]] && found_key2=true

        # If both keys are found, break early
        [[ "${found_key1}" == true && "${found_key2}" == true ]] && break
    done

    # If either key was not found in the array, return
    [[ "${found_key1}" == false || "${found_key2}" == false ]] && return

    # If the same key was pressed twice `delete`, otherwise `change`
    if [[ "${key1}" == "${key2}" ]]; then
        zle -U DS"${key1}"
    else
        zle -U CS"${key1}""${key2}"
    fi
}
zle -N _manipulate_surrounding


# SELECT INSIDE SURROUNDING
# ---------------------------------------------------------------------------- #
# Called by `_select_in_surrounding` function
bindkey -M visual "Q'" select-quoted
bindkey -M visual 'Q"' select-quoted
bindkey -M visual 'Q`' select-quoted
bindkey -M visual 'Q{' select-bracketed
bindkey -M visual 'Q(' select-bracketed
bindkey -M visual 'Q[' select-bracketed
bindkey -M visual 'Q<' select-bracketed

local function _select_in_surrounding() {
    emulate -L zsh
    zle visual-mode
    case "${KEYS}" in
        "'") zle -U "Q'" ;;
        '"') zle -U 'Q"' ;;
        '`') zle -U 'Q`' ;;
        '{') zle -U 'Q{tala' ;;
        '(') zle -U 'Q(tala' ;;
        '[') zle -U 'Q[tala' ;;
        '<') zle -U 'Q<tala' ;;
    esac
}
zle -N _select_in_surrounding


# ADD SURROUNDING
# ---------------------------------------------------------------------------- #
# Called by `_add_surrounding` function
bindkey -M visual "M'" add-surround
bindkey -M visual 'M"' add-surround
bindkey -M visual 'M`' add-surround
bindkey -M visual 'M[' add-surround
bindkey -M visual 'M(' add-surround
bindkey -M visual 'M{' add-surround
bindkey -M visual 'M<' add-surround

local function _add_surrounding() {
    emulate -L zsh
    case "${KEYS}" in
        "'") zle -U "M''" ;;
        '"') zle -U 'M""' ;;
        '`') zle -U 'M``' ;;
        '{') zle -U 'M{{' ;;
        '(') zle -U 'M((' ;;
        '[') zle -U 'M[[' ;;
        '<') zle -U 'M<<' ;;
    esac

    # Save the region coords for `_reactivate_region` widget
    cursor_point="${CURSOR}"
    cursor_mark="${MARK}"
}
zle -N _add_surrounding
