---------------------------------------------------------------------------------------------------------------------------------------------
-- Main mouse handler function.
---------------------------------------------------------------------------------------------------------------------------------------------
return function(tmod, tkey)
    local log = hs.logger.new('vimouse', 'debug')
    local tapmods = {['cmd']=false, ['ctrl']=false, ['alt']=false, ['shift']=false}
    local eventTypes = hs.eventtap.event.types
    local eventPropTypes = hs.eventtap.event.properties
    local keyStrokeHandler = nil
    local flagHandler = nil
    local menuIcon = nil
    local mousedownTime = 0
    local mousepressTime = 0
    local mousepress = 0
    local awaitingSecondJumpInput = false
    local firstKeyPressed = nil
    local subJumpPos = nil
    local selectedGrid = nil
    local gridIsDisplayed = false
    local m = require('module_routes')

    m.ScreenWatcher:initiate(m.AppGrid, m.ScreenGrid)
    m.ScreenWatcher:createScreenBorder()

    local function resetDisplayLayout()
        print('Resetting display layout.')
        m.ScreenWatcher:createScreenBorder()
    end
    displayLayoutWatcher = hs.screen.watcher.new(resetDisplayLayout)
    displayLayoutWatcher:start()


    -----------------------------------------------------------------------------------------
    -- If mouse toggle is set to one key without a modifier, comment out the function below.
    -----------------------------------------------------------------------------------------
    -- Bind a selected flag to the key used to toggle mouse control on/off.
    if type(tmod) == 'string' then
        tapmods[tmod] = true
    else
        for _, v in ipairs(tmod) do
            tapmods[v] = true
        end
    end


    -----------------------------------------------------------------------------------------------------------------------------------------
    -- Handler for dealing with flag change events.
    -----------------------------------------------------------------------------------------------------------------------------------------
    flagHandler = hs.eventtap.new({eventTypes.flagsChanged}, function(event)
        m.MouseEvt:stopMoving()
        local flags = event:getFlags()
        local code = event:getKeyCode()

        if flags.shift then
            m.MouseEvt.flags.shift = true
        elseif not flags.shift then
            m.MouseEvt.flags.shift = false
        end

        if flags.cmd then
            m.MouseEvt.flags.cmd = true
        elseif not flags.cmd then
            m.MouseEvt.flags.cmd = false
        end

        if flags.ctrl then
            m.MouseEvt.flags.ctrl = true
        elseif not flags.ctrl then
            m.MouseEvt.flags.ctrl = false
        end

    end)


    -----------------------------------------------------------------------------------------------------------------------------------------
    -- Handler for dealing with key up/down events.
    -----------------------------------------------------------------------------------------------------------------------------------------
    keyStrokeHandler = hs.eventtap.new({eventTypes.keyDown, eventTypes.keyUp}, function(event)
        local coords = hs.mouse.absolutePosition()
        local code = event:getKeyCode()
        local key = hs.keycodes.map[code]
        local flags = event:getFlags()
        local is_tapkey = code == hs.keycodes.map[tkey]
        local repeating = event:getProperty(eventPropTypes.keyboardEventAutorepeat)
        local keyIsUp = event:getType() == eventTypes.keyUp
        local keyIsDown = event:getType() == eventTypes.keyDown
        local keyIsRepeating = repeating == 1


        -------------------------------------------------------------------------------------------------------------------------------------
        -- Determine if the corresponding key to toggle mouse control on/off was pressed.
        -------------------------------------------------------------------------------------------------------------------------------------
        if is_tapkey == true then
            for i, v in pairs(tapmods) do
                if flags[i] == nil then
                    flags[i] = false
                end
                -- If the current flag is not == the mouse toggle binding then remain in mouse control mode.
                if tapmods[i] ~= flags[i] then
                    is_tapkey = false
                    break
                end
            end
        end

        -- Toggle back to insert mode if the set key binding is pressed.
        if is_tapkey then
            if menuIcon then
                hs.alert('🎹', 0.6)
                -- menuIcon:delete()
                menuIcon:removeFromMenuBar()
                menuIcon = nil
            end
            awaitingSecondJumpInput = false
            firstKeyPressed = nil
            subJumpPos = nil
            selectedGrid = nil
            gridIsDisplayed = false
            keyStrokeHandler:stop()
            flagHandler:stop()
            hs.mouse.absolutePosition(coords)
            m.Scrolling:terminate()
            m.AppGrid:hideGrid()
            m.ScreenGrid:hideGrid()
            m.MouseEvt:resetProperties('mouseUp')
            m.ScreenWatcher.mouseControlEnabled = false
            m.ScreenWatcher:toggleScreenBorder('off')

            return true
        end


        -------------------------------------------------------------------------------------------------------------------------------------
        -- Enable selected keybindings or inputs while in mouse mode.
        -------------------------------------------------------------------------------------------------------------------------------------
        -- Check if the current input is in the corresponding table to enable selected keybindings during mouse control.
        if m.EnabledBindings.cmd[key] and flags.cmd then
            return false
        elseif m.EnabledBindings.alt[key] and flags.alt then
            return false
        elseif m.EnabledBindings.noFlag[key] then
            return false
        end


        -------------------------------------------------------------------------------------------------------------------------------------
        -- This block is responsible for jumping the cursor to the center of each cell in a 3x3 grid corresponding to the
        -- dimensions of the currently focused app or screen.
        -------------------------------------------------------------------------------------------------------------------------------------
        local jumpTrigger = {
            [m.Var.topLeft] = 'topLeft',
            [m.Var.topCenter] = 'topCenter',
            [m.Var.topRight] = 'topRight',
            [m.Var.centerLeft] = 'centerLeft',
            [m.Var.center] = 'center',
            [m.Var.centerRight] = 'centerRight',
            [m.Var.bottomLeft] = 'bottomLeft',
            [m.Var.bottomCenter] = 'bottomCenter',
            [m.Var.bottomRight] = 'bottomRight',
        }

        ---------------------------------------------------------------------------------------------

        -- Display the grid on the currently focused app.
        if key == m.Var.showAppGrid then
            if keyIsDown then
                selectedGrid = m.AppGrid
                m.AppGrid:displayGrid()
            elseif keyIsUp then
                awaitingSecondJumpInput = false
                m.AppGrid:hideGrid()
            end
        end

        ---------------------------------------------------------------------------------------------

        -- Display the grid on the currently active screen.
        if key == m.Var.showScreenGrid then
            if keyIsDown then
                selectedGrid = m.ScreenGrid
                m.ScreenGrid:displayGrid()
            elseif keyIsUp then
                awaitingSecondJumpInput = false
                m.ScreenGrid:hideGrid()
            end
        end

        ---------------------------------------------------------------------------------------------

        -- If the grid jump highlights are displayed allow the corresponding keys to trigger
        -- a jump to the associated highlight coords.
        local gridIsDisplayed = m.AppGrid.isDisplayed or m.ScreenGrid.isDisplayed

        -- Throttle all non jump based events when the grid is displayed.
        if gridIsDisplayed then m.MouseEvt:resetProperties() end

        if gridIsDisplayed and jumpTrigger[key] then
            -- Prevent keyboard autorepeat from spamming jump inputs.
            if keyIsRepeating or keyIsUp then return true end
            local input = jumpTrigger[key]
            if awaitingSecondJumpInput then
                -- Set the middle jump coord of whichever grid was initially jumped to, to the initial coord.
                if input == 'center' then
                    local subJumpPos = selectedGrid.mappedCoords[firstKeyPressed]
                    m.MouseEvt:highlight(subJumpPos)
                else
                    local subJumpPos = firstLetter[input]
                    m.MouseEvt:highlight(subJumpPos, 'subGridFocused')
                end
            else
                -- Jump to the selected sub-grid and set the initial jump coord.
                firstKeyPressed = input
                firstLetter = selectedGrid.subGridMappedCoords[input]
                selectedGrid:displaySubGrid(firstKeyPressed)
                local jumpPos = selectedGrid.mappedCoords[input]
                m.MouseEvt:highlight(jumpPos)
                awaitingSecondJumpInput = true
            end
        end

        ---------------------------------------------------------------------------------------------

        -- Jump the cursor to the previous or next display with the associated bindings.
        if not gridIsDisplayed then
            if keyIsUp then
                local currentScreen = hs.mouse.getCurrentScreen()
                -- Jump the cursor to the center of the next screen.
                if key == m.Var.jumpNextScreen then
                    local nextScreenCenter = hs.geometry.rectMidPoint(currentScreen:next():fullFrame())
                    m.MouseEvt:highlight(nextScreenCenter)
                end
                -- Jump the cursor to the center of the previous screen.
                if key == m.Var.jumpPreviousScreen then
                    local prevScreenCenter = hs.geometry.rectMidPoint(currentScreen:previous():fullFrame())
                    m.MouseEvt:highlight(prevScreenCenter)
                end
            end
        end


        -------------------------------------------------------------------------------------------------------------------------------------
        -- Scroll events with 'e', 'w', 'd', and 'r'.
        -------------------------------------------------------------------------------------------------------------------------------------
        local scrollKeyTable = {
            [m.Var.scrollUp] = 'up',
            [m.Var.scrollDown] = 'down',
            [m.Var.scrollLeft] = 'left',
            [m.Var.scrollRight] = 'right',
        }

        -- Disable scroll events when cursor jump layer keys are held.
        if not gridIsDisplayed then
            if scrollKeyTable[key] then
                local input = scrollKeyTable[key]
                if keyIsRepeating then
                    m.Scrolling.keyIsHeld = true
                end
                -- Send scrolling events.
                if keyIsDown then
                    m.Scrolling[input] = true
                    m.Scrolling:initiate()
                elseif keyIsUp then
                    m.Scrolling[input] = false
                    m.Scrolling:terminate()
                end
            end
        end


        -------------------------------------------------------------------------------------------------------------------------------------
        -- Enable mouse clicking and dragging when the spacebar is held down.
        -------------------------------------------------------------------------------------------------------------------------------------
        if key == 'space' then
            -- This prevents click inputs spamming when the space bar is held down.
            if keyIsRepeating then return true end

            -- Send only one mouse click if the interval between clicks is greater than the double click threshold set by the OS.
            local now = hs.timer.secondsSinceEpoch()
            if now - mousepressTime > hs.eventtap.doubleClickInterval() then
                m.MouseEvt.clicks = 1
            end

            -- Send a double click event if the spacebar is pressed twice within a 0.22 second window.
            if keyIsDown then
                if now - mousedownTime <= 0.22 then
                    m.MouseEvt.clicks = m.MouseEvt.clicks + 1
                    mousepressTime = now
                end
                mousedownTime = hs.timer.secondsSinceEpoch()
            end

            -- Set the state of the mouse button and post click events.
            if keyIsDown then
                m.MouseEvt[key] = true
                m.MouseEvt:click('MouseDown')
            elseif keyIsUp then
                m.MouseEvt[key] = false
                m.MouseEvt:click('MouseUp')
            end
        end


        -------------------------------------------------------------------------------------------------------------------------------------
        -- Set the up/down state of corresponding keys and call key repeat functions if the key is present in the table.
        -------------------------------------------------------------------------------------------------------------------------------------
        local movementKeyTable = {
            [m.Var.cursorUp] = 'up',
            [m.Var.cursorDown] = 'down',
            [m.Var.cursorLeft] = 'left',
            [m.Var.cursorRight] = 'right',
            [m.Var.cursorSlow] = 'slow',
            [m.Var.cursorFast] = 'fast',
        }

        -- if not flags.cmd and not flags.alt then
        if not gridIsDisplayed then
            if movementKeyTable[key] then
                local input = movementKeyTable[key]
                if keyIsRepeating then return true end
                -- Send mouse movement events when the corresponding keys are pressed.
                if keyIsDown then
                    m.MouseEvt[input] = true
                elseif keyIsUp then
                    m.MouseEvt[input] = false
                end
                -- Call the timer function to begin posting mouse events.
                m.MouseEvt:move()
            end

            -- Cancel the movement timer function if no movement keys are held.
            if not m.MouseEvt.up
                and not m.MouseEvt.down
                and not m.MouseEvt.left
                and not m.MouseEvt.right
            then
                m.MouseEvt:stopMoving()
            end
        end

        -- This is a catch all to prevent any unrelated keystrokes registering if they are
        -- pressed while mouse control mode is active.
        return true
    end)

    -- Bind the flag/key passed into the function as arguments to toggle mouse control on/off.
    hs.hotkey.bind(tmod, tkey, nil, function(event)
        if not menuIcon then
            hs.alert('𝕍ⅈ-𝕍ⅈ', 0.6)
            menuIcon = hs.menubar.new():setTitle('𝕍ⅈ-𝕍ⅈ')
        end
        keyStrokeHandler:start()
        flagHandler:start()
        m.MouseEvt:highlight(hs.mouse.absolutePosition())
        m.ScreenWatcher.mouseControlEnabled = true
        m.ScreenWatcher:toggleScreenBorder('on')
    end)
