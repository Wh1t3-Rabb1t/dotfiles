# TODO

---

## IMMEDIATE TASKS:

- Upgrade 'move_to_slot' fn to move window to the next screen if moving say;
  right from the right slot.

- See if I can consolidate the tab left/right bindings into a single key
  combo across apps without remapping browsers.

- Refactor the menus to support shift layer (when shift is pressed illuminate
  the shift bindings, when it is released illuminate the base layer etc).

- Add an 'Apple spotlight' send_keys binding that temporarily enters insert
  mode as a defacto means of launching 'any' app.

- Polish the 'cycle_main_apps' fn to drop the window filter (maybe just poll
  a launching application to wait for it's initial window to open).

- Track all keys currently bound and which are available for all
  (realistic) layers.

- Add 'leader' key support. Leader could function as a toggle between sending
  system and app specific keys. Also could do something like change the border
  color of say: 'kitty' when toggling between system and kitty binding layer.

- Create a command palette (fuzzy searchable). Track the number of executions
  for each action over time, then assign them a index that corresponds to keys
  ranked by easiest to hardest to hit (i.e. homerow keys are easier to hit
  than super + some_key etc).
  This would also paint a clear picture of which actions should be grouped
  together.

- Set up a path watcher for 'config.lua' (when its location is finalized)
  which will be responsible for dumping and re-initing assets.

- For the mouse.press / mouse.release fns:
  Add a differently colored circle which will display if a 'double-click' was
  invoked.

- Setup globals for values like 'step' when resizing windows etc. (make it easy
  to customize values like this in a central file).

- Add asserts to the top of each function call/relevant code section to check
  values passed etc are correct.

- Ensure that popups etc are either hidden/deleted in the appropriate places.

- Add a return flag to all fns processed by the action queue, so we can repeat
  the fn if it fails (or signals a repeat).

- Bind 'refresh_state' to a key so we could trigger it during runtime if
  something weird happens.

- In each init fn add a check to ensure that all preceding (required) modules
  have been initialized.

- Create an fzf popup launcher which takes the list of actions in and execs
  the selected one.

- Create a small debugging fn that prints all open windows along with their
  idx so we can sync focused win idx with state rather that falling back to 1.

- Incorporate documentation boilerplate somewhere:
  ```lua
  -- DESCRIPTION
  --
  -- Parameters:
  --   target (table | number):
  --     hs.window      (table):   Clear the slot assigned to this window
  --     hs.screen:id() (number):  Clear every slot on the screen with this ID
  --
  -- Notes:
  --   Empty slots are represented by false, not nil
  --
  -- Calls:
  --   clear_slots()
  --
  -- State changes:
  --   state.screens[id].layout.left
  --   state.screens[id].layout.right
  --   state.screens[id].layout.maximized
  --
  -- Errors:
  --   Assumes the target window's screen ID exists in state.screens
  --
  -- Returns:
  --   true  (bool):  win:frame() is equal to the usable screen frame
  --   false (bool):  win:frame() is NOT equal to the usable screen frame
  --------------------------------------------------------------------------------
  ```

---

## CONSIDERATIONS:

- Cleanup of state.screen_config[id] happens when a screen is disconnected.

- If an app remains open, but all of its windows are closed we should
  (possibly) still consider it an available window.

- Could distinguish between mouse and keyboard actions when snapping windows
  into slots (when resizing etc via the kb snapping occurs, with the mouse no
  snapping such as to not interfere with base OS behaviour, both could be
  toggled via an option).

- Should we remove everything but the keystroke fns from the event queue.

---

## STYLING (to be fully implemented):

- snake_case for variables/functions.
- UPPER_CASE for constants.
- PascalCase for classes.
- __snake_case for private/hidden variables.

---

## BUGS:

- When calling windows.init() with the desktop open; it causes an hs crash
  (attempted to index nil val 'win'). Could launch a kitty window as default.

- When unplugging or plugging in a new display, it breaks the coords of the
  shader that was on the original display.

- LOOK INTO: if MACOS system apps like 'system settings' will cause problems
  trying to snap into dimensions that aren't supported.

- Low priority: Passing an uppercase key along with 'shift' in the mod table
  breaks in the eventtap (shift should be assumed if passed twice. really shift
  should only be passed once in your own dotfiles you fkng bellend).

---

## Module todo:

- Re-implement lazy caching of screens/windows (need a watcher to check for
  changes even when the menu is not active).

- Maybe rm launch_or_focus(app) in favour of apple spotlight to launch apps.

- Name a kitty tab 'Broot' and create a bunch of modal bindings to send
  hard to remember actions. (if app == 'kitty' and win:title() == 'Broot').

- For 'Brave' we could create a 'cycle_focus' action that sends keystrokes to
  cycle focus between things like:
  ```txt
  Focus next pane                  Command Alt ArrowDown
  Focus previous pane              Command Alt ArrowUp
  Focus web contents pane
  ```

- Consider adding:
      Apple: (Spotlight|Dock)
      Volume: (Up|Down|Mute)
      Media: (Play/Pause)
      Toggle bluetooth
      Quit app

- Research automatically setting up 'brave://settings/system/shortcuts'.

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
