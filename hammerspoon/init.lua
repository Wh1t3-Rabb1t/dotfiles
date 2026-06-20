-- My guiding moonlight

-- https://www.hammerspoon.org/docs/index.html
-- https://www.hammerspoon.org/docs/hs.html
-- https://www.lua.org/
-- https://www.lua.org/pil/contents.html


-- Toggle wifi on/off when locking screen
--------------------------------------------------------------------------------
function f(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        hs.wifi.setPower(false)
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
        hs.wifi.setPower(true)
    end

    -- if event == hs.caffeinate.watcher.systemWillSleep then
    --     bluetooth('off')
    -- elseif event == hs.caffeinate.watcher.screensDidWake then
    --     bluetooth('on')
    --     hs.alert('Bluetooth is connected.')
    -- end

end
watcher = hs.caffeinate.watcher.new(f)
watcher:start()


-- Apply darkmode to the HS console
--------------------------------------------------------------------------------
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
--     local console = hs.console.hswindow()
--     if not console or not console:isVisible() then
--         hs.openConsole()
--     end
-- end


-- Command-Q delay on quitting an application
--------------------------------------------------------------------------------
local cmdQDelay = 0.75
local cmdQTimer = nil
local cmdQAlert = nil

local function cmdQCleanup()
    hs.alert.closeSpecific(cmdQAlert)
    cmdQTimer = nil
    cmdQAlert = nil
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
    cmdQAlert = hs.alert('Hold to Quit: ' .. app:name(), true)
end

hs.hotkey.bind({'cmd'}, 'q', startCmdQ, stopCmdQ)


-- Auto reloads HS configuration on document save
--------------------------------------------------------------------------------
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

hs.pathwatcher.new(os.getenv('HOME') .. '/.local/dotfiles/hammerspoon/', reloadConfig):start()
hs.alert.show('🔨🥄')



-- Announcer for Hammerspoon
--------------------------------------------------------------------------------
-- speaker = hs.speech.new()
-- speaker:speak('Ready to rock')


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


-- -- Turn off bluetooth when system goes to sleep
-- --------------------------------------------------------------------------------
-- -- Print the error message if command fails to execute.
-- -- function checkBluetoothResult(rc, stderr, stderr)
-- function checkBluetoothResult(rc, stderr)
--     if rc ~= 0 then
--         print(string.format('Unexpected result executing `blueutil`: rc=%d stderr=%s stdout=%s', rc, stderr, stdout))
--     end
-- end
--
-- function bluetooth(power)
--     print('Setting bluetooth to ' .. power)
--     local t = hs.task.new('/opt/homebrew/bin/blueutil', checkBluetoothResult, {'--power', power})
--     t:start()
-- end


-- -- Automatically move screenshots to the notes/images folder
-- --------------------------------------------------------------------------------
-- function moveScreenshots(files)
--     for _,file in ipairs(files) do
--         if file:match('Screenshot') then
--             -- Rename the file to remove spaces
--             local newFilename = file:gsub("%s+", "-")
--             os.rename(file, newFilename)
--
--             -- Move the file to the specified directory
--             hs.execute("mv '" .. newFilename .. "' /Users/tillcappel/Desktop/SWE-Projects/Notes/images/")
--
--             -- Copy filename to the clipboard and format it for markdown preview in VSCode
--             local filename = newFilename:match(".+/([^/]+)")
--             hs.pasteboard.setContents("![Alt text](images/" .. filename .. ")")
--         end
--     end
-- end
-- -- Watch the desktop for new screenshots
-- moveSC = hs.pathwatcher.new('/Users/tillcappel/Desktop/', moveScreenshots):start()
--
-- -- Copy the file name to clipboard
-- hs.execute("echo '" .. file .. "' | pbcopy")


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
