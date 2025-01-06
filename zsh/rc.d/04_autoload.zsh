#               _        _                 _
#    __ _ _   _| |_ ___ | | ___   __ _  __| |
#   / _` | | | | __/ _ \| |/ _ \ / _` |/ _` |
#  | (_| | |_| | || (_) | | (_) | (_| | (_| |
#   \__,_|\__,_|\__\___/|_|\___/ \__,_|\__,_|
# ============================================================================ #

# Enable bracketed paste
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# Enable url-quote-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Use default provided history search widgets
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Ensure add-zsh-hook is loaded, as it's used in rc files
autoload -Uz add-zsh-hook

# Custom personal functions
# Don't use -U as we need aliases here
autoload -z psg vpaste evalcache compdefcache

# Enable wrapper, if original command is available
(( ${+commands[man]} )) && autoload -z wrap-man
(( ${+commands[sudo]} )) && autoload -z wrap-sudo
