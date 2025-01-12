#           _             _             _
#   _______| |__    _ __ | |_   _  __ _(_)_ __  ___
#  |_  / __| '_ \  | '_ \| | | | |/ _` | | '_ \/ __|
#   / /\__ \ | | | | |_) | | |_| | (_| | | | | \__ \
#  /___|___/_| |_| | .__/|_|\__,_|\__, |_|_| |_|___/
# =================|_|============|___/======================================= #

# ZSH-Z
# ---------------------------------------------------------------------------- #
# XDG compliance
ZSHZ_DATA="${XDG_CACHE_HOME}/zsh/z"

# Match to uncommon prefix
ZSHZ_UNCOMMON=1

# Ignore case when lowercase, match case with uppercase
ZSHZ_CASE=smart

source "${ZPLUGINDIR}/zsh-z/zsh-z.plugin.zsh"


# AUTOSUGGESTIONS
# ---------------------------------------------------------------------------- #
source "${ZPLUGINDIR}/autosuggestions/zsh-autosuggestions.zsh"


# AUTOPAIR
# ---------------------------------------------------------------------------- #
source "${ZPLUGINDIR}/autopair/autopair.zsh"


# FAST SYNTAX HIGHLIGHTING
# ---------------------------------------------------------------------------- #
source "${ZPLUGINDIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"


# HISTORY SUBSTRING SEARCH
# ---------------------------------------------------------------------------- #
source "${ZPLUGINDIR}/history-substring-search/zsh-history-substring-search.plugin.zsh"

# Cmd
bindkey -M vicmd 'i' history-substring-search-up       # i
bindkey -M vicmd 'k' history-substring-search-down     # k

# Vis
bindkey -M viins '^[[A' history-substring-search-up    # Up
bindkey -M viins '^[[B' history-substring-search-down  # Down


# BROOT
# ---------------------------------------------------------------------------- #
if (( ${+commands[broot]} )); then
    source "${XDG_CONFIG_HOME}/broot/launcher/bash/br"
fi