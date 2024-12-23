
-- -- Prints the name of the focused app or window.
-- print(focusedWindow:application():name())
-- local focusedWin = hs.window.focusedWindow():application():name()
-- print(focusedWin)


-- -- Print keycode to the console when a keydown event occurs.
-- function printKeyCode(event)
--     print(event:getKeyCode())
-- end
-- eventTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, printKeyCode)
-- eventTap:start()

-- -- Print the frame width of the currently focused window.
-- local focusedWindow = hs.window.focusedWindow()
-- if focusedWindow then
--     local frame = focusedWindow:frame()
--     print(frame.h)
--     -- print(frame.w)
-- else
--     print("No focused window.")
-- end


-- -- Check the event type of a mouse event when posted.
-- function checkMouseEvent()
--     -- eventWatcher = hs.eventtap.new({ eventTypes.leftMouseDown, eventTypes.leftMouseUp, eventTypes.leftMouseDragged }, function(event)
--     eventWatcher = hs.eventtap.new({ eventTypes.leftMouseDown, eventTypes.leftMouseUp }, function(event)
--         local mEvt = event:getType()
--         if mEvt == 1 then
--             print('Mouse Down')
--         elseif mEvt == 2 then
--             print('Mouse Up')
--         elseif mEvt == 6 then
--             print('Mouse Dragging')
--         end
--     end)
--     eventWatcher:start()
-- end


-- -- If a window is focused retrieve the name and disable mouseDown events if certain windows are focused.
-- if hs.window.focusedWindow() then
--     local focusedWin = hs.window.focusedWindow():application():name()
--     if focusedWin == 'Control Center'
--         or focusedWin == 'System Settings'
--         or focusedWin == 'Notification Center'
--     then
--         clickThrough = true
--     else
--         clickThrough = false
--     end
--     -- print(focusedWin)
-- end



-- Round a number either up or down to the nearest integer.
local function roundNumber(num)
    return math.floor(num + 0.5)
end


-- ! List all running processes.
local applications = hs.application.runningApplications()
for i, app in ipairs(applications) do
    local appName = app:name()
    local pid = app:pid()
    print('Application: ' .. appName)
    print('PID: ' .. pid)
    print('----------------------------------------------')
end



-- Callback function for screen layout changes
local function screenLayoutChangeHandler()
    local screens = hs.screen.allScreens()
    local screenCount = #screens
    print('Screen layout changed. Number of connected screens: ' .. screenCount)
end
-- Create a hs.screen watcher and register the callback function
-- local screenWatcher = hs.screen.watcher.new(screenLayoutChangeHandler)
-- screenWatcher:start()

-- Generate a random integer between two numbers.
local function randomInteger(min, max)
    -- Ensure min and max values are integers.
    min = math.floor(min)
    max = math.floor(max)
    -- Swap min and max values if necessary.
    if min > max then
        min, max = max, min
    end
    -- Generate the random integer within the range.
    return math.random(min, max)
end

-- Generate a random float between two numbers.
local function randomFloat(min, max)
    -- Generate the random float within the range.
    local randomNumber = min + math.random() * (max - min)
    -- Round the float to a maximum of 2 decimal places.
    local roundedNumber = math.floor(randomNumber * 100 + 0.5) / 100
    return roundedNumber
end


function getDockPosition()
    local dockPosition = ''
    local tmpFile = '/tmp/hs_dock_position.txt' -- Temporary file to store output.
    -- Execute the defaults read command and redirect output to the temporary file.
    local command = string.format('/usr/bin/defaults read com.apple.dock orientation > %s', tmpFile)
    local _, _, _, exitCode = hs.execute(command)
    if exitCode == 0 then
        -- Read the contents of the temporary file.
        local file = io.open(tmpFile, 'r')
        if file then
            dockPosition = file:read('*all'):gsub('%s+', '') -- Remove leading/trailing spaces.
            file:close()
        end
        -- Remove the temporary file.
        os.remove(tmpFile)
    else
        print('Failed to retrieve Dock position.')
    end
    return dockPosition
end
-- Call the function to retrieve the Dock position and save it to a variable.
-- local position = getDockPosition()
-- print('Dock position: ' .. position)




local n = 9
function factorial(n)
    if n <= 1 then
        return 1
    else
        return n * factorial(n - 1)
    end
end
function combination(n, r)
    return factorial(n) / (factorial(r) * factorial(n - r))
end
function uniqueDoubleLetterSequences(n)
    local numWaysToChooseTwoLetters = combination(n, 2)
    local numWaysToArrangeLetters = 2 -- There are two arrangements: letter1-letter2 and letter2-letter1
    return numWaysToChooseTwoLetters * numWaysToArrangeLetters
end
local numUniqueDoubleLetterSequences = uniqueDoubleLetterSequences(n)
print('Number of unique double letter sequences with ' .. n .. ' letters: ' .. numUniqueDoubleLetterSequences)










if key == 'o' then
    -- if key == 'v' then
        if keyIsUp then

            -- -- This is how to access the second jump coord after the first jump has been executed.
            -- local firstLetter = m.AppGrid.subGridMappedCoords[key]
            -- local subJumpPos = firstLetter[key]
            -- print(subJumpPos)

            -- local awaitingSecondJumpInput = m.AppGrid.subGridMappedCoords.e.r
            -- m.CursorJump:highlight(awaitingSecondJumpInput, m.Var)


            -- print(m.AppGrid.subGridMappedCoords.e.r)

            -- local applications = hs.application.runningApplications()
            -- for i, app in ipairs(applications) do
            --     local appName = app:name()
            --     local pid = app:pid()
            --     print('Application: ' .. appName)
            --     print('PID: ' .. pid)
            --     print('----------------------------------------------')
            -- end

            -- -- Get all visible windows.
            -- -- local windows = hs.window.visibleWindows()
            -- local windows = hs.window.allWindows()
            -- for i, v in ipairs(windows) do
            --     local application = v:application()
            --     local windowTitle = v:title()
            --     local windowFrame = v:frame()
            --     local winFrameCenter = hs.geometry.rectMidPoint(windowFrame)
            --     local applicationName = application:name()
            --     print(applicationName .. ' // ' .. windowTitle)
            --     print('X coords: ' .. windowFrame.x)
            --     print('Y coords: ' .. windowFrame.y)
            --     print('----------------------------------------------')
            -- end

                                -- m.CursorJump:showTestCircle(windowFrame)


            -- -- Retrieve all connected screens.
            -- local screens = hs.screen.allScreens()
            -- -- Get the count of connected screens.
            -- local screenCount = #screens
            -- print('Number of connected screens: ' .. screenCount)

            -- -- Retrieve the session properties
            -- local properties = hs.caffeinate.sessionProperties()
            -- -- Print the session properties
            -- for key, value in pairs(properties) do
            --     print(key, value)
            -- end

            -- m.ScreenWatcher:terminate()
            -- m.AppGrid:hideGrid()
            -- m.ScreenGrid:hideGrid()
            -- for i, v in ipairs(mappedCoords) do
            --     print('Key:', v.key)
            --     print('Value-X:', v.value.x)
            --     print('Value-Y:', v.value.y)
            --     print('-------------------------')
            -- end
        end
    end
