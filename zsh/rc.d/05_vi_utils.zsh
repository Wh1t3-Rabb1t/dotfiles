#   ,
#  / \               _
#  \  \          ___(_)
#   \  \        /  /__
#    \  \      /  /|  |
#     \  \    /  / |  |
#      \  \  /  /  |  |
#       \  \/  /   |  |
#        \    /    |  |
#         \  /     |__| utils
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
    for k in "$escape_sequences[@]"; do
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
function zle-keymap-select() {
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


# LINE NAVIGATION
# ---------------------------------------------------------------------------- #
local function _jump_forward_word() {
    emulate -L zsh
    zle vi-forward-word-end
    zle vi-forward-char  # Prevent the cursor landing left of the final letter
}
zle -N _jump_forward_word

# Custom line navigation widgets to handle multiline commands properly.
# NOTE: 'in bounds' checks aren't really needed as ZLE appears to handle
# cursor boundaries automatically. e.g. Setting CURSOR to a value less
# than 1 or greater than the number of characters held in BUFFER,
# positions the cursor at the start, or end of BUFFER without issue.
local function _up_line() {
    emulate -L zsh
    CURSOR=$(( CURSOR - COLUMNS ))
    zle -R
}
zle -N _up_line

local function _down_line() {
    emulate -L zsh
    CURSOR=$(( CURSOR + COLUMNS ))
    zle -R
}
zle -N _down_line

local function _line_start() {
    emulate -L zsh
    CURSOR=$(( CURSOR - ( (CURSOR + 4) % COLUMNS ) ))
    zle -R
}
zle -N _line_start

local function _line_end() {
    emulate -L zsh
    CURSOR=$(( CURSOR - ( (CURSOR + 4) % COLUMNS ) + COLUMNS - 1 ))
    zle -R
}
zle -N _line_end


# DELETE MOTIONS
# ---------------------------------------------------------------------------- #
zmodload zsh/deltochar

# Invoked by `_delete_motions`
local function _zap_backwards() { zle zap-to-char -n -1 }
zle -N _zap_backwards
bindkey -M vicmd 'ZB' _zap_backwards
bindkey -M vicmd 'ZF' zap-to-char

# Cmd
local function _delete_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Make widget repeatable with the dot operator
    zle -f vichange

    # Read next typed keystroke
    local key
    read -k 1 key
    case $key in
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
        'h')                               # wh = Delete to line start
            zle backward-kill-line
            ;;
        ';')                               # w; = Delete to line end
            zle kill-line
            ;;
        '.')                               # w. = Delete to next typed char
            local pos next_char
            pos="${BUFFER[$CURSOR+1]}"
            read -k 1 next_char
            [[ "$pos" == "$next_char" ]] && \
                zle delete-char
            zle -U ZF"$next_char"
            ;;
        ',')                               # w, = Delete to previous typed char
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
# Cmd
function _replace_chars() {
    echo -ne $underline_cursor
    zle vi-replace-chars
    echo -ne $block_cursor
}
zle -N _replace_chars


# SELECT IN WORD / LINE
# ---------------------------------------------------------------------------- #
# Cmd
local function _select_in_word() {
    emulate -L zsh
    zle visual-mode
    zle select-in-word
}
zle -N _select_in_word


# COPY
# ---------------------------------------------------------------------------- #
# Invoked by copy, cut, and change motion functions
bindkey -M vicmd 'TN' vi-find-next-char-skip
bindkey -M vicmd 'TP' vi-find-prev-char-skip

