#   ,
#  / \               _
#  \  \          ___(_)
#   \  \        /  /__
#    \  \      /  /|  |
#     \  \    /  / |  |
#      \  \  /  /  |  |
#       \  \/  /   |  |
#        \    /    |  |
#         \  /     |__| bindings
# ======== \/ ================================================================ #

# See: `man zshzle`

bindkey -v
export KEYTIMEOUT=1

# Highlight color
zle_highlight+=(paste:none)               # Prevent text highlight on paste
zle_highlight+=(region:bg=blue,fg=white)  # Set highlight color in visual mode

# INDEX
# ---------------------------------------------------------------------------- #
# USER DEFINED FUNCTIONS
# ZSH-HISTORY-SUBSTRING-SEARCH PLUGIN
# MODE TOGGLING
# LINE NAVIGATION
# DELETE BINDINGS
# DELETE MOTIONS
# UNDO / REDO / DOT OPERATOR
# SELECT IN WORD / LINE
# UPPER / LOWER / SWAP CASE
# COPY
# CUT
# CHANGE
# PASTE
# INCREMENT / DECREMENT INTEGERS
# SURROUND
# CHANGE / DELETE SURROUNDING
# SELECT INSIDE SURROUNDING
# ADD SURROUNDING


# REMOVE DEFAULT KEYMAPS
# ---------------------------------------------------------------------------- #
local _defaults
_defaults=(
    'd'
    'D'
    'e'
    'E'
    'b'
    'B'
    'c'
    'C'
    'x'
    'X'
    's'
    'S'
    'y'
    'Y'
    'v'
    'V'
    't'
    'T'
    'w'
    'W'
    'n'
    'N'
    'i'
    'I'
    'k'
    'j'
    'J'
    'g'
    'G'
    'o'
    'O'
    'p'
    'P'
    'm'
    'u'
    'l'
    'h'
    '#'
    '$'
    "'"
    '"'
    '`'
    '^'
    '|'
    ','
    '.'
    '+'
    '?'
    '~'
    '<'
    ':'
    '\-'
    '\t'
)
for m in vicmd visual viopp; do
    for k in "$_defaults[@]"; do
        bindkey -rM $m $k
    done
done


# USER DEFINED FUNCTIONS
# ---------------------------------------------------------------------------- #
zle -N bk_broot_launcher
bindkey -M viins "^[f" bk_broot_launcher   # Alt f = Launch broot

zle -N bk_cmd_history_fzf
bindkey -M viins "^[p" bk_cmd_history_fzf  # Alt p = Command history fzf

zle -N bk_teleport
bindkey -M viins "^['" bk_teleport         # Alt ' = Z jump history fzf

zle -N bk_rename_fzf
bindkey -M viins "^[r" bk_rename_fzf       # Alt r = Rename files / dirs in cwd


# MODE TOGGLING
# ---------------------------------------------------------------------------- #
bindkey -M vicmd '^[' vi-insert        # Esc = Insert/cmd mode
bindkey -M vicmd 's' visual-mode       # s = Visual mode
bindkey -M vicmd 'S' visual-line-mode  # S = Visual line mode


# LINE NAVIGATION
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'l' vi-forward-char           # l = Right
bindkey -M vicmd 't' vi-backward-char          # t = Left
bindkey -M vicmd 'h' beginning-of-line         # h = Jump to LINE START
bindkey -M vicmd ';' end-of-line               # ; = Jump to LINE END
bindkey -M vicmd 'o' vi-forward-word           # o = Jump forwards by WORD
bindkey -M vicmd 'u' vi-backward-word          # u = Jump backwards by WORD
bindkey -M vicmd 'O' vi-forward-word-end       # O = Jump forwards to WORD end
bindkey -M vicmd 'U' vi-backward-word-end      # U = Jump backwards to WORD end
bindkey -M vicmd '.' vi-repeat-find            # . = Next `f` search result
bindkey -M vicmd ',' vi-rev-repeat-find        # , = Previous `f` search result

# Vis
bindkey -M visual 'o' vi-forward-word          # o = Jump forwards by WORD
bindkey -M visual 'u' vi-backward-word         # u = Jump backwards by WORD
bindkey -M visual 'O' vi-forward-word-end      # O = Jump forwards to WORD end
bindkey -M visual 'U' vi-backward-word-end     # U = Jump backwards to WORD end
bindkey -M visual 'a' exchange-point-and-mark  # a = Other side of selection

# Ins
bindkey -M viins '^[[H' beginning-of-line      # Home = Jump LINE START
bindkey -M viins '^[[F' end-of-line            # End = Jump LINE END
bindkey -M viins '^[[1;3D' vi-backward-word    # Alt Left = Jump backwards by WORD

# A forward-char call is required to prevent
# the cursor landing left of the final letter
local function _jump_forward_word() {
    emulate -L zsh
    zle vi-forward-word-end
    zle vi-forward-char
}
zle -N _jump_forward_word
bindkey -M viins '^[[1;3C' _jump_forward_word  # Alt Right = Jump forwards by WORD


