# Vi Bindings


## MODE TOGGLING ---------------------------------------------------------------
`Esc` : Vi-insert
`s` : Visual-mode
`S` : Visual-line-mode


## LINE NAVIGATION -------------------------------------------------------------
Cmd
`l` : Vi-forward-char
`t` : Vi-backward-char
`h` : Beginning-of-line
`;` : End-of-line
`o` : Vi-forward-word
`u` : Vi-backward-word
`O` : Vi-forward-word-end
`U` : Vi-backward-word-end
`.` : Vi-repeat-find
`,` : Vi-rev-repeat-find


## DELETE BINDINGS -------------------------------------------------------------
Cmd
`BS` : Backward-delete-char
`Del` : Delete-char
`Alt BS` : Backward-kill-word
`Alt Del` : Kill-word
`Ctrl BS` : Backward-kill-line
`Ctrl Del` : Kill-line
`Shift Del` : Kill-whole-line


## DELETE MOTIONS --------------------------------------------------------------
Cmd
- `w...` : Delete_motions
                                                         # wt = In word
                                                         # wu = Word left
                                                         # wo = Word right
                                                         # wl = Whole line
                                                         # wh = To line start
                                                         # w; = To line end
                                                         # w. = Next input char
                                                         # w, = Prev input char


## UNDO / REDO / DOT OPERATOR --------------------------------------------------
Cmd
- `Hyphen` : Vi-repeat-change
- `Alt y` : Undo
- `Alt Y` : Redo


## SELECT IN WORD / LINE -------------------------------------------------------
Cmd
- `Alt Right` : Select_in_word

## UPPER / LOWER / SWAP CASE ---------------------------------------------------
Cmd
- `_` : Vi-swap-case

Vis
- `-` : Vi-up-case
- `_` : Vi-down-case


## COPY ------------------------------------------------------------------------
Cmd
- `c...` : Copy_motions
                                                         # ct = In word
                                                         # cu = Word left
                                                         # co = Word right
                                                         # cl = Whole line
                                                         # ch = To line start
                                                         # c; = To line end
                                                         # c. = Next input char
                                                         # c, = Prev input char

Vis
- `c` : Copy_to_clipboard


## CUT -------------------------------------------------------------------------
Cmd
- `x...` : Cut_motions
                                                         # xt = In word
                                                         # xu = Word left
                                                         # xo = Word right
                                                         # xl = Whole line
                                                         # xh = To line start
                                                         # x; = To line end
                                                         # x. = Next input char
                                                         # x, = Prev input char

Vis
- `x` : Cut_to_clipboard


## CHANGE ----------------------------------------------------------------------
Cmd

- `y...` : Change_motions
                                                         # yt = In word
                                                         # yu = Word left
                                                         # yo = Word right
                                                         # yl = Whole line
                                                         # yh = To line start
                                                         # y; = To line end
                                                         # y. = Next input char
                                                         # y, = Prev input char

Vis

- `y` : Vi-change


## PASTE -----------------------------------------------------------------------
Cmd

- `v` : Paste_from_clipboard

Vis

- `v` : Paste_from_clipboard_visual

Ins

- `Alt v` : Paste_from_clipboard


## INCREMENT / DECREMENT INTEGERS ----------------------------------------------
Cmd
- `Alt c` : Increment_integers
- `Alt x` : Decrement_integers


## CHANGE / DELETE SURROUNDING -------------------------------------------------
Cmd

- `Space...` : Manipulate_surrounding

The first input following Space specifies the char to change *FROM*, the second
input specifies the char to change *TO*.


## SELECT INSIDE SURROUNDING ---------------------------------------------------
Cmd

Any quote or opening bracket character will enter visual mode and select the area
between said character.


## ADD SURROUNDING -------------------------------------------------------------
Vis

Any quote or opening bracket character will add a pair of said character to
either side of the visual selection.

