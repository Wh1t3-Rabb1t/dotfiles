# SHELL SCRIPT

---

# Basic Operators

## Arithmetic Operators --------------------------------------------------------

- `+`  : Addition.
- `-`  : Subtraction.
- `*`  : Multiplication.
- `/`  : Division.
- `%`  : Modulus.
- `++` : Increment.
- `--` : Decrement.

## Comparison Operators --------------------------------------------------------

- `-eq` : Equal to.
- `-ne` : Not equal to.
- `-lt` : Less than.
- `-le` : Less than or equal to.
- `-gt` : Greater than.
- `-ge` : Greater than or equal to.

## Logical Operators -----------------------------------------------------------

- `&&` : Logical AND.
- `||` : Logical OR.
- `!`  : Logical NOT.

## File Test Operators ---------------------------------------------------------

- `-e` : Checks if a file exists.
- `-d` : Checks if a directory exists.
- `-f` : Checks if a file is a regular file.
- `-r` : Checks if a file is readable.
- `-w` : Checks if a file is writable.
- `-x` : Checks if a file is executable.
- `-s` : Checks if a file is non-empty.

---

# Tests

## Test with `[[ ... ]]` -------------------------------------------------------

- Used for conditional expressions.
- Supports string comparisons and pattern matching.
- Allows logical operators like `&&` and `||`.

## Test arithmetic with `(( ... ))` --------------------------------------------

- Evaluates arithmetic expressions.
- Supports typical arithmetic operators (`+`, `-`, `*`, `/`, `%`).
- Returns true for non-zero results and false for zero.

---

# Special Variables

- `$0`: The name of the script.
- `$1`, `$2`, `...`: Arguments passed to the script.
- `$#`: Number of arguments.
- `$?`: Exit status of the last command.
- `$$`: Process ID of the current shell.
- `$!`: Process ID of the last background command.
- `$@`: All arguments passed to the script (individually quoted).
- `$*`: All arguments passed to the script (as a single word).

---

# Quoting

## Single Quotes `'...'` -------------------------------------------------------

- Treats everything inside as a literal string.
- No variable expansion, special characters (like `$`, `*`, `\`) are taken literally.
- Useful for preserving the exact value of the string, including spaces.

## Double Quotes `"..."` -------------------------------------------------------

- Allows variable expansion (e.g., `$var` will be replaced with the value of `var`).
- Prevents word splitting (preserves spaces in variables) and globbing (wildcards `*` won't expand).
- Useful for protecting strings while still allowing variables and commands to be evaluated.

---

# Redirection

## Input Redirection -----------------------------------------------------------

- `< file`: Takes input from a file.

## Output Redirection ----------------------------------------------------------

- `> file`: Redirects standard output to a file.
- `>> file`: Appends standard output to a file.

## Error Redirection -----------------------------------------------------------

- `2> file`: Redirects standard error to a file.
- `2>> file`: Appends standard error to a file.

## Combine Output and Error ----------------------------------------------------

- `&> file`: Redirects both stdout and stderr to a file.
- `&>> file`: Appends both stdout and stderr to a file.

---

# Pipelines

- `command1 | command2`: Pipe output of `command1` to input of `command2`.

---

# Exit Status

- `0`: Success.
- Non-zero: Failure or specific error codes.

---

# Miscellaneous

## Command Substitution --------------------------------------------------------

```bash
    $(command)
```

- Substitutes the result of `command`.

## Background Commands ---------------------------------------------------------

```bash
    command &
```

- Runs `command` in the background.

## Sourcing Files --------------------------------------------------------------

```bash
    . file
```

or

```bash
    source file
```

- Executes a script within the current shell environment.
