#                          /\\\
#                          \/\\\
#  /\\\\\\\\\\\ /\\\\\\\\\\ \/\\\
#  \///////\\\/ \/\\\//////  \/\\\\\\\\\\\
#        /\\\/   \/\\\\\\\\\\ \/\\\/////\\\
#       /\\\/     \////////\\\ \/\\\   \/\\\
#      /\\\\\\\\\\\ /\\\\\\\\\\ \/\\\   \/\\\
#    . \/////////// \//////////  \///    \/// rc
#==============================================================================#

# See:
    # https://thevaluable.dev/zsh-install-configure-mouseless/
    # https://github.com/carpet-stain/dotfiles/tree/master/zsh
    # https://htr3n.github.io/2018/07/faster-zsh/
    # https://frederic-hemberger.de/notes/speeding-up-initial-zsh-startup-with-lazy-loading/
    # https://grml.org/zsh/zsh-lovers.html
    # ANSI escape codes:  https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797


#
#
#
#
# !! REQUIRED TO LAUNCH KITTY WITHIN A VM
#
#
# DON'T USE IN REAL DEPLOY SCRIPT
#
#
#
#
export MESA_GL_VERSION_OVERRIDE=4.5 export MESA_GLSL_VERSION_OVERRIDE=450



# Configuration
for conffile in "${ZDOTDIR}"/rc.d/*; do
    source "${conffile}"
done
unset conffile


# User scripts
for zscripts in $ZSCRIPTDIR $ZSCRIPTDIR/*(N/); do
    fpath=($zscripts $fpath)
    autoload -Uz $fpath[1]/*(.:t)
done
unset zscripts



# # OPTIONS
# #------------------------------------------------------------------------------#
# unsetopt BEEP                # Don't beep on errors
# setopt HIST_IGNORE_ALL_DUPS  # Don't add duplicate commands
# setopt HIST_SAVE_NO_DUPS     # Don't add duplicate consecutive commands
# setopt HIST_IGNORE_SPACE     # Don't add commands with leading whitespace
# setopt HIST_NO_FUNCTIONS     # Don't add function calls
# setopt HIST_REDUCE_BLANKS    # Don't add commands that differ only by whitespace
# setopt INC_APPEND_HISTORY    # Append commands to history upon execution
# setopt SHARE_HISTORY         # Share history between all sessions
# setopt AUTO_PUSHD            # Push the current directory visited on the stack
# setopt PUSHD_IGNORE_DUPS     # Do not store duplicates in the stack
# setopt PUSHD_SILENT          # Don't print the directory stack after pushd or popd
# setopt BSD_ECHO              # Require `-e` to interpret escape sequences in echo strings
# setopt PRINT_EXIT_VALUE      # Print exit code if command fails


# # p10k / SOURCE PLUGINS
# #------------------------------------------------------------------------------#
# # Ensure zsh plugin directory exists
# if [[ ! -d "$ZPLUGINDIR" ]]; then
#     echo -e "\nCreating ZPLUGINDIR: $ZPLUGINDIR"
#     mkdir -p "$ZPLUGINDIR"
#     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZPLUGINDIR}/powerlevel10k"
#     git clone https://github.com/romkatv/zsh-defer.git "${ZPLUGINDIR}/zsh-defer"
# fi

# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# # To customize prompt, run `p10k configure` or edit ~/.config/zsh/custom/.p10k.zsh.
# source "${ZPLUGINDIR}/powerlevel10k/powerlevel10k.zsh-theme"
# [[ ! -f ~/.config/zsh/src/.p10k.zsh ]] || source ~/.config/zsh/src/.p10k.zsh

# # !! Tab completion must be loaded before zplugins (specifically fzf-tab)
# source "${ZDOTDIR}/src/auto_cmds.zsh"
# source "${ZDOTDIR}/src/vi_bindings.zsh"
# source "${ZDOTDIR}/src/tab_completion.zsh"

# source "${ZDOTDIR}/src/zplugins.zsh"


# Aloxaf/fzf-tab
# zsh-users/zsh-history-substring-search
# zdharma-continuum/fast-syntax-highlighting
# zsh-users/zsh-autosuggestions
# rupa/z

# !! add a command check to ensure broot is available
# source "${HOME}/.config/broot/launcher/bash/br"


# # AUTOLOAD FUNCTIONS
# #------------------------------------------------------------------------------#
# for funcdir in $ZFUNCDIR $ZFUNCDIR/*(N/); do
#     fpath=($funcdir $fpath)
#     autoload -Uz $fpath[1]/*(.:t)
# done
# unset funcdir


# ALIASES
#------------------------------------------------------------------------------#
# alias h="cd ~"
# alias b="cd -"
# alias ls="echo ''; lsd -A -v"
# alias ll="echo ''; lsd -A --long"
# alias lt="echo ''; lsd -A --tree --depth"
# alias gnug="grep -H -n -i --color=auto"
# alias showAll="defaults write com.apple.finder AppleShowAllFiles True; killall Finder"
# alias hideAll="defaults write com.apple.finder AppleShowAllFiles False; killall Finder"
# alias dlv="yt-dlp -f mp4"
# alias dl720p="yt-dlp -S vcodec:h264,fps,res:720,acodec:m4a"
# alias dl1080p="yt-dlp -S vcodec:h264,fps,res:1080,acodec:m4a"
# alias syntaxTheme="fast-theme -l"
# alias getIP="ifconfig | grep inet"

# # Functions
# alias e="fn_open_with_nvim"
# alias f="fn_find_and_open_file"
# alias d="fn_find_and_cd_to_dir"
# alias up="fn_navigate_up_dir_tree"
# alias lg="fn_rg_fzf_and_open_with_nvim"
# alias md="fn_preview_markdown"
# alias vs="fn_find_vim_sessions"
# alias nf="fn_create_files"
# alias nd="fn_create_directories"
# alias rm="fn_move_to_trash"
# alias gg="fn_git_add_commit_push"
# alias dlm="fn_dl_audio"
# alias dlpl="fn_dl_and_concat_playlist_audio"
# alias dlfullpl="fn_dl_playlist_audio"
# alias ren="fn_rename_all_files_in_cwd"

# # Plugin managers
# alias bo="brew outdated"
# alias bu="brew upgrade"
# alias zpo="_zplugin_check_for_updates"
# alias zpu="_zplugin_update"
# alias zpa="_zplugin_add_new"
# alias zpd="_zplugin_delete"


# Brewfile
#------------------
# kitty
# p10k
# fzf
# nvim
# broot
# ripgrep
# fd
# lsd
# bat
# jq
# gitui
# delta
# tealdeer
# btop
# shell check
# luarocks
# yt-dlp
# ffmpeg
# glow
# mpv
