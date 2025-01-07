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
setopt APPEND_HISTORY        # History: append to existing file
setopt HIST_IGNORE_ALL_DUPS  # History: don't add duplicate commands
setopt HIST_SAVE_NO_DUPS     # History: don't add duplicate consecutive commands
setopt HIST_IGNORE_SPACE     # History: don't add commands with leading whitespace
setopt HIST_NO_FUNCTIONS     # History: don't add function calls
setopt HIST_REDUCE_BLANKS    # History: don't add commands that differ only by whitespace
setopt INC_APPEND_HISTORY    # History: append commands upon execution
setopt SHARE_HISTORY         # History: share between all sessions
setopt EXTENDED_HISTORY      # History: save commands timestamps and duration
setopt AUTO_PUSHD            # Dir stack: push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS     # Dir stack: don't store duplicates
setopt PUSHD_SILENT          # Dir stack: don't print the stack after pushd or popd
setopt AUTO_PARAM_SLASH      # Cmp: Complete folders with / at end
setopt LIST_TYPES            # Cmp: Mark type of completion suggestions
setopt HASH_LIST_ALL         # Cmp: Hash entire cmd path before attempting completion
setopt COMPLETE_IN_WORD      # Cmp: Allow completion from within a word/phrase
setopt ALWAYS_TO_END         # Cmp: Move cursor to the end of a completed word
setopt BSD_ECHO              # Require `-e` to interpret escape sequences in echo strings
setopt PRINT_EXIT_VALUE      # Print exit code if command fails
setopt EXTENDED_GLOB         # Treat special characters as part of patterns
setopt MULTIOS               # Allows multiple input and output redirections
setopt CLOBBER               # Allow > redirection to truncate existing files
setopt BRACE_CCL             # Allow brace character class list expansion
setopt INTERACTIVE_COMMENTS  # Allow use of comments in interactive code
setopt LONG_LIST_JOBS        # List jobs in the long format by default
setopt AUTO_RESUME           # Attempt to resume existing job before creating a new process
setopt NOTIFY                # Report status of background jobs immediately




# setopt CORRECT_ALL # try to correct the spelling of all arguments in a line


# A bit fancy than default
# PROMPT_EOL_MARK='%K{red} %k'
