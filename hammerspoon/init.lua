-- My guiding moonlight. --

-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://www.lua.org/pil/contents.html
-- https://www.lua.org/
-- https://ebens.me/post/lua-for-programmers-part-1/

-- A young intelligent turtle
-- Found programming Unix a hurdle

------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------
-- Mouse control module.
-----------------------------------------------------------------------------------------------

-- local vimouse = require('vimouse')
-- vimouse({'ctrl', 'alt'}, 'o')
-- hs.hid.capslock.set(false)

-- local m = require('module_routes')
-- -- m.ScreenWatcher:initiate(m.AppGrid, m.ScreenGrid, m.Var)



-- function toggleScreenWatcher(event)
--     if event == hs.caffeinate.watcher.screensDidLock then
--         m.ScreenWatcher:terminate()
--         toggleWifi()
--     elseif event == hs.caffeinate.watcher.screensDidUnlock then
--         -- Restart the screen watcher when system wakes from sleep.
--         local screenWatcherWakeUpDelay = hs.timer.delayed.new(2, function()
--             m.ScreenWatcher:initiate(m.AppGrid, m.ScreenGrid, m.Var)
--         end)
--         screenWatcherWakeUpDelay:start()
--         toggleWifi()
--     end
-- end
-- gridWatcher = hs.caffeinate.watcher.new(toggleScreenWatcher)
-- gridWatcher:start()



-- function testf()
--     print('layout changed')
-- end
-- testw = hs.screen.watcher.new(testf)
-- -- testw = hs.screen.watcher.newWithActiveScreen(testf)
-- testw:start()



-----------------------------------------------------------------------------------------------
-- Display a notification when a copy event occurs.
-----------------------------------------------------------------------------------------------

-- local lastPasteboardChangeCount = hs.pasteboard.changeCount()
-- local eventTypes = hs.eventtap.event.types

-- local function hasPasteboardChanged()
--     local currentChangeCount = hs.pasteboard.changeCount()
--     return currentChangeCount ~= lastPasteboardChangeCount
-- end

-- local pasteboardWatcher = hs.eventtap.new({eventTypes.keyUp, eventTypes.flagsChanged}, function(event)
--     local code = event:getKeyCode()
--     local keycodes = hs.keycodes.map
--     local flags = event:getFlags()
--     if code == keycodes['c'] and flags.cmd then
--         if hasPasteboardChanged() then
--             hs.alert('COPY', 0.4)
--         end
--         lastPasteboardChangeCount = hs.pasteboard.changeCount() -- Update the last change count
--     end
-- end)
-- pasteboardWatcher:start()



-----------------------------------------------------------------------------------------------
-- Turn off bluetooth when system goes to sleep.
-----------------------------------------------------------------------------------------------

local function toggleWifi()
    local currentStatus = hs.wifi.interfaceDetails().power
    hs.wifi.setPower(not currentStatus)
end

-- Print the error message if command fails to execute.
-- function checkBluetoothResult(rc, stderr, stderr)
function checkBluetoothResult(rc, stderr)
    if rc ~= 0 then
        print(string.format('Unexpected result executing `blueutil`: rc=%d stderr=%s stdout=%s', rc, stderr, stdout))
    end
end

function bluetooth(power)
    print('Setting bluetooth to ' .. power)
    local t = hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult, {'--power', power})
    t:start()
end

