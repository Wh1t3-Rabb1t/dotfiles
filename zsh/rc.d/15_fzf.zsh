#    __     __
#   / _|___/ _|
#  | ||_  / |_
#  |  _/ /|  _|
#  |_|/___|_|
# ============================================================================ #

# https://vitormv.github.io/fzf-themes/

FZF_KEY_BINDINGS="\
page-up:preview-page-up,\
page-down:preview-page-down,\
shift-up:half-page-up+refresh-preview,\
shift-down:half-page-down+refresh-preview,\
shift-right:change-preview-window(down|right),\
shift-left:change-preview-window(up|left),\
shift-delete:clear-query,\
;:jump,\
tab:toggle-sort,\
alt-p:toggle-preview,\
alt-s:toggle,\
alt-A:toggle-all,\
alt-a:select-all"

FZF_JUMP_LABELS="\
ftdksleiwoacnvghyxmruqpFTDKSLEIWOACNVGHYXMRUQP+=-~[]{}()!&_|;:<>/?.,#@%1234567890"

FZF_COLORS="\
fg:#585b70,\
gutter:#313244,\
current-bg:#313244,\
current-fg:#7f849c,\
hl:reverse:#870005,\
current-hl:#f38ba8,\
prompt:#cdd6f4,\
pointer:#cdd6f4,\
spinner:#cdd6f4,\
marker:#cdd6f4,\
border:#1e66f5,\
header:#eed49f,\
preview-border:#1e66f5"

FZF_PREVIEW="\
([[ -f {} ]] && ( \
    bat {} || cat {})) \
|| ([[ -d {} ]] && ( \
    eza \
        --long \
        --group \
        --git \
        --git-repos \
        --header \
        --no-user \
        --almost-all \
        --group-directories-first \
        --classify=always \
        --icons=always \
        --color=always {} \
    || ls \
        -l \
        --time-style=locale \
        --almost-all \
        --human-readable \
        --group-directories-first \
        --classify \
        --color {} \
    | less)) \
|| echo {} 2> /dev/null \
| head -200"

export FZF_DEFAULT_OPTS="\
--bind='$FZF_KEY_BINDINGS' \
--jump-labels='$FZF_JUMP_LABELS' \
--color='$FZF_COLORS' \
--preview='$FZF_PREVIEW' \
--preview-window='right,border-left,<88(up:50%,border-bottom)' \
--height=100% \
--prompt=' ' \
--pointer='▐' \
--marker='▌' \
--tac \
--ansi"

RG_COMMAND="rg \
--files \
--no-ignore \
--no-line-number \
--hidden \
--follow"

FD_COMMAND="fd \
--type file \
--hidden \
--follow \
--color=always"

# Try to use Rg or Fd, if available as default Fzf command
if (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND=$RG_COMMAND
elif (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND=$FD_COMMAND
fi

# source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
