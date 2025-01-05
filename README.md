# DOTFILES

- Download xcode developer tools

```sh
xcode-select --install
```

- Download homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- New deploy

```sh
git clone https://github.com/Wh1t3-Rabb1t/dotfiles.git "${HOME}"/.local/dotfiles; "${HOME}"/.local/dotfiles/brew_bootstrap.zsh
```

```sh
"${HOME}"/.local/dotfiles/deploy.zsh
```

## Alternate testing commands

- MacOs settings scripts

```sh
$HOME/.local/dotfiles/macos/system_settings.zsh
```

- Useful debugging commands

```sh
defaults write com.apple.finder FXPreferredViewStyle Nlsv; defaults write com.apple.finder AppleShowAllFiles True; killall Finder
```
