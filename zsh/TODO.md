# TODO


- Dropping karabiner. Link no longer exists in deploy script

- Finish refining git submodule scripts
- Add checks for os type when using `pbpaste` in scripts
- Add a check to ensure that luarocks is installed before initializing luacheck

- Hammerspoon:
    Rewrite basic Rectangle features with Hammerspoon
    App launcher / focuser with Hammerspoon
    Monitor brightness control with Hammerspoon
    Possibly auto quit Finder when system wakes up with Hammerspoon



- Configure ghostty
- Fix ghostty navigate split bindings

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
