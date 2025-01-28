# TODO


- Finish refining git submodule scripts
- Add checks for os type when using `pbpaste` in scripts
- Ensure that local binary paths are declared via env variables and NOT ${HOME}/.local/ etc.

# NOTE
- look into:
-
- Additional completions
- fpath=("${ZDOTDIR}/plugins/completions/src" ${fpath})
- fpath=("${ZDOTDIR}/plugins/git-completion/src" ${fpath})
-
- Enable git-extras completions
- source "${DOTFILES}/tools/git-extras/etc/git-extras-completion.zsh"



- Store these somewhere
```sh
# Text styling
# echo -e "\e[1mbold\e[0m"
# echo -e "\e[3mitalic\e[0m"
# echo -e "\e[4munderline\e[0m"
# echo -e "\e[9mstrikethrough\e[0m"
# echo -e "\e[31mHello World\e[0m"
# echo -e "\x1B[31mHello World\e[0m"

# Ansi colors
# 0;30 – Black
# 0;31 – Red
# 0;32 – Green
# 0;33 – Yellow
# 0;34 – Blue
# 0;35 – Magenta
# 0;36 – Cyan
# 0;37 – White
# 1;30 – Bright Black (Gray)
# 1;31 – Bright Red
# 1;32 – Bright Green
# 1;33 – Bright Yellow
# 1;34 – Bright Blue
# 1;35 – Bright Magenta
# 1;36 – Bright Cyan
# 1;37 – Bright White
```



- Fix ghostty navigate split bindings
- Rewrite basic Rectangle features with Hammerspoon
- App launcher / focuser with Hammerspoon
- Monitor brightness control with Hammerspoon
- Possibly auto quit Finder when system wakes up with Hammerspoon


- Configure ghostty
- Configure sketchybar
- Configure vimium-c
- Configure https://github.com/lusingander/serie

- ? (Maybe) Put a file named '.hushlogin' into the home directory to prevent last login message when zsh loads.


---

## Plugins

https://github.com/catppuccin/bat
https://github.com/walles/moar
https://github.com/bootandy/dust
https://github.com/mafredri/zsh-async
https://github.com/MichaelAquilina/zsh-auto-notify
https://github.com/junegunn/fzf-git.sh
https://github.com/rs/curlie
https://github.com/davecheney/httpstat
https://github.com/direnv/direnv
https://github.com/maaslalani/slides
https://github.com/zsh-users/zsh-completions
https://github.com/lincheney/fzf-tab-completion


- http client
https://github.com/Julien-cpsn/ATAC


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
- Implement substitute binding
- Implement registers

- Configure git in ~/.gitconfig
- Add a check to ensure that luarocks is installed before initializing luacheck

- Learn Java: https://www.youtube.com/playlist?list=PLZPZq0r_RZOMhCAyywfnYLlrjiVOkdAI1
- Git etc: https://www.youtube.com/@bootdotdev/videos

- awk cheat sheet
    https://github.com/gennaro-tedesco/dotfiles/blob/master/navi/awk.cheat

- Rg globbing tips:
The feature you’re talking about is one of my favorites and most used, it’s even turbo charged when you use live_grep_glob (or set rg_glob=true) and then search for a regex limited to specific files, I.e foo.*bar -- *.lua !*spec* which means search for a line that has both foo AND bar inside lua files excluding spec files (tests), then I ctrl-g to fuzzy for the fine tuning.
