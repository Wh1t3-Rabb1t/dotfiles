# TODO

## STYLING (to be fully implemented):

- snake_case for variables/functions.
- UPPER_CASE for constants.
- PascalCase for classes.
- __snake_case for private/hidden variables.

---

## BUGS:

- There is some bug when using uppercase letters as bindings in sys_menu.

- When unplugging or plugging in a new display, it breaks the coords of the
  shader that was on the original display.

- LOOK INTO: if MACOS system apps like 'system settings' will cause problems
  trying to snap into dimensions that aren't supported.

---

## Modules:

- Currently all sys_menu fns have been changed from local to part of the
  module object. (change select functions back to local wherever possible).

- Cache the popup dimensions (w, h).

- Integrate state.overlays etc with layout.screens.
```lua
    if not state.overlays[id] then
init_overlay(screen, id)
    end
    ```

---

## Layout module:

- Incorporate base 'layouts'.
  (set the divider value to 0.35, 0.65, or 0.5 to emulate thirds/half layouts).

- Might need to change window z-index level when exiting from fullsceen.
  (suppose we are moving the divider but the other forefront window is
  incompantible/untracked).

- Key repeating when moving the divider.

- Implement move window to adjacent screen fn.

- Move to sys_menu popup (if not screen_id then init):
```lua
local layout = require('layout')
layout.init()
```

- Determine if 'layout.init' should be called on init, or only
  when a new window is launched / focused.

---

## Misc

- Incorporate the table of 'supported_apps' into the each of their respective
  bindings array i.e.
```lua
local bindings = {
    ['Brave Browser'] = {
        {
            key = ';',
            desc = 'Tab right',
            action = function() M.send_keys('pagedown', 'ctrl') end
        },
        -- ...
    },
    ['System'] = {
        {
            key = 'h',
            desc = 'Tab left',
            action = function() M.send_keys('pageup', 'ctrl') end
        },
        -- ...
    },
}
```

- Need to incorporate a robust event queue for key inputs.
  (when sending key stokes while the tap is active).

- We can remove all x y coord logic from canvas creation, and instead build
  a helper function that determines focused app then passes coords to
  'popup:topLeft(coords)' when launching the popup.

- When displaying the app/system canvas bindings side by side we should center
  the app specific canvas in the center of said app, and put the system canvas
  on the opposite side of the screen.
  Can use this method to display the canvas at given coords:
  ```lua
  asset.popup:topLeft({ x = 10, y = 10 })
  ```

- Example canvas:
  ```sh
  # +------------------------------+  +------------------------+
  # | [k] kitty  [i] Brave         |  | System bindings        |
  # | ---------------------------- |  | ---------------------- |
  # | [c] Copy to sys clipboard    |  | [U] Brightness (up)    |
  # | [x] Cut to sys clipboard     |  | [D] Brightness (down)  |
  # | [v] Paste from sys clipboard |  | [P] Brightness (print) |
  # +------------------------------+  +------------------------+
  ```

- Look into the use of:
  ```lua
  popup:delete()
  -- vs
  popup:hide()
  ```

- Emulate 'which-key' from the perspective of keypresses expanding sub menus.
  Pressing the modal key would always return to the top level menu,
  but holding the modifier would return to the previous sub menu.

- Break the menu trigger up into modal and when modifier is held (or both).

- Consider sending a singe 'escape' keystoke before launching sys_menu.
  This would exit apps in fullscreen mode and set a semi consistent ui state
  in broswers etc.

- Build out functionality for sys_menu that send given keystrokes when
  certain apps are focused; i.e. if a browser is focused, we can send it's
  default tab switching bindings etc. This way we can build out an interactive
  "cheat sheet" of important hotkeys and drop karabiner altogether.

- Re-incorporate bluetooth watcher.

- Add to zsh deploy script:
```lua
--
-- Write this to "~/.hammerspoon/init.lua"
--
local config_dir = os.getenv('HOME') .. '/.local/dotfiles/hammerspoon/'

local pkgs = {
    config_dir .. '?.lua',
    config_dir .. 'modules/?.lua',
    config_dir .. 'core/?.lua',
}

-- Read from linked dotfiles and update package path
if config_dir then
    package.path = package.path .. ';' .. table.concat(pkgs, ';')
    dofile(config_dir .. 'init.lua')
end
```

---

## Brightness module

- Implement key repeating.

---

## Vivi

- Need to add vivi_modules routes to package path in '~/.hammerspoon'
- Slight refactor and modernization.
