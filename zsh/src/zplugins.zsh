#             _             _
#   _____ __ | |_   _  __ _(_)_ __  ___
#  |_  / '_ \| | | | |/ _` | | '_ \/ __|
#   / /| |_) | | |_| | (_| | | | | \__ \
#  /___| .__/|_|\__,_|\__, |_|_| |_|___/
#======|_|============|___/====================================================#

# See: https://github.com/mattmc3/zsh_unplugged


# CHECK FOR UPDATES
#-------------------
# Globals:    ZPLUGINDIR
# Arguments:  None
#------------------------------------------------------------------------------#
local function _zplugin_check_for_updates() {
    emulate -L zsh
    local updates_found=false
    local green="\e[0m\e[33m"
    local color_end="\e[m"

    for d in $ZPLUGINDIR/*/.git; do
        local repo_dir="${d:h}"
        local repo_name=$(basename "$repo_dir")
        local git_output=$(git -C "$repo_dir" fetch origin --dry-run 2>&1)

        if [[ -n "$git_output" ]]; then
            updates_found=true
            echo -e "\nUpdate available for: ${green}${repo_name}${color_end}"
        fi
    done

    if [[ "$updates_found" == false ]]; then
        echo -e "\nNo zplugin updates available."
    fi
}


# PULL UPDATES IF AVAILABLE
#---------------------------
# Globals:    ZPLUGINDIR
# Arguments:  None
#------------------------------------------------------------------------------#
local function _zplugin_update() {
    emulate -L zsh
    local plugins_updated=false
    local green="\e[0m\e[33m"
    local color_end="\e[m"

    for d in $ZPLUGINDIR/*/.git(/); do
        local repo_dir="${d:h}"
        local repo_name=$(basename "$repo_dir")
        local outdated_plugin=$(git -C "$repo_dir" fetch origin --dry-run 2>&1)

        if [[ -n "$outdated_plugin" ]]; then
            plugins_updated=true
            echo -e "\nUpdating: ${green}${repo_name}${color_end}\n"
            command git -C "$repo_dir" pull --ff --recurse-submodules --depth 1 --rebase --autostash
        fi
    done

    if [[ "$plugins_updated" = false ]]; then
        echo -e "\nAll zplugins are up to date."
    fi
}


# DELETE SELECTED ZSH PLUGIN
#----------------------------
# Globals:    ZDOTDIR, ZPLUGIN_REPOS, ZPLUGINDIR
# Arguments:  None (fzf is used to select target plugin)
#------------------------------------------------------------------------------#
local function _zplugin_delete() {
    emulate -L zsh
    source "${ZDOTDIR}/src/.zplugin_list.zsh"
    local filename="${ZDOTDIR}/src/.zplugin_list.zsh"
    local target_repo="$(echo "$ZPLUGIN_REPOS" | tr ' ' '\n' | fzf)"
    local repo_to_delete=$(basename "$target_repo")

    if [[ -z "$target_repo" ]]; then
        echo -e "\nSearch cancelled."
        return
    elif [[ ! -e "$filename" ]]; then
        echo -e "\nzplugin file not found."
        exit 1
    fi

    # Delete the matching line from the file
    local matching_line=$(grep "$target_repo" "$filename")
    sed -i '' -e "\~$target_repo~d" "$filename"

    # Remove the plugin and reload zplugin init file
    rm $ZPLUGINDIR/$repo_to_delete
    source "${ZDOTDIR}/src/zplugins.zsh"
}


# ADD AND INITIALIZE NEW PLUGIN WITH GITHUB URL
#-----------------------------------------------
# Globals:    ZDOTDIR
# Arguments:  Github repo url
#------------------------------------------------------------------------------#
local function _zplugin_add_new() {
    emulate -L zsh
    local repo_url="$1"
    local repo_name=$(echo "$repo_url" | awk -F'/' '{print $(NF-1)"/"$NF}')
    local filename="${ZDOTDIR}/src/.zplugin_list.zsh"

    if [[ $# -eq 0 ]]; then
        echo -e "\nNeed to pass plugin repo as arg."
        return
    elif [[ ! -e "$filename" ]]; then
        echo -e "\nFile not found: $filename"
        exit 1
    fi

    # Append the arg to the second last line of the file
    local last_line=$(tail -n 1 "$filename")
    sed -i '' -e '$i\'$'\n    '"$repo_name" "$filename"

    # Reload zlpugins
    source "${ZDOTDIR}/src/zplugins.zsh"
}


# CLONE A PLUGIN, IDENTIFY ITS INIT FILE, SOURCE IT, AND ADD IT TO THE FPATH
#----------------------------------------------------------------------------
# Globals:    ZPLUGINDIR, ZPLUGIN_REPOS
# Arguments:  Array containing zsh plugin list (ZPLUGIN_REPOS)
#------------------------------------------------------------------------------#
local function _zplugin_load() {
    emulate -L zsh
    local repo plugdir initfile initfiles=()

    for repo in $@; do
        plugdir=$ZPLUGINDIR/${repo:t}
        initfile=$plugdir/${repo:t}.plugin.zsh

        # Clone the plugin if a new entry exists in the plugin array
        if [[ ! -d $plugdir ]]; then
            echo -e "\nCloning $repo..."
            git clone -q --depth 1 --recursive --shallow-submodules \
                https://github.com/$repo $plugdir
        fi

        # Locate and symlink the init file if it exists
        if [[ ! -e $initfile ]]; then
            initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
            (( $#initfiles )) || {echo >&2 "\nNo init file found '$repo'." && continue}
            ln -sf $initfiles[1] $initfile
        fi

        fpath+=$plugdir
        (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
    done
}

# Retrieve the zplugin_repos array
source "${ZDOTDIR}/src/.zplugin_list.zsh"
_zplugin_load "${ZPLUGIN_REPOS[@]}"
