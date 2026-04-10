# TODO

## Snacks notes:

Plugins to keep:

- ? Rip substitute
- ? Gitsigns

Plugins to remove (rewrite essential functionality):
- Trailblazer
- Recorder
- Spider

## Priority: High

- Remove Spider plugin and instead tweak nvims text objects for congruence.
- Rework open line below to drop the use of marks if possible.
- Make sure swap_point_and_mark function is still working properly.
- Look into keymap_funcs and replace anything that has been made redundant.
- Look into whether or not we can disable multiple tabs
  (help pages etc forced to launch in splits).

- `:checkhealth which-key` has useful info about overlapping bindings.

## Priority: Low

- Create autocommand to turn off wrap if buffer width is < 80.
- Consider creating an ignored filetypes module that sets ignore lists for
  different plugins to prevent plugins clashing.
- Set up bindings to inspect / evaluate selection.
- Write correct lua evaluation bindings for a popup window -- vmap("=", ":lua<CR>", { silent = false }).
- Set up code action bindings.

## Plugins

- https://github.com/andrewferrier/debugprint.nvim
- https://github.com/stevearc/overseer.nvim
- https://github.com/kawre/leetcode.nvim
- https://github.com/lukas-reineke/cmp-under-comparator

- Plugin framework: https://github.com/ldelossa/litee.nvim

## Debug

- https://github.com/mfussenegger/nvim-dap
- https://github.com/rcarriga/nvim-dap-ui
- https://github.com/theHamsta/nvim-dap-virtual-text
- https://github.com/leoluz/nvim-dap-go
- https://github.com/rcarriga/cmp-dap

wiki: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#lua

## Possibly incorporate these bindings

```lua
-- MOVE SELECTION LEFT / RIGHT
--------------------------------------------------------------------------------
vmap("<Right>", [["zx"zpgvlolo]])                 -- Move selection right
vmap("<Left>",  [["zxhh"zpgvhoho]])               -- Move selection left
```

## Store these notes somewhere

- Registers:
```txt
"  Unnamed register. Holds the last deleted or yanked text.
*  Primary system clipboard selection (X11 on Unix-like systems).
+  Secondary clipboard register. Used for copying/pasting with the system clipboard.
.  Last inserted text register. Contains last inserted text.
-  Small delete register. Holds text from deletions smaller than a line (like dw).
0  Yank register for the last yank command. Last yanked text (not overwritten by deletes).
_  Black hole register. Discards any text sent to it, acting as a "null" register.
#  Alternate file name register. Holds name of the last file edited.
/  Last search pattern register. Stores the most recent search pattern.
%  Current file name register. Holds the name of the current file.
:  Last executed command register. Containing the last command-line command entered.
=  Expression register. Allows you to evaluate expressions and insert the result.
~  Register for the last tilde operation. Stores result of the last g~ or ~ operation.
```

- On semanticTokens (from the net):
```txt
I use for C/C++. I don't like the way tree sitter works for these
languages and the error recovery of the LSP prevents a missing
semicolon in a line to affect the syntax highlight of the next
lines. And since Tree sitter can't differentiate macros from types,
the syntax highlight is completely broken in some code.
```
