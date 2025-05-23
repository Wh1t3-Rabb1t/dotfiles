# Vicmd Bindings


## MODE TOGGLING ---------------------------------------------------------------

- `Esc`                  : Insert mode
- `s`                    : Visual mode
- `S`                    : Visual line mode


## LINE NAVIGATION -------------------------------------------------------------

- `l`                    : Forward char
- `t`                    : Backward char
- `,`                    : Beginning of line
- `.`                    : End of line
- `o`                    : Forward word
- `u`                    : Backward word
- `O`                    : Forward word end
- `U`                    : Backward word end
- `f`                    : Find character
- `;`                    : Repeat find
- `h`                    : Rev repeat find


## DELETE BINDINGS -------------------------------------------------------------

- `BS`                   : Backward delete char
- `Del`                  : Delete char
- `Alt BS`               : Backward kill word
- `Alt Del`              : Kill word
- `Ctrl BS`              : Backward kill line
- `Ctrl Del`             : Kill line
- `Shift Del`            : Kill whole line


## DELETE MOTIONS --------------------------------------------------------------

- `w...`                 : Delete motions
- `wt`                   : In word
- `wu`                   : Word left
- `wo`                   : Word right
- `wl`                   : Whole line
- `w,`                   : To line start
- `w.`                   : To line end
- `w;`                   : Next input char
- `wh`                   : Prev input char


## UNDO / REDO / DOT OPERATOR --------------------------------------------------

- `Hyphen`               : Repeat change
- `Alt y`                : Undo
- `Alt Y`                : Redo


## SELECT IN WORD / LINE -------------------------------------------------------

- `W`                    : Select in word


## UPPER / LOWER / SWAP CASE ---------------------------------------------------

- `_`                    : Swap case


## COPY ------------------------------------------------------------------------

- `c...`                 : Copy motions
- `ct`                   : In word
- `cu`                   : Word left
- `co`                   : Word right
- `cl`                   : Whole line
- `c,`                   : To line start
- `c.`                   : To line end
- `c;`                   : Next input char
- `ch`                   : Prev input char


## CUT -------------------------------------------------------------------------

- `x...`                 : Cut motions
- `xt`                   : In word
- `xu`                   : Word left
- `xo`                   : Word right
- `xl`                   : Whole line
- `x,`                   : To line start
- `x.`                   : To line end
- `x;`                   : Next input char
- `xh`                   : Prev input char


## CHANGE ----------------------------------------------------------------------

- `y...`                 : Change motions
- `yt`                   : In word
- `yu`                   : Word left
- `yo`                   : Word right
- `yl`                   : Whole line
- `y,`                   : To line start
- `y.`                   : To line end
- `y;`                   : Next input char
- `yh`                   : Prev input char


## PASTE -----------------------------------------------------------------------

- `v`                    : Paste from clipboard
- `Alt p`                : Paste from clipboard ring


## INCREMENT / DECREMENT INTEGERS ----------------------------------------------

- `X`                    : Increment integers
- `C`                    : Decrement integers


## CHANGE / DELETE SURROUNDING -------------------------------------------------

- `Space...`             : Manipulate surrounding

The first input following Space specifies the
char to change *FROM*, the second input specifies
the char to change *TO*.


## SELECT INSIDE SURROUNDING ---------------------------------------------------

Any quote or opening bracket character will
enter visual mode and select the area between
said character.
