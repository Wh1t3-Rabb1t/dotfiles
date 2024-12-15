source "${ZDOTDIR}/plugins/history-substring-search/zsh-history-substring-search.plugin.zsh"

# Cmd
bindkey -M vicmd 'i' history-substring-search-up       # i
bindkey -M vicmd 'k' history-substring-search-down     # k

# Vis
bindkey -M viins '^[[A' history-substring-search-up    # Up
bindkey -M viins '^[[B' history-substring-search-down  # Down
