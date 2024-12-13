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




    # Use cache for commands
    # zstyle ':completion:*' use-cache on
    # zstyle ':completion:*' cache-path ${ZDOTDIR:-$HOME}/.zcompcache



# Completion tweaks
zstyle ':completion:*'              list-colors         "${(s.:.)LS_COLORS}"
zstyle ':completion:*'              list-dirs-first     true
zstyle ':completion:*'              verbose             true
zstyle ':completion:*'              menu                no
zstyle ':completion:*'              matcher-list        'm:{[:lower:]}={[:upper:]}'
zstyle ':completion::complete:*'    use-cache           true
zstyle ':completion::complete:*'    cache-path          "${XDG_CACHE_HOME}/zsh/compcache"
zstyle ':completion:*:descriptions' format              [%d]
zstyle ':completion:*:manuals'      separate-sections   true

# Enable cached completions, if present
if [[ -d "${XDG_CACHE_HOME}/zsh/fpath" ]]; then
    fpath=("${XDG_CACHE_HOME}/zsh/fpath" ${fpath})
fi

# Additional completions
# fpath=("${ZDOTDIR}/plugins/completions/src" ${fpath})
fpath=("${ZDOTDIR}/plugins/git-completion/src" ${fpath})

# Enable git-extras completions
source "${DOTFILES}/tools/git-extras/etc/git-extras-completion.zsh"

# Make sure complist is loaded (should be called before compinit)
zmodload zsh/complist

# Init completions, but regenerate compdump only once a day.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+20' matches files (or directories or whatever) that are older than 20 hours.
autoload -Uz compinit
if [[ -n "${XDG_CACHE_HOME}/zsh/compdump"(#qN.mh+20) ]]; then
    compinit -i -u -d "${XDG_CACHE_HOME}/zsh/compdump"
    # zrecompile fresh compdump in background
    {
        autoload -Uz zrecompile
        zrecompile -pq "${XDG_CACHE_HOME}/zsh/compdump"
    } &!
else
    compinit -i -u -C -d "${XDG_CACHE_HOME}/zsh/compdump"
fi

# Include hidden files in autocomplete
_comp_options+=(globdots)

# Enable bash completions too
autoload -Uz bashcompinit
bashcompinit





# # GENERAL
# #------------------------------------------------------------------------------#
# # Should be called before compinit
# zmodload zsh/complist

# # Load homebrew completions
# if type brew &>/dev/null; then
#     # Brew stores completion files in: /opt/homebrew/share/zsh/site-functions
#     FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
# fi

# # Load custom completions
# fpath=(${ZDOTDIR}/ext_completions $fpath)

# # Only check compinit cache once per day. This prevents unnecessary regeneration
# # of the completion sytem's config file, thus speeding up load times
# autoload -Uz compinit
# if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR}/.zcompcache/.zcompdump) ]; then
#     compinit -d "${ZDOTDIR}/.zcompcache/.zcompdump"
# else
#     compinit -C -d "${ZDOTDIR}/.zcompcache/.zcompdump"
# fi

# # Include hidden files in autocomplete
# _comp_options+=(globdots)


# # ZSTYLES
# #------------------------------------------------------------------------------#
# # Use cache for commands
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path ${ZDOTDIR:-$HOME}/.zcompcache

# # Confirm selection and relaunch fzf-tab (space char)
# zstyle ':fzf-tab:*' continuous-trigger ' '

# # Set flags
# zstyle ':fzf-tab:*' fzf-flags --no-preview --color=hl:reverse:#f38ba8

# # # Set default FZF preview style for tab complete
# # zstyle ':fzf-tab:complete:*' fzf-preview '\
# #     ([[ -f ${realpath} ]] && (bat ${realpath} || cat ${realpath})) || \
# #     ([[ -d ${realpath} ]] && (lsd -A -v ${realpath} | less)) || \
# #     echo ${realpath} 2> /dev/null | head -200\
# # '




