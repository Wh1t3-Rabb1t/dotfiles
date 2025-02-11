#           _           _              _
#   _______| |__    ___| |_ __ _  __ _(_)_ __   __ _    __ _ _ __ ___  __ _
#  |_  / __| '_ \  / __| __/ _` |/ _` | | '_ \ / _` |  / _` | '__/ _ \/ _` |
#   / /\__ \ | | | \__ \ || (_| | (_| | | | | | (_| | | (_| | | |  __/ (_| |
#  /___|___/_| |_| |___/\__\__,_|\__, |_|_| |_|\__, |  \__,_|_|  \___|\__,_|
# ===============================|___/=========|___/========================== #

# local HEADER_A="󰐃 Add selection to the stage. <Tab> : Show staging area."
# local HEADER_B="󰐃 Remove selection from the stage. <Tab> : Resume search."
# local PROMPT_A="Concealing .  "
# local PROMPT_B="Displaying .  "

# local arrow="\033[0m\033[33m  =>\033[m ~"


# AUTOMATICALLY ECHO STAGED ENTRIES WHEN CHANGING DIRECTORY
# ---------------------------------------------------------------------------- #
# function chpwd() {
#     if [[ -s "$ZSH_STAGE" ]]; then
#         local dir_icon="\033[38;5;75m  \033[m ~"
#         local file_icon="\033[38;5;189m  \033[m ~"

#         echo -e "\nCurrently staged:"
#         awk -F'/' -v file_icon="$file_icon" -v dir_icon="$dir_icon" '
#             BEGIN { OFS=FS }
#             {
#                 # Build the target path starting from field 4 if available
#                 out = ""
#                 if (NF >= 4) {
#                     for (i = 4; i <= NF; i++) {
#                         out = out (i == 4 ? "" : OFS) $i
#                     }
#                 } else {
#                     out = $0
#                 }

#                 # If the target path ends with a slash, assume it is a directory
#                 if (out ~ /\/$/) {
#                     icon = dir_icon
#                 } else {
#                     icon = file_icon
#                 }

#                 print icon out
#             }
#         ' "$ZSH_STAGE"
#     fi
# }


#   ...


# ADD SELECTED ITEMS TO THE STAGING AREA
# ---------------------------------------------------------------------------- #
local function _add_to_staging_area() {
    local selection=$( \
        fd --color=always \
        | fzf --multi \
    )

    if [[ -n "$selection" ]]; then
        local entries=""

        # The (f) flag splits $selection into an array on newlines
        for item in ${(f)selection}; do

            # Preserve trailing slash if present (if path is a directory)
            local absolute_path
            if [[ "$item" == */ ]]; then
                absolute_path="${item:A}/"
            else
                absolute_path="${item:A}"
            fi

            # Only append if the file is not already in $ZSH_STAGE
            # Grep flags:
            #   --fixed-strings
            #   --line-regexp
            #   --quiet
            if ! grep -Fxq "$absolute_path" "$ZSH_STAGE"; then
                echo "$absolute_path" >> "$ZSH_STAGE"
                unset absolute_path

                local icon
                if [[ -d "$item" ]]; then
                    icon="\033[38;5;75m  \033[m"
                else
                    icon="\033[38;5;189m  \033[m"
                fi

                entries+="${icon} ${item}"$'\n'
                unset icon
            fi
        done
        unset item

        if [[ -n "$entries" ]]; then
            entries=${entries%$'\n'}
            echo -e "\nAdded to the staging area:"
            echo -e "$entries"
        fi
    fi
}
alias st="_add_to_staging_area"


# MOVE CONTENTS OF THE STAGING AREA TO THE CWD
# ---------------------------------------------------------------------------- #
local function _move_staged_entries() {
    local -a selection
    selection=( ${(f)"$(<"${ZSH_STAGE}")"} )

    # The '--' prevents problems with file names starting with a dash
    mv --interactive --verbose --target-directory "${PWD}" -- "${selection[@]}"

    # Clear the staging area
    sed -ni '' "${ZSH_STAGE}"
}
alias sm="_move_staged_entries"
