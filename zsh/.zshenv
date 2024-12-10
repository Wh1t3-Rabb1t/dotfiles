# ! ITEMS MUST BE ADDED TO THE $PATH IN .zshrc TO AVOID BEING OVERWRITTEN
# ! WHEN etc/zprofile IS SOURCED AFTER .zshenv

export XDG_CONFIG_HOME="${HOME}/.config"  # MacOs default config directory
export ZDOTDIR="${HOME}/.config/zsh"      # Set zsh config directory

# Rust
. "$HOME/.cargo/env"
