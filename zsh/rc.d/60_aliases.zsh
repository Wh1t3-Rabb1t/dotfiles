#         _ _
#    __ _| (_) __ _ ___  ___  ___
#   / _` | | |/ _` / __|/ _ \/ __|
#  | (_| | | | (_| \__ \  __/\__ \
#   \__,_|_|_|\__,_|___/\___||___/
# ============================================================================ #

# General
# ---------------------------------------------------------------------------- #
alias h="cd ~"
alias b="cd -"
alias getip="ifconfig | grep inet"


# Git
# ---------------------------------------------------------------------------- #
(( ${+commands[git]} )) && {
    alias gg="_add_commit_push"
    alias gl="git log --all --graph --decorate --oneline"
}


# Lsd
# ---------------------------------------------------------------------------- #
(( ${+commands[lsd]} )) && {
    alias ls="echo ''; lsd -A -v"
    alias ll="echo ''; lsd -A --long"
    alias lt="echo ''; lsd -A --tree --depth"
}


# Homebrew
# ---------------------------------------------------------------------------- #
(( ${+commands[brew]} )) && {
    alias bo="brew outdated"
    alias bu="brew upgrade"
}


# yt-dlp
# ---------------------------------------------------------------------------- #
(( ${+commands[yt-dlp]} )) && {
    alias dlm="_dl_audio_as_opus"
    alias dlpl="_dl_playlist_audio_and_concat"
    alias dlfullpl="_dl_playlist_audio_individually"
    alias dlv="yt-dlp -f mp4"
    alias dl320p="yt-dlp -S vcodec:h264,fps,res:320,acodec:m4a"
    alias dl480p="yt-dlp -S vcodec:h264,fps,res:480,acodec:m4a"
    alias dl720p="yt-dlp -S vcodec:h264,fps,res:720,acodec:m4a"
    alias dl1080p="yt-dlp -S vcodec:h264,fps,res:1080,acodec:m4a"
}


# zscripts
# ---------------------------------------------------------------------------- #
[[ -v ZSCRIPTDIR ]] && {
    alias e="_launch_nvim"
    alias f="_find_and_open_files"
    alias d="_find_and_goto_dir"
    alias up="_navigate_up_dir_tree"
    alias nf="_create_files"
    alias nd="_create_dirs"
    alias rm="_move_to_trash"
    alias md="_glow_markdown"
    alias vs="_find_vim_sessions"
    alias cl="_clear_screen_soft_bottom"
}

# alias g="_rg_fzf_into_nvim"



# # Enable diff with colors
# if (( ${+commands[colordiff]} )); then
#     alias diff="colordiff --new-file --text --recursive -u --algorithm patience"
# fi



# # Human file sizes
# (( ${+commands[df]} )) && alias df="df --human-readable --print-type"
# (( ${+commands[du]} )) && alias du="du --human-readable --total"

# # Handy stuff and a bit of XDG compliance
# (( ${+commands[grep]} )) && alias grep="grep --color=auto --binary-files=without-match --devices=skip"
# (( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
# (( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"

# # Suppress suggestions and globbing, enable wrappers
# (( ${+commands[touch]} )) && alias touch="nocorrect touch"
# (( ${+commands[mkdir]} )) && alias mkdir="nocorrect mkdir"
# (( ${+commands[cp]} )) && alias cp="nocorrect cp --verbose"
# (( ${+commands[ag]} )) && alias ag="noglob ag"
# (( ${+commands[fd]} )) && alias fd="noglob fd"
# (( ${+commands[man]} )) && alias man="nocorrect wrap-man"
# (( ${+commands[sudo]} )) && alias sudo="noglob wrap-sudo " # trailing space is needed to enable alias expansion