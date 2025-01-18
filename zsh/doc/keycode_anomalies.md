# TERMINAL KEYCODE ANOMALIES

## Terminal ctrl bindings ------------------------------------------------------

- `Ctrl A` : Move to the beginning of the line.
- `Ctrl E` : Move to the end of the line.
- `Ctrl U` : Cut everything before the cursor to the beginning of the line.
- `Ctrl K` : Cut everything after the cursor to the end of the line.
- `Ctrl W` : Cut the word before the cursor.
- `Ctrl Y` : Paste the most recently cut text.
- `Ctrl R` : Search backward in history.
- `Ctrl S` : Search forward in history.
- `Ctrl D` : Delete the character under the cursor.
- `Ctrl L` : Clear the screen.
- `Ctrl C` : Interrupt the current foreground process (sends SIGINT).
- `Ctrl Z` : Suspend the current foreground process (sends SIGTSTP).

'Available' key combinations on a '101' PC keyboard attached to a PC running
'zsh' under xfce4 under Debian Linux (I don't know who's 'in charge'). All
combinations that produce duplicate codes within the 'grey' keys have been
removed except for the simplest avatar which is shown. Note, some grey
keys/combinations have '^letter' duplicates, like 'Enter' == '^M', these have
not been removed. Other active combinations were not 'available' since used
by the system, even from console, eg. 'Alt+Function' keys switch terminals.
Perhaps the 'Meta' key would do more, but this is with a 101 KB. Interesting
that there are far more combinations available in DOS, such as Ctrl+Function
-- all available in DOS, none of them available in Linux, so it seems. None
of the tripple key combinations (eg. 'Ctrl+Alt+Up') produced any unique codes
within the grey keys, but they do produce codes in the white keys. Interesting
anomalies: '^[[22' '^[[27' '^[[30' are 'missing', you have to wonder why those
numbers were skipped. (Which is to say that you might expect 'F11' to be
'^[[22' not '^[[23'.)

The key codes shown are as they would be output by 'showkeys -a' or 'bindkey'
at CLI. However, for some reason if you use 'bindkey' within a script (as in
'.zshrc') ' ^[ ' must be replaced with ' \e ', thus at CLI:

```sh
bindkey -s '^[[[A' 'my-command \C-m'
```

... bind 'F1' to 'my-command' and execute it (the ' \C-m ' simulates the
'Enter' key).

in '.zshrc':

```sh
bindkey -s '\e[25' 'my-command1 ; my command2 \C-m'
```

... bind 'Shift-F1' to 'my-command1' followed by 'my-command2' and execute
both of them.


## Combinations using just the 'grey' keys -------------------------------------

`F1`        = '^[[[A'
`F2`        = '^[[[B'
`F3`        = '^[[[C'
`F4`        = '^[[[D'
`F5`        = '^[[[E'
`F6`        = '^[[17~'
`F7`        = '^[[18~'
`F8`        = '^[[19~'
`F9`        = '^[[20~'
`F10`       = '^[[21~'
`F11`       = '^[[23~'
`F12`       = '^[[24~'

`Shift-F1`  = '^[[25~'
`Shift-F2`  = '^[[26~'
`Shift-F3`  = '^[[28~'
`Shift-F4`  = '^[[29~'
`Shift-F5`  = '^[[31~'
`Shift-F6`  = '^[[32~'
`Shift-F7`  = '^[[33~'
`Shift-F8`  = '^[[34~'

`Insert`    = '^[[2~'
`Delete`    = '^[[3~'
`Home`      = '^[[1~'
`End`       = '^[[4~'
`PageUp`    = '^[[5~'
`PageDown`  = '^[[6~'
`Up`        = '^[[A'
`Down`      = '^[[B'
`Right`     = '^[[C'
`Left`      = '^[[D'

`Bksp`      = '^?'
`Bksp-Alt`  = '^[^?'
`Bksp-Ctrl` = '^H'    console only.

`Esc`       = '^['
`Esc-Alt`   = '^[^['

`Enter`     = '^M'
`Enter-Alt` = '^[^M'

`Tab`       = '^I' or '\t'  unique form! can be bound, but does not 'showkey -a'.
`Tab-Alt`   = '^[\t'


## Combinations using the white keys -------------------------------------------

Anomalies:

- 'Ctrl+`' == 'Ctrl+2', and 'Ctrl+1' == '1' in xterm.
- Several 'Ctrl+number' combinations are void at console, but return
codes in xterm.
- OTOH Ctrl+Bksp returns '^H' at console, but is identical to plain
'Bksp' in xterm.
- There are no doubt more of these little glitches however, in the main:

White key codes are easy to undertand, each of these 'normal' printing keys
has six forms:

`A`            = 'a'    (duhhh)
`A-Shift`      = 'A'    (who would have guessed?)
`A-Alt`        = '^[a'

`A-Ctrl`       = '^A'
`A-Alt-Ctrl`   = '^[^A'
`A-Alt-Shift`  = '^[A'
`A-Ctrl-Shift` = '^A'   (Shift has no effect)

Don't forget that:

`/-Shift-Ctrl` = `Bksp`      = '^?'
`[-Ctrl`       = `Esc`       = '^['
`M-Ctrl`       = `Enter`     = '^M'

And, we can 'stack' keybindings:

```sh
bindkey -s '^Xm' "My mistress\' eyes are nothing like the sun."
```

... Bind 'Ctrl-X' followed by 'm' to a nice line of poetry.

And we can flirt with madness:

```sh
bindkey -s '^Pletmenot' 'Let me not, to the marriage of true minds'
```

... but you have to start something like that with a 'modifier' character.
Try it, if you like keyboard shortcuts, you can really go to town.

