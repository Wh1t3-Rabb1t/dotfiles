# Globbing in Zsh

Globbing is the process of using wildcard patterns to match filenames in the shell. Unlike regular expressions, glob patterns are simpler and are interpreted directly by the shell.

## 1. Basic Wildcards

`*`                   Matches zero or more characters (excluding /)
`?`                   Matches exactly one character (excluding /)
`[abc]`               Matches one of the characters a, b, or c
`[a-z]`               Matches any one character in the given range (a to z)
`[!abc]` or `[^abc]`  Matches any character except a, b, or c

- Example:

```sh
echo *.txt            # Matches all .txt files in the current directory
echo file?.txt        # Matches file1.txt, file2.txt, but NOT file10.txt
echo file[1-3].txt    # Matches file1.txt, file2.txt, file3.txt
echo file[!1-3].txt   # Matches file4.txt, file5.txt (excludes 1-3)
```

## 2. Recursive Globbing (**)

`**`  Matches files and directories recursively

- Example:

```sh
echo **/*.txt         # Matches all .txt files in all subdirectories (Zsh)
shopt -s globstar     # Enable recursive globbing in Bash
echo **/*.txt         # Works in Bash after enabling
```

## 3. Extended Globbing

`?(pattern)`            Matches zero or one occurrences of pattern
`*(pattern)`            Matches zero or more occurrences of pattern
`+(pattern)`            Matches one or more occurrences of pattern
`@(pattern1|pattern2)`  Matches exactly one of the given patterns
`!(pattern)`            Matches anything except pattern

```sh
echo !(file).txt  # Matches all .txt files except "file.txt"
echo +(a|b)*.txt  # Matches files starting with "a" or "b", ending with ".txt"
echo *(a|b).txt   # Matches zero or more "a" or "b" followed by .txt
```

## 4. Qualifiers

Zsh supports qualifiers to filter results. They are appended after a glob pattern.

`/`  Matches directories
`.`  Matches regular files
`@`  Matches symbolic links
`*`  Matches executable files
`-`  Matches non-empty directories
`^`  Negates a qualifier

- Example:

```sh
echo **/*(/)   # Lists directories only
echo **/*(.)   # Lists regular files only
echo **/*(@)   # Lists symbolic links only
echo **/*(^/)  # Lists everything except directories
```

## 5. Null Globbing vs. Fail Globbing

- Example:

```sh
setopt NULL_GLOB
echo *.xyz  # Expands to nothing if no match is found
```
```sh
setopt FAIL_GLOB
echo *.xyz  # Errors out if no match is found
```

## 6. Hidden Files

By default, * does not match dotfiles.

```sh
setopt GLOB_DOTS  # Matches dotfiles
echo *
```

## 7. Numeric Globbing

Zsh allows numeric ranges in globs:

```sh
echo file<1-10>.txt   # Matches file1.txt to file10.txt
echo file<01-10>.txt  # Matches file01.txt to file10.txt
```

## 8. Case-Insensitive Globbing

```sh
setopt CASE_GLOB
echo *.TXT  # Matches both .txt and .TXT files
```

## 9. Brace Expansion (Not Globbing but Similar)

Brace expansion {} generates permutations, unlike globs.

```sh
echo file{1,2,3}.txt  # Expands to file1.txt file2.txt file3.txt
echo file{A..D}.txt   # Expands to fileA.txt fileB.txt fileC.txt fileD.txt
```
