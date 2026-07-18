-- My guiding moonlight

-- https://www.lua.org/
-- https://www.lua.org/pil/contents.html
-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://learnhammerspoon.com/

local state = require('state')
local cache = require('cache')

require('console').init()
require('announcer').init()
require('wifi').init()
require('screenshots').init()
require('quit_timer').init()


-- Hot reload hammerspoon
hs.hotkey.bind({ 'ctrl', 'shift' }, 'r', function()
    hs.reload()
end)


-- SYSTEM BINDINGS
---------------------------------
-- k - Focus kitty
-- i - Focus Brave
--
-- c - Copy to sys clipboard
-- x - Cut to sys clipboard
-- v - Paste from sys clipboard
--
-- (DON'T REQUIRE PRIME KB REAL ESTATE)
-- U - Brightness (up)
-- D - Brightness (down)
-- P - Brightness (print)
-- S - Apple spotlight
-- D - Apple dock
-- W - Toggle wifi
-- B - Toggle bluetooth
--
-- + - Zoom in
-- - - Zoom out
--
-- (requires confirmation)
-- W - Close tab
-- Q - Quit app




-- Organize by caching vs runtime functions:
--------------------------------------------
-- WINDOWS:
-- move_window_divider()
-- launch_or_focus()
-- swap_splits()
-- maximize_window()
-- close_menu()
-- send_keys()
--
-- SHADERS:
-- adjust_brightness()
-- print_values()
--
--
-- calc_popup_coords()
-- window_appeared()
-- window_side()
-- slot_frames()
-- snap_windows()
-- is_window_fullscreen()
-- usable_screen_frame()
-- create_overlay()


local sys_menu = require('sys_menu')

-- Binding popup menu
hs.hotkey.bind({ 'ctrl' }, 'f', function()
    local function initialized(t)
        local done = false
        if type(t) == 'table' and next(t) ~= nil then
            done = true
        end
        return done
    end

    -- Init windows module if required
    if not initialized(cache.screens) or
       not initialized(state.screens) or
       not initialized(state.menu)
    then
        require('windows').init()
    end

    -- Init menu module if required
    if not initialized(cache.assets) or
       not initialized(cache.lookup)
    then
        require('popups').init()
    end

    sys_menu.launch_menu()
end)
