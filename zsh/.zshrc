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
# https://github.com/carpet-stain/dotfiles/tree/master/zsh
# https://htr3n.github.io/2018/07/faster-zsh/
# https://frederic-hemberger.de/notes/speeding-up-initial-zsh-startup-with-lazy-loading/
# https://grml.org/zsh/zsh-lovers.html
# ANSI escape codes:  https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797


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
