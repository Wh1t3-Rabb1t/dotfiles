# TODO

## Misc

- Implements shaders, and window management under a centralized toggle switch
  in a similar fashion to vivi. Use hs.canvas to display all bound keys
  (i.e. which-key).

- Re-incorporate bluetooth watcher.

- Add to zsh deploy script:
```lua
--
-- Write this to "~/.hammerspoon/init.lua"
--
local config_dir = os.getenv('HOME') .. '/.local/dotfiles/hammerspoon/'
local module_dir = config_dir .. 'modules/?.lua'
local user_dir   = config_dir .. 'core/?.lua'

local pkgs = ';' .. module_dir .. ';' .. user_dir

-- Read from linked dotfiles and update package path
if config_dir then
    package.path = package.path .. pkgs
    dofile(config_dir .. 'init.lua')
end
```

---

## Brightness module

- Find appropriate key bindings.
- Implement key repeating.

---

## Vivi

- Need to add vivi_modules routes to package path in '~/.hammerspoon'
- Slight refactor and modernization.
