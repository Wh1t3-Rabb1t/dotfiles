# ZSCRIPTS

`zscripts` are added to the fpath and autoloaded on first call.

Organization is loosely based on the tools they rely on / utility they
serve, but some overlap is unavoidable, (we could just dump 80% of scripts
in a directory called fzf, but that wouldn't be practical).

Everything with a leading underscore in it's name is omitted from fzf when
invoking the cheat sheet widget (e.g. `_will_be_ignored`). I don't want to
populate the cheat sheet with scripts bound to hotkeys, or aliased, which
would only pollute results with commands that I perform frequently, and therefor
don't need to look up.
