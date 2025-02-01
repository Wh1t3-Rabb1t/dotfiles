#   _                _     _           _ _
#  | | _____ _   _  | |__ (_)_ __   __| (_)_ __   __ _ ___
#  | |/ / _ \ | | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
#  |   <  __/ |_| | | |_) | | | | | (_| | | | | | (_| \__ \
#  |_|\_\___|\__, | |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# ===========|___/===============================|___/======================== #


# ╭────────────────────────╮
# │ ALT LAYER KEY BINDINGS │
# ╰────────────────────────╯

# Alt r: Rename files / dirs in cwd
zle -N _rename_fzf
bindkey -M viins "^[r" _rename_fzf                                   # Alt r


# Alt f: Find and open file/s with neovim
zle -N _find_files
bindkey -M viins "^[f" _find_files                                   # Alt f


# Alt g: Grep term and open with neovim
zle -N _grep_into_nvim
bindkey -M viins "^[a" _grep_into_nvim                               # Alt a


# Alt p: Preview files with bat
zle -N _preview_files
bindkey -M viins "^[p" _preview_files                                # Alt p


# ╭─────────────────────────╮
# │ EMPTY LINE KEY BINDINGS │
# ╰─────────────────────────╯

# The scripts these keys are bound to are executed on a single press, only
# when the command line is empty. Otherwise they input the relevant key onto
# the command line, or execute the relevant action.
#
# i.e. pressing semicolon ';' calls the `_zsh_cheat_sheet` widget when the
# command line is empty, but inputs a semicolon character as normal otherwise.
#
# NOTE: Certain keys like Tab, or comma, are bound by plugins (fzf-tab and
# zsh-autopairs in this case), so rather than inputting say; a comma to the
# command line if the conditions for executing an 'empty-line'  binding aren't
# met, we instead call the relevant zsh-autopairs widget manually so that the
# desired behaviour will be respected. As such, plugins must be sourced prior
# to declaring these bindings for their associated widgets to work.


# BROOT LAUNCHER
# ---------------------------------------------------------------------------- #
local function _broot_launcher() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="br --sort-by-type"
        zle accept-line
    else
        zle accept-line
    fi
}
zle -N _broot_launcher
bindkey -M viins " " _broot_launcher                                 # Space
bindkey -M vicmd " " _broot_launcher


# YAZI LAUNCHER
# ---------------------------------------------------------------------------- #
local function _yazi_launcher() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="yazi"
        zle accept-line
    else
        LBUFFER[CURSOR+1]+=" "
        POSTDISPLAY=
        zle redisplay
    fi
}
zle -N _yazi_launcher
bindkey -M viins "^I" _yazi_launcher                                 # Tab


# LAUNCH NEOVIM SESSION
# ---------------------------------------------------------------------------- #
local function _launch_nvim_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _launch_nvim
    else
        fzf-tab-complete
        POSTDISPLAY=      # Clear zsh-autosuggestions if present
        zle redisplay     # Syntax highlighting on fzf-tab exit
    fi
}
zle -N _launch_nvim_wrapper
bindkey -M viins "^M" _launch_nvim_wrapper                           # Enter


# ZSCRIPTS FZF
# ---------------------------------------------------------------------------- #
local function _zscripts_fzf_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _zscripts_fzf || LBUFFER[CURSOR+1]+=";"
}
zle -N _zscripts_fzf_wrapper
bindkey -M viins ";" _zscripts_fzf_wrapper                           # ;


# ZSH HELP PAGES
# ---------------------------------------------------------------------------- #
local function _zsh_help_pages_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _zsh_help_pages || LBUFFER[CURSOR+1]+="?"
}
zle -N _zsh_help_pages_wrapper
bindkey -M viins "?" _zsh_help_pages_wrapper                         # ?


# CMD HISTORY
# ---------------------------------------------------------------------------- #
local function _zsh_cmd_history_wrapper() {
    emulate -L zsh

    # Use `history-substring-search-down` in place of zsh `down-line-or-history`
    # builtin to prevent functionality conflicts.
    [[ -z "$BUFFER" ]] && _zsh_cmd_history || history-substring-search-down
}
zle -N _zsh_cmd_history_wrapper
bindkey -M viins "^[[A" _zsh_cmd_history_wrapper                     # Up


# CD UP ONE DIR
# ---------------------------------------------------------------------------- #
local function _cd_up_dir() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd ../"
        zle accept-line
    else
        zle vi-backward-char
    fi
}
zle -N _cd_up_dir
bindkey -M viins "^[[D" _cd_up_dir                                   # Left


# CD DOWN DIR TREE
# ---------------------------------------------------------------------------- #
local function _cd_in_cwd_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _cd_in_cwd || zle vi-forward-char
}
zle -N _cd_in_cwd_wrapper
bindkey -M viins "^[[C" _cd_in_cwd_wrapper                           # Right


# TELEPORT
# ---------------------------------------------------------------------------- #
local function _teleport_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _teleport || autopair-insert
}
zle -N _teleport_wrapper
bindkey -M viins "'" _teleport_wrapper                               # '


# FD INTO CD
# ---------------------------------------------------------------------------- #
local function _find_and_goto_dir_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _find_and_goto_dir
    else
        POSTDISPLAY=
        LBUFFER[CURSOR+1]+="-"
    fi
}
zle -N _find_and_goto_dir_wrapper
bindkey -M viins "\-" _find_and_goto_dir_wrapper                     # -


# TRASH FILES / DIRECTORIES
# ---------------------------------------------------------------------------- #
local function _move_to_trash_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _move_to_trash || zle backward-kill-word
}
zle -N _move_to_trash_wrapper
bindkey -M viins "^[^?" _move_to_trash_wrapper                       # Alt BS


# CLEAR COMMAND LINE
# ---------------------------------------------------------------------------- #
local function _clear_command_line() {
    emulate -L zsh
    if [[ -z "$RBUFFER" ]]; then
        BUFFER=
        POSTDISPLAY=
    else
        zle delete-char
    fi
}
zle -N _clear_command_line
bindkey -M viins "^[[3~" _clear_command_line                         # Delete
