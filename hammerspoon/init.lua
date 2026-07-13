-- My guiding moonlight

-- https://www.lua.org/
-- https://www.lua.org/pil/contents.html
-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://learnhammerspoon.com/


require('console').init()
require('announcer').init()
require('wifi').init()


-- local bluetooth = require('bluetooth')
-- bluetooth.init()



local state = require('state')
local cache = require('cache')
local layout = require('layout')
local qtimer = require('quit_timer')
local sys_menu = require('sys_menu')
local popups = require('popups')

local bk = hs.hotkey.bind

-- Hot reload hammerspoon
bk({ 'ctrl', 'shift' }, 'r', function() hs.reload() end)

-- Command-Q delay on quitting an application
bk({ 'cmd' }, 'q', qtimer.start_cmd_q, qtimer.stop_cmd_q)



-- SYSTEM BINDINGS:
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




-- Binding popup menu
bk({ 'ctrl' }, 'f', function()
    local function initialized(t)
        local done = false
        if type(t) == 'table' and next(t) ~= nil then
            done = true
        end
        return done
    end

    -- Init layout module if required
    if not initialized(cache.screens) or
       not initialized(state.screens) or
       not initialized(state.menu)
    then
        layout.init()
    end

    -- Init menu module if required
    if not initialized(cache.assets) or
       not initialized(cache.lookup)
    then
        popups.init()
    end

    sys_menu.launch_menu()
end)





-- -- Display a notification when a copy event occurs
-- --------------------------------------------------------------------------------
-- local lastPasteboardChangeCount = hs.pasteboard.changeCount()
-- local eventTypes = hs.eventtap.event.types
--
-- local function hasPasteboardChanged()
--     local currentChangeCount = hs.pasteboard.changeCount()
--     return currentChangeCount ~= lastPasteboardChangeCount
-- end
--
-- local pasteboardWatcher = hs.eventtap.new({eventTypes.keyUp, eventTypes.flagsChanged}, function(event)
--     local code = event:getKeyCode()
--     local keycodes = hs.keycodes.map
--     local flags = event:getFlags()
--     if code == keycodes['c'] and flags.cmd then
--         if hasPasteboardChanged() then
--             hs.alert('COPY', 0.4)
--         end
--         lastPasteboardChangeCount = hs.pasteboard.changeCount()  -- Update the last change count
--     end
-- end)
-- pasteboardWatcher:start()



-- -- Basic app launch or focus function
-- --------------------------------------------------------------------------------
-- function appLauncher(app)
--     hs.application.open(app, wait, true)
--
--     local startTime = hs.timer.secondsSinceEpoch()
--     local elapsedTime = 0
--     local targetApp = nil
--
--     repeat
--         targetApp = hs.application.get(app)
--         elapsedTime = hs.timer.secondsSinceEpoch() - startTime
--     until targetApp or elapsedTime >= 10
--
--     if targetApp then
--         targetApp:activate()
--         local newWindow = nil
--         startTime = hs.timer.secondsSinceEpoch()
--
--         repeat
--             hs.timer.usleep(100000) -- Wait for 100 milliseconds before checking again.
--             newWindow = targetApp:focusedWindow()
--         until newWindow or hs.timer.secondsSinceEpoch() - startTime >= 10
--
--         if newWindow then
--             local frame = newWindow:frame()
--             hs.mouse.absolutePosition(frame.center)
--         else
--             print('Timeout: No window found within 10 seconds for: ' .. app)
--         end
--     else
--         print('Timeout: ' .. app .. ' did not open within 10 seconds.')
--     end
-- end
-- hs.hotkey.bind(capsHeld, 'h', function() hs.toggleConsole() end) -- Hammerspoon console.
-- hs.hotkey.bind(capsHeld, 'a', function() appLauncher('Activity Monitor') end)
-- hs.hotkey.bind(capsHeld, 'd', function() appLauncher('Dictionary') end)
-- hs.hotkey.bind(capsHeld, 'n', function() appLauncher('Notes') end)
