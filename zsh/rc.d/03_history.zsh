# !! History cannot be set in ~/.zshenv because it will
# be overwritten by /etc/.zshrc in favour of macOS defaults
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTORY_IGNORE='(cd *|mv *|rm *|nf *|nd *|dl*)'
HISTSIZE=10000
SAVEHIST=10000
