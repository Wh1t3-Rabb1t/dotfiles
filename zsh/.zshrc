#!/usr/bin/env zsh

#                          /\\\
#                          \/\\\
#  /\\\\\\\\\\\ /\\\\\\\\\\ \/\\\
#  \///////\\\/ \/\\\//////  \/\\\\\\\\\\\
#        /\\\/   \/\\\\\\\\\\ \/\\\/////\\\
#       /\\\/     \////////\\\ \/\\\   \/\\\
#      /\\\\\\\\\\\ /\\\\\\\\\\ \/\\\   \/\\\
#    . \/////////// \//////////  \///    \/// rc
# ============================================================================ #


# https://thevaluable.dev/zsh-install-configure-mouseless/
# https://htr3n.github.io/2018/07/faster-zsh/
# https://frederic-hemberger.de/notes/speeding-up-initial-zsh-startup-with-lazy-loading/
# https://grml.org/zsh/zsh-lovers.html
# ANSI escape codes:  https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797


# ZSCRIPTS
# ---------------------------------------------------------------------------- #
local zscripts
for zscripts in $ZSCRIPTDIR $ZSCRIPTDIR/*(N/); do
    fpath=($zscripts $fpath)
    autoload -Uz $fpath[1]/*(.:t)
done
unset zscripts


# RC
# ---------------------------------------------------------------------------- #
typeset -a zsh_rc=(
    "${ZDOTDIR}/modules/p10k/instant_prompt.zsh"
    "${ZDOTDIR}/modules/core/opts.zsh"
    "${ZDOTDIR}/modules/core/history.zsh"
    "${ZDOTDIR}/modules/core/autoload.zsh"
    "${ZDOTDIR}/modules/p10k/config.zsh"
    "${ZDOTDIR}/modules/core/colors.zsh"
    "${ZDOTDIR}/modules/core/completion.zsh"
    "${ZDOTDIR}/modules/vi/init.zsh"
    "${ZDOTDIR}/modules/vi/bindings.zsh"
    "${ZDOTDIR}/modules/plugins/init.zsh"
    "${ZDOTDIR}/modules/fzf/config.zsh"
    "${ZDOTDIR}/modules/fzf/fzf_tab.zsh"
    "${ZDOTDIR}/modules/core/bindings.zsh"
    "${ZDOTDIR}/modules/core/aliases.zsh"
    "${ZDOTDIR}/modules/calendar/init.zsh"
)

local conffile
for conf_file in "${zsh_rc[@]}"; do
    source "$conf_file"
done
unset conffile
