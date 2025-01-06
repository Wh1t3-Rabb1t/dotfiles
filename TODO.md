# TODO



- Finish configuring fzf tab

- Ensure that local binary paths are declared via env variables and NOT ${HOME}/.local/ etc.

- Fix ghostty navigate split bindings
- Write a script to check for zsh plugin updates
- Tweak `f` open files to enable opening of multiple files (with nvim only mpv can't open playlists)
- Finish reworking 'd' alias (search and jump to dir)
- Finish refactoring zsh config
- Test if setting fzf local path is causing issues with nvim fzf lua inside of vm
- Rewrite basic Rectangle features with Hammerspoon
- Possibly auto quit Finder when system wakes up with Hammerspoon
- App launcher / focuser with Hammerspoon


- ReConfigure Lualine
- Set global ignore for rg and fd
- Configure yazi
- Configure ghostty
- Configure sketchybar
- Configure vimium-c
- Configure rg
- Configure https://github.com/lusingander/serie

---

## Plugins


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
- Implement substitute binding
- Fix mass rename function to work with regex (double quote param expansion of the sed line may be the problem)
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
