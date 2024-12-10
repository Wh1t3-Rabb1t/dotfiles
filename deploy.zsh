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
zf_mkdir -p "${XDG_CONFIG_HOME}"/{git,bat,btop,broot,nvim,gitui,kitty,lsd,luacheck,vim,zsh}
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh,tig}
zf_mkdir -p "${XDG_DATA_HOME}"/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
zf_chmod 700 "${XDG_CONFIG_HOME}/gnupg"
print "\n    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable...\n"
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "    ...present and valid, skipping .zshenv symlink\n"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "    ...failed to match this script dir, symlinking .zshenv\n"
fi

print "#------------------------------------------------------------------------------#\n"

# Link config files
print "Linking config files...\n"
zf_ln -sfn "${SCRIPT_DIR}/vim" "${XDG_CONFIG_HOME}/vim"
zf_ln -sf "${SCRIPT_DIR}/nvim/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
zf_ln -sfn "${SCRIPT_DIR}/nvim/after" "${XDG_CONFIG_HOME}/nvim/after"
zf_ln -sfn "${SCRIPT_DIR}/nvim/lua" "${XDG_CONFIG_HOME}/nvim/lua"
zf_ln -sfn "${SCRIPT_DIR}/nvim/plugins" "${XDG_DATA_HOME}/nvim/site/pack/plugins/start"
zf_ln -sfn "${SCRIPT_DIR}/tmux" "${XDG_CONFIG_HOME}/tmux"
zf_ln -sf "${SCRIPT_DIR}/configs/gitconfig" "${XDG_CONFIG_HOME}/git/config"
zf_ln -sf "${SCRIPT_DIR}/configs/gitattributes" "${XDG_CONFIG_HOME}/git/attributes"
zf_ln -sf "${SCRIPT_DIR}/configs/gitignore" "${XDG_CONFIG_HOME}/git/ignore"
zf_ln -sf "${SCRIPT_DIR}/configs/mc.ini" "${XDG_CONFIG_HOME}/mc/ini"
zf_ln -sf "${SCRIPT_DIR}/configs/htoprc" "${XDG_CONFIG_HOME}/htop/htoprc"
zf_ln -sf "${SCRIPT_DIR}/configs/ranger" "${XDG_CONFIG_HOME}/ranger/rc.conf"
zf_ln -sf "${SCRIPT_DIR}/configs/gemrc" "${XDG_CONFIG_HOME}/gem/gemrc"
zf_ln -snf "${SCRIPT_DIR}/configs/ranger-plugins" "${XDG_CONFIG_HOME}/ranger/plugins"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Make sure submodules are installed
print "Syncing submodules...\n"
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

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

print "#------------------------------------------------------------------------------#\n"

# Install hook to call deploy script after successful pull
print "Installing git hooks...\n"
zf_mkdir -p .git/hooks
zf_ln -sf ../../deploy.zsh .git/hooks/post-merge
zf_ln -sf ../../deploy.zsh .git/hooks/post-checkout
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

if (( ${+commands[make]} )); then
    # Make install git-extras
    print "Installing git-extras...\n"
    pushd tools/git-extras
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "    ...done\n"

    print "#------------------------------------------------------------------------------#\n"

    print "Installing git-quick-stats...\n"
    pushd tools/git-quick-stats
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "    ...done\n"
fi

print "#------------------------------------------------------------------------------#\n"

# Link gpg configs to $GNUPGHOME
print "Linking gnupg configs...\n"
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg.conf" "${XDG_CONFIG_HOME}/gnupg/gpg.conf"
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg-agent.conf" "${XDG_CONFIG_HOME}/gnupg/gpg-agent.conf"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

print "Installing fzf...\n"
pushd tools/fzf
if ./install --bin > /dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
    print "    ...done\n"
else
    print "    ...failed. Probably unsupported architecture, please check fzf installation guide\n"
fi
popd

print "#------------------------------------------------------------------------------#\n"

