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

bindkey -v
export KEYTIMEOUT=1


# HIGHLIGHTS
# ---------------------------------------------------------------------------- #
zle_highlight+=(paste:none)               # Prevent text highlight on paste
zle_highlight+=(region:bg=blue,fg=white)  # Set highlight color in visual mode


# REMOVE DEFAULT KEYMAPS
# ---------------------------------------------------------------------------- #
# NOTE: You can unbind all of the 'viins' keys too but it removes literally
# every key; a-z, 0-9, everything... This wouldn't be a problem as they can be
# explicitly redeclared like so:
#
# bindkey -R -M viins "a"-"z" self-insert
# etc...
#
# But this approach causes fzf-tab to break and even manually redeclaring all
# of the alphanumeric keys / special characters causes doesn't fix the issue.
# (I'm assuming it relies on some zsh widgets being tied to default bindings
# which are getting wiped but this is a yacht problem and I'm eating porridge).
bindkey -rp -M vicmd ''
bindkey -rp -M visual ''
bindkey -rp -M viopp ''

# Hack to disable ctrl + PageUp / PageDown. This combination isn't bound to
# anything by default but causes zle to enter visual mode and temporarily
# freeze when pressed in insert mode. (I use this binding for tab switching
# in neovim and web browsers so it's easy to hit by accident).
local function _noop() {return}; zle -N _noop
bindkey -M viins '^[[6;5~' _noop
bindkey -M viins '^[[5;5~' _noop
bindkey -M vicmd '^[[6;5~' _noop
bindkey -M vicmd '^[[5;5~' _noop


# LINE NAVIGATION
# ---------------------------------------------------------------------------- #
# A forward-char call is required to prevent
# the cursor landing left of the final letter
local function _jump_forward_word() {
    emulate -L zsh
    zle vi-forward-word-end
    zle vi-forward-char
}
zle -N _jump_forward_word


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
    _underline_cursor

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
            _block_cursor
            return
            ;;
    esac

    _block_cursor
}
zle -N _delete_motions


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
    _underline_cursor

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
            _block_cursor
            return
            ;;
    esac

    _block_cursor
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
    _underline_cursor

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
            _block_cursor
            return
            ;;
    esac

    _block_cursor
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
    _underline_cursor

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
                && _block_cursor
            ;;
        ',')                               # y, = Change to previous typed char
            local prev_char
            read -k 1 prev_char
            zle -U "TP${prev_char}"
            zle vi-change
            [[ $LBUFFER != *"$prev_char"* ]] \
                && _block_cursor
            ;;
        *)
            _block_cursor
            return
            ;;
    esac
}
zle -N _change_motions


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
local function _block_cursor() { echo -ne "\e[1 q" }
zle -N _block_cursor

local function _beam_cursor() { echo -ne "\e[5 q" }
zle -N _beam_cursor

local function _underline_cursor() { echo -ne "\e[4 q" }
zle -N _underline_cursor

local function _echo_to_sys_clipboard() { echo -n "$CUTBUFFER" | pbcopy -i }
zle -N _echo_to_sys_clipboard

local function _auto_mark_set() { zle -U 'j'; zle vi-set-mark }
zle -N _auto_mark_set

local function _auto_mark_go() { zle -U 'j'; zle vi-goto-mark }
zle -N _auto_mark_go
