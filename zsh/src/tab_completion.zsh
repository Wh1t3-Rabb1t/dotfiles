# tab____                      _      _   _
#   / ___|___  _ __ ___  _ __ | | ___| |_(_) ___  _ __  ___
#  | |   / _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \/ __|
#  | |__| (_) | | | | | | |_) | |  __/ |_| | (_) | | | \__ \
#   \____\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_|___/
#=======================|_|====================================================#

# See:
    # https://thevaluable.dev/zsh-completion-guide-examples/
    # man zshcompwid
    # man zshcompsys
    # man zshcompctl


# GENERAL
#------------------------------------------------------------------------------#
# Should be called before compinit
zmodload zsh/complist

# Load homebrew completions
if type brew &>/dev/null; then
    # Brew stores completion files in: /opt/homebrew/share/zsh/site-functions
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Load custom completions
fpath=(${ZDOTDIR}/ext_completions $fpath)

# Only check compinit cache once per day. This prevents unnecessary regeneration
# of the completion sytem's config file, thus speeding up load times
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR}/.zcompcache/.zcompdump) ]; then
    compinit -d "${ZDOTDIR}/.zcompcache/.zcompdump"
else
    compinit -C -d "${ZDOTDIR}/.zcompcache/.zcompdump"
fi

# Include hidden files in autocomplete
_comp_options+=(globdots)


# ZSTYLES
#------------------------------------------------------------------------------#
# Use cache for commands
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${ZDOTDIR:-$HOME}/.zcompcache

# Confirm selection and relaunch fzf-tab (space char)
zstyle ':fzf-tab:*' continuous-trigger ' '

# Set flags
zstyle ':fzf-tab:*' fzf-flags --no-preview --color=hl:reverse:#f38ba8

# # Set default FZF preview style for tab complete
# zstyle ':fzf-tab:complete:*' fzf-preview '\
#     ([[ -f ${realpath} ]] && (bat ${realpath} || cat ${realpath})) || \
#     ([[ -d ${realpath} ]] && (lsd -A -v ${realpath} | less)) || \
#     echo ${realpath} 2> /dev/null | head -200\
# '
