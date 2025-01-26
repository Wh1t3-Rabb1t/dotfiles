#   ,
#  / \               _
#  \  \          ___(_)
#   \  \        /  /__
#    \  \      /  /|  |
#     \  \    /  / |  |
#      \  \  /  /  |  |
#       \  \/  /   |  |
#        \    /    |  |
#         \  /     |__| bindings
# ======== \/ ================================================================ #


# INDEX
# ---------------------------------------------------------------------------- #
# MODE TOGGLING
# LINE NAVIGATION
# DELETE BINDINGS
# DELETE MOTIONS
# UNDO / REDO / DOT OPERATOR / REPLACE
# SELECT IN WORD / LINE
# UPPER / LOWER / SWAP CASE
# COPY
# CUT
# CHANGE
# PASTE
# INCREMENT / DECREMENT INTEGERS
# MATCH BRACKETS
# CHANGE / DELETE SURROUNDING
# SELECT INSIDE SURROUNDING
# ADD SURROUNDING


# MODE TOGGLING
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '^['       vi-insert                    # Esc
bindkey -M vicmd 'a'        vi-add-next                  # a
bindkey -M vicmd 'A'        vi-add-eol                   # A
bindkey -M vicmd 's'        visual-mode                  # s
bindkey -M vicmd 'S'        visual-line-mode             # S
bindkey -M vicmd 'G'        _reactivate_region           # G

# Vis
bindkey -M visual '^['      _deactivate_region           # Esc

# Ins
bindkey -M viins '^['       vi-cmd-mode                  # Esc


# LINE NAVIGATION
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'i'        _up_line                     # i
bindkey -M vicmd 'k'        _down_line                   # k
bindkey -M vicmd 'l'        vi-forward-char              # l
bindkey -M vicmd 't'        vi-backward-char             # t
bindkey -M vicmd ','        _line_start                  # ,
bindkey -M vicmd '.'        _line_end                    # .
bindkey -M vicmd 'o'        vi-forward-word              # o
bindkey -M vicmd 'u'        vi-backward-word             # u
bindkey -M vicmd 'O'        vi-forward-word-end          # O
bindkey -M vicmd 'U'        vi-backward-word-end         # U
bindkey -M vicmd 'f'        vi-find-next-char            # f
bindkey -M vicmd ';'        vi-repeat-find               # ;
bindkey -M vicmd 'h'        vi-rev-repeat-find           # h

# Vis
bindkey -M visual 'o'       vi-forward-word              # o
bindkey -M visual 'u'       vi-backward-word             # u
bindkey -M visual 'O'       vi-forward-word-end          # O
bindkey -M visual 'U'       vi-backward-word-end         # U
bindkey -M visual 'a'       exchange-point-and-mark      # a

# Ins
bindkey -M viins '^[[H'     beginning-of-line            # Home
bindkey -M viins '^[[F'     end-of-line                  # End
bindkey -M viins '^[[1;3D'  vi-backward-word             # Alt Left
bindkey -M viins '^[[1;3C'  _jump_forward_word           # Alt Right


# DELETE BINDINGS
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '^?'       backward-delete-char         # BS
bindkey -M vicmd '^[[3~'    delete-char                  # Del
bindkey -M vicmd '^[^?'     backward-kill-word           # Alt BS
bindkey -M vicmd '^[[3;3~'  kill-word                    # Alt Del
bindkey -M vicmd '^H'       backward-kill-line           # Ctrl BS
bindkey -M vicmd '^[[3;5~'  kill-line                    # Ctrl Del
bindkey -M vicmd '^[[3;2~'  kill-whole-line              # Shift Del

# Vis
bindkey -M visual '^?'      kill-region                  # BS
bindkey -M visual '^[[3~'   kill-region                  # Del

# Ins
bindkey -M viins '^?'       backward-delete-char         # BS
bindkey -M viins '^[[3~'    delete-char                  # Del
bindkey -M viins '^[^?'     backward-kill-word           # Alt BS
bindkey -M viins '^[[3;3~'  kill-word                    # Alt Del
bindkey -M viins '^H'       backward-kill-line           # Ctrl BS
bindkey -M viins '^[[3;5~'  kill-line                    # Ctrl Del
bindkey -M viins '^[[3;2~'  kill-whole-line              # Shift Del


