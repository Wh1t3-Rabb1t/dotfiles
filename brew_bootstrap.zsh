
sudo -v

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --verbose --no-lock --file "${0:A:h}"/macos/Brewfile
