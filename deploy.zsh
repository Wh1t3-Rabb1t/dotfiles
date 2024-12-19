#!/usr/bin/env zsh

set -e

zmodload -m -F zsh/files b:zf_rm b:zf_ln b:zf_mkdir

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"


# local term_width="$(tput cols)"
# print "################################################################################\n"

# Retrieve terminal pane width
local term_width="$(tput cols)"

# Create required directories
print "\nCreating required directory tree...\n"
# zf_mkdir -p "${XDG_CONFIG_HOME}"
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh}
zf_mkdir -p "${XDG_DATA_HOME}"/{zsh,man/man1,vim/spell}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
print "    ...done\n"
print "$(printf '%*s' "$term_width" | tr ' ' '#')\n"
# print "################################################################################\n"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable...\n"
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "    ...present and valid, skipping .zshenv symlink\n"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "    ...failed to match this script dir, symlinking .zshenv\n"
fi
print "################################################################################\n"

# Link configs
print "Linking config files...\n"
zf_ln -sfn "${SCRIPT_DIR}" "${XDG_CONFIG_HOME}"
print "    ...done\n"
print "################################################################################\n"

# Make sure submodules are installed
print "Syncing submodules...\n"
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "\n    ...done\n"
print "################################################################################\n"

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
print "################################################################################\n"

print "Installing fzf...\n"
pushd tools/fzf
if ./install --bin > /dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    print "\n    ...done\n"
else
    print "\n    ...failed. Probably unsupported architecture, please check fzf installation guide\n"
fi
popd
print "################################################################################\n"

# Generate vim help tags
if (( ${+commands[vim]} )); then
    print "Generating vim helptags...\n"
    command vim --not-a-term -i "NONE" -c "helptags ALL" -c "qall" &> /dev/null
    print "    ...done\n"
    print "################################################################################\n"
fi

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k...\n"
${SHELL} -is <<<'' &> /dev/null
print "    ...done\n"
print "################################################################################\n"

# Set fast-syntax-highlighting theme
print "Setting fast-syntax-highlighting theme\n"
${SHELL} -is <<<'fast-theme base16' &>/dev/null
print "    ...done\n"
print "################################################################################\n"

# Download brew dependencies if deploying to a mac with brew enabled
if [[ "${OSTYPE}" == darwin* && -n "${commands[brew]}" ]]; then
    print "Installing homebrew dependancies...\n"
    cd "${ZDOTDIR:h}/macos"
    brew bundle
    cd ~
    print "\n    ...done\n"
    print "################################################################################\n"
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
