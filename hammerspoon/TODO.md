# TODO

---

## STYLING (to be fully implemented):

- snake_case for variables/functions.
- UPPER_CASE for constants.
- PascalCase for classes.
- __snake_case for private/hidden variables.

---

## BUGS:

- When unplugging or plugging in a new display, it breaks the coords of the
  shader that was on the original display.

- LOOK INTO: if MACOS system apps like 'system settings' will cause problems
  trying to snap into dimensions that aren't supported.

---

## Modules:

- Restructure state.wins and state.app_wins into one table 'wins.all' and
  'wins[app]'. Also restructure such that each table contains its win idx.

- Set up window open/closed fns that update state.wins when windows are
  opened, closed, focused (through either kb, or click).

- Look into creating a window watcher that updates state/cache when windows
  are opened/closed.

- Research automatically setting up 'brave://settings/system/shortcuts'.

- Certain kitty actions are temporarily commented out in the registry.

- Work on refactoring the registry structure to make bound keys easier to
  read/manage.

- Sync popups.show() with the current screen (i.e. showing a popup for an app
  with windows on each screen is inconsistent, sometimes appears on the
  unfocused window).

- Consider binding 'escape' to temporary_insert() and (cancel|exit) to the same
  key as launch_menu().

- Might need to change window z-index level when exiting from fullscreen.
  (suppose we are moving the divider but the other forefront window is
  incompantible/untracked).

- Create a simple (y/n) confirmation popup module for certain actions
  (i.e. quit app).

- Integrate popup (x, y) with screen state and temporary_insert popup x, y.

- temporary_insert() needs to signify that it's active in state otherwise
  relaunching the menu without unbinding 'enter' and 'escape' will get weird.

- When entering fullscreen let's see if it's possible to apply the shader value
  to the fullscreen 'workspace' (or whatever mac calls it).

- Add 'on_click' (needs to be mouse up not mouse down evt) and 'focus ?' events
  to ensure state.curr_win is changed when required.

- Update cache when screens are connected/disconnected. Also check if the 'id'
  remains the same and if not look into using 'UUID' instead.

- In 'launch_menu()' need to check if focused window is fullsceen (exit
  fullsceen if it is).

- Implement an 'expand/collapse' binding for each popup (make it stateful so we
  don't need to keep hiding unwanted popups).

- Incorporate base 'layouts'.
  (set the divider value to 0.35, 0.65, or 0.5 to emulate thirds/half layouts).

---

## Misc:

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

- Consider sending a singe 'escape' keystoke before launching which_key.
  This would exit apps in fullscreen mode and set a semi consistent ui state
  in broswers etc.

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

## Vivi

- Need to add vivi_modules routes to package path in '~/.hammerspoon'
- Slight refactor and modernization.
