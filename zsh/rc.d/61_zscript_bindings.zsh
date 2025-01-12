#                     _       _     _     _           _ _
#   _______  ___ _ __(_)_ __ | |_  | |__ (_)_ __   __| (_)_ __   __ _ ___
#  |_  / __|/ __| '__| | '_ \| __| | '_ \| | '_ \ / _` | | '_ \ / _` / __|
#   / /\__ \ (__| |  | | |_) | |_  | |_) | | | | | (_| | | | | | (_| \__ \
#  /___|___/\___|_|  |_| .__/ \__| |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# =====================|_|======================================|___/========= #

# # CHEAT SHEAT
# # ---------------------------------------------------------------------------- #
# zle -N _cheat_sheet
# bindkey -M viins "^[c" _cheat_sheet         # Alt c = Cheat sheet


# RENAME FZF
# ---------------------------------------------------------------------------- #
zle -N _rename_fzf
bindkey -M viins "^[r" _rename_fzf          # Alt r = Rename files / dirs in cwd


# GREP NVIM
# ---------------------------------------------------------------------------- #
zle -N _grep_into_nvim
bindkey -M viins "^[g" _grep_into_nvim      # Alt g = Grep term and open in nvim




# ---------------------------------------------------------------------------- #

# NOTE:
# fzf-tab and zsh-autopairs must be pre loaded so that their widget's
# can be used here


# FIXME
# available actions to map:
#
# ; Teleport
# / find and cd to dir
# . cd in cwd
# , cd up dir tree
#
# - cheat sheet
# cmd history fzf
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

# keys effected by zsh autopair will require a monkey patch to work
# ''
# ""


# Navigate up one directory.
# NOTE: Although not related to fzf-tab, I'm putting this here because it
# somewhat mirrors the `_cd_if_buffer_empty` function.
# local function _cd_to_parent_dir() {
#     emulate -L zsh
#     BUFFER="cd ../"
#     zle accept-line

# }
# zle -N _cd_to_parent_dir
# bindkey -M viins "^[[Z" _cd_to_parent_dir  # Btab




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
bindkey -M viins "^m" _broot_launcher


# TELEPORT
# ---------------------------------------------------------------------------- #
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
        fzf-tab-complete
    fi
}
zle -N _cmd_history_fzf_wrapper
bindkey -M viins "^i" _cmd_history_fzf_wrapper


# CHEAT SHEAT
# ---------------------------------------------------------------------------- #
local function _cheat_sheet_wrapper() {
    emulate -L zsh

    if [[ -z "$BUFFER" ]]; then
        _cheat_sheet
    else
        LBUFFER[CURSOR+1]+="-"
    fi
}
zle -N _cheat_sheet_wrapper
bindkey -M viins "\-" _cheat_sheet_wrapper



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





