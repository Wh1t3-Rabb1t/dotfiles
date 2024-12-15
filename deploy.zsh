#!/usr/bin/env zsh

set -e

zmodload -m -F zsh/files b:zf_rm b:zf_ln b:zf_mkdir


# 1: Install dev tools
#
#    xcode-select --install
#
# 2: Install brew
#
#    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#    eval "$(/opt/homebrew/bin/brew shellenv)"
#
#
#    (not needed as config will be pulled from gittub)
#    echo >> /Users/${USER}/.zprofile
#    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile


# +----------------+
# | XDG COMPLIANCE |
# +----------------+

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Create required directories
print "\nCreating required directory tree...\n"
# zf_mkdir -p "${XDG_CONFIG_HOME}"/{bat,broot/{skins,launcher/bash},btop/themes,git,gitui,karabiner/{automatic_backups,assets/complex_modifications},kitty/backgrounds,lsd,luacheck,mpv,nvim/{lua/conf/{editor,lang,tools,ui},plugins,user,util},vial,vim,zsh}

zf_mkdir -p "${XDG_CONFIG_HOME}"/zsh
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh}
zf_mkdir -p "${XDG_DATA_HOME}"/{zsh,man/man1,vim/spell}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
print "\n    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# # Link zshenv if needed
# print "Checking for ZDOTDIR env variable...\n"
# if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
#     print "    ...present and valid, skipping .zshenv symlink\n"
# else
#     ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
#     print "    ...failed to match this script dir, symlinking .zshenv\n"
# fi

zf_ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${HOME}/.zshenv"

print "#------------------------------------------------------------------------------#\n"

# Link config files
print "Linking config files...\n"
zf_ln -sfn "${SCRIPT_DIR}/vim" "${XDG_CONFIG_HOME}/vim"

# zf_ln -sf "${SCRIPT_DIR}/nvim/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
# zf_ln -sfn "${SCRIPT_DIR}/nvim/lua" "${XDG_CONFIG_HOME}/nvim/lua"


# zf_ln -sfn "${SCRIPT_DIR}/nvim/after" "${XDG_CONFIG_HOME}/nvim/after"
# zf_ln -sfn "${SCRIPT_DIR}/nvim/plugins" "${XDG_DATA_HOME}/nvim/site/pack/plugins/start"

# zf_ln -sfn "${SCRIPT_DIR}/tmux" "${XDG_CONFIG_HOME}/tmux"
# zf_ln -sf "${SCRIPT_DIR}/configs/gitconfig" "${XDG_CONFIG_HOME}/git/config"
# zf_ln -sf "${SCRIPT_DIR}/configs/gitattributes" "${XDG_CONFIG_HOME}/git/attributes"
# zf_ln -sf "${SCRIPT_DIR}/configs/gitignore" "${XDG_CONFIG_HOME}/git/ignore"
# zf_ln -sf "${SCRIPT_DIR}/configs/mc.ini" "${XDG_CONFIG_HOME}/mc/ini"
# zf_ln -sf "${SCRIPT_DIR}/configs/htoprc" "${XDG_CONFIG_HOME}/htop/htoprc"
# zf_ln -sf "${SCRIPT_DIR}/configs/ranger" "${XDG_CONFIG_HOME}/ranger/rc.conf"
# zf_ln -sf "${SCRIPT_DIR}/configs/gemrc" "${XDG_CONFIG_HOME}/gem/gemrc"
# zf_ln -snf "${SCRIPT_DIR}/configs/ranger-plugins" "${XDG_CONFIG_HOME}/ranger/plugins"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Make sure submodules are installed
print "Syncing submodules...\n"
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# print "Compiling zsh plugins...\n"
# {
#     emulate -LR zsh
#     setopt local_options extended_glob
#     autoload -Uz zrecompile
#     for plugin_file in ${SCRIPT_DIR}/zsh/plugins/**/*.zsh{-theme,}(#q.); do
#         zrecompile -pq "${plugin_file}"
#     done
# }
# print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# # Install hook to call deploy script after successful pull
# print "Installing git hooks...\n"
# zf_mkdir -p .git/hooks
# zf_ln -sf ../../deploy.zsh .git/hooks/post-merge
# zf_ln -sf ../../deploy.zsh .git/hooks/post-checkout
# print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

print "Installing fzf...\n"
pushd zsh/plugins/fzf
if ./install --bin > /dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/zsh/plugins/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/zsh/plugins/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    print "    ...done\n"
else
    print "    ...failed. Probably unsupported architecture, please check fzf installation guide\n"
fi
popd

print "#------------------------------------------------------------------------------#\n"

if (( ${+commands[vim]} )); then
    # Generate vim help tags
    print "Generating vim helptags...\n"
    command vim --not-a-term -i "NONE" -c "helptags ALL" -c "qall" &> /dev/null
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"
fi

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k...\n"
${SHELL} -is <<<'' &> /dev/null
print "    ...done\n"