function f(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        toggleWifi()
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
        toggleWifi()
    end

    if event == hs.caffeinate.watcher.systemWillSleep then
        bluetooth('off')
    elseif event == hs.caffeinate.watcher.screensDidWake then
        bluetooth('on')
        hs.alert('Bluetooth is connected.')
    end
end
watcher = hs.caffeinate.watcher.new(f)
watcher:start()

        -- -- Restart the screen watcher when system wakes from sleep.
        -- local screenWatcherWakeUpDelay = hs.timer.delayed.new(5, function()
        --     m.ScreenWatcher:initiate(m.AppGrid, m.ScreenGrid, m.Var)
        -- end)
        -- screenWatcherWakeUpDelay:start()



-----------------------------------------------------------------------------------------------
-- Applies darkmode to the HS console.
-----------------------------------------------------------------------------------------------

hs.console.darkMode(true)
if hs.console.darkMode() then
    hs.console.consoleFont({ name = 'Courier', size = 20 })
    hs.console.consoleCommandColor({ blue = 1 })
    hs.console.consoleResultColor({ red = 1 })
    hs.console.windowBackgroundColor({ white = 0 })
    hs.console.inputBackgroundColor({ white = 0 })
    hs.console.outputBackgroundColor({ white = 0 })
    hs.console.consolePrintColor({ white = 1 })
    hs.console.alpha(1)
end
hs.console.clearConsole()

-- function showConsoleIfNeeded()
--     -- local console = hs.console.getConsole()
--     local console = hs.console.hswindow()
--     if not console or not console:isVisible() then
--         hs.openConsole()
--     end
-- end
-- showConsoleIfNeeded()



-----------------------------------------------------------------------------------------------
-- Command-Q delay on quitting an application (also resets zlite fetch throttle state).
-----------------------------------------------------------------------------------------------

-- local function resetZliteFetchState()
--     local filePath = os.getenv('HOME') .. '/.throttleZliteFetch'
--     local fileExists = hs.fs.attributes(filePath) ~= nil
--     if fileExists then
--         os.execute('rm -f ' .. filePath)
--         print('zlite fetch state reset.')
--     else
--         print('No fetch state file found.')
--     end
-- end

local cmdQDelay = 0.75
local cmdQTimer = nil
local cmdQAlert = nil

local function cmdQCleanup()
    hs.alert.closeSpecific(cmdQAlert)
    cmdQTimer = nil
    cmdQAlert = nil
    -- if app then
        -- local appName = app:name()
        -- if appName == 'kitty' then
        --     resetZliteFetchState()
        -- end
    -- end
end

local function stopCmdQ()
    if cmdQTimer then
        cmdQTimer:stop()
        cmdQCleanup()
        hs.alert('Cancelled', 0.5)
    end
end

local function startCmdQ()
    local app = hs.application.frontmostApplication()
    cmdQTimer = hs.timer.doAfter(cmdQDelay, function() app:kill(); cmdQCleanup() end)
    cmdQAlert = hs.alert('Hold to Quit ' .. app:name(), true)
end

hs.hotkey.bind({'cmd'}, 'q', startCmdQ, stopCmdQ)

-- local cmdQ = hs.hotkey.bind({'cmd'}, 'q', startCmdQ, stopCmdQ)



-----------------------------------------------------------------------------------------------
-- Auto reloads HS configuration on document save, also updates the markdown preview in
-- VSCode when its associated CSS file is.
-----------------------------------------------------------------------------------------------

local function reloadConfig(files)
    local doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
hs.alert.show('🔨🥄')


-- hsConfigWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

-- Announcer for Hammerspoon.
speaker = hs.speech.new()
speaker:speak('Ready to rock')




-----------------------------------------------------------------------------------------------

-- function sendKeystroke(modifiers, character)
--     local event = require("hs.eventtap").event
--     event.newKeyEvent(modifiers, string.lower(character), true):post()
--     event.newKeyEvent(modifiers, string.lower(character), false):post()
-- end

-- -- The path to the CSS file is also stored in VScodes settings.json, so if the path changes it will need to be updated there too.
-- function markdownCSSpreviewUpdate(files)
--     for _,file in pairs(files) do
--         if file:sub(-4) == '.css' then
--             hs.alert.show('Markdown styling preview updated!', 0.7)
--             sendKeystroke({'alt'}, '8')
--         end
--     end
-- end
-- mdCssWatcher = hs.pathwatcher.new('/Users/tillcappel/Desktop/SWE-Projects/Notes/', markdownCSSpreviewUpdate):start()

-----------------------------------------------------------------------------------------------

-- -- Automatically move screenshots to the notes/images folder for easy notes integration.
-- function moveScreenshots(files)
--     for _,file in ipairs(files) do
--         -- Check if the file is a screenshot.
--         if file:match('Screenshot') then
--             -- Rename the file to remove spaces.
--             local newFilename = file:gsub("%s+", "-")
--             os.rename(file, newFilename)

--             -- Move the file to the specified directory.
--             hs.execute("mv '" .. newFilename .. "' /Users/tillcappel/Desktop/SWE-Projects/Notes/images/")

--             -- Copy the filename to the clipboard and format it for markdown preview in VSCode.
--             local filename = newFilename:match(".+/([^/]+)")
--             hs.pasteboard.setContents("![Alt text](images/" .. filename .. ")")
--         end
--     end
-- end
-- -- Watch the desktop for new screenshots.
-- moveSC = hs.pathwatcher.new('/Users/tillcappel/Desktop/', moveScreenshots):start()

-- -- Copy the file name to clipboard.
-- hs.execute("echo '" .. file .. "' | pbcopy")

-----------------------------------------------------------------------------------------------

-- local firefoxToggle = 0
-- -- This function focuses all open Firefox windows.
-- function focusAllWindows(app)
--     hs.application.launchOrFocus(app)
--     local app = hs.application.get(app)

--     if app ~= nil then
--         local windows = app:allWindows()
--         firefoxToggle = firefoxToggle + 1

--         if firefoxToggle % 2 ~= 0 then
--             table.sort(windows, function(a, b) return a:id() > b:id() end)
--         else
--             table.sort(windows, function(a, b) return a:id() < b:id() end)
--         end

--         for i, window in ipairs(windows) do
--             window:focus()
--             frame = window:frame()
--             hs.mouse.absolutePosition(frame.center)
--         end
--     end
-- end
-- -- hs.hotkey.bind(capsHeld, 'o', function() focusAllWindows('Firefox') end)

--     -- local frontmostApp = hs.application.frontmostApplication()
--     -- if frontmostApp:bundleID() == 'org.mozilla.firefox' then
--     --     -- print('oioi')
--     --     firefoxToggle = firefoxToggle + 1
--     -- end


-- firefoxToggle = 0
-- local evttype = event:getRawEventData()



-- local eventTypes = hs.eventtap.event.types
-- local keyWatcher4

-- keyWatcher4 = hs.eventtap.new({eventTypes.keyDown, eventTypes.flagsChanged}, function(event)
--     local code = event:getKeyCode()
--     local keycodes = hs.keycodes.map
--     local flags = event:getFlags()

--     if code == keycodes['c'] and flags.cmd then
--         print('hello')

--         -- if hasPasteboardChanged() then
--         --     hs.alert('COPY', 0.4)
--         -- end
--         -- lastPasteboardChangeCount = hs.pasteboard.changeCount() -- Update the last change count
--     end
-- end)
-- keyWatcher4:start()



-- hs.eventtap.keyStroke({"cmd"}, "c", 0) -- or whatever method you want to trigger the copy
-- hs.pasteboard.callbackWhenChanged(5, function(state)
--     if state then
--         local contents = hs.pasteboard.getContents()
--         -- do what you want with contents
--     else
--         error("copy timeout") -- or whatever fallback you want when it times out
--     end
-- end)



        -- for k, v in pairs(evttype) do
        --     for i, j in pairs(v) do
        --         print(i .. ' : ' .. j)
        --     end
            -- print(k)
            -- print(v)
        -- end

-----------------------------------------------------------------------------------------------



    -- -- Create a window filter to track focused window changes
    -- local wf = hs.window.filter.new()
    -- -- Function to handle focused window changes
    -- local function focusedWindowChangeHandler()
    --     -- Get the currently focused window
    --     local focusedWindow = wf:getWindows(wf.sortByFocusedLast)[1]
    --     -- Get the screen of the focused window
    --     local focusedScreen = focusedWindow:screen()
    --     -- Perform actions based on the focused screen
    --     if focusedScreen then
    --         print('Currently focused screen: ' .. focusedScreen:name())
    --     else
    --         print('No screen is currently focused.')
    --     end
    -- end
    -- -- Create a screen watcher and register the focused window change handler
    -- local screenWatcher = hs.screen.watcher.new(function()
    --     focusedWindowChangeHandler()
    -- end)
    -- screenWatcher:start()
    -- -- Initially, call the focused window change handler to get the currently focused screen
    -- focusedWindowChangeHandler()



-- local wf = hs.window.filter
-- function some_fn(win, evt)
--     print(win .. evt)
-- end

-- wfBase = wf.new{win_title}
-- wfBase:subscribe(wf.windowMoved, function() some_fn('VSCode ', 'moved.') end)
-- wfBase:subscribe(wf.windowFocused, function() some_fn('VSCode ', 'focused.') end)
-- wfBase = wf.new{'Code'}
-- local winTitlePattern = 'VSCode' -- Lua pattern matching the desired window title(s)

-- -- Iterate through existing windows to check if they match the title pattern
-- for _, win in ipairs(wfBase:getWindows()) do
--     if win:title():match(winTitlePattern) then
--         some_fn(win:application():name(), ' window matched the title pattern.')
--     end
-- end




-- local wf = hs.window.filter

-- function some_fn(win, evt)
--     -- local focusedWindow = hs.window.focusedWindow()
--     -- local win_title = focusedWindow:title()
--     print(win.w .. evt)
--     -- print(win_title)
-- end

-- local wfBase = wf.new():setFilters({ wf.focusCurrent })
-- wfBase:subscribe(wf.windowMoved, function(win) some_fn(win:frame(), ' window moved.') end)
-- -- wfBase:subscribe(wf.windowMoved, function(win) some_fn(win:application():name(), ' window moved.') end)
-- -- wfBase:subscribe(wf.windowFocused, function(win) some_fn(win:application():name(), ' window focused.') end)

-- wfBase:subscribe(wf.windowFocused, function(win)
--     some_fn(win:title(), ' window focused.')
-- end)



-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

-- -- Basic app launch or focus function.
-- function appLauncher(app)
--     hs.application.open(app, wait, true)

--     local startTime = hs.timer.secondsSinceEpoch()
--     local elapsedTime = 0
--     local targetApp = nil

--     repeat
--         targetApp = hs.application.get(app)
--         elapsedTime = hs.timer.secondsSinceEpoch() - startTime
--     until targetApp or elapsedTime >= 10

--     if targetApp then
--         targetApp:activate()
--         local newWindow = nil
--         startTime = hs.timer.secondsSinceEpoch()

--         repeat
--             hs.timer.usleep(100000) -- Wait for 100 milliseconds before checking again.
--             newWindow = targetApp:focusedWindow()
--         until newWindow or hs.timer.secondsSinceEpoch() - startTime >= 10

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

-----------------------------------------------------------------------------------------------
-- App quick launcher key bindings.
-----------------------------------------------------------------------------------------------

-- -- Focus any Firefox window with 'Developer' in the title.
-- function ffDevToolsFocus()
--     local wf = hs.window.filter
--     local firefoxFilter = wf.new(false):setAppFilter('Firefox', { allowTitles = 'Developer' })
--     local firefoxWindows = firefoxFilter:getWindows()
--     if #firefoxWindows > 0 then
--         firefoxWindows[1]:focus()
--     end
-- end
-- hs.hotkey.bind({'ctrl', 'shift'}, 'c', function() ffDevToolsFocus() end)








-- function checkVSCodeFocus()
--     local frontmostApp = hs.application.frontmostApplication()
--     -- if frontmostApp ~= nil and frontmostApp:bundleID() == 'com.microsoft.VSCode' then
--     if frontmostApp:bundleID() == 'com.microsoft.VSCode' then
--         print('y')
--     else
--         print('n')
--     end
-- end
-- hs.hotkey.bind({'ctrl', 'shift'}, ';', function() checkVSCodeFocus() end)

-- function sendKeystroke(modifiers, character)
--     local event = require('hs.eventtap').event
--     event.newKeyEvent(modifiers, string.lower(character), true):post()
--     event.newKeyEvent(modifiers, string.lower(character), false):post()
-- end

-- -- VSCode launcher function.
-- local vscodeToggle = 0
-- function vscodeLauncher(app)
--     local frontmostApp = hs.application.frontmostApplication()

--     if frontmostApp:bundleID() ~= 'com.microsoft.VSCode' then
--         hs.application.open(app, wait, true)
--         newWindow = hs.window.frontmostWindow()
--         frame = newWindow:frame()
--         hs.mouse.absolutePosition(frame.center)
--     elseif frontmostApp:bundleID() == 'com.microsoft.VSCode' then
--         vscodeToggle = vscodeToggle + 1
--     end

--     if vscodeToggle == 1 then
--         sendKeystroke({'ctrl', 'shift'}, '6') -- workbench.action.quickSwitchWindow.
--     elseif vscodeToggle > 1 then
--         sendKeystroke({'ctrl', 'shift'}, '7') -- Navigate next in quick open.
--     end
-- end
-- -- hs.hotkey.bind(capsHeld, 'k', function() vscodeLauncher('Visual Studio Code') end)
