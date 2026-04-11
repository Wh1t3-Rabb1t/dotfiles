# Resources

- Ascii file headers:
      https://www.asciiart.eu/text-to-ascii-art (standard format)
- Runtime guide:
      https://thevaluable.dev/vim-runtime-guide-example/
- Configuration examples:
      https://dotfyle.com/neovim/configurations/top
- Revert plugins to prev version:
      https://dev.to/vonheikemen/lazynvim-how-to-revert-a-plugin-back-to-a-previous-version-1pdp

## Notes

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
