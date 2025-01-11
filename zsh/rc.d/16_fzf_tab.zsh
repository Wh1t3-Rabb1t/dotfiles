#    __     __   _        _
#   / _|___/ _| | |_ __ _| |__
#  | ||_  / |_  | __/ _` | '_ \
#  |  _/ /|  _| | || (_| | |_) |
#  |_|/___|_|    \__\__,_|_.__/
# ============================================================================ #

# Use fzf for tab completions
source "${ZDOTDIR}/plugins/fzf-tab/fzf-tab.zsh"

local FZF_TAB_KEY_BINDINGS="\
shift-delete:clear-query,\
;:jump,\
ctrl-s:toggle-sort,\
alt-s:toggle,\
alt-A:toggle-all,\
alt-a:select-all"

local FZF_TAB_JUMP_LABELS="\
ftdksleiwoacnvghyxmruqpFTDKSLEIWOACNVGHYXMRUQP+=-~[]{}()!&_|;:<>/?.,#@%1234567890"

local FZF_TAB_COLORS="\
fg:#585b70,\
gutter:#313244,\
current-bg:#313244,\
current-fg:#7f849c,\
hl:reverse:#870005,\
current-hl:#f38ba8:underline,\
prompt:#cdd6f4,\
pointer:#cdd6f4,\
spinner:#cdd6f4,\
marker:#cdd6f4,\
border:#1e66f5,\
header:#eed49f,\
preview-border:#1e66f5"

# Set flags
zstyle ':fzf-tab:*' fzf-flags \
    --header='Switch group with `<` and `>`' \
    --bind=$FZF_TAB_KEY_BINDINGS \
    --jump-labels=$FZF_TAB_JUMP_LABELS \
    --color=$FZF_TAB_COLORS \
    --no-preview \
    --height=100% \
    --prompt=' ' \
    --pointer='▐' \
    --marker='▌' \
    --layout=default

# Confirm selection and relaunch fzf-tab (space char)
zstyle ':fzf-tab:*' continuous-trigger ' '

# Switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
