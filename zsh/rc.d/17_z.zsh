#           _
#   _______| |__       ____
#  |_  / __| '_ \ ____|_  /
#   / /\__ \ | | |_____/ /
#  /___|___/_| |_|    /___|
# ============================================================================ #

# XDG compliance
ZSHZ_DATA="${XDG_CACHE_HOME}/zsh/z"

# match to uncommon prefix
ZSHZ_UNCOMMON=1

# ignore case when lowercase, match case with uppercase
ZSHZ_CASE=smart

source "${ZDOTDIR}/plugins/zsh-z/zsh-z.plugin.zsh"
