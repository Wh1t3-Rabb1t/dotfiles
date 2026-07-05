
local qtimer = require('quit_timer')


local bk = hs.hotkey.bind

-- Hot reload hammerspoon
bk({ 'ctrl', 'shift' }, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({ 'cmd' }, 'q', qtimer.startCmdQ, qtimer.stopCmdQ)


-- Binding popup menu
--------------------------------------------------------------------------------
local sys_menu = require('sys_menu')
bk({ 'ctrl' }, 'f', function()
    sys_menu.launch_menu()
end)




-- (WIP) Layout module
local layout = require('layout')
layout.init()

bk({ 'alt' }, 'u', function()
    layout.launch_or_focus('kitty')
end)
bk({ 'alt' }, 'o', function()
    layout.launch_or_focus('Brave Browser')
end)

bk({ 'alt' }, 'i', function()
    layout.swap_window_slots()
end)
bk({ 'alt' }, 'l', function()
    layout.move_window_divider('right')
end)
bk({ 'alt' }, 't', function()
    layout.move_window_divider('left')
end)




---------------------------------
-- SYSTEM BINDINGS:
-- k - Focus kitty
-- i - Focus Brave
--
-- c - Copy to sys clipboard
-- x - Cut to sys clipboard
-- v - Paste from sys clipboard
--
--
-- (don't require prime kb real estate)
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




---------------------------------
-- APP SPECIFIC KEY REDIRECTS:


---------------------------------
-- WINDOW MANAGEMENT:
--
-- * Each screen is broken into two 'slots'
-- * When focusing an app that is behind another window if it is bigger
--   or smaller than the window alignment column, snap it into place.
--
-- t - Move window into left slot
-- l - Move window into right slot
-- T - Re-align slot left  (move 'line' between windows left)
-- L - Re-align slot right  (move 'line' between windows right)
--
-- S - Swap window slots (swap window left/right positions)
--
-- N - Send window to the next display
-- M - Fullscreen window
