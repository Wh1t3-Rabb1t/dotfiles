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
$HOME/.local/dotfiles/macos/macos_settings.zsh
```

```sh
$HOME/.local/dotfiles/macos/macos_keybindings.zsh
```

- Useful debugging commands

```sh
defaults read com.brave.Browser NSUserKeyEquivalents
```
