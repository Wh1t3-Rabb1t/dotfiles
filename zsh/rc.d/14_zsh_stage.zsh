#           _           _              _
#   _______| |__    ___| |_ __ _  __ _(_)_ __   __ _    __ _ _ __ ___  __ _
#  |_  / __| '_ \  / __| __/ _` |/ _` | | '_ \ / _` |  / _` | '__/ _ \/ _` |
#   / /\__ \ | | | \__ \ || (_| | (_| | | | | | (_| | | (_| | | |  __/ (_| |
#  /___|___/_| |_| |___/\__\__,_|\__, |_|_| |_|\__, |  \__,_|_|  \___|\__,_|
# ===============================|___/=========|___/========================== #


# AUTOMATICALLY ECHO STAGED ENTRIES WHEN CHANGING DIRECTORY
# ---------------------------------------------------------------------------- #
function chpwd() {
    if [[ -s "$ZSH_STAGE" ]]; then
        local dir_icon="\033[38;5;75m  \033[m ~"
        local file_icon="\033[38;5;189m  \033[m ~"

        echo -e "\nCurrently staged:"
        awk -F '/' -v file_icon="$file_icon" -v dir_icon="$dir_icon" '
            BEGIN { OFS=FS }
            {
                # Build the target path starting from field 4 if available
                out = ""
                if (NF >= 4) {
                    for (i = 4; i <= NF; i++) {
                        out = out (i == 4 ? "" : OFS) $i
                    }
                } else {
                    out = $0
                }

                # If the target path ends with a slash, assume it is a directory
                if (out ~ /\/$/) {
                    icon = dir_icon
                } else {
                    icon = file_icon
                }

                print icon out
            }
        ' "$ZSH_STAGE"
    fi
}