end

---- I DID IT!!!!!!!!! ----




-- local chosenFrame = hs.window.focusedWindow():frame()
-- local screenFrame = hs.mouse.getCurrentScreen():frame()
-- local mousePoint = hs.mouse.getRelativePosition()
-- local is_tapkey = code == keycodes[tkey]

-- local sideSpecificMod = nil
-- local throttleInputRepeat = false
-- displayLayoutWatcher = hs.screen.watcher.newWithActiveScreen(resetDisplayLayout)

-- elseif m.EnabledBindings.cmdShift[key] and flags.cmd and flags.shift then
--     return false
-- elseif m.EnabledBindings.ctrlCmd[key] and flags.ctrl and flags.cmd then
--     return false

-- m.ScreenGrid.screenBorder:show()
-- m.ScreenWatcher:toggleScreenBorder(hs.mouse.getCurrentScreen())
-- m.ScreenWatcher:createScreenBorder('on')
-- testScreenWatcher:start()
-- remapper = FRemap.new()
-- remapper:remap('a', 'ctrl')
-- remapper:register()

-- m.ScreenGrid.screenBorder:hide()
-- m.ScreenWatcher:createScreenBorder('off')
-- remapper:unregister()

        -- if flags.shift then
        --     m.MouseEvt.shift = true
        --     -- m.MouseEvt:stopMoving()
        -- elseif not flags.shift then
        --     m.MouseEvt.shift = false
        -- end

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


    -- -- local nums = { 5, 7, 2, 9, 3, 1, 4, 6, 8 }
    -- -- local nums = { 'c', 'f', 'b', 'a', 'g', 'd', 'e', 'i', 'h' }
    -- local nums = { 52, 7, 21, 3, 9, 32, 44, 69, 89 }
    -- local tempTable = {}
    -- local newTable = {}

        -- if keyIsUp then
        --     if key == 'o' then
        --         for i, v in pairs(nums) do
        --             -- tempTable[i] = v
        --             tempTable[v] = v
        --             -- print(i)
        --             -- print(v)
        --         end
        --         for i, v in pairs(nums) do
        --             -- newTable[i] = tempTable[v]
        --             -- newTable[i] = tempTable[i]
        --             newTable[v] = tempTable[i]
        --             -- print(i)
        --             -- print(v)
        --         end
        --     end
        --     if key == 'p' then
        --         -- for i, v in pairs(newTable) do
        --         for i, v in pairs(tempTable) do
        --             print(i)
        --             print(v)
        --         end
        --     end
        -- end



        -- -- Function to add value to the end of tempTable
        -- local function addToEnd(value)
        --     table.insert(tempTable, value)
        -- end

        -- -- Function to add value to the start of tempTable
        -- local function addToStart(value)
        --     table.insert(tempTable, 1, value)
        -- end


        -- if keyIsUp then
        --     if key == 'u' then
        --         -- Loop through the nums table
        --         for i, num in ipairs(nums) do
        --             if i == 1 then
        --                 -- First element in the nums table, add it to the start of tempTable
        --                 addToStart(num)
        --             elseif i == #nums then
        --                 -- Last element in the nums table, add it to the end of tempTable
        --                 addToEnd(num)
        --             else
        --                 -- Check if the current number is larger than the last entry in tempTable
        --                 if num > tempTable[#tempTable] then
        --                     addToEnd(num)
        --                 -- Check if the current number is smaller than the first entry in tempTable
        --                 elseif num < tempTable[1] then
        --                     addToStart(num)
        --                 else
        --                     -- Find the position to insert the number within tempTable
        --                     for j, tNum in ipairs(tempTable) do
        --                         if num < tNum then
        --                             table.insert(tempTable, j, num)
        --                             break
        --                         end
        --                     end
        --                 end
        --             end
        --         end
        --         -- Print the result
        --         for _, num in ipairs(tempTable) do
        --             print(num)
        --         end
        --     end
        -- end

        -- Loop throught the table moving the entries copying each value to a new table.
        -- Each iteration log the smallest and largest values and place the new item at the start or end of the
        -- table according to it's size while continually tracking the largest and smallest values.

        -- function gigaChadSort()
        --     for i, v in pairs(nums) do
        --         tempTable[v] = i
        --     end
        --     for i, v in pairs(nums) do
        --         newTable[i] = tempTable[v]
        --     end
        -- end

        -- Prints the name of the focused app or window.
        -- local focusedWinTitle = hs.window.focusedWindow():title()
        -- local focusedWinApp = hs.window.focusedWindow():application():name()
        -- print(focusedWinApp)
        -- for i, v in pairs (oioi) do
            -- print(i) -- This value is equal to the activeScreen variable.
            -- print(v)
            -- print('------------------------------------')
            -- if i == 2 then
                -- v:show()
            -- end
        -- end

        -- function iterateWindows()
        --     local allWindows = hs.window.allWindows()
        --     for _, win in ipairs(allWindows) do
        --         -- Access window properties or perform actions on each window
        --         if win:application():name() == 'Code' then
        --             print('Window id: ' .. win:id())
        --             print('Window title: ' .. win:title())
        --             print('Window application: ' .. win:application():name())
        --             print('-----------------------------------')
        --         end
        --     end
        -- end

        -- -- The minimum distance that the cursor can move in any direction is 1 pixel.
        -- -- This means that the minimum travel distance while repeating must be 2 pixels
        -- -- so that single and double axis movement are fluid.
        -- local function pixelTest()
        --     local oi = hs.mouse.absolutePosition()
        --     -- oi.x = oi.x + 0.2
        --     oi.x = oi.x + 0.9
        --     hs.mouse.absolutePosition(oi)
        -- end




        -- -- If the grid jump highlights are displayed allow the corresponding keys to trigger
        -- -- a jump to the associated highlight coords.
        -- local gridIsDisplayed = m.AppGrid.isDisplayed or m.ScreenGrid.isDisplayed
        -- -- if gridIsDisplayed and keyIsUp then
        -- if gridIsDisplayed then
        --     m.MouseEvt:resetProperties()
        --     if jumpTrigger[key] then
        --         if keyIsRepeating or keyIsUp then return true end
        --         local input = jumpTrigger[key]
        --         if awaitingSecondJumpInput then
        --             -- Set the middle jump coord of whichever grid was initially jumped to, to the initial coord.
        --             if input == 'center' then
        --                 local subJumpPos = selectedGrid.mappedCoords[firstKeyPressed]
        --                 m.MouseEvt:highlight(subJumpPos)
        --             else
        --                 local subJumpPos = firstLetter[input]
        --                 m.MouseEvt:highlight(subJumpPos, true)
        --             end
        --         else
        --             firstKeyPressed = input
        --             firstLetter = selectedGrid.subGridMappedCoords[input]
        --             selectedGrid:displaySubGrid(firstKeyPressed)
        --             local jumpPos = selectedGrid.mappedCoords[input]
        --             m.MouseEvt:highlight(jumpPos)
        --             awaitingSecondJumpInput = true
        --         end
        --     end
        -- end


        -- -- If the grid jump highlights are displayed allow the corresponding keys to trigger
        -- -- a jump to the associated highlight coords.
        -- local gridIsDisplayed = m.AppGrid.isDisplayed or m.ScreenGrid.isDisplayed
        -- if gridIsDisplayed and keyIsUp then
        --     if jumpTrigger[key] then
        --         if awaitingSecondJumpInput then
        --             -- Set the middle jump coord of whichever grid was initially jumped to, to the initial coord.
        --             if jumpTrigger[key] == 'center' then
        --                 local subJumpPos = selectedGrid.mappedCoords[firstKeyPressed]
        --                 m.MouseEvt:highlight(subJumpPos)
        --             else
        --                 local subJumpPos = firstLetter[jumpTrigger[key]]
        --                 m.MouseEvt:highlight(subJumpPos, true)
        --             end
        --         else
        --             firstKeyPressed = jumpTrigger[key]
        --             firstLetter = selectedGrid.subGridMappedCoords[jumpTrigger[key]]
        --             selectedGrid:displaySubGrid(firstKeyPressed)
        --             local jumpPos = selectedGrid.mappedCoords[jumpTrigger[key]]
        --             m.MouseEvt:highlight(jumpPos)
        --             awaitingSecondJumpInput = true
        --         end
        --     end
        -- end
        -- ---------------------------------------------------------------------------------------------

        -- if awaitingSecondJumpInput then
        --     if keyIsUp then
        --         if jumpTriggerKeys[key] then
        --             if key == 'd' then
        --                 subJumpPos = m.AppGrid.mappedCoords[firstKeyPressed]
                        -- m.CursorJump:highlight(subJumpPos, m.Var)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var)
        --             else
        --                 subJumpPos = firstLetter[key]
                        -- m.CursorJump:highlight(subJumpPos, m.Var)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var)
        --             end
        --         end
        --     end
        -- end
        -- -- If the apps jump coords are displayed allow the corresponding keys to trigger a jump to the associated coords.
        -- if m.AppGrid.isDisplayed then
        --     if not awaitingSecondJumpInput then
        --         if jumpTriggerKeys[key] then
        --             if keyIsUp then
        --                 firstLetter = m.AppGrid.subGridMappedCoords[key]
        --                 firstKeyPressed = key
        --                 -- m.AppGrid:hideGrid()
        --                 local jumpPos = m.AppGrid.mappedCoords[key]
                        -- m.CursorJump:highlight(jumpPos, m.Var)
        --                 m.MouseEvt:highlight(jumpPos, m.Var)
        --                 awaitingSecondJumpInput = true
        --             end
        --         end
        --     end
        -- end




        -- -- If quote is pressed, focus the grid on the current screen.
        -- if key == "'" then
        --     if keyIsDown then
        --         if throttleInputRepeat then
        --             return true
        --         else
        --             if m.AppGrid.isDisplayed then
        --                 m.AppGrid:hideGrid()
        --             end
        --             throttleInputRepeat = true
        --             m.ScreenGrid.throttleScrollEvents = true
        --             m.ScreenGrid:displayGrid()
        --         end
        --     elseif keyIsUp then
        --         throttleInputRepeat = false
        --     end
        -- end

        -- -- If the screens jump coords are displayed allow the corresponding keys to trigger a jump to the associated coords.
        -- if m.ScreenGrid.isDisplayed then
        --     if keyIsUp then
        --         if jumpTriggerKeys[key] then
        --             m.ScreenGrid:hideGrid()
        --             local jumpPos = m.ScreenGrid.mappedCoords[key]
                    -- m.CursorJump:highlight(jumpPos, m.Var)
        --             m.MouseEvt:highlight(jumpPos, m.Var)
        --             m.ScreenGrid.throttleScrollEvents = false
        --         end
        --     end
        -- end

        -- local AppGridIsDisplayed = m.AppGrid.isDisplayed
        -- local ScreenGridIsDisplayed = m.ScreenGrid.isDisplayed
        -- local gridIsDisplayed = AppGridIsDisplayed or ScreenGridIsDisplayed

        -- if AppGridIsDisplayed then
        --     selectedGrid = m.AppGrid
        -- elseif ScreenGridIsDisplayed then
        --     selectedGrid = m.ScreenGrid
        -- end

        -- -- If the apps jump coords are displayed allow the corresponding keys to trigger a jump to the associated coords.
        -- if m.AppGrid.isDisplayed and keyIsUp then
        --     if jumpTriggerKeys[key] then
        --         if awaitingSecondJumpInput then
        --             -- Set the middle jump letter of whichever grid was initially jumped to, to 'd'.
        --             if key == 'd' then
        --                 local subJumpPos = m.AppGrid.mappedCoords[firstKeyPressed]
                        -- m.CursorJump:highlight(subJumpPos, m.Var)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var)
        --             else
        --                 local subJumpPos = firstLetter[key]
                        -- m.CursorJump:highlight(subJumpPos, m.Var, true)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var, true)
        --             end
        --         else
        --             firstKeyPressed = key
        --             firstLetter = m.AppGrid.subGridMappedCoords[key]
        --             m.AppGrid:displaySubGrid(firstKeyPressed)
        --             local jumpPos = m.AppGrid.mappedCoords[key]
                    -- m.CursorJump:highlight(jumpPos, m.Var)
        --             m.MouseEvt:highlight(jumpPos, m.Var)
        --             awaitingSecondJumpInput = true
        --         end
        --     end
        -- end

        -- -- If the screens jump coords are displayed allow the corresponding keys to trigger a jump to the associated coords.
        -- if m.ScreenGrid.isDisplayed and keyIsUp then
        --     if jumpTriggerKeys[key] then
        --         if awaitingSecondJumpInput then
        --             -- Set the middle jump letter of whichever grid was initially jumped to, to 'd'.
        --             if key == 'd' then
        --                 local subJumpPos = m.ScreenGrid.mappedCoords[firstKeyPressed]
                        -- m.CursorJump:highlight(subJumpPos, m.Var)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var)
        --             else
        --                 local subJumpPos = firstLetter[key]
                        -- m.CursorJump:highlight(subJumpPos, m.Var, true)
        --                 m.MouseEvt:highlight(subJumpPos, m.Var, true)
        --             end
        --         else
        --             firstKeyPressed = key
        --             firstLetter = m.ScreenGrid.subGridMappedCoords[key]
        --             m.ScreenGrid:displaySubGrid(firstKeyPressed)
        --             local jumpPos = m.ScreenGrid.mappedCoords[key]
                    -- m.CursorJump:highlight(jumpPos, m.Var)
        --             m.MouseEvt:highlight(jumpPos, m.Var)
        --             awaitingSecondJumpInput = true
        --         end
        --     end
        -- end

        -- -- Determine whether to focus the grid on the current app or screen.
        -- if m.AppGrid.isDisplayed then
        --     selectedGrid = m.AppGrid
        -- elseif m.ScreenGrid.isDisplayed then
        --     selectedGrid = m.ScreenGrid
        -- end


        -- local jumpTriggerKeys = {
        --     ['w'] = true,
        --     ['e'] = true,
        --     ['r'] = true,
        --     ['s'] = true,
        --     ['d'] = true,
        --     ['f'] = true,
        --     ['x'] = true,
        --     ['c'] = true,
        --     ['v'] = true,
        -- }

        -- -- If the grid jump highlights are displayed allow the corresponding keys to trigger
        -- -- a jump to the associated highlight coords.
        -- local gridIsDisplayed = m.AppGrid.isDisplayed or m.ScreenGrid.isDisplayed
        -- if gridIsDisplayed and keyIsUp then
        --     if jumpTriggerKeys[key] then
        --         if awaitingSecondJumpInput then
        --             -- Set the middle jump letter of whichever grid was initially jumped to, to 'd'.
        --             if key == 'd' then
        --                 local subJumpPos = selectedGrid.mappedCoords[firstKeyPressed]
        --                 m.MouseEvt:highlight(subJumpPos, m.Var)
        --             else
        --                 local subJumpPos = firstLetter[key]
        --                 m.MouseEvt:highlight(subJumpPos, m.Var, true)
        --             end
        --         else
        --             firstKeyPressed = key
        --             firstLetter = selectedGrid.subGridMappedCoords[key]
        --             selectedGrid:displaySubGrid(firstKeyPressed)
        --             local jumpPos = selectedGrid.mappedCoords[key]
        --             m.MouseEvt:highlight(jumpPos, m.Var)
        --             awaitingSecondJumpInput = true
        --         end
        --     end
        -- end
