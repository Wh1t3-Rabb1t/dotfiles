# Redirection in Zsh

## General Syntax

- `> file`        stdout -> file (overwrite)
- `>> file`       stdout -> file (append)
- `2> file`       stderr -> file
- `&> file`       stdout + stderr -> file
- `> /dev/null`   Discard stdout
- `2> /dev/null`  Discard stderr
- `&> /dev/null`  Discard both
- `2>&1`          Redirect stderr to wherever stdout is going

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

- Capture stdout, silence stderr:
```sh
result=$(myfunc 2>/dev/null)
```

- Capture stderr only:
```sh
err_output=$(myfunc 2>&1 1>/dev/null)
```

- Safe fallback if stdout is empty:
```sh
json=$(fetch_data 2>/dev/null) || json="{}"
```
