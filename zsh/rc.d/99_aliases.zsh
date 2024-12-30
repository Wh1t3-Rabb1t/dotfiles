#         _ _
#    __ _| (_) __ _ ___  ___  ___
#   / _` | | |/ _` / __|/ _ \/ __|
#  | (_| | | | (_| \__ \  __/\__ \
#   \__,_|_|_|\__,_|___/\___||___/
# ============================================================================ #

# Some handy suffix aliases
# alias -s log=less

alias h="cd ~"
alias b="cd -"

(( ${+commands[lsd]} )) && {
    alias ls="echo ''; lsd -A -v"
    alias ll="echo ''; lsd -A --long"
    alias lt="echo ''; lsd -A --tree --depth"
}

alias gnug="grep -H -n -i --color=auto"
alias dlv="yt-dlp -f mp4"
alias dl720p="yt-dlp -S vcodec:h264,fps,res:720,acodec:m4a"
alias dl1080p="yt-dlp -S vcodec:h264,fps,res:1080,acodec:m4a"
alias getIP="ifconfig | grep inet"
# alias syntaxTheme="fast-theme -l"
# alias showAll="defaults write com.apple.finder AppleShowAllFiles True; killall Finder"
# alias hideAll="defaults write com.apple.finder AppleShowAllFiles False; killall Finder"


# Functions
alias e="launch_nvim"
alias f="find_and_open"
alias d="find_and_goto"
alias up="navigate_up_dir_tree"
alias lg="rg_fzf_into_nvim"
alias md="glow_markdown"
alias vs="find_vim_sessions"
alias nf="create_files"
alias nd="create_dirs"
alias rm="move_to_trash"

# Git
alias gg="add_commit_push"

# yt-dlp
alias dlm="audio_in_opus"
alias dlpl="playlist_audio_and_concat"
alias dlfullpl="playlist_audio_individually"


# Plugin managers
alias bo="brew outdated"
alias bu="brew upgrade"
# alias zpo="_zplugin_check_for_updates"
# alias zpu="_zplugin_update"
# alias zpa="_zplugin_add_new"
# alias zpd="_zplugin_delete"




# Override regular 'clear' with custom one, that puts prompt at bottom
alias clear=clear-screen-soft-bottom

# Prefer nvim when installed
(( ${+commands[nvim]} )) && {
    alias nv="nvim"
    alias vi="nvim"
    alias vim="nvim"
}

# Human file sizes
(( ${+commands[df]} )) && alias df="df --human-readable --print-type"
(( ${+commands[du]} )) && alias du="du --human-readable --total"

# Handy stuff and a bit of XDG compliance
(( ${+commands[grep]} )) && alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
(( ${+commands[tmux]} )) && {
    alias stmux="tmux new-session 'sudo --login'"
}
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
# (( ${+commands[ls]} )) && {
#     alias ls="ls --color=auto --hyperlink=auto --classify"
#     alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"
# }

# History suppression
# (( ${+commands[clear]} )) && alias clear=" clear"
# alias pwd=" pwd"
# alias exit=" exit"

# Safety
# (( ${+commands[rm]} )) && alias rm="rm -I --preserve-root=all"

# Suppress suggestions and globbing, enable wrappers
# (( ${+commands[find]} )) && alias find="noglob find"
(( ${+commands[touch]} )) && alias touch="nocorrect touch"
(( ${+commands[mkdir]} )) && alias mkdir="nocorrect mkdir"
(( ${+commands[cp]} )) && alias cp="nocorrect cp --verbose"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"
(( ${+commands[man]} )) && alias man="nocorrect wrap-man"
(( ${+commands[sudo]} )) && alias sudo="noglob wrap-sudo " # trailing space is needed to enable alias expansion
