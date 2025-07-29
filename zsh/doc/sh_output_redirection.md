# Redirection in Zsh

## General Syntax

- `> file`                       stdout -> file (overwrite)
- `>> file`                      stdout -> file (append)
- `2> file`                      stderr -> file
- `&> file`                      stdout + stderr -> file
- `> /dev/null`                  Discard stdout
- `2> /dev/null`                 Discard stderr
- `&> /dev/null`                 Discard both
- `2>&1`                         Redirect stderr to wherever stdout is going

## Heredocs & Herestrings

- Pass a string as input to stdin:
```sh
cmd <<< "$input"
```

- Read multi-line input safely:
```sh
cat <<EOF > config.txt
key=value
another=true
EOF
```

## Examples

```sh
# Capture stdout (only stdout is captured)
var=$(cmd)
```

```sh
# Capture stdout, silence stderr
result=$(myfunc 2>/dev/null)
```

```sh
# Capture stderr only (swap streams before capture)
err_output=$(myfunc 2>&1 1>/dev/null)
```

```sh
# Safe fallback if stdout is empty
json=$(fetch_data 2>/dev/null) || json="{}"
```