# DELETE BINDINGS
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '^?' backward-delete-char  # BS = Delete backwards
bindkey -M vicmd '^[[3~' delete-char        # Del = Delete forwards
bindkey -M vicmd '^[^?' backward-kill-word  # Alt BS = Delete WORD LEFT
bindkey -M vicmd '^[[3;3~' kill-word        # Alt Del = Delete WORD RIGHT
bindkey -M vicmd '^H' backward-kill-line    # Ctrl BS = Delete to LINE start
bindkey -M vicmd '^[[3;5~' kill-line        # Ctrl Del = Delete to LINE end
bindkey -M vicmd '^[[3;2~' kill-whole-line  # Shift Del = Delete whole line

# Vis
bindkey -M visual '^?' kill-region          # BS = Delete selection
bindkey -M visual '^[[3~' kill-region       # Del = Delete selection

# Ins
bindkey -M viins '^?' backward-delete-char  # BS = Delete backwards
bindkey -M viins '^[[3~' delete-char        # Del = Delete forwards
bindkey -M viins '^[^?' backward-kill-word  # Alt BS = Delete WORD LEFT
bindkey -M viins '^[[3;3~' kill-word        # Alt Del = Delete WORD RIGHT
bindkey -M viins '^H' backward-kill-line    # Ctrl BS = Delete to LINE end
bindkey -M viins '^[[3;5~' kill-line        # Ctrl Del = Delete to LINE start
bindkey -M viins '^[[3;2~' kill-whole-line  # Shift Del = Delete whole line


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
        't')                        # wt = Delete in word
            _select_in_word
            zle kill-region
            ;;
        'u')                        # wu = Delete word left
            zle backward-kill-word
            ;;
        'o')                        # wo = Delete word right
            zle kill-word
            ;;
        'l')                        # wl = Delete whole line
            zle kill-whole-line
            ;;
        'h')                        # wh = Delete to line start
            zle backward-kill-line
            ;;
        ';')                        # w; = Delete to line end
            zle kill-line
            ;;
        '.')                        # w. = Delete to next typed char
            local pos next_char
            pos="${BUFFER[$CURSOR+1]}"
            read -k 1 next_char
            [[ "$pos" == "$next_char" ]] && \
                zle delete-char
            zle -U ZF"$next_char"
            ;;
        ',')                        # w, = Delete to previous typed char
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
bindkey -M vicmd 'w' _delete_motions

# Vis
bindkey -M visual 'w' kill-region  # w = Delete visual selection


# UNDO / REDO / DOT OPERATOR
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '\-' vi-repeat-change  # Tab = Dot operator
bindkey -M vicmd '^[y' undo             # Alt y = Undo
bindkey -M vicmd '^[Y' redo             # Alt Y = Redo

# Ins
bindkey -M viins '^[y' undo             # Alt y = Undo
bindkey -M viins '^[Y' redo             # Alt Y = Redo


# SELECT IN WORD / LINE
# ---------------------------------------------------------------------------- #
# Cmd
local function _select_in_word() {
    emulate -L zsh
    zle visual-mode
    zle select-in-word
}
zle -N _select_in_word
bindkey -M vicmd '^[[1;3C' _select_in_word    # Alt Right = Select in WORD

# Vis
bindkey -M visual '^[[1;3C' visual-line-mode  # Alt Right = Enter visual LINE mode


# UPPER / LOWER / SWAP CASE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '_' vi-swap-case    # _ = Swap case

# Vis
bindkey -M visual '_' vi-up-case     # - = Uppercase selection
bindkey -M visual '\-' vi-down-case  # _ = Lowercase selection


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
        't')                         # ct = Copy in word
            _auto_mark_set
            _select_in_word
            _copy_to_clipboard
            _auto_mark_go
            ;;
        'u')                         # cu = Copy word left
            _auto_mark_set
            zle vi-backward-char
            zle visual-mode
            zle vi-backward-word
            _copy_to_clipboard
            _auto_mark_go
            ;;
        'o')                         # co = Copy word right
            zle visual-mode
            zle vi-forward-word-end
            _copy_to_clipboard
            ;;
        'l')                         # cl = Copy whole line
            zle vi-yank-whole-line
            _echo_to_sys_clipboard
            ;;
        'h')                         # ch = Copy to line start
            _auto_mark_set
            zle visual-mode
            zle beginning-of-line
            _copy_to_clipboard
            _auto_mark_go
            ;;
        ';')                         # c; = Copy to line end
            zle vi-yank-eol
            _echo_to_sys_clipboard
            ;;
        '.')                         # c. = Copy to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _copy_to_clipboard
            ;;
        ',')                         # c, = Copy to previous typed char
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
bindkey -M vicmd 'c' _copy_motions

