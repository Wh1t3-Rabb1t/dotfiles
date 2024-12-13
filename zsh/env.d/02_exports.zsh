#                              _
#    _____  ___ __   ___  _ __| |_ ___
#   / _ \ \/ / '_ \ / _ \| '__| __/ __|
#  |  __/>  <| |_) | (_) | |  | |_\__ \
#   \___/_/\_\ .__/ \___/|_|   \__|___/
#============|_|===============================================================#

# XDG basedir spec compliance
if [[ ! -v XDG_CONFIG_HOME ]]; then
    export XDG_CONFIG_HOME"=${HOME}/.config"
fi
if [[ ! -v XDG_CACHE_HOME ]]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi
if [[ ! -v XDG_DATA_HOME ]]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi
if [[ ! -v XDG_STATE_HOME ]]; then
    export XDG_STATE_HOME="${HOME}/.local/state"
fi
if [[ ! -v XDG_RUNTIME_DIR ]]; then
    export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}/runtime-${USER}"
fi

export ZDOTDIR="${HOME}/.config/zsh"
export GOPATH="${XDG_DATA_HOME}/go"
export WORKSPACE="${HOME}/workspace"
export MANPAGER="nvim +Man!"

# !! History cannot be set in ~/.zshenv because it will
# be overwritten in /etc/.zshrc in favour of macOS defaults
export HISTFILE="${XDG_DATA_HOME}/zsh/history"
export HISTORY_IGNORE='(cd *|mv *|rm *|nf *|nd *|dl*)'
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export DIRSTACKSIZE=1000



# export HISTFILE="${ZDOTDIR}/.zcompcache/.zsh_history"
# export POWERLEVEL9K_CONFIG_FILE="${ZDOTDIR}/src/.p10k.zsh"


# # FZF Defaults
# FZF_KEY_BINDINGS="\
# page-up:preview-page-up,\
# page-down:preview-page-down,\
# shift-up:half-page-up+refresh-preview,\
# shift-down:half-page-down+refresh-preview,\
# alt-p:toggle-preview,\
# shift-right:change-preview-window(down|right),\
# shift-left:change-preview-window(up|left),\
# shift-delete:clear-query,\
# tab:toggle-sort,\
# ;:jump,\
# alt-s:toggle,\
# alt-A:toggle-all,\
# alt-a:select-all"

# FZF_JUMP_LABELS="\
# ftdksleiwoacnvghyxmruqpFTDKSLEIWOACNVGHYXMRUQP+=-~[]{}()!&_|;:<>/?.,#@%1234567890"

# # Catppuccin colors
# FZF_COLORS="\
# fg:#7f849c,\
# gutter:#585b70,\
# current-bg:#585b70,\
# current-fg:#f38ba8,\
# hl:reverse:#f38ba8,\
# current-hl:reverse:#f38ba8,\
# prompt:#cdd6f4,\
# pointer:#cdd6f4,\
# spinner:#cdd6f4,\
# marker:#f9e2af,\
# border:#1e66f5,\
# preview-border:#1e66f5"

# FZF_PREVIEW="\
# ([[ -f {} ]] && (bat {} || cat {})) || \
# ([[ -d {} ]] && (lsd -A -v {} | less)) || \
# echo {} 2> /dev/null | head -200"

# export FZF_DEFAULT_COMMAND="\
# rg --files \
# --no-ignore \
# --no-line-number \
# --hidden \
# --follow \
# --glob '!Library' \
# --glob '!.git'"

# export FZF_DEFAULT_OPTS="\
# --bind='$FZF_KEY_BINDINGS' \
# --jump-labels='$FZF_JUMP_LABELS' \
# --color='$FZF_COLORS' \
# --preview='$FZF_PREVIEW' \
# --preview-window 'right,border-left,<55(down:50%,border-top)' \
# --height=100% \
# --layout=reverse \
# --prompt=' : ' \
# --pointer='▶' \
# --marker='+'"




# z jump chache location
#------------------------------------------------------------------------------#
# export _Z_DATA="${ZDOTDIR}/.zcompcache/.zjump_cache"

# export ZPLUGINDIR="${HOME}/.zsh-plugins"  # Set zsh plugin directory
# export ZFUNCDIR="${ZDOTDIR}/functions"    # User defined zsh functions

# export PATH="/opt/homebrew/opt/curl/bin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"
# export PATH="/opt/homebrew/sbin:$PATH"
