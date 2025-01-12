#   _                _     _           _ _
#  | | _____ _   _  | |__ (_)_ __   __| (_)_ __   __ _ ___
#  | |/ / _ \ | | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
#  |   <  __/ |_| | | |_) | | | | | (_| | | | | | (_| \__ \
#  |_|\_\___|\__, | |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# ===========|___/===============================|___/======================== #


# LASTWIDGET (scalar)
#        The name of the last widget that was executed; read-only.


# killring (array)
#        The array of previously killed items, with the most recently
#        killed first.  This gives the items that would be retrieved by a
#        yank-pop in the same order.  Note, however, that the most recently
#        killed item is in $CUTBUFFER; $killring shows the array of
#        previous entries.

#        The default size for the kill ring is eight, however the length
#        may be changed by normal array operations.  Any empty string in
#        the kill ring is ignored by the yank-pop command, hence the size
#        of the array effectively sets the maximum length of the kill ring,
#        while the number of non-zero strings gives the current length,
#        both as seen by the user at the command line.




# ╭────────────────────────╮
# │ ALT LAYER KEY BINDINGS │
# ╰────────────────────────╯

# Alt r: Rename files / dirs in cwd
zle -N _rename_fzf
bindkey -M viins "^[r" _rename_fzf

# Alt g: Grep term and open in nvim
zle -N _grep_into_nvim
bindkey -M viins "^[g" _grep_into_nvim


# ╭──────────────────────╮
# │ ONESHOT KEY BINDINGS │
# ╰──────────────────────╯
# The scripts these keys are bound to are executed on a single press, only
# when the command line is empty. Otherwise they input the relevant key onto
# the command line, or execute the relevant action.
#
# i.e. pressing semicolon ';' calls the `_zsh_cheat_sheet` widget when the
# command line is empty, and inputs a semicolon character as normal otherwise.
#
# NOTE: Certain keys like Tab, or comma, are bound by plugins (fzf-tab and
# zsh-autopairs in this case), so rather than inputting say; a comma to the
# command line if the conditions for executing a oneshot binding aren't met,
# we instead call the relevant zsh-autopairs widget manually so that the desired
# behaviour will be respected. As such, plugins must be sourced prior to
# declaring these bindings for their widgets to work.


# BROOT
# ---------------------------------------------------------------------------- #
local function _broot_launcher() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="br --sort-by-type --no-tree"
        zle accept-line
    else
        zle accept-line
    fi
}
zle -N _broot_launcher
bindkey -M viins "^M" _broot_launcher


# LAUNCH NEOVIM
# ---------------------------------------------------------------------------- #
local function _neovim_launcher() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _launch_nvim
    else
        fzf-tab-complete
        zle redisplay     # Syntax highlighting on fzf-tab exit
    fi
}
zle -N _neovim_launcher
bindkey -M viins "^I" _neovim_launcher


# ZSH CHEAT SHEAT
# ---------------------------------------------------------------------------- #
local function _cheat_sheet_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _zsh_cheat_sheet
    else
        LBUFFER[CURSOR+1]+=";"
    fi
}
zle -N _cheat_sheet_wrapper
bindkey -M viins ";" _cheat_sheet_wrapper


# CMD HISTORY
# ---------------------------------------------------------------------------- #
# NOTE: The first awk line adds color to the second field (the commmand prefix).
# The second removes the command's index and cleans up white space before
# inserting the command onto the buffer.
local function _cmd_history_fzf_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _cmd_history_fzf
    else
        # Use this in place of zsh `zle down-line-or-history` builtin
        # to prevent functionality conflicts.
        history-substring-search-down
    fi
}
zle -N _cmd_history_fzf_wrapper
bindkey -M viins "^[[B" _cmd_history_fzf_wrapper


# DIRECTORY NAVIGATION
# ---------------------------------------------------------------------------- #
# Teleport
local function _teleport_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _teleport
    else
        autopair-insert
    fi
}
zle -N _teleport_wrapper
bindkey -M viins "'" _teleport_wrapper


# Cd to parent dir
local function _cd_to_parent_dir() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd ../"
        zle accept-line
    else
        zle vi-backward-char
    fi
}
zle -N _cd_to_parent_dir
bindkey -M viins "^[[D" _cd_to_parent_dir  # Left arrow


# Cd to subdirectory of cwd
local function _cd_to_subdir() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd "
        CURSOR=${#BUFFER}
        fzf-tab-complete
    else
        zle vi-forward-char
    fi
}
zle -N _cd_to_subdir
bindkey -M viins "^[[C" _cd_to_subdir  # Right arrow


# Fd and cd down dirtree
local function _find_and_goto_dir_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _find_and_goto_dir
    else
        LBUFFER[CURSOR+1]+="-"
    fi
}
zle -N _find_and_goto_dir_wrapper
bindkey -M viins "\-" _find_and_goto_dir_wrapper


# FIXME
# available actions to map:
#
# ' Teleport
# - find and cd to dir
# Right cd in cwd
# Left cd up dir tree
#
# ; zsh cheat sheet
# <tab> cmd history fzf
#
# find and open files
# broot
# yazi

# available keys:
# space
# tab
# enter
# ;
# ,
# .
# /
# -
# =
# ''
# ""





# # Press enter to open fzf-tab cd completion menu if the command line is empty
# local function _cd_if_buffer_empty() {
#     emulate -L zsh
#     if [[ "$BUFFER" == "cd " ]]; then
#         CURSOR=${#BUFFER}
#         fzf-tab-complete
#     elif [[ -z "$BUFFER" ]]; then
#         BUFFER="cd "
#         CURSOR=${#BUFFER}
#         fzf-tab-complete
#     else
#         zle accept-line
#     fi
# }
# zle -N _cd_if_buffer_empty
# bindkey -M viins "^M" _cd_if_buffer_empty

# local function _test_fn() {
#     emulate -L zsh
#     if [[ -z "$BUFFER" ]]; then
#         BUFFER="cd "
#     else
#         LBUFFER[CURSOR+1]+="="
#         #         # zle vi-forward-char
#         #         # BUFFER+=" "
#         #         # CURSOR=${#BUFFER}
#     fi
# }
# zle -N _test_fn
# bindkey -M viins "=" _test_fn



# local function _tab_wrapper() {
#     emulate -L zsh
#     if [[ -z "$BUFFER" ]]; then
#         BUFFER="cd "
#         CURSOR=${#BUFFER}
#         fzf-tab-complete
#     else
#         fzf-tab-complete
#     fi
# }
# zle -N _tab_wrapper
# bindkey -M viins "^I" _tab_wrapper



# # Press space when the command line is empty to open 'leader' menu
# local function _leader_key() {
#     emulate -L zsh
#     if [[ -z "$BUFFER" ]]; then
#         BUFFER="cd "
#         CURSOR=${#BUFFER}
#         fzf-tab-complete
#     else
#         LBUFFER[CURSOR+1]+=" "
#         # zle vi-forward-char
#         # BUFFER+=" "
#         # CURSOR=${#BUFFER}
#     fi
# }
# zle -N _leader_key
# bindkey -M viins " " _leader_key




