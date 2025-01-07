#   _     _     _
#  | |__ (_)___| |_ ___  _ __ _   _
#  | '_ \| / __| __/ _ \| '__| | | |
#  | | | | \__ \ || (_) | |  | |_| |
#  |_| |_|_|___/\__\___/|_|   \__, |
# ============================|___/=========================================== #

# !! HISTSIZE cannot be set in ~/.zshenv because it will
# be overwritten by /etc/.zshrc in favour of macOS defaults

# HISTFILE="${XDG_DATA_HOME}/zsh/.zsh_history"
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTORY_IGNORE='(cd *|mv *|rm *|nf *|nd *|dl*)'
HISTSIZE=10000
SAVEHIST=10000

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
