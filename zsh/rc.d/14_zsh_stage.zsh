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
        awk -F'/' -v file_icon="$file_icon" -v dir_icon="$dir_icon" '
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


# ADD SELECTED ITEMS TO THE STAGING AREA
# ---------------------------------------------------------------------------- #
local HEADER_A=" Select items to stage.
<Tab>   : Show staging area.
<Enter> : Add selection to the staging area.
"

local HEADER_B="󱪢 Remove selection from the stage.
<Tab>   : Resume search.
<Enter> : Remove selection from the staging area.
"

local PROMPT_A="Staging  "
local PROMPT_B="Removing  "

local TOGGLE_STAGING_AREA='
    if [[ "$FZF_PROMPT" != "Staging  " ]]; then
        echo "change-prompt('$PROMPT_A')+change-header('$HEADER_A')+reload(fd --color=always --hidden)"
    else
        echo "change-prompt('$PROMPT_B')+change-header('$HEADER_B')+reload(cat '$ZSH_STAGE')"
    fi
'

local STAGE_OR_UNSTAGE='
    if [[ "$FZF_PROMPT" != "Staging  " ]]; then
        if (( "$FZF_SELECT_COUNT" > 1 )); then
            local marked_items
            for item in {+}; do
                local line="$(grep -Fxn -- "${item//$'\n'/}" "$ZSH_STAGE" | cut -d: -f1)"
                marked_items="${marked_items}${line}d;"
                unset line
            done
            unset item

            sed -i "$marked_items" "$ZSH_STAGE"
            unset marked_items

            echo "reload(cat "$ZSH_STAGE")"
        else
            echo "execute(sed -i "$(grep -Fxn -- {} "$ZSH_STAGE" | cut -d: -f1)d" "$ZSH_STAGE")+reload(cat "$ZSH_STAGE")"
        fi
    else
        echo "accept-non-empty"
    fi
'


# TODO: add a toggle for hidden files, and a toggle for cwd / entire dir tree


local function _add_to_staging_area() {
    local selection=$( \
        fd \
            --color=always \
            --hidden \
        | fzf \
            --multi \
            --header=$HEADER_A \
            --header-border=top \
            --prompt=$PROMPT_A \
            --bind="tab:transform:$TOGGLE_STAGING_AREA" \
            --bind="enter:transform:$STAGE_OR_UNSTAGE" \
    )

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
    > "$ZSH_STAGE"
}
alias sm="_move_staged_entries"



# sed -ni '' "$ZSH_STAGE"
