#                     _       _     _     _           _ _
#   _______  ___ _ __(_)_ __ | |_  | |__ (_)_ __   __| (_)_ __   __ _ ___
#  |_  / __|/ __| '__| | '_ \| __| | '_ \| | '_ \ / _` | | '_ \ / _` / __|
#   / /\__ \ (__| |  | | |_) | |_  | |_) | | | | | (_| | | | | | (_| \__ \
#  /___|___/\___|_|  |_| .__/ \__| |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# =====================|_|======================================|___/========= #

# COMMAND HISTORY FZF
# ---------------------------------------------------------------------------- #
zle -N cmd_history_fzf
bindkey -M viins "^[p" cmd_history_fzf      # Alt p = Command history fzf


# TELEPORT
# ---------------------------------------------------------------------------- #
zle -N teleport
bindkey -M viins "^['" teleport             # Alt ' = Z jump history fzf


# RENAME FZF
# ---------------------------------------------------------------------------- #
zle -N rename_fzf
bindkey -M viins "^[r" rename_fzf           # Alt r = Rename files / dirs in cwd


# BROOT
# ---------------------------------------------------------------------------- #
if (( ${+commands[broot]} )); then
    source "${XDG_CONFIG_HOME}/broot/launcher/bash/br"
    zle -N broot_launcher
    bindkey -M viins "^[f" broot_launcher   # Alt f = Launch broot
fi