# Vis
function _copy_to_clipboard() {
    emulate -L zsh
    zle vi-yank
    echo -n "$CUTBUFFER" | pbcopy -i
}
zle -N _copy_to_clipboard
bindkey -M visual 'c' _copy_to_clipboard  # c = Copy visual selection


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
        't')                        # xt = Cut in word
            _select_in_word
            _cut_to_clipboard
            ;;
        'u')                        # xu = Cut word left
            zle backward-kill-word
            _echo_to_sys_clipboard
            ;;
        'o')                        # xo = Cut word right
            zle kill-word
            _echo_to_sys_clipboard
            ;;
        'l')                        # xl = Cut whole line
            zle kill-whole-line
            _echo_to_sys_clipboard
            ;;
        'h')                        # xh = Cut to line start
            zle backward-kill-line
            _echo_to_sys_clipboard
            ;;
        ';')                        # x; = Cut to line end
            zle kill-line
            _echo_to_sys_clipboard
            ;;
        '.')                        # x. = Cut to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            _cut_to_clipboard
            ;;
        ',')                        # x, = Cut to previous typed char
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
bindkey -M vicmd 'x' _cut_motions

# Vis
local function _cut_to_clipboard() {
    zle vi-delete
    echo -n "$CUTBUFFER" | pbcopy -i
}
zle -N _cut_to_clipboard
bindkey -M visual 'x' _cut_to_clipboard  # x = Cut visual selection


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
        't')                          # yt = Change in word
            _select_in_word
            zle vi-change
            ;;
        'u')                          # yu = Change word left
            zle backward-kill-word
            zle vi-insert
            ;;
        'o')                          # yo = Change word right
            zle kill-word
            zle vi-insert
            ;;
        'l')                          # yl = Change whole line
            zle vi-change-whole-line
            ;;
        'h')                          # yh = Change to line start
            zle backward-kill-line
            zle vi-insert
            ;;
        ';')                          # y; = Change to line end
            zle vi-change-eol
            ;;
        '.')                          # y. = Change to next typed char
            local next_char
            read -k 1 next_char
            zle -U "TN${next_char}"
            zle vi-change
            [[ $RBUFFER != *"$next_char"* ]] \
                && _block_cursor
            ;;
        ',')                          # y, = Change to previous typed char
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
bindkey -M vicmd 'y' _change_motions

# Vis
bindkey -M visual 'y' vi-change  # y = Change visual selection


# PASTE
# ---------------------------------------------------------------------------- #
# Cmd / Ins
local function _paste_from_clipboard() {
    emulate -L zsh
    CUTBUFFER=$(pbpaste)
    zle vi-put-before
}
zle -N _paste_from_clipboard
bindkey -M vicmd 'v' _paste_from_clipboard
bindkey -M viins '^[v' _paste_from_clipboard

# Vis
local function _paste_from_clipboard_visual() {
    emulate -L zsh
    zle kill-region
    CUTBUFFER=$(pbpaste)
    zle vi-put-before
}
zle -N _paste_from_clipboard_visual
bindkey -M visual 'v' _paste_from_clipboard_visual


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
bindkey -M vicmd '\x1bc' _increment_integers  # Alt c = Increment integers

local function _decrement_integers() {
    emulate -L zsh
    incarg=-1
    zle -U 'NU'
}
zle -N _decrement_integers
bindkey -M vicmd '\x1bx' _decrement_integers  # Alt x = Decrement integers


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
# Cmd
bindkey -M vicmd 'CS' change-surround
bindkey -M vicmd 'DS' delete-surround

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
bindkey -M vicmd ' ' _manipulate_surrounding


# SELECT INSIDE SURROUNDING
# ---------------------------------------------------------------------------- #
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
bindkey -M vicmd "'" _select_in_surrounding
bindkey -M vicmd '"' _select_in_surrounding
bindkey -M vicmd '`' _select_in_surrounding
bindkey -M vicmd '{' _select_in_surrounding
bindkey -M vicmd '(' _select_in_surrounding
bindkey -M vicmd '[' _select_in_surrounding
bindkey -M vicmd '<' _select_in_surrounding

# Called by `_select_in_surrounding` function
bindkey -M visual "Q'" select-quoted
bindkey -M visual 'Q"' select-quoted
bindkey -M visual 'Q`' select-quoted
bindkey -M visual 'Q{' select-bracketed
bindkey -M visual 'Q(' select-bracketed
bindkey -M visual 'Q[' select-bracketed
bindkey -M visual 'Q<' select-bracketed


# ADD SURROUNDING
# ---------------------------------------------------------------------------- #
# Cmd
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
bindkey -M visual "'" _add_surrounding
bindkey -M visual '"' _add_surrounding
bindkey -M visual '`' _add_surrounding
bindkey -M visual '{' _add_surrounding
bindkey -M visual '(' _add_surrounding
bindkey -M visual '[' _add_surrounding
bindkey -M visual '<' _add_surrounding

# Called by `_add_surrounding` function
bindkey -M visual "M'" add-surround
bindkey -M visual 'M"' add-surround
bindkey -M visual 'M`' add-surround
bindkey -M visual 'M[' add-surround
bindkey -M visual 'M(' add-surround
bindkey -M visual 'M{' add-surround
bindkey -M visual 'M<' add-surround


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
