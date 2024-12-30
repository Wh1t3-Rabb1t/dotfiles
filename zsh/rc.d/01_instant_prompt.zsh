#   _           _              _                                     _
#  (_)_ __  ___| |_ __ _ _ __ | |_   _ __  _ __ ___  _ __ ___  _ __ | |_
#  | | '_ \/ __| __/ _` | '_ \| __| | '_ \| '__/ _ \| '_ ` _ \| '_ \| __|
#  | | | | \__ \ || (_| | | | | |_  | |_) | | | (_) | | | | | | |_) | |_
#  |_|_| |_|___/\__\__,_|_| |_|\__| | .__/|_|  \___/|_| |_| |_| .__/ \__|
# ==================================|_|=======================|_|============= #

# Clear screen, move cursor to the bottom
# but don't do this under ssh or sudo sessions, as prompt already at the bottom
if ! [[ -v SSH_TTY || -v SUDO_USER ]]; then
    autoload -Uz .clear_screen_soft_bottom
    .clear_screen_soft_bottom
fi

# powerlevel10k instant prompt stanza
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
