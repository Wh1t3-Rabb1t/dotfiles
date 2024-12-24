#    __     __   _        _
#   / _|___/ _| | |_ __ _| |__
#  | ||_  / |_  | __/ _` | '_ \
#  |  _/ /|  _| | || (_| | |_) |
#  |_|/___|_|    \__\__,_|_.__/
# ============================================================================ #

# Use fzf for tab completions
source "${ZDOTDIR}/plugins/fzf-tab/fzf-tab.zsh"

# Confirm selection and relaunch fzf-tab (space char)
zstyle ':fzf-tab:*' continuous-trigger ' '

# Set flags
zstyle ':fzf-tab:*' fzf-flags --no-preview --color=hl:reverse:#f38ba8