if (( ${+commands[perl]} )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy...\n"
    zf_ln -sf "${SCRIPT_DIR}/tools/diff-so-fancy/diff-so-fancy" "${HOME}/.local/bin/diff-so-fancy"
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"
fi

if (( ${+commands[vim]} )); then
    # Generate vim help tags
    print "Generating vim helptags...\n"
    command vim --not-a-term -i "NONE" -c "helptags ALL" -c "qall" &> /dev/null
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"
fi

if (( ${+commands[nvim]} )); then
    # Generate nvim help tags
    print "Generating nvim helptags...\n"
    command nvim --headless -c "helptags ALL" -c "qall" &> /dev/null
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"

    # Update treesitter config
    print "Updating treesitter config...\n"
    command nvim --headless -c "TSUpdate" -c "qall" &> /dev/null
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"

    # Update mason registries
    print "Updating mason registries...\n"
    command nvim --headless -c "MasonUpdate" -c "qall" &> /dev/null
    print "    ...done\n"
    print "#------------------------------------------------------------------------------#\n"
fi

# Link goenv plugins to $GOENV_ROOT
print "Linking goenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/goenv/goenv/plugins/go-build" "${XDG_DATA_HOME}/goenv/plugins/go-build"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link jenv plugins to $JENV_ROOT
print "Linking jenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/jenv/jenv/available-plugins/export" "${XDG_DATA_HOME}/jenv/plugins/export"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link luaenv plugins to $LUAENV_ROOT
print "Linking luaenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/luaenv/lua-build" "${XDG_DATA_HOME}/luaenv/plugins/lua-build"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/luaenv/luaenv-luarocks" "${XDG_DATA_HOME}/luaenv/plugins/luaenv-luarocks"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link nodenv plugins to $NODENV_ROOT
print "Linking nodenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/nodenv/node-build" "${XDG_DATA_HOME}/nodenv/plugins/node-build"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/nodenv/nodenv-aliases" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-aliases"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/nodenv/nodenv-env" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-env"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/nodenv/nodenv-man" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-man"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/nodenv/nodenv-package-rehash" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-package-rehash"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link phpenv plugins to $PHPENV_ROOT
print "Linking phpenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/phpenv/php-build" "${XDG_DATA_HOME}/phpenv/plugins/php-build"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/phpenv/phpenv-aliases" "${XDG_DATA_HOME}/phpenv/plugins/phpenv-aliases"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/phpenv/phpenv-composer" "${XDG_DATA_HOME}/phpenv/plugins/phpenv-composer"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link plenv plugins to $PLENV_ROOT
print "Linking plenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/plenv/perl-build" "${XDG_DATA_HOME}/plenv/plugins/perl-build"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/plenv/plenv-contrib" "${XDG_DATA_HOME}/plenv/plugins/plenv-contrib"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/plenv/plenv-download" "${XDG_DATA_HOME}/plenv/plugins/plenv-download"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link pyenv plugins to $PYENV_ROOT
print "Linking pyenv plugins...\n"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/pyenv/pyenv/plugins/python-build" "${XDG_DATA_HOME}/pyenv/plugins/python-build"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/pyenv/pyenv-virtualenv" "${XDG_DATA_HOME}/pyenv/plugins/pyenv-virtualenv"
zf_ln -snf "${SCRIPT_DIR}/env-wrappers/pyenv/pyenv-default-packages" "${XDG_DATA_HOME}/pyenv/plugins/pyenv-default-packages"
zf_ln -sf "${SCRIPT_DIR}/env-wrappers/pyenv/default-packages" "${XDG_DATA_HOME}/pyenv/default-packages"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Link rbenv plugins to $RBENV_ROOT
print "Linking rbenv plugins...\n"
local -a rbenv_plugins
rbenv_plugins=("ruby-build" "rbenv-aliases" "rbenv-binstubs" "rbenv-chefdk" "rbenv-ctags" "rbenv-default-gems" "rbenv-env" "rbenv-man")
local plugin
for plugin in "${rbenv_plugins[@]}"; do
    zf_ln -snf "${SCRIPT_DIR}/env-wrappers/rbenv/${plugin}" "${XDG_DATA_HOME}/rbenv/plugins/${plugin}"
done
ln -sf "${SCRIPT_DIR}/env-wrappers/rbenv/default-gems" "${XDG_DATA_HOME}/rbenv/default-gems"
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k...\n"
${SHELL} -is <<<'' &> /dev/null
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Download/refresh TLDR pages
print "Downloading TLDR pages...\n"
${SCRIPT_DIR}/tools/tldr-bash-client/tldr -u > /dev/null
print "    ...done\n"

print "#------------------------------------------------------------------------------#\n"

# Install crontab task to pull updates every midnight
print "Installing cron job for periodic updates...\n"
local cron_task="cd ${SCRIPT_DIR} && git -c user.name=cron.update -c user.email=cron@localhost stash && git pull && git stash pop"
local cron_schedule="0 0 * * * ${cron_task}"
if cat <(grep --ignore-case --invert-match --fixed-strings "${cron_task}" <(crontab -l)) <(echo "${cron_schedule}") | crontab -; then
    print "    ...done\n"
else
    print "Please add \`cd ${SCRIPT_DIR} && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
fi