# ADD TO / REMOVE FROM THE STAGING AREA
# ---------------------------------------------------------------------------- #
local function _add_to_staging_area() {
    # Generate a unique state directory using timestamp
    local FZF_STATE_DIR="${VI_STATE_DIR}/fzf_state_$(date +%Y%m%d%H%M%S)"
    mkdir -p "$FZF_STATE_DIR"

    local HEADER_A=" Select items to stage.
Alt _ : Show hidden.
Alt ' : Show tree.
Tab   : Show staging area.
Enter : Add selection to the staging area."

    local HEADER_B="󱪢 Remove selection from the stage.
Tab   : Resume search.
Enter : Remove selection from the staging area."

    local TOGGLE_STAGING_AREA='
        [[ -e "'"$FZF_STATE_DIR"'/stage_focused" ]] && rm "'"$FZF_STATE_DIR"'/stage_focused" \
            || touch "'"$FZF_STATE_DIR"'/stage_focused"
    '

    local TOGGLE_HIDDEN_FLAG='
        if [[ ! -e "'"$FZF_STATE_DIR"'/stage_focused" ]]; then
            [[ -e "'"$FZF_STATE_DIR"'/hidden" ]] && rm "'"$FZF_STATE_DIR"'/hidden" \
                || touch "'"$FZF_STATE_DIR"'/hidden"
        fi
    '

    local TOGGLE_CWD_FLAG='
        if [[ ! -e "'"$FZF_STATE_DIR"'/stage_focused" ]]; then
            [[ -e "'"$FZF_STATE_DIR"'/cwd" ]] && rm "'"$FZF_STATE_DIR"'/cwd" \
                || touch "'"$FZF_STATE_DIR"'/cwd"
        fi
    '

    local RELOAD_OPTS='
        if [[ -e "'"$FZF_STATE_DIR"'/stage_focused" ]]; then
            local STAGE_HEADER="'"$HEADER_B"'"
            echo "change-header('\$STAGE_HEADER')+reload(cat '"$ZSH_STAGE"')"
        else
            local FD_CMD="fd --max-depth=1"
            local SEARCH_HEADER="'"$HEADER_A"'"

            if [[ -e "'"$FZF_STATE_DIR"'/hidden" ]]; then
                SEARCH_HEADER="${SEARCH_HEADER/Show hidden./Hide hidden.}"
                FD_CMD+=" --hidden"
            fi
            if [[ -e "'"$FZF_STATE_DIR"'/cwd" ]]; then
                SEARCH_HEADER="${SEARCH_HEADER/Show tree./Collapse tree.}"
                FD_CMD="${FD_CMD/ --max-depth=1}"
            fi

            echo "change-header('\$SEARCH_HEADER')+reload('\$FD_CMD')"
        fi
    '

    local STAGE_OR_UNSTAGE='
        if [[ -e "'"$FZF_STATE_DIR"'/stage_focused" ]]; then
            if (( "$FZF_SELECT_COUNT" > 1 )); then
                local marked_items

                for item in {+}; do
                    local line="$(grep -Fxn -- "${item//$'\n'/}" "$ZSH_STAGE" | cut -d: -f1)"
                    marked_items="${marked_items}${line}d;"
                    unset line
                done

                sed -i "$marked_items" "$ZSH_STAGE"
                echo "reload(cat '"$ZSH_STAGE"')"
            else
                local line="$(grep -Fxn -- {} '"$ZSH_STAGE"' | cut -d: -f1)"
                echo "execute(sed -i "${line}d" '"$ZSH_STAGE"')+reload(cat '"$ZSH_STAGE"')"
            fi
        else
            echo "accept-non-empty"
        fi
    '

    local selection=$( \
        fd \
            --max-depth=1 \
        | fzf \
            --multi \
            --header=$HEADER_A \
            --header-border=top \
            --bind="alt-_:transform:$TOGGLE_HIDDEN_FLAG+$RELOAD_OPTS" \
            --bind="alt-':transform:$TOGGLE_CWD_FLAG+$RELOAD_OPTS" \
            --bind="tab:transform:$TOGGLE_STAGING_AREA+$RELOAD_OPTS" \
            --bind="enter:transform:$STAGE_OR_UNSTAGE" \
    )

    [[ -d "$FZF_STATE_DIR" ]] && rm -rf "$FZF_STATE_DIR"

    if [[ -n "$selection" ]]; then
        local entries=""

        # The (f) flag splits $selection into an array delimited by line breaks
        for item in ${(f)selection}; do

            # Preserve trailing slash if present
            local absolute_path
            [[ "$item" == */ ]] && absolute_path="${item:A}/" \
                || absolute_path="${item:A}"

            # Only append if the file is not already in $ZSH_STAGE
            # Grep flags:
            #     --fixed-strings
            #     --line-regexp
            #     --quiet
            if ! grep -Fxq "$absolute_path" "$ZSH_STAGE"; then
                echo "$absolute_path" >> "$ZSH_STAGE"

                local icon
                [[ -d "$item" ]] && icon="\033[38;5;75m  \033[m" \
                    || icon="\033[38;5;189m  \033[m"

                entries+="${icon} ${item}"$'\n'
                unset icon
            fi
            unset absolute_path
        done
        unset item
    fi

    if [[ -n "$entries" ]]; then
        entries="${entries%$'\n'}"
        echo -e "\nAdded to the staging area:"
        echo -e "$entries"
    fi
}
alias st="_add_to_staging_area"


# MOVE CONTENTS OF THE STAGING AREA TO THE CWD
# ---------------------------------------------------------------------------- #
local function _move_staged_entries() {
    local -a selection
    selection=( ${(f)"$(<"${ZSH_STAGE}")"} )

    # The '--' prevents problems with file names starting with a dash
    mv --interactive --verbose --target-directory "$PWD" -- "${selection[@]}"

    # Clear the staging area
    sed -ni '' "$ZSH_STAGE"
}
alias sm="_move_staged_entries"




###################################################################


# local RELOAD_OPTS='
#     if [[ "$FZF_PROMPT" == "Staging  " ]]; then
#         if [[ -e "'"$FZF_STATE_DIR"'/hidden" ]]; then
#             echo "change-header("Hide hidden.")+reload(fd)"
#         else
#             echo "change-header("Show hidden.")+reload(fd --hidden)"
#         fi
#     fi
# '



# local TOGGLE_HIDDEN_FLAG='
#     if [[ "$FZF_PROMPT" == "Staging  " ]]; then
#         if [[ -e "'"$FZF_STATE_DIR"'/hidden" ]]; then
#             rm "'"$FZF_STATE_DIR"'/hidden"
#         else
#             touch "'"$FZF_STATE_DIR"'/hidden"
#         fi
#     fi
# '


# TODO: add a toggle for hidden files, and a toggle for cwd / entire dir tree

# echo "change-header('"$HEADER_A"')+reload(fd)"
# echo "change-header('"$HEADER_A"')+reload(fd --hidden)"


# TODO: set binding to combo actions. first create the file flag. then call the constructor case statement


# example of action chaining
# --bind="alt-_:transform:$TOGGLE_HIDDEN+$TOGGLE_STAGING_AREA" \




# local HEADER_A=" Select items to stage.
# <Tab>   : Show staging area.
# <Enter> : Add selection to the staging area.
# <Alt-_> : Toggle hidden.
# <Alt-'> : Toggle cwd/full tree.
# "



# local TOGGLE_STAGING_AREA='
#     if [[ "$FZF_PROMPT" != "Staging  " ]]; then
#         echo "change-prompt('$PROMPT_A')+change-header('$HEADER_A')+reload(fd)"
#     else
#         echo "change-prompt('$PROMPT_B')+change-header('$HEADER_B')+reload(cat '$ZSH_STAGE')"
#     fi
# '



# local HEADER_TEMPLATE=" Select items to stage.
# Tab   : Show staging area.
# Enter : Add selection to the staging area.
# Alt h : Show hidden.
# Alt t : Toggle cwd/full tree."


# local TOGGLE_STAGING_AREA='
#     local PROMPT_A="Staging  "
#     local PROMPT_B="Removing  "

#     if [[ "$FZF_PROMPT" == "Staging  " ]]; then
#         echo "change-prompt('\$PROMPT_B')+reload(fd)"
#     else
#         echo "change-prompt('\$PROMPT_A')+clear-query"
#     fi
# '


