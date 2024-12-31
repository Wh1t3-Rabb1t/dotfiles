# DOTFILES

- Download xcode developer tools

```sh
xcode-select --install
```

- Download homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Clone dotfiles and execute deploy script

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"; git clone https://github.com/Wh1t3-Rabb1t/dotfiles.git "$HOME/.local/dotfiles"; $HOME/.local/dotfiles/deploy.zsh
```

## Alternate testing commands

- MacOs settings scripts

```sh
$HOME/.local/dotfiles/macos/system_settings.zsh
```

- Useful debugging commands

```sh
defaults write com.apple.Terminal "Window Settings" -dict-add "Basic" '{ KeyboardOptionKeyIsMeta = 1; }'; killall Terminal
```
