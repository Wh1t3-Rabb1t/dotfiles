# Highlighting plugin
source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

zstyle :plugin:fast-syntax-highlighting theme "base16"
typeset -g FAST_THEME_NAME="base16"


# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp cursor)
# # Highlight known abbreviations
# typeset -A ZSH_HIGHLIGHT_REGEXP
# ZSH_HIGHLIGHT_REGEXP+=('^[[:blank:][:space:]]*('${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' 'fg=blue')
