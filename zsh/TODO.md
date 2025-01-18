# TODO


- flushing nvim dropbar replace or reimplement lualine winbar. (it was consuming 10% cpu while idle)
- Rework nvim window resize logic to either keep column count above 80, or turn wrap off when it falls below 80

- Add a check to zsh cheat sheet widget to auto execute certain scripts on selection
- account for quotes when filename has spaces in rename widget

- !! use a FIFO to implement vi mode registers that can be accessed across different shells!

- 1. Standardize Rg / Fzf colors (only neovim remains)
- 5. Rewrite move to Trash script
- write a script to check for / download zsh plugin updates



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


- Ensure that local binary paths are declared via env variables and NOT ${HOME}/.local/ etc.

- Fix ghostty navigate split bindings
- Rewrite basic Rectangle features with Hammerspoon
- App launcher / focuser with Hammerspoon
- Monitor brightness control with Hammerspoon
- Possibly auto quit Finder when system wakes up with Hammerspoon


- ReConfigure Lualine
- Configure ghostty
- Configure sketchybar
- Configure vimium-c
- Configure https://github.com/lusingander/serie

- ? (Maybe) Put a file named '.hushlogin' into the home directory to prevent last login message when zsh loads.


---

## Plugins

https://github.com/bootandy/dust
https://github.com/mafredri/zsh-async
https://github.com/MichaelAquilina/zsh-auto-notify
https://github.com/junegunn/fzf-git.sh
https://github.com/rs/curlie
https://github.com/davecheney/httpstat
https://github.com/direnv/direnv
https://github.com/walles/moar
https://github.com/maaslalani/slides
https://github.com/catppuccin/bat
https://github.com/zsh-users/zsh-completions

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

- test nvim setup
brew "npm"
brew "luarocks"
brew "go"
brew "sqlite"
brew "fzf"
brew "neovim"







cask "brave-browser"
cask "firefox"
cask "firefox-developer-edition"
cask "font-meslo-for-powerlevel10k"
cask "ghostty"
cask "hammerspoon"
cask "karabiner-elements"
cask "kitty"
cask "rectangle"




brew "bat"
brew "blueutil"
brew "broot"
brew "btop"
brew "coreutils"
brew "curl"
brew "fd"
brew "ffmpeg"
brew "git"
brew "git-delta"
brew "gitui"
brew "glow"
brew "gnu-sed"
brew "gnu-tar"
brew "go"
brew "grep"
brew "jq"
brew "lsd"
brew "luarocks"
brew "mpv"
brew "neovim"
brew "npm"
brew "ripgrep"
brew "serie"
brew "sqlite"
brew "shellcheck"
brew "tealdeer"
brew "vim"
brew "wget"
brew "yt-dlp"
brew "zsh"





update nerdfont repo brew install command in README `brew install --cask font-hack-nerd-font`



- Rework upper / lower case, dot op bindings to match nvim
- Look into implementing gnu privacy guard and wireguard
- Implement pfblockerNG
- Implement substitute binding
- Implement registers
- Add checks in .zshrc to ensure certain directories and env variables exist to prevent bugs when initializing a new system

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
