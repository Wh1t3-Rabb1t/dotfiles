# Recursive Globbing (**)

- Examples:

## 1. Finding All .txt Files

```sh
# Directory structure:
.
├── file1.txt          # Matched
├── dir1
│   ├── file2.txt      # Matched
│   ├── subdir
│   │   ├── file3.txt  # Matched
│   │   ├── file4.log
│   ├── script.sh
├── dir2
│   ├── file5.txt      # Matched
│   ├── another.log

echo **/*.txt
```

Matches:

```sh
file1.txt
dir1/file2.txt
dir1/subdir/file3.txt
dir2/file5.txt
```

## 2. Matching Only Files in the First Level of Subdirectories

```sh
# Directory structure:
.
├── file1.txt
├── dir1
│   ├── file2.txt       # Matched
│   ├── subdir
│   │   ├── file3.txt
│   │   ├── file4.log
│   ├── script.sh       # Matched
├── dir2
│   ├── file5.txt       # Matched
│   ├── another.log     # Matched

# */ matches only one level deep (direct children of .)
echo */*.txt
```

Matches:

```sh
dir1/file2.txt
dir2/file5.txt
```

## 3: Finding All Executable Files Recursively

```sh
# Directory structure:
.
├── script.sh          # Matched (if executable)
├── dir1
│   ├── run.sh         # Matched (if executable)
│   ├── subdir
│   │   ├── start.sh   # Matched (if executable)
│   │   ├── readme.md
│   ├── config.json
├── dir2
│   ├── main.sh        # Matched (if executable)

# **/*(x) finds all files recursively (**/*)
# (x) filters only executable files (Zsh qualifier)
echo **/*(x)
```

Matches (only if they have execute permission):

```sh
script.sh
dir1/run.sh
dir1/subdir/start.sh
dir2/main.sh
```

## 4: Finding Empty Directories (/^ for non-empty)

```sh
# Directory structure:
.
├── dir1
│   ├── subdir1       # Matched
│   ├── subdir2
│   │   ├── file.txt
├── dir2
│   ├── emptydir      # Matched

# **/*(/) finds all directories
# (/^ ) filters only empty directories
echo **/*(/^)
```

Matches:

```sh
dir1/subdir1
dir2/emptydir
```

## 5: Finding Symlinks

```sh
# Directory structure:
.
├── link1 -> /some/path           # Matched
├── dir1
│   ├── subdir
│   │   ├── link2 -> ../file.txt  # Matched
│   ├── link3 -> /bin/bash        # Matched
│   ├── script.sh

# **/*(@) finds all symbolic links recursively
echo **/*(@)
```

Matches:

```sh
link1
dir1/subdir/link2
dir1/link3
```

## 6: Finding Non-Text Files

```sh
# Directory structure:
.
├── file1.txt
├── image.png      # Matched
├── dir1
│   ├── photo.jpg  # Matched
│   ├── script.sh
├── dir2
│   ├── video.mp4  # Matched

# **/*.(^(txt|md)) matches all files
# ^(txt|md) excludes .txt and .md files (Zsh negation syntax)
echo **/*.^(txt|md)
```

Matches:

```sh
image.png
dir1/photo.jpg
dir2/video.mp4
```

