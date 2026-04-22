#         _ _
#    __ _| (_) __ _ ___  ___  ___
#   / _` | | |/ _` / __|/ _ \/ __|
#  | (_| | | | (_| \__ \  __/\__ \
#   \__,_|_|_|\__,_|___/\___||___/
# ============================================================================ #

alias h="cd ~"
alias b="cd -"
alias ei="caffeine"
alias fein="caffeine"
alias oa="open -a"
alias lg='cat "${XDG_STATE_HOME}/logs/log"'
alias getip="ifconfig | grep inet"
alias bindings="bindkey | grep -v '_noop' | column"

# yt-dlp
alias dlm="_dl_audio_as_opus"
alias dlpl="_dl_playlist_audio_and_concat"
alias dlfullpl="_dl_playlist_audio_individually"
alias dlv="_dl_video_size_optimized"

# Git
(( ${+commands[git]} )) && {
    alias gg="_add_commit_push"
    alias gl="git log --all --graph --decorate --oneline"
}

# Homebrew
(( ${+commands[brew]} )) && {
    alias bo="brew outdated"
    alias bu="brew upgrade"
}

# Eza / gnu ls
if (( ${+commands[eza]} )); then
    # Short list (using --long flag for git status in output)
    alias ls="eza \
        --long \
        --no-user \
        --no-time \
        --no-filesize \
        --no-permissions \
        --git \
        --git-repos \
        --header \
        --almost-all \
        --group-directories-first \
        --classify=auto \
        --icons=auto \
        --color=auto"

    # Long list
    alias ll="eza \
        --long \
        --no-user \
        --group \
        --git \
        --git-repos \
        --header \
        --almost-all \
        --group-directories-first \
        --classify=auto \
        --icons=auto \
        --color=auto"

    # Tree view (default: 2 levels deep, pass `-L` to override depth)
    alias lt="eza \
        --tree \
        --level=2 \
        --almost-all \
        --group-directories-first \
        --classify=auto \
        --icons=auto \
        --color=auto"
elif (( ${+commands[gls]} )); then
    # Short list
    alias ls="gls \
        -1 \
        --almost-all \
        --human-readable \
        --group-directories-first \
        --classify \
        --color"

    # Long list
    alias ll="gls \
        -l \
        --time-style=locale \
        --almost-all \
        --human-readable \
        --group-directories-first \
        --classify \
        --color"
fi

# zscripts
[[ -v ZSCRIPTDIR ]] && {
    alias nf="_create_files"
    alias nd="_create_dirs"
    alias md="_glow_markdown"
    alias vs="_find_vim_sessions"
    alias cl="_clear_screen_soft_bottom"
    alias po="_check_for_plugin_updates"
    alias pu="_update_plugins"
}

# Needs some testing...
#
# # Trailing whitespace is needed here to enable alias expansion
# (( ${+commands[sudo]} )) && alias sudo="noglob enhanced_sudo "
