# TODO

---

## Plugins


https://github.com/mafredri/zsh-async
https://github.com/hlissner/zsh-autopair
https://github.com/junegunn/fzf-git.sh
https://github.com/rs/curlie
https://github.com/davecheney/httpstat
https://github.com/direnv/direnv
https://github.com/walles/moar
https://github.com/maaslalani/slides
https://github.com/MichaelAquilina/zsh-auto-notify
https://github.com/catppuccin/bat
https://github.com/agkozak/zsh-z


---

## Misc

- Broot folder view binding needs to be changed from tab to something else
- Rework upper / lower case, dot op bindings to match nvim
- Look into implementing gnu privacy guard and wireguard
- Implement substitute binding
- Implement zplugins as submodules in the main config dir
- Fix mass rename function to work with regex (double quote param expansion of the sed line may be the problem)
- Implement registers
- Add checks in .zshrc to ensure certain directories and env variables exist to prevent bugs when initializing a new system

- Create a dedicated git repo for backup files / deprecated code
- Configure git in ~/.gitconfig
- Set Rg search highlight colors
- Set fzf env variables in ~/.config/fzf
- Add copy and paste from registers to zsh vi mode
- Add a check to ensure that luarocks is installed before initializing luacheck
- Create bindings to launch nvim from zsh and broot

- Learn Java: https://www.youtube.com/playlist?list=PLZPZq0r_RZOMhCAyywfnYLlrjiVOkdAI1
- Git etc: https://www.youtube.com/@bootdotdev/videos

- awk cheat sheet
    https://github.com/gennaro-tedesco/dotfiles/blob/master/navi/awk.cheat

- Rg globbing tips:
The feature you’re talking about is one of my favorites and most used, it’s even turbo charged when you use live_grep_glob (or set rg_glob=true) and then search for a regex limited to specific files, I.e foo.*bar -- *.lua !*spec* which means search for a line that has both foo AND bar inside lua files excluding spec files (tests), then I ctrl-g to fuzzy for the fine tuning.
