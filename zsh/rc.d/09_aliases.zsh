# Some handy suffix aliases
# alias -s log=less

alias h="cd ~"
alias b="cd -"
alias ls="echo ''; lsd -A -v"
alias ll="echo ''; lsd -A --long"
alias lt="echo ''; lsd -A --tree --depth"
alias gnug="grep -H -n -i --color=auto"
alias showAll="defaults write com.apple.finder AppleShowAllFiles True; killall Finder"
alias hideAll="defaults write com.apple.finder AppleShowAllFiles False; killall Finder"
alias dlv="yt-dlp -f mp4"
alias dl720p="yt-dlp -S vcodec:h264,fps,res:720,acodec:m4a"
alias dl1080p="yt-dlp -S vcodec:h264,fps,res:1080,acodec:m4a"
alias syntaxTheme="fast-theme -l"
alias getIP="ifconfig | grep inet"

# Functions
alias e="fn_open_with_nvim"
alias f="fn_find_and_open_file"
alias d="fn_find_and_cd_to_dir"
alias up="fn_navigate_up_dir_tree"
alias lg="fn_rg_fzf_and_open_with_nvim"
alias md="fn_preview_markdown"
alias vs="fn_find_vim_sessions"
alias nf="fn_create_files"
alias nd="fn_create_directories"
alias rm="fn_move_to_trash"
alias gg="fn_git_add_commit_push"
alias dlm="fn_dl_audio"
alias dlpl="fn_dl_and_concat_playlist_audio"
alias dlfullpl="fn_dl_playlist_audio"
alias ren="fn_rename_all_files_in_cwd"

# Plugin managers
alias bo="brew outdated"
alias bu="brew upgrade"
alias zpo="_zplugin_check_for_updates"
alias zpu="_zplugin_update"
alias zpa="_zplugin_add_new"
alias zpd="_zplugin_delete"




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
(( ${+commands[ls]} )) && {
    alias ls="ls --group-directories-first --color=auto --hyperlink=auto --classify"
    alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"
}

# History suppression
(( ${+commands[clear]} )) && alias clear=" clear"
alias pwd=" pwd"
alias exit=" exit"

# Safety
(( ${+commands[rm]} )) && alias rm="rm -I --preserve-root=all"

# Suppress suggestions and globbing, enable wrappers
(( ${+commands[find]} )) && alias find="noglob find"
(( ${+commands[touch]} )) && alias touch="nocorrect touch"
(( ${+commands[mkdir]} )) && alias mkdir="nocorrect mkdir"
(( ${+commands[cp]} )) && alias cp="nocorrect cp --verbose"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"
(( ${+commands[man]} )) && alias man="nocorrect wrap-man"
(( ${+commands[sudo]} )) && alias sudo="noglob wrap-sudo " # trailing space is needed to enable alias expansion
