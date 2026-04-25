#             _
#    ___ ___ | | ___  _ __ ___
#   / __/ _ \| |/ _ \| '__/ __|
#  | (_| (_) | | (_) | |  \__ \
#   \___\___/|_|\___/|_|  |___/
# ============================================================================ #

# Also nice:
#   solarized-light
#   tokyonight-moon
#   tokyonight-night
#   tokyonight-storm
#   ayu

if (( ${+commands[vivid]} )); then
    export LS_COLORS="$(vivid generate solarized-dark)"
fi

