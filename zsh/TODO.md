# TODO

## Priority: High

- Change the name of `$ZSH_VI` into something suitable for a generalized for a user state dir.

- Use a coproc to read from the subshell in the find vim sessions script.

- Incorporate vi-pipe into vi mode:
```txt
vi-pipe
       This function reads a movement command from the keyboard and then prompts for an external command. The part of the buffer covered by the movement is piped
       to the external command and then replaced by the command's output. If the movement command is bound to vi-pipe, the current line is used.

       The function serves as an example for reading a vi movement command from within a user-defined widget.
```

- Running brew doctor on a newly launched kitty instance causes this error...
```zsh
Please note that these warnings are just used to help the Homebrew maintainers
with debugging if you file an issue. If everything you use Homebrew for is
working fine: please don't worry or file an issue; just ignore this. Thanks!

Warning: Homebrew's "sbin" was not found in your PATH but you have installed
formulae that put executables in /opt/homebrew/sbin.
Consider setting your PATH for example like so:
  echo 'export PATH="/opt/homebrew/sbin:$PATH"' >> ~/.zshrc
[1]    24599 exit 1     brew doctor
```
... need to try updating the PATH earlier in zsh init process, will come back to this after sf sorting strategy is complete.

- (maybe related to above) Move to trash script is failing to output results to the command line after
a new instance of the kitty app is launched, it's being caused because zscripts are loaded before rc.d
in .zshrc need to move zscript init to somewhere within rc.d.
- zscripts: Fix the broken highlight on the `_x` in zscripts fzf function.
- Change echo calls to printf.
- Set up macOS mission control navigation bindings and increase animation speed via cli os settings.
- Add checks for os type when using `pbpaste` in scripts.
- Setup `autoenv` for python as an intro to envs.
- Look into implementing `gnu privacy guard`, `wireguard`, and `pfblockerNG`.
- Learn Java: https://www.youtube.com/playlist?list=PLZPZq0r_RZOMhCAyywfnYLlrjiVOkdAI1
- Update nerdfont repo brew install command in README `brew install --cask font-hack-nerd-font`.

## Priority: Low

- Research zshcontrib:
Dumping Shell State
Remembering recent directories
Keyboard Definition

- Refactor these horrible lines from deploy.zsh to remove subshells:
```bash
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"
```

- Debugging echo command (make leading or trailing whitespace obvious):
```sh
echo ">$line<" > "$LOG"
```

- Set broot jump between results binding.
- Look into enabling italic and bold in kitty Monaco font.
- Consider changing enter binding back to broot launcher.
- Drop unnecessary find_and_goto_dir script and replace hyphen empty line binding with something else.
- Make sure the stage is clear when launching a new zsh instance (the app not a new process).
- Create script that duplicates a file / dir in place.
- Update zplugin update script to dump plugins, re clone, and re compile before pushing.
- Add zscript to manually regenerate compdump (if we say, download something with brew and want completions right away).

- Setup: https://github.com/gdh1995/vimium-c

- Need to wrangle this:
```bash
# With 'change-nth'. The current nth option is exported as $FZF_NTH.
ps -ef | fzf --reverse --header-lines 1 --header-border bottom --input-border \
           --color nth:regular,fg:dim \
           --bind 'ctrl-n:change-nth(8..|1|2|3|4|5|6|7|)' \
           --bind 'result:transform-prompt:echo "${FZF_NTH}> "'
```



- Update vi mode `gv` with this:
```txt
zle-line-pre-redraw
       Executed whenever the input line is about to be redrawn, providing an opportunity to update the region_highlight array.
```

- Store rg globbing tips somewhere:
```txt
The feature you’re talking about is one of my favorites and most used, it’s
even turbo charged when you use live_grep_glob (or set rg_glob=true) and
then search for a regex limited to specific files,
I.e foo.*bar -- *.lua !*spec* which means search for a line that has both
foo AND bar inside lua files excluding spec files (tests), then I ctrl-g
to fuzzy for the fine tuning.
```

## Plugins

- https://github.com/bigH/git-fuzzy
- https://github.com/Julien-cpsn/ATAC
- https://github.com/catppuccin/bat
- https://github.com/hyperupcall/autoenv
- https://github.com/direnv/direnv
- https://github.com/davecheney/httpstat
- https://github.com/junegunn/fzf-git.sh
- https://github.com/zsh-users/zsh-completions
- https://github.com/lincheney/fzf-tab-completion
- https://github.com/maaslalani/slides

## Hammerspoon

- Dropping karabiner. Link no longer exists in deploy script.
- Reinstall hammerspoon via homebrew.
- Rewrite basic Rectangle features with Hammerspoon.
- App launcher / focuser with Hammerspoon. Some good examples here: https://github.com/kovidgoyal/kitty/issues/45.
- Monitor brightness control with Hammerspoon.
- Possibly auto quit Finder when system wakes up with Hammerspoon.

## Useful dofile repos

- https://github.com/z0rc/dotfiles/
- https://github.com/chrisgrieser/.config/
- https://github.com/gennaro-tedesco/dotfiles/
- https://github.com/Phantas0s/.dotfiles/

## Some ambient dnb / future jungle on the horizon

- https://soundcloud.com/papazen
- https://soundcloud.com/zorrovian
- https://soundcloud.com/pizza_hotline
- https://soundcloud.com/neuralfold