# Cmd
local function _copy_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case $key in
        't')                               # ct = Copy in word
            _auto_mark_set
            _select_in_word
            _copy_to_clipboard
            _auto_mark_go
            ;;
        'u')                               # cu = Copy word left
            _auto_mark_set
            zle vi-backward-char
            zle visual-mode
            zle vi-backward-word
            _copy_to_clipboard
            _auto_mark_go
            ;;
        'o')                               # co = Copy word right
            zle visual-mode
            zle vi-forward-word-end
            _copy_to_clipboard
            ;;
        'l')                               # cl = Copy whole line
            zle vi-yank-whole-line
            _echo_to_sys_clipboard
            ;;
        'h')                               # ch = Copy to line start
            _auto_mark_set
            zle visual-mode
            zle beginning-of-line
            _copy_to_clipboard
            _auto_mark_go
            ;;
        ';')                               # c; = Copy to line end
            zle vi-yank-eol
            _echo_to_sys_clipboard
            ;;
        '.')                               # c. = Copy to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _copy_to_clipboard
            ;;
        ',')                               # c, = Copy to previous typed char
            local prev_char
            read -k 1 prev_char
            _auto_mark_set
            zle -U "TP${prev_char}"
            _copy_to_clipboard
            _auto_mark_go
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac

    echo -ne $block_cursor
}
zle -N _copy_motions

# Vis
function _copy_to_clipboard() {
    emulate -L zsh
    zle vi-yank
    echo -n "$CUTBUFFER" | pbcopy -i
}
zle -N _copy_to_clipboard


# CUT
# ---------------------------------------------------------------------------- #
# Cmd
local function _cut_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case $key in
        't')                               # xt = Cut in word
            _select_in_word
            _cut_to_clipboard
            ;;
        'u')                               # xu = Cut word left
            zle backward-kill-word
            _echo_to_sys_clipboard
            ;;
        'o')                               # xo = Cut word right
            zle kill-word
            _echo_to_sys_clipboard
            ;;
        'l')                               # xl = Cut whole line
            zle kill-whole-line
            _echo_to_sys_clipboard
            ;;
        'h')                               # xh = Cut to line start
            zle backward-kill-line
            _echo_to_sys_clipboard
            ;;
        ';')                               # x; = Cut to line end
            zle kill-line
            _echo_to_sys_clipboard
            ;;
        '.')                               # x. = Cut to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _cut_to_clipboard
            ;;
        ',')                               # x, = Cut to previous typed char
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

# Vis
local function _cut_to_clipboard() {
    zle vi-delete
    echo -n "$CUTBUFFER" | pbcopy -i
}
zle -N _cut_to_clipboard


# CHANGE
# ---------------------------------------------------------------------------- #
# Cmd
local function _change_motions() {
    emulate -L zsh
    echo -ne $underline_cursor

    # Read next typed keystroke
    local key
    read -k 1 key
    case $key in
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
        'h')                               # yh = Change to line start
            zle backward-kill-line
            zle vi-insert
            ;;
        ';')                               # y; = Change to line end
            zle vi-change-eol
            ;;
        '.')                               # y. = Change to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            zle vi-change
            [[ $RBUFFER != *"$next_char"* ]] \
                && echo -ne $block_cursor
            ;;
        ',')                               # y, = Change to previous typed char
            local prev_char
            read -k 1 prev_char
            zle -U "TP${prev_char}"
            zle vi-change
            [[ $LBUFFER != *"$prev_char"* ]] \
                && echo -ne $block_cursor
            ;;
        *)
            echo -ne $block_cursor
            return
            ;;
    esac
}
zle -N _change_motions


# CLIPBOARD RING
# ---------------------------------------------------------------------------- #
# TODO: Consider locking file on write to prevent race conditions
local VI_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh_vi"
local VI_CLIPBOARD_RING="${VI_STATE_DIR}/clipboard-ring"

# Create required dir / files
[[ ! -d "${VI_STATE_DIR}" ]] && mkdir -p "$VI_STATE_DIR"
[[ ! -f "${VI_CLIPBOARD_RING}" ]] && touch "$VI_CLIPBOARD_RING"

local _clipboard_ring_indexes=(
    {a..z}
    {A..Z}
)

local function _clipboard_ring() {
    emulate -L zsh
    local key
    read -k 1 key
    case $key in
        'c')
            _copy_to_clipboard
            ;;
        'x')
            _cut_to_clipboard
            ;;
        'r')
            # TODO: Finish this by appying `_clipboard_ring_indexes` to each entry
            tac "$VI_CLIPBOARD_RING" | awk -v prefix="TEST PREFIX: " '{print prefix $0}' | fzf
            ;;
        '*')
            return
            ;;
    esac

    # Tac the file rather than worry about prepending to the array dumbass
    echo "${CUTBUFFER}" >> "$VI_CLIPBOARD_RING"

    # Prevent number of entries from exceeding `_clipboard_ring_indexes` count
    if [[ $(wc -l < "$VI_CLIPBOARD_RING") -gt 51 ]]; then
        # TODO: Add check to see if gnu sed is installed
        # macOS-compatible (use `-i` without quotes on Linux)
        # sed -i '' '1d' "$VI_CLIPBOARD_RING"

        sed -i '1d' "$VI_CLIPBOARD_RING"
    fi
}
zle -N _clipboard_ring

