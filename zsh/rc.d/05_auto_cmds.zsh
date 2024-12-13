#               _                             _
#    __ _ _   _| |_ ___     ___ _ __ ___   __| |___
#   / _` | | | | __/ _ \   / __| '_ ` _ \ / _` / __|
#  | (_| | |_| | || (_) | | (__| | | | | | (_| \__ \
#   \__,_|\__,_|\__\___/   \___|_| |_| |_|\__,_|___/
#==============================================================================#

# Temporarily disable instant history writes to check exit codes
zshaddhistory() {
    emulate -L zsh
    _HISTLINE=${1%%$'\n'}
    return 1
}

# Only add the previous command to history if it returned 0
precmd() {
    local -i rc=$?
    emulate -L zsh
    if (( $rc == 0 && $+_HISTLINE && $#_HISTLINE )); then
        print -rs -- $_HISTLINE
        unset _HISTLINE
    fi
}
