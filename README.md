# DOTFILES

- automatic shell config deploy practise repo


xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"


git clone https://github.com/Wh1t3-Rabb1t/dotfiles.git "$HOME/.local/dotfiles"
$HOME/.local/dotfiles/deploy.zsh
chsh -s /bin/zsh
