-- My guiding moonlight

-- https://www.lua.org/
-- https://www.lua.org/pil/contents.html
-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://learnhammerspoon.com/

require('console').init()
require('announcer').init()
require('wifi').init()
require('screenshots').init()
require('quit_timer').init()


-- Hot reload hammerspoon
hs.hotkey.bind({ 'ctrl', 'shift' }, 'r', function()
    hs.reload()
end)

-- Binding popup menu
hs.hotkey.bind({ 'cmd', 'ctrl', 'alt', 'shift' }, 'space', function()
    require('caching').init()
    require('which_key').launch_menu()
end)


-- SYSTEM BINDINGS
---------------------------------
-- c  -  Copy to sys clipboard
-- x  -  Cut to sys clipboard
-- v  -  Paste from sys clipboard
--
-- (DON'T REQUIRE PRIME KB REAL ESTATE)
-- U  -  Brightness (up)
-- D  -  Brightness (down)
-- P  -  Brightness (print)
-- S  -  Apple spotlight
-- D  -  Apple dock
-- W  -  Toggle wifi
-- B  -  Toggle bluetooth
--
-- +  -  Zoom in
-- -  -  Zoom out
--
-- (requires confirmation)
-- W  -  Close tab
-- Q  -  Quit app




-- Organize by caching vs runtime functions:
--------------------------------------------
-- WINDOWS:
--   resize_splits()
--   launch_or_focus()
--   swap_splits()
--   maximize_window()
--
--   -- LOCALS --
--   get_window_side()
--   get_split_coords
--   snap_windows()
--   is_window_fullscreen()
--   get_window_layout()
--
--
-- WHICH_KEY:
--   get_popup_coords()
--   close_menu()
--   send_keys()
--   show_popups()
--
-- SHADERS:
-- adjust_brightness()
-- print_values()
--
--
--
-- slot_frames()
-- usable_screen_frame()
-- create_overlay()
