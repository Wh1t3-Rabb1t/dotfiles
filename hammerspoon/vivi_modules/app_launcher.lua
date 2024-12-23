
local Var = require('../vivi_modules/global_variables')
local eventTypes = hs.eventtap.event.types
-- local eventPropTypes = hs.eventtap.event.properties

local AppLauncher = {}

-- Basic app launch or focus function.
local function appLauncher(app)
    hs.application.open(app, wait, true)

    local startTime = hs.timer.secondsSinceEpoch()
    local elapsedTime = 0
    local targetApp = nil

    repeat
        targetApp = hs.application.get(app)
        elapsedTime = hs.timer.secondsSinceEpoch() - startTime
    until targetApp or elapsedTime >= 10

    if targetApp then
        targetApp:activate()
        local newWindow = nil
        startTime = hs.timer.secondsSinceEpoch()

        repeat
            hs.timer.usleep(100000) -- Wait for 100 milliseconds before checking again.
            newWindow = targetApp:focusedWindow()
        until newWindow or hs.timer.secondsSinceEpoch() - startTime >= 10

        if newWindow then
            local frame = newWindow:frame()
            hs.mouse.absolutePosition(frame.center)
        else
            print('Timeout: No window found within 10 seconds for: ' .. app)
        end
    else
        print('Timeout: ' .. app .. ' did not open within 10 seconds.')
    end
end

function AppLauncher:initiate()
    appLaunchWatcher = hs.eventtap.new({eventTypes.flagsChanged, eventTypes.keyUp, eventTypes.keyDown}, function(event)
        local flags = event:getFlags()
        local code = event:getKeyCode()

        -- local sideSpecificFlagCodes = {
        --   [55] = 'leftCmd',
        --   [58] = 'leftAlt',
        --   [59] = 'leftCtrl',
        --   [56] = 'leftShift',
        --   [54] = 'rightCmd',
        --   [61] = 'rightAlt',
        --   [62] = 'rightCtrl',
        --   [60] = 'rightShift',
        -- }

        -- if sideSpecificFlagCodes[code] then
        --     -- The bottom line will print the value eg. 'leftCmd'.
        --     -- print(sideSpecificFlagCodes[code])
        --     sideSpecificMod = sideSpecificFlagCodes[code]
        -- end
    end)
end

return AppLauncher

-- local capsHeld = {'ctrl', 'shift'}
-- hs.hotkey.bind(capsHeld, 'i', function() appLauncher('iTerm') end)
-- hs.hotkey.bind(capsHeld, 'n', function() appLauncher('Notes') end)
-- hs.hotkey.bind(capsHeld, 'm', function() appLauncher('Slack') end)
-- hs.hotkey.bind(capsHeld, 'l', function() appLauncher('Brave Browser') end)
-- hs.hotkey.bind(capsHeld, 'd', function() appLauncher('Dictionary') end)
-- hs.hotkey.bind(capsHeld, 'a', function() appLauncher('Activity Monitor') end)
-- hs.hotkey.bind(capsHeld, ';', function() appLauncher('VLC') end)
-- hs.hotkey.bind(capsHeld, 'b', function() appLauncher('Bitwarden') end)
-- hs.hotkey.bind(capsHeld, 'u', function() appLauncher('IINA') end)
-- hs.hotkey.bind(capsHeld, 'f', function() appLauncher('Finder') end)
-- hs.hotkey.bind(capsHeld, 'h', function() hs.toggleConsole() end) -- Hammerspoon console.
-- hs.hotkey.bind(capsHeld, '/', function() hs.reload() end) -- Hammerspoon reload.
