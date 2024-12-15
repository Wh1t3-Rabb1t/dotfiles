# DOTFILES

- automatic shell config deploy practise repo

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

```sh
defaults write com.apple.finder AppleShowAllFiles True; killall Finder; git clone https://github.com/Wh1t3-Rabb1t/dotfiles.git "$HOME/.local/dotfiles"; chmod +x $HOME/.local/dotfiles/deploy.zsh; $HOME/.local/dotfiles/deploy.zsh
```
