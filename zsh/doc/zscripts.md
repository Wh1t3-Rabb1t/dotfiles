# ZSCRIPTS

`zscripts` are a collection of user defined zsh utility scripts which are
added to the fpath and autoloaded on first call.

Organization is loosely based on the tools they rely on / utility they
serve, but some overlap is unavoidable, (we could just dump 50% of scripts
in a directory called fzf, but that wouldn't be practical).

Pressing `;` on an empty command line invokes the `_zscripts_fzf` widget
which pipes a list of zscripts into fzf and appends the selected command
onto the command line for execution.

Scripts with a trailing `_x` in their name are executed upon selection
(e.g. `will_be_executed_immediately_x`), scripts with a leading underscore
in their name are omitted from fzf when invoking the cheat sheet widget
(e.g. `_will_be_ignored`). I don't want to populate the cheat sheet with
scripts bound to hotkeys, or aliased, which would only pollute results
with commands that I perform frequently, and therefor don't need to look up.
