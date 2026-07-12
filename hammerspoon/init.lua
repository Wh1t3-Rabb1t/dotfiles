-- My guiding moonlight

-- https://www.lua.org/
-- https://www.lua.org/pil/contents.html
-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://learnhammerspoon.com/

require('keymaps')
require('console')
require('announcer')
-- require('watchers')



-- local shader = require('shaders')

local state = require('state')
local layout = require('layout')
local menu_assets = require('menu_caching')


-- Binding popup menu
--------------------------------------------------------------------------------
local sys_menu = require('sys_menu')

-- Initialize state if necessary
hs.hotkey.bind({ 'ctrl' }, 'f', function()
    local screen = hs.screen.mainScreen()
    local id = screen:id()

    if not state.layout.screens[id] then
        layout.init()
    end

    if not state.assets.tap or not state.assets.system then
        menu_assets.init()
    end


    --
    -- TODO: add check to see if the focused app is compatible and if so; does it's
    -- cache exist
    --


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
