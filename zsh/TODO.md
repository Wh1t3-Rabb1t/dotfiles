# TODO


- !! The reason the embedded fzf script wasn't working was because the file variables were scoped outside of the fzf subscript

- Change echo calls to printf
- Add checks for os type when using `pbpaste` in scripts

- Consider changing enter binding back to broot launcher

- Fix zsh stage error (an empty file with only spaces is considered as an entry)

- Move to trash script is failing to output results to the command line after a new instance of the kitty app is launched,
it's being caused because zscripts are loaded before rc.d in .zshrc need to move zscript init to somewhere within rc.d

- Dropping karabiner. Link no longer exists in deploy script
- Setup autoenv for python as an intro to envs
- NVIM: create autocommand to turn off wrap if buffer width is < 80

- drop unnecessary find_and_goto_dir script and replace hyphen empty line binding with something else
- make sure the stage is clear when launching a new zsh instance (the app not a new process)
- Create script that duplicates a file / dir in place

- Update zplugin update script to dump plugins, re clone, and re compile before pushing
- Add zscript to manually regenerate compdump (if we say, download something with brew and want completions right away)


- Need to wrangle this.
```bash
# With 'change-nth'. The current nth option is exported as $FZF_NTH.
ps -ef | fzf --reverse --header-lines 1 --header-border bottom --input-border \
           --color nth:regular,fg:dim \
           --bind 'ctrl-n:change-nth(8..|1|2|3|4|5|6|7|)' \
           --bind 'result:transform-prompt:echo "${FZF_NTH}> "'
```

- update vi mode `gv` with this:
zle-line-pre-redraw
       Executed whenever the input line is about to be redrawn, providing an opportunity to update the region_highlight array.


- maybe use this in some scripts
fd
-l, --list-details
       Use a detailed listing format like 'ls -l'. This is
       basically an alias for '--exec-batch ls -l' with some
       additional 'ls' options. This can be used to see more
       metadata, to show symlink targets and to achieve a
       deterministic sort order.


- Add a check to ensure that luarocks is installed before initializing luacheck

- Hammerspoon:
    Rewrite basic Rectangle features with Hammerspoon
    App launcher / focuser with Hammerspoon. Some good examples here: https://github.com/kovidgoyal/kitty/issues/45
    Monitor brightness control with Hammerspoon
    Possibly auto quit Finder when system wakes up with Hammerspoon


- Configure vimium-c
- Ascii art: https://emojicombos.com/batman-ascii-art


---

## zsh man page index

1   User commands (executables in /bin, /usr/bin)
2   System calls (kernel-level functions, e.g., open(), read())
3   Library functions (C standard library, e.g., printf(), malloc())
4   Special files (e.g., /dev/null, /proc)
5   File formats and configuration files (e.g., /etc/passwd, crontab)
6   Games and screensavers
7   Miscellaneous (e.g., man 7 regex explains regex syntax)
8   System administration commands (requires root, e.g., mount, iptables)
9   Kernel internal APIs (used for kernel development)

---

## Plugins

- http client: https://github.com/Julien-cpsn/ATAC

https://github.com/catppuccin/bat
https://github.com/hyperupcall/autoenv
https://github.com/direnv/direnv
https://github.com/davecheney/httpstat
https://github.com/junegunn/fzf-git.sh
https://github.com/zsh-users/zsh-completions
https://github.com/lincheney/fzf-tab-completion
https://github.com/maaslalani/slides

---

## Some ambient dnb / future jungle on the horizon

https://soundcloud.com/papazen
https://soundcloud.com/zorrovian
https://soundcloud.com/pizza_hotline
https://soundcloud.com/neuralfold

---

## Brewfile

update nerdfont repo brew install command in README `brew install --cask font-hack-nerd-font`

- Look into implementing gnu privacy guard and wireguard
- Implement pfblockerNG


- Learn Java: https://www.youtube.com/playlist?list=PLZPZq0r_RZOMhCAyywfnYLlrjiVOkdAI1
- Git etc: https://www.youtube.com/@bootdotdev/videos

- Useful dofile repos:
    https://github.com/z0rc/dotfiles/
    https://github.com/chrisgrieser/.config/
    https://github.com/gennaro-tedesco/dotfiles/
    https://github.com/Phantas0s/.dotfiles/

- Rg globbing tips:
The feature you’re talking about is one of my favorites and most used, it’s even turbo charged when you use live_grep_glob (or set rg_glob=true) and then search for a regex limited to specific files, I.e foo.*bar -- *.lua !*spec* which means search for a line that has both foo AND bar inside lua files excluding spec files (tests), then I ctrl-g to fuzzy for the fine tuning.
