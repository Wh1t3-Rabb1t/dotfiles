#             _         _        _                                       _
#   ___ _   _| |__  ___| |_ _ __(_)_ __   __ _   ___  ___  __ _ _ __ ___| |__
#  / __| | | | '_ \/ __| __| '__| | '_ \ / _` | / __|/ _ \/ _` | '__/ __| '_ \
#  \__ \ |_| | |_) \__ \ |_| |  | | | | | (_| | \__ \  __/ (_| | | | (__| | | |
#  |___/\__,_|_.__/|___/\__|_|  |_|_| |_|\__, | |___/\___|\__,_|_|  \___|_| |_|
# =======================================|___/================================ #

source "${ZDOTDIR}/plugins/history-substring-search/zsh-history-substring-search.plugin.zsh"

# Cmd
bindkey -M vicmd 'i' history-substring-search-up       # i
bindkey -M vicmd 'k' history-substring-search-down     # k

# Vis
bindkey -M viins '^[[A' history-substring-search-up    # Up
bindkey -M viins '^[[B' history-substring-search-down  # Down
