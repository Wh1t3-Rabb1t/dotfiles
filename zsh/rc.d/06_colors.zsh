#             _
#    ___ ___ | | ___  _ __ ___
#   / __/ _ \| |/ _ \| '__/ __|
#  | (_| (_) | | (_) | |  \__ \
#   \___\___/|_|\___/|_|  |___/
# ============================================================================ #

if (( ${+commands[vivid]} )); then
    export LS_COLORS="$(vivid generate solarized-dark)"

    # Also nice:
    # export LS_COLORS="$(vivid generate solarized-light)"
    # export LS_COLORS="$(vivid generate tokyonight-moon)"
    # export LS_COLORS="$(vivid generate tokyonight-night)"
    # export LS_COLORS="$(vivid generate tokyonight-storm)"
    # export LS_COLORS="$(vivid generate ayu)"
fi
