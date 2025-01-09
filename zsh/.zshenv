#           _
#   _______| |__   ___ _ ____   __
#  |_  / __| '_ \ / _ \ '_ \ \ / /
#   / /\__ \ | | |  __/ | | \ V /
#  /___|___/_| |_|\___|_| |_|\_/
# ============================================================================ #

# Determine own path if ZDOTDIR isn't set or home symlink exists
if [[ -z "${ZDOTDIR}" || -L "${HOME}/.zshenv" ]]; then
    local homezshenv="${HOME}/.zshenv"
    ZDOTDIR="${homezshenv:A:h}"
fi

# DOTFILES dir is parent to ZDOTDIR
export DOTFILES="${ZDOTDIR:h}"

# Disable global zsh configuration
unsetopt GLOBAL_RCS


# ZMODLOAD
# ---------------------------------------------------------------------------- #
# Enable profiling, if requested via env var
# do `ZSH_ZPROF_ENABLE=1 exec zsh`
if [[ -v ZSH_ZPROF_ENABLE ]]; then
    zmodload zsh/zprof
fi

# Load zsh/files module to provide some builtins for file modifications
zmodload -F zsh/files b:zf_ln b:zf_mkdir b:zf_rm


# XDG
# ---------------------------------------------------------------------------- #
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
# if [[ ! -v XDG_RUNTIME_DIR ]]; then
#     export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}/runtime-${USER}"
# fi


# EXPORTS
# ---------------------------------------------------------------------------- #
export WORKSPACE="${HOME}/workspace"
export ZSCRIPTDIR="${ZDOTDIR}/zscripts"
export GOPATH="${XDG_DATA_HOME}/go"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME}/git/config"

# PATHS
# ---------------------------------------------------------------------------- #
# Add caching functions
fpath=(${ZDOTDIR}/caching ${fpath})

# Ensure we have local paths enabled
path=(/usr/local/bin /usr/local/sbin ${path})

if [[ "${OSTYPE}" = darwin* ]]; then
    # Check whether Homebrew available under new path
    if (( ! ${+commands[brew]} )) && [[ -x /opt/homebrew/bin/brew ]]; then
        path=(/opt/homebrew/bin ${path})
    fi

    if (( ${+commands[brew]} )); then
        autoload -z evalcache
        evalcache brew shellenv

        # Enable gnu version of utilities on macOS, if installed
        for gnuutil in coreutils gnu-sed gnu-tar grep; do
            if [[ -d ${HOMEBREW_PREFIX}/opt/${gnuutil}/libexec/gnubin ]]; then
                path=(${HOMEBREW_PREFIX}/opt/${gnuutil}/libexec/gnubin ${path})
            fi
            if [[ -d ${HOMEBREW_PREFIX}/opt/${gnuutil}/libexec/gnuman ]]; then
                MANPATH="${HOMEBREW_PREFIX}/opt/${gnuutil}/libexec/gnuman:${MANPATH}"
            fi
        done

        # Prefer curl installed via brew
        if [[ -d ${HOMEBREW_PREFIX}/opt/curl/bin ]]; then
            path=(${HOMEBREW_PREFIX}/opt/curl/bin ${path})
        fi
    fi
fi

# Enable local binaries and man pages
path=(${HOME}/.local/bin ${path})
MANPATH="${XDG_DATA_HOME}/man:${MANPATH}"

# Add go binaries to paths
path=(${GOPATH}/bin ${path})


# EDITOR
# ---------------------------------------------------------------------------- #
# Prefer nvim over vim
if (( ${+commands[nvim]} )); then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man!"
else
    export EDITOR="vim"
    export VISUAL="vim"
fi
