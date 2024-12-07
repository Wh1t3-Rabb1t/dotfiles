#       _             _
#   ___| | ___   __ _(_)_ __
#  |_  / |/ _ \ / _` | | '_ \
#   / /| | (_) | (_| | | | | |
#  /___|_|\___/ \__, |_|_| |_|
#===============|___/==========================================================#

# Compile zcompdump if modified to increase startup speed.
# &! is used to "disown" the process, forcing it to run in the background independent of the shell.
{
    zcompdump="${ZDOTDIR}/.zcompcache/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!
