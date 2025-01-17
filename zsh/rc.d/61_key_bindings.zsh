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
bindkey -M viins "^[r" _rename_fzf


# Alt f: Find and open file/s with neovim
zle -N _find_files
bindkey -M viins "^[f" _find_files


# Alt g: Grep term and open with neovim
zle -N _grep_into_nvim
bindkey -M viins "^[g" _grep_into_nvim


# ╭──────────────────────╮
# │ ONESHOT KEY BINDINGS │
# ╰──────────────────────╯
#
# The scripts these keys are bound to are executed on a single press, only
# when the command line is empty. Otherwise they input the relevant key onto
# the command line, or execute the relevant action.
#
# i.e. pressing semicolon ';' calls the `_zsh_cheat_sheet` widget when the
# command line is empty, but inputs a semicolon character as normal otherwise.
#
# NOTE: Certain keys like Tab, or comma, are bound by plugins (fzf-tab and
# zsh-autopairs in this case), so rather than inputting say; a comma to the
# command line if the conditions for executing a oneshot binding aren't met,
# we instead call the relevant zsh-autopairs widget manually so that the desired
# behaviour will be respected. As such, plugins must be sourced prior to
# declaring these bindings for their widgets to work.


# BROOT LAUNCHER
# ---------------------------------------------------------------------------- #
local function _enter_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="br --sort-by-type"
        zle accept-line
    else
        zle accept-line
    fi
}
zle -N _enter_wrapper
bindkey -M viins "^M" _enter_wrapper


# YAZI LAUNCHER
# ---------------------------------------------------------------------------- #
local function _space_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="yazi"
        zle accept-line
    else
        LBUFFER[CURSOR+1]+=" "
        POSTDISPLAY=
    fi
}
zle -N _space_wrapper
bindkey -M viins " " _space_wrapper


# LAUNCH NEOVIM SESSION
# ---------------------------------------------------------------------------- #
local function _tab_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _launch_nvim
    else
        fzf-tab-complete
        POSTDISPLAY=      # Clear zsh-autosuggestions if present
        zle redisplay     # Syntax highlighting on fzf-tab exit
    fi
}
zle -N _tab_wrapper
bindkey -M viins "^I" _tab_wrapper


# ZSH CHEAT SHEAT
# ---------------------------------------------------------------------------- #
local function _semicolon_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _zsh_cheat_sheet || LBUFFER[CURSOR+1]+=";"
}
zle -N _semicolon_wrapper
bindkey -M viins ";" _semicolon_wrapper


# CMD HISTORY
# ---------------------------------------------------------------------------- #
# NOTE: The first awk line adds color to the second field (the commmand prefix).
# The second removes the command's index and cleans up white space before
# inserting the command onto the buffer.
local function _up_key_wrapper() {
    emulate -L zsh

    # Use `history-substring-search-down` in place of zsh `down-line-or-history`
    # builtin to prevent functionality conflicts.
    [[ -z "$BUFFER" ]] && _cmd_history_fzf || history-substring-search-down
}
zle -N _up_key_wrapper
bindkey -M viins "^[[A" _up_key_wrapper


# TELEPORT
# ---------------------------------------------------------------------------- #
local function _quote_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _teleport || autopair-insert
}
zle -N _quote_wrapper
bindkey -M viins "'" _quote_wrapper


# FD INTO CD
# ---------------------------------------------------------------------------- #
local function _hyphen_wrapper() {
    emulate -L zsh
    [[ -z "$BUFFER" ]] && _find_and_goto_dir || LBUFFER[CURSOR+1]+="-"
}
zle -N _hyphen_wrapper
bindkey -M viins "\-" _hyphen_wrapper


# CD UP ONE DIR
# ---------------------------------------------------------------------------- #
local function _left_arrow_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd ../"
        zle accept-line
    else
        zle vi-backward-char
    fi
}
zle -N _left_arrow_wrapper
bindkey -M viins "^[[D" _left_arrow_wrapper


# CD DOWN ONE DIR
# ---------------------------------------------------------------------------- #
local function _right_arrow_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd "
        CURSOR=${#BUFFER}
        fzf-tab-complete
    else
        zle vi-forward-char
    fi
}
zle -N _right_arrow_wrapper
bindkey -M viins "^[[C" _right_arrow_wrapper






# PRINT HELP DOCS
# ---------------------------------------------------------------------------- #
local function _question_mark_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        pushd "$ZDOTDIR"

        local selection=$( \
            fd \
                --type file \
                --extension md \
                --color always \
            | fzf --header=' zsh help pages.' \
        )

        if [[ "$selection" ]]; then
            print "\n"
            glow "$selection"
            print "\n"
        fi

        popd
        zle redisplay
    else
        LBUFFER[CURSOR+1]+="?"
    fi
}
zle -N _question_mark_wrapper
bindkey -M viins "?" _question_mark_wrapper
