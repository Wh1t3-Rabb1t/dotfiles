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

# NOTE: The bindings are declared in reverse order than is usual (Down initiates
# history search rather than Up). This is so that I can bind the Up key to search
# history via fzf on an empty cli.

# Vis
bindkey -M viins '^[[B' history-substring-search-up
bindkey -M viins '^[[A' history-substring-search-down


# BROOT
# ---------------------------------------------------------------------------- #
if (( ${+commands[broot]} )); then
    source "${DOTFILES}/broot/launcher/bash/br"
fi


builtin source "${WORKSPACE}/sentinel-zsh/init.zsh"

# source "${WORKSPACE}/sentrifuge/init.zsh"


# FZF_UI_BIND "alt-m" "--hidden" "--no-hidden"
# FZF_UI_BIND "alt-n" "--absolute-path" "--relative-path"
