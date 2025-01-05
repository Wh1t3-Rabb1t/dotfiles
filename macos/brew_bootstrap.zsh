#!/usr/bin/env zsh

sudo -v

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --verbose --no-lock --file "${HOME}"/.local/dotfiles/macos/Brewfile

# ln -sf "${HOME}"/.local/dotfiles/zsh/.zshenv "${HOME}"/.zshenv


# print "Brew dependancies successfully installed, press 'y' to continue to zsh initialization, any other key to abort."
# read -r choice

# if [[ "$choice" == "y" ]]; then
#     print "Reloading the shell..."
#     exec zsh -c "${HOME}/.local/dotfiles/deploy.zsh"
# else
#     print "Aborting."
# fi
