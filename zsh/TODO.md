# TODO


- Finish refining git submodule scripts
- Add checks for os type when using `pbpaste` in scripts
- Ensure that local binary paths are declared via env variables and NOT ${HOME}/.local/ etc.
- Add a check to ensure that luarocks is installed before initializing luacheck
- Fix ghostty navigate split bindings
- Rewrite basic Rectangle features with Hammerspoon
- App launcher / focuser with Hammerspoon
- Monitor brightness control with Hammerspoon
- Possibly auto quit Finder when system wakes up with Hammerspoon


- Configure ghostty
- Configure sketchybar
- Configure vimium-c

- ? (Maybe) Put a file named '.hushlogin' into the home directory to prevent last login message when zsh loads.


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

- awk cheat sheet
    https://github.com/gennaro-tedesco/dotfiles/blob/master/navi/awk.cheat

- Rg globbing tips:
The feature you’re talking about is one of my favorites and most used, it’s even turbo charged when you use live_grep_glob (or set rg_glob=true) and then search for a regex limited to specific files, I.e foo.*bar -- *.lua !*spec* which means search for a line that has both foo AND bar inside lua files excluding spec files (tests), then I ctrl-g to fuzzy for the fine tuning.
