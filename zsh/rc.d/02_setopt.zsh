#            _              _
#   ___  ___| |_ ___  _ __ | |_
#  / __|/ _ \ __/ _ \| '_ \| __|
#  \__ \  __/ || (_) | |_) | |_
#  |___/\___|\__\___/| .__/ \__|
# ===================|_|====================================================== #

unsetopt BEEP                # Don't beep on errors
unsetopt FLOW_CONTROL        # Disable annoying keys
unsetopt NOMATCH             # Try to avoid the 'zsh: no matches found...'
unsetopt SHORT_LOOPS         # Disable short loop forms, can be confusing
unsetopt RM_STAR_SILENT      # Notify when rm is running with *
setopt RM_STAR_WAIT          # Wait 10 seconds for confirmation when running rm with *
setopt HIST_IGNORE_ALL_DUPS  # Don't add duplicate commands
setopt HIST_SAVE_NO_DUPS     # Don't add duplicate consecutive commands
setopt HIST_IGNORE_SPACE     # Don't add commands with leading whitespace
setopt HIST_NO_FUNCTIONS     # Don't add function calls
setopt HIST_REDUCE_BLANKS    # Don't add commands that differ only by whitespace
setopt INC_APPEND_HISTORY    # Append commands to history upon execution
setopt SHARE_HISTORY         # Share history between all sessions
setopt EXTENDED_HISTORY      # Save commands timestamps and duration to history file
setopt AUTO_PUSHD            # Push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS     # Do not store duplicates in the stack
setopt PUSHD_SILENT          # Don't print the directory stack after pushd or popd
setopt BSD_ECHO              # Require `-e` to interpret escape sequences in echo strings
setopt PRINT_EXIT_VALUE      # Print exit code if command fails
setopt EXTENDED_GLOB         # Treat special characters as part of patterns
setopt MULTIOS               # Allows multiple input and output redirections
setopt CLOBBER               # Allow > redirection to truncate existing files
setopt BRACE_CCL             # Allow brace character class list expansion
setopt INTERACTIVE_COMMENTS  # Allow use of comments in interactive code
setopt AUTO_PARAM_SLASH      # Complete folders with / at end
setopt LIST_TYPES            # Mark type of completion suggestions
setopt HASH_LIST_ALL         # Ensure entire cmd path is hashed before attempting completion
setopt COMPLETE_IN_WORD      # Allow completion from within a word/phrase
setopt ALWAYS_TO_END         # Move cursor to the end of a completed word
setopt LONG_LIST_JOBS        # List jobs in the long format by default
setopt AUTO_RESUME           # Attempt to resume existing job before creating a new process
setopt NOTIFY                # Report status of background jobs immediately




# setopt APPEND_HISTORY # history appends to existing file
# setopt CORRECT_ALL # try to correct the spelling of all arguments in a line


# a bit fancy than default
# PROMPT_EOL_MARK='%K{red} %k'
