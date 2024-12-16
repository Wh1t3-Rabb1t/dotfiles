# # Set cursor shape as I-beam before prompt, switch to block before executing commands
# # https://invisible-island.net/ncurses/terminfo.ti.html#toc-_X_T_E_R_M__Features
# # Ss - set cursor shape, usually 6 as argument means I-beam
# # Se - reset cursor shape, which is usually block
# if (( ${+terminfo[Ss]} && ${+terminfo[Se]} )); then
#     _zsh_cursor_shape_reset() {
#         echoti Se
#     }

#     _zsh_cursor_shape_ibeam() {
#         echoti Ss 6
#     }

#     add-zsh-hook preexec _zsh_cursor_shape_reset
#     add-zsh-hook precmd _zsh_cursor_shape_ibeam
# fi

cursor_mode() {
# See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursors
cursor_block='\e[2 q'
cursor_beam='\e[6 q'

function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne $cursor_block
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne $cursor_beam
    fi
}

zle-line-init() {
    echo -ne $cursor_beam
}

# If you have a problem with End and Home key
#    zle-line-init () {
#       # Default zle-line-init
#       if (( $+terminfo[smkx] ))
#       then
#               echoti smkx
#       fi
#       zle editor-info
#
#       # Modify cursor!
#       zle -K viins
#   }

zle -N zle-keymap-select
zle -N zle-line-init
}

cursor_mode