# DELETE MOTIONS
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'w'        _delete_motions              # w...
                                                         # wt = In word
                                                         # wu = Word left
                                                         # wo = Word right
                                                         # wl = Whole line
                                                         # w, = To line start
                                                         # w. = To line end
                                                         # w; = Next input char
                                                         # wh = Prev input char

# Vis
bindkey -M visual 'w'       kill-region                  # w


# UNDO / REDO / DOT OPERATOR / REPLACE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'r'        _replace_chars               # r
bindkey -M vicmd 'R'        vi-replace                   # R
bindkey -M vicmd '\-'       vi-repeat-change             # Hyphen
bindkey -M vicmd '^[y'      undo                         # Alt y
bindkey -M vicmd '^[Y'      redo                         # Alt Y

# Ins
bindkey -M viins '^[y'      undo                         # Alt y
bindkey -M viins '^[Y'      redo                         # Alt Y


# SELECT IN WORD / LINE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '^[[1;3C'  _select_in_word              # Alt Right

# Vis
bindkey -M visual '^[[1;3C' visual-line-mode             # Alt Right


# UPPER / LOWER / SWAP CASE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '_'        vi-swap-case                 # _

# Vis
bindkey -M visual '_'       vi-up-case                   # -
bindkey -M visual '\-'      vi-down-case                 # _


# COPY
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'c'        _copy_motions                # c...
                                                         # ct = In word
                                                         # cu = Word left
                                                         # co = Word right
                                                         # cl = Whole line
                                                         # c, = To line start
                                                         # c. = To line end
                                                         # c; = Next input char
                                                         # ch = Prev input char

# Vis
bindkey -M visual 'c'       _copy_to_clipboard           # c


# CUT
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'x'        _cut_motions                 # x...
                                                         # xt = In word
                                                         # xu = Word left
                                                         # xo = Word right
                                                         # xl = Whole line
                                                         # x, = To line start
                                                         # x. = To line end
                                                         # x; = Next input char
                                                         # xh = Prev input char

# Vis
bindkey -M visual 'x'       _cut_to_clipboard            # x


# CHANGE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'y'        _change_motions              # y...
                                                         # yt = In word
                                                         # yu = Word left
                                                         # yo = Word right
                                                         # yl = Whole line
                                                         # y, = To line start
                                                         # y. = To line end
                                                         # y; = Next input char
                                                         # yh = Prev input char

# Vis
bindkey -M visual 'y'       vi-change                    # y


# PASTE
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'v'        _paste_from_clipboard        # v
bindkey -M vicmd 'V'        _clipboard_ring_paste        # V

# Vis
bindkey -M visual 'v'       _paste_from_clipboard_visual # v
bindkey -M visual 'V'       _clipboard_ring_paste_over   # V


# INCREMENT / DECREMENT INTEGERS
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd 'C'        _increment_integers          # C
bindkey -M vicmd 'X'        _decrement_integers          # X


# MATCH BRACKETS
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd '%'        vi-match-bracket             # %

# Vis
bindkey -M visual '%'       vi-match-bracket             # %


# CHANGE / DELETE SURROUNDING
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd ' '        _manipulate_surrounding      # Space...

# The first input following Space specifies the
# char to change FROM, the second input specifies
# the char to change TO.


# SELECT INSIDE SURROUNDING
# ---------------------------------------------------------------------------- #
# Cmd
bindkey -M vicmd "'"        _select_in_surrounding       # '
bindkey -M vicmd '"'        _select_in_surrounding       # "
bindkey -M vicmd '`'        _select_in_surrounding       # `
bindkey -M vicmd '{'        _select_in_surrounding       # {
bindkey -M vicmd '('        _select_in_surrounding       # (
bindkey -M vicmd '['        _select_in_surrounding       # [
bindkey -M vicmd '<'        _select_in_surrounding       # <


# ADD SURROUNDING
# ---------------------------------------------------------------------------- #
# Vis
bindkey -M visual "'"       _add_surrounding             # '
bindkey -M visual '"'       _add_surrounding             # "
bindkey -M visual '`'       _add_surrounding             # `
bindkey -M visual '{'       _add_surrounding             # {
bindkey -M visual '('       _add_surrounding             # (
bindkey -M visual '['       _add_surrounding             # [
bindkey -M visual '<'       _add_surrounding             # <
