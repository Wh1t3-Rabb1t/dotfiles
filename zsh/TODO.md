# TODO

- Dropping karabiner. Link no longer exists in deploy script

- NVIM: create autocommand to turn off wrap if buffer width is < 80

- Update zplugin update script to dump plugins, re clone, and re compile before pushing

- Find a way to cache dirs that contain Session.vim files (store in an array and update when Session files are created or moved to Trash)
- Setup autoenv for python as an intro to envs

- drop unnecessary find_and_goto_dir script and replace hyphen empty line binding with something else


- when the stage is focused use the --keep-right flag to ensure the file names are showing if the terminal pane is narrower than the path length
- sync stage aliases with broot internals
- make sure the stage is clear when launching a new zsh instance (the app not a new process)
- Create script that duplicates a file / dir in place

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





- Add zscript to manually regenerate compdump (if we say, download something with brew and want completions right away)

- Add checks for os type when using `pbpaste` in scripts
- Add a check to ensure that luarocks is installed before initializing luacheck

- Hammerspoon:
    Rewrite basic Rectangle features with Hammerspoon
    App launcher / focuser with Hammerspoon. Some good examples here: https://github.com/kovidgoyal/kitty/issues/45
    Monitor brightness control with Hammerspoon
    Possibly auto quit Finder when system wakes up with Hammerspoon


- Configure vimium-c

- Ascii art: https://emojicombos.com/batman-ascii-art

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
