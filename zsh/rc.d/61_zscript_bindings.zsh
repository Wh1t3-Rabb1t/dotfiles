#                     _       _     _     _           _ _
#   _______  ___ _ __(_)_ __ | |_  | |__ (_)_ __   __| (_)_ __   __ _ ___
#  |_  / __|/ __| '__| | '_ \| __| | '_ \| | '_ \ / _` | | '_ \ / _` / __|
#   / /\__ \ (__| |  | | |_) | |_  | |_) | | | | | (_| | | | | | (_| \__ \
#  /___|___/\___|_|  |_| .__/ \__| |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# =====================|_|======================================|___/========= #

# CHEAT SHEAT
# ---------------------------------------------------------------------------- #
zle -N _cheat_sheet
bindkey -M viins "^[c" _cheat_sheet         # Alt c = Cheat sheet


# COMMAND HISTORY FZF
# ---------------------------------------------------------------------------- #
zle -N _cmd_history_fzf
bindkey -M viins "^[p" _cmd_history_fzf      # Alt p = Command history fzf


# TELEPORT
# ---------------------------------------------------------------------------- #
zle -N _teleport
bindkey -M viins "^['" _teleport             # Alt ' = Z jump history fzf


# RENAME FZF
# ---------------------------------------------------------------------------- #
zle -N _rename_fzf
bindkey -M viins "^[r" _rename_fzf           # Alt r = Rename files / dirs in cwd


# BROOT
# ---------------------------------------------------------------------------- #
if (( ${+commands[broot]} )); then
    source "${XDG_CONFIG_HOME}/broot/launcher/bash/br"
    zle -N _broot_launcher
    bindkey -M viins "^[f" _broot_launcher   # Alt f = Launch broot
fi
