#!/usr/bin/env zsh
#       _            _
#    __| | ___ _ __ | | ___  _   _
#   / _` |/ _ \ '_ \| |/ _ \| | | |
#  | (_| |  __/ |_) | | (_) | |_| |
#   \__,_|\___| .__/|_|\___/ \__, |
# ============|_|============|___/============================================ #

set -e
zmodload -m -F zsh/files b:zf_rm b:zf_ln b:zf_mkdir


# Get the current path
# ---------------------------------------------------------------------------- #
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"


# Default XDG paths
# ---------------------------------------------------------------------------- #
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"


# Install Homebrew and set MacOs defaults
# ---------------------------------------------------------------------------- #
if [[ "${OSTYPE}" == darwin* ]]; then
    # Install brew
    print "\nInstalling Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print "    ...done\n"
    print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"

    # Install dependancies
    print "Installing Homebrew dependancies...\n"
    command brew bundle install --verbose --no-lock --file "${SCRIPT_DIR}"/macos/Brewfile
    print "\n    ...done\n"
    print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"

    # Set MacOs defaults
    print "Setting MacOs defaults...\n"
    "${SCRIPT_DIR}"/macos/system_settings.zsh
    print "    ...done\n"
    print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"
fi


# Create required directories
# ---------------------------------------------------------------------------- #
print "Creating required directory tree...\n"
zf_mkdir -p "${XDG_CONFIG_HOME}"/nvim
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh}
zf_mkdir -p "${XDG_DATA_HOME}"/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
print "    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Link zshenv if needed
# ---------------------------------------------------------------------------- #
print "Checking for ZDOTDIR env variable...\n"
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "    ...present and valid, skipping .zshenv symlink\n"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "    ...failed to match this script dir, symlinking .zshenv\n"
fi
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Link configs
# ---------------------------------------------------------------------------- #
print "Linking config files...\n"
zf_ln -sfn "${SCRIPT_DIR}/bat" "${XDG_CONFIG_HOME}/bat"
zf_ln -sfn "${SCRIPT_DIR}/broot" "${XDG_CONFIG_HOME}/broot"
zf_ln -sfn "${SCRIPT_DIR}/btop" "${XDG_CONFIG_HOME}/btop"
zf_ln -sfn "${SCRIPT_DIR}/ghostty" "${XDG_CONFIG_HOME}/ghostty"
zf_ln -sfn "${SCRIPT_DIR}/git" "${XDG_CONFIG_HOME}/git"
zf_ln -sfn "${SCRIPT_DIR}/gitui" "${XDG_CONFIG_HOME}/gitui"
zf_ln -sfn "${SCRIPT_DIR}/hammerspoon" "${XDG_CONFIG_HOME}/hammerspoon"
zf_ln -sfn "${SCRIPT_DIR}/karabiner" "${XDG_CONFIG_HOME}/karabiner"
zf_ln -sfn "${SCRIPT_DIR}/kitty" "${XDG_CONFIG_HOME}/kitty"
zf_ln -sfn "${SCRIPT_DIR}/lsd" "${XDG_CONFIG_HOME}/lsd"
zf_ln -sfn "${SCRIPT_DIR}/luacheck" "${XDG_CONFIG_HOME}/luacheck"
zf_ln -sfn "${SCRIPT_DIR}/mpv" "${XDG_CONFIG_HOME}/mpv"
zf_ln -sf "${SCRIPT_DIR}/nvim/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
zf_ln -sfn "${SCRIPT_DIR}/nvim/lua" "${XDG_CONFIG_HOME}/nvim/lua"
zf_ln -sfn "${SCRIPT_DIR}/vim/.vimrc" "${HOME}/.vimrc"
print "    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Make sure submodules are installed
# ---------------------------------------------------------------------------- #
print "Syncing submodules...\n"
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "\n    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Compile compatible zsh plugin files
# ---------------------------------------------------------------------------- #
print "Compiling zsh plugins...\n"
{
    emulate -LR zsh
    setopt local_options extended_glob
    autoload -Uz zrecompile
    for plugin_file in ${SCRIPT_DIR}/zsh/plugins/**/*.zsh{-theme,}(#q.); do
        zrecompile -pq "${plugin_file}"
    done
}
print "    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Trigger zsh run with powerlevel10k prompt to download gitstatusd
# ---------------------------------------------------------------------------- #
print "Downloading gitstatusd for powerlevel10k...\n"
${SHELL} -is <<<'' &> /dev/null
print "    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Set fast-syntax-highlighting theme
# ---------------------------------------------------------------------------- #
print "Setting fast-syntax-highlighting theme...\n"
${SHELL} -is <<<'fast-theme base16' &> /dev/null
print "    ...done\n"
print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"


# Generate Vim help tags
# ---------------------------------------------------------------------------- #
if (( ${+commands[vim]} )); then
    print "Generating Vim helptags...\n"
    command vim --not-a-term -i "NONE" -c "helptags ALL" -c "qall" &> /dev/null
    print "    ...done\n"
    print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"
fi


# Setup Neovim
# ---------------------------------------------------------------------------- #
if (( ${+commands[nvim]} )); then
    # Launch nvim to trigger Lazy and download plugins
    print "Downloading Neovim plugins and generating help tags...\n"
    command nvim --headless -c "helptags ALL" -c "qall" &> /dev/null

    # Launch nvim and install Mason dependancies
    print "Installing LSP servers/tools...\n"
    # `MasonInstallAll` isn't a neovim builtin. It's a user command declared in:
    # ./nvim/lua/conf/lang/mason.lua
    command nvim --headless -c "MasonInstallAll" -c "qall" &> /dev/null
    print "    ...done\n"
    print "$(printf '%*s' "$(tput cols)" | tr ' ' '#')\n"
fi


print " ██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗ "
print " ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝ "
print " ██████╔╝█████╗  ███████║██║  ██║ ╚████╔╝  "
print " ██╔══██╗██╔══╝  ██╔══██║██║  ██║  ╚██╔╝   "
print " ██║  ██║███████╗██║  ██║██████╔╝   ██║    "
print " ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝    "
print "           ████████╗ ██████╗               "
print "           ╚══██╔══╝██╔═══██╗              "
print "              ██║   ██║   ██║              "
print "              ██║   ██║   ██║              "
print "              ██║   ╚██████╔╝              "
print "              ╚═╝    ╚═════╝               "
print "    ██████╗  ██████╗  ██████╗██╗  ██╗      "
print "    ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝      "
print "    ██████╔╝██║   ██║██║     █████╔╝       "
print "    ██╔══██╗██║   ██║██║     ██╔═██╗       "
print "    ██║  ██║╚██████╔╝╚██████╗██║  ██╗      "
print "    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝    \n"
print "Log out/restart to reflect updated MacOs keyboard settings.\n"