# TODO: move to vi bindings file
bindkey -M visual ' ' _clipboard_ring


# tac "$file" | awk -v prefix="$prefix" '{print prefix $0}' | fzf



# VI_CLIPBOARD_RING_ARRAY+=( "${CUTBUFFER}" )
# VI_RING_INDEX=$(( VI_RING_INDEX + 1 ))

# local VI_RING_INDEX="${VI_STATE_DIR}/ring-index"
# [[ ! -f "${VI_RING_INDEX}" ]] && touch "$VI_RING_INDEX"
# local VI_CLIPBOARD_RING_ARRAY=()
# VI_CLIPBOARD_RING_ARRAY+=( "[;${_clipboard_ring_indexes[VI_RING_INDEX]}] ${CUTBUFFER}" )

# local function _clipboard_ring() {
#     emulate -L zsh
#     local key
#     read -k 1 key
#     case $key in
#         'c')
#             _copy_to_clipboard
#             ;;
#         'x')
#             _cut_to_clipboard
#             ;;
#         '*')
#             return
#             ;;
#     esac

#     echo "[;${_clipboard_ring_indexes[VI_RING_INDEX]}] ${CUTBUFFER}" >> "$VI_CLIPBOARD_RING"
#     VI_RING_INDEX=$(( VI_RING_INDEX + 1 ))
# }
# zle -N _clipboard_ring
# bindkey -M visual 'n' _clipboard_ring


# PASTE
# ---------------------------------------------------------------------------- #
# Cmd
local function _paste_from_clipboard() {
    emulate -L zsh
    CUTBUFFER=$(pbpaste)
    zle vi-put-before
}
zle -N _paste_from_clipboard

# Vis
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

# Cmd
local function _manipulate_surrounding() {
    emulate -L zsh
    local characters=(\' \" \` \{ \( \[ \<)
    local found_key1=false
    local found_key2=false
    local key1
    local key2
    read -k 1 key1
    read -k 1 key2

    # Check if both inputs exist in the characters array
    for k in "$characters[@]"; do
        [[ "$k" == "$key1" ]] && found_key1=true
        [[ "$k" == "$key2" ]] && found_key2=true

        # If both keys are found, break early
        [[ "$found_key1" == true && "$found_key2" == true ]] && break
    done

    # If either key was not found in the array, return
    [[ "$found_key1" == false || "$found_key2" == false ]] && return

    # If the same key was pressed twice `delete`, otherwise `change`
    if [[ "$key1" == "$key2" ]]; then
        zle -U DS"$key1"
    else
        zle -U CS"$key1""$key2"
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

# Cmd
local function _select_in_surrounding() {
    emulate -L zsh
    zle visual-mode
    case "$KEYS" in
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

# Vis
local function _add_surrounding() {
    emulate -L zsh
    case "$KEYS" in
        "'") zle -U "M''" ;;
        '"') zle -U 'M""' ;;
        '`') zle -U 'M``' ;;
        '{') zle -U 'M{{' ;;
        '(') zle -U 'M((' ;;
        '[') zle -U 'M[[' ;;
        '<') zle -U 'M<<' ;;
    esac
}
zle -N _add_surrounding


# UTIL FUNCTIONS
# ---------------------------------------------------------------------------- #
local function _echo_to_sys_clipboard() { echo -n "$CUTBUFFER" | pbcopy -i }
zle -N _echo_to_sys_clipboard

local function _auto_mark_set() { zle -U 'j'; zle vi-set-mark }
zle -N _auto_mark_set

local function _auto_mark_go() { zle -U 'j'; zle vi-goto-mark }
zle -N _auto_mark_go
