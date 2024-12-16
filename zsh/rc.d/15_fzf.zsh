#    __     __
#   / _|___/ _|
#  | ||_  / |_
#  |  _/ /|  _|
#  |_|/___|_|
#==============================================================================#

FZF_KEY_BINDINGS="\
page-up:preview-page-up,\
page-down:preview-page-down,\
shift-up:half-page-up+refresh-preview,\
shift-down:half-page-down+refresh-preview,\
alt-p:toggle-preview,\
shift-right:change-preview-window(down|right),\
shift-left:change-preview-window(up|left),\
shift-delete:clear-query,\
tab:toggle-sort,\
;:jump,\
alt-s:toggle,\
alt-A:toggle-all,\
alt-a:select-all"

FZF_JUMP_LABELS="\
ftdksleiwoacnvghyxmruqpFTDKSLEIWOACNVGHYXMRUQP+=-~[]{}()!&_|;:<>/?.,#@%1234567890"

# Catppuccin colors
FZF_COLORS="\
fg:#7f849c,\
gutter:#585b70,\
current-bg:#585b70,\
current-fg:#f38ba8,\
hl:reverse:#f38ba8,\
current-hl:reverse:#f38ba8,\
prompt:#cdd6f4,\
pointer:#cdd6f4,\
spinner:#cdd6f4,\
marker:#f9e2af,\
border:#1e66f5,\
preview-border:#1e66f5"

FZF_PREVIEW="\
([[ -f {} ]] && (bat {} || cat {})) || \
([[ -d {} ]] && (lsd -A -v {} || ls -a {} | less)) || \
echo {} 2> /dev/null | head -200"

export FZF_DEFAULT_OPTS="\
--bind='$FZF_KEY_BINDINGS' \
--jump-labels='$FZF_JUMP_LABELS' \
--color='$FZF_COLORS' \
--preview='$FZF_PREVIEW' \
--preview-window='right,border-left,<55(down:50%,border-top)' \
--height=100% \
--layout=reverse \
--prompt=' : ' \
--pointer='▶' \
--marker='+'"

RG_COMMAND="\
rg --files \
--no-ignore \
--no-line-number \
--hidden \
--follow \
--glob '!Library/*' \
--glob '!.git/*'"

FD_COMMAND="\
fd --type file \
--follow \
--hidden \
--exclude .git \
--exclude Library \
--color=always"

# Try to use rg or fd, if available as default fzf command
if (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND=$RG_COMMAND
elif (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND=$FD_COMMAND
fi

# source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
