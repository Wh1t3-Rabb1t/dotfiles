

        -- local movementKeyTable = {
        --     ['k'] = true,
        --     ['i'] = true,
        --     ['l'] = true,
        --     ['t'] = true,
        --     ['s'] = true,
        --     ['f'] = true,
        -- }

        -- -- if not flags.cmd and not flags.alt then
        -- if movementKeyTable[key] then
        --     if repeating ~= 0 then return true end

        --     -- Don't delete the jump grid if the speed-up or slow-down keys are pressed.
        --     if key ~= 's' and key ~= 'f' then
        --         m.AppGrid:hideGrid()
        --         m.ScreenGrid:hideGrid()
        --         m.Scrolling.throttleEvents = false
        --     end

        --     -- Send mouse movement events when the corresponding keys are pressed.
        --     if keyIsDown then
        --         m.MouseEvt[key] = true
        --     elseif keyIsUp then
        --         m.MouseEvt[key] = false
        --     end

        --     -- Call the timer function to begin posting mouse events.
        --     m.MouseEvt:move(m.Var)
        -- end

        -- -- Cancel the movement timer function if no movement keys are held.
        -- if not m.MouseEvt.k
        --     and not m.MouseEvt.i
        --     and not m.MouseEvt.l
        --     and not m.MouseEvt.t
        -- then
        --     m.MouseEvt:stopMoving()
        -- end



        -- -- Send a left click event with Applescript at the target coords.
        -- local function executeAppleScript(targetX, targetY)
        --     local applescriptCode = string.format([[
        --         tell application "System Events"
        --         click at {%d, %d}
        --       end tell
        --     ]], targetX, targetY)
        --     -- Run the AppleScript code
        --     local success, result, rawOutput = hs.osascript.applescript(applescriptCode)
        --     -- Check if the AppleScript code execution was successful
        --     if success then
        --         print("AppleScript execution succeeded")
        --         -- Process the result or rawOutput as needed
        --     else
        --         print("AppleScript execution failed")
        --         -- Access the error information if needed: result.error
        --     end
        -- end
        -- -- coX = math.ceil(coords.x)
        -- -- coY = math.ceil(coords.y)
        -- -- executeAppleScript(coX, coY)



        -- local jumpTriggerKeys = {
        --     [keycodes['w']] = true,
        --     [keycodes['e']] = true,
        --     [keycodes['r']] = true,
        --     [keycodes['s']] = true,
        --     [keycodes['d']] = true,
        --     [keycodes['f']] = true,
        --     [keycodes['x']] = true,
        --     [keycodes['c']] = true,
        --     [keycodes['v']] = true,
        -- }



                -- canvas.outerRing:delete(0)
                -- canvas.innerRing:delete(0)
                -- canvas.jumpLetter:delete(0)

-- print('arg:' .. frame.w)
-- print('cached:' .. self.cachedFrame.w)
-- print('----------------------')

-- function AppGrid:screenWatcher(frame)
--     -- If the app frame has changed rerun then coord mapper.
--     if frame.w ~= self.cachedFrame.w or frame.h ~= self.cachedFrame.h or frame.x ~= self.cachedFrame.x or frame.y ~= self.cachedFrame.y then
--         self.cachedFrame = frame
--         -- self.mapCoords('a', frame)
--     end
-- end

---------------------------------------------------------------------------------------------------------------------------------------------

-- AppGrid.circle = nil
-- AppGrid.timer = nil
-- AppGrid.color = nil
-- AppGrid.__index = AppGrid
-- AppGrid.name = 'AppGrid'

-- Instead of setting self.isHighlightActive to true set it to a number which
-- increments each time up til 9 to get 9 individual timers.

-- -- Create the outer/inner ring and letter canvases.
-- local outerRing = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize })
-- local innerRing = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter })
-- local jumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize })

    -- -- Create the smaller canvas for the inner circle.
    -- local innerCircle = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter })
    -- -- local innerCircle = hs.canvas.new()
    -- innerCircle[1] = {
    --     type = 'circle',
    --     action = 'fill',
    --     fillColor = { red = 1, blue = 1, green = 1, alpha = 1 }, -- White.
    --     -- frame = { x = (posX + margin), y = (posY + margin), w = diameter, h = diameter }
    -- }
    -- innerCircle:show()


    -- -- If the grid already exists on the screen delete and redraw it.
    -- if self[letter] then
    --     self[letter].outerRing:hide(0)
    --     self[letter].innerRing:hide(0)
    --     self[letter].jumpLetter:hide(0)
    --     self[letter].outerRing:delete(0)
    --     self[letter].innerRing:delete(0)
    --     self[letter].jumpLetter:delete(0)
    --     self[letter] = nil
    -- end


    -- -- Begin a timer to animate the canvas.
    -- canvasTimer = hs.timer.new(0.02, function()
    --     endAngle = endAngle + endAngle
    --     if endAngle >= 360 then
    --         isTimerActive = false
    --         canvasTimer:stop()
    --     end
    -- end)
        -- canvasTimer:start()

    -- local styledJumpLetter = hs.styledtext.new('w', { font = 'Courier' })
    -- local styledJumpLetterDrawing = hs.drawing.text(hs.geometry.rect(0, 0, 100, 100), styledJumpLetter)
    -- styledJumpLetterDrawing:show()

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

-- function AppGrid:showOnTimer(highlightPos)
--     local highlightPos = hs.mouse.absolutePosition()

--     local circleDiameter = 50
--     local borderSize = circleDiameter + (circleDiameter / 10)
--     local margin = (borderSize - circleDiameter) / 2
--     local posX = highlightPos.x - (borderSize / 2)
--     local posY = highlightPos.y - (borderSize / 2)

--     -- Create the larger canvas.
--     local borderCanvas = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize })
--     borderCanvas[1] = {
--         type = 'circle',
--         action = 'fill',
--         fillColor = { red = 1, blue = 1, green = 1, alpha = 1 }, -- White.
--         frame = { x = 0, y = 0, w = tostring(borderSize), h = tostring(borderSize) }
--     }
--     borderCanvas:show()

--     -- Create the smaller canvas for the circle.
--     local circleCanvas = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = circleDiameter, h = circleDiameter })
--     circleCanvas[1] = {
--         type = 'circle',
--         action = 'fill',
--         fillColor = { red = 1, blue = 0, green = 0, alpha = 1 }, -- Red.
--         frame = { x = 0, y = 0, w = tostring(circleDiameter), h = tostring(circleDiameter) }
--     }
--     circleCanvas:show()

--     -- canvas:bringToFront(true) -- Bring the canvas to the front.
--     return self
-- end

-- ---------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

    -- -- Create the smaller canvas for the inner circle.
    -- local innerCircle = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = circleDiameter, h = circleDiameter })
    -- innerCircle[1] = {
    --     type = 'circle',
    --     action = 'fill',
    --     fillColor = { red = 1, blue = 1, green = 1, alpha = 1 }, -- White.
    --     frame = { x = (posX + margin), y = (posY + margin), w = circleDiameter, h = circleDiameter }
    -- }
    -- innerCircle:show()
    -- canvas:bringToFront(true) -- Bring the canvas to the front.


-- -- This function draws 2 circles one atop the other to give the effect of a circle with a border.
-- function AppGrid:showLayeredCircles(highlightPos)
--     local circleDiameter = 50
--     local borderSize = circleDiameter + (circleDiameter / 10)
--     local margin = (borderSize - circleDiameter) / 2
--     local posX = highlightPos.x - (borderSize / 2)
--     local posY = highlightPos.y - (borderSize / 2)

--     -- Create the larger canvas.
--     local borderCanvas = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize })
--     borderCanvas[1] = {
--         type = 'circle',
--         action = 'fill',
--         fillColor = { red = 1, blue = 1, green = 1, alpha = 1 }, -- White.
--         frame = { x = 0, y = 0, w = tostring(borderSize), h = tostring(borderSize) }
--     }
--     borderCanvas:show()

--     -- Create the smaller canvas for the circle.
--     local circleCanvas = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = circleDiameter, h = circleDiameter })
--     circleCanvas[1] = {
--         type = 'circle',
--         action = 'fill',
--         fillColor = { red = 1, blue = 0, green = 0, alpha = 1 }, -- Red.
--         frame = { x = 0, y = 0, w = tostring(circleDiameter), h = tostring(circleDiameter) }
--     }
--     circleCanvas:show()
-- end

-- local circleRadius = circleDiameter / 2
-- local borderCanvas = hs.canvas.new({ x = 0, y = 0, w = borderSize, h = borderSize })
-- local circleCanvas = hs.canvas.new({ x = margin, y = margin, w = circleDiameter, h = circleDiameter })


-------------------------------------------------------------------------------------------------------------------------------------------





-- function AppGrid:show()
--     local canvas = hs.canvas.new({ x = 100, y = 100, w = 250, h = 250 })
--     canvas:appendElements({
--         type = 'ellipticalArc',
--         action = 'stroke',
--         strokeColor = { red = 1, green = 0, blue = 0, alpha = 1 }, -- Red
--         strokeWidth = 20,
--         arcRadii = false, -- Prevent the line being drawn from the center of the circle.
--         clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--         startAngle = 0,
--         endAngle = 360
--     })
--     canvas:show()
-- end


---------------------------------------------------------------------------------------------------------------------------------------------

-- function AppGrid:showOnTimer()
--     local circle = self.circle
--     local timer = self.timer

--     if circle then
--         circle:hide(0.5)
--         if timer then
--             timer:stop()
--         end
--     end
--     local mouseCirclePoint = hs.mouse.absolutePosition()

--     local color = nil
--     if (self.color) then
--         color = self.color
--     else
--         color = { red = 1, blue = 0, green = 0, alpha = 1 }
--     end

--     -- Create a canvas object and set it's size (the first 2 numbers determine the coordinates of the circle, the second 2 determin the size).
--     local canvas = hs.canvas.new(hs.geometry.rect(mouseCirclePoint.x - 40, mouseCirclePoint.y - 40, 80, 80))

--     -- Draw a circle with the desired stroke color and width.
--     local strokeWidth = 5
--     local radius = (80 - strokeWidth) / 2
--     canvas[1] = {
--         type = 'circle',
--         action = 'strokeAndFill',
--         fillColor = color,
--         strokeWidth = strokeWidth,
--         arcRadii = false, -- Prevent the line being drawn from the center of the circle.
--         clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--         -- frame = {
--         --     x = tostring(radius),
--         --     y = tostring(radius),
--         --     w = tostring(radius * 2),
--         --     h = tostring(radius * 2)
--         -- }
--     }

--     -- Bring the canvas to the front.
--     canvas:bringToFront(true)
--     -- Show the canvas with animation.
--     canvas:show(0.5)
--     -- Assign the canvas to a variable if needed.
--     self.circle = canvas

--     self.timer = hs.timer.doAfter(0.4, function()
--         self.circle:hide(0.4)
--         hs.timer.doAfter(0, function()
--             self.circle:delete()
--             self.circle = nil
--         end)
--     end)

--     -- ERROR!
--     -- LuaSkin: hs.canvas:delete - explicit delete is no longer required for canvas objects; garbage collection occurs automatically

--     return self
-- end

---------------------------------------------------------------------------------------------------------------------------------------------




-- local count = 500
-- -- Pass the reference to the AppGrid module.
-- function ScreenWatcher:initiate(AppGridModule, ScreenGridModule, hlSize)
--     windowWatcher = hs.eventtap.new({eventTypes.keyUp, eventTypes.mouseMoved}, function(event)
--         -- local activeApplication = hs.application.frontmostApplication()
--         -- local everyScreen = hs.screen.allScreens()

--         -- if event:getType() == eventTypes.mouseMoved then
--         --     count = count + 1
--         -- end
--         -- if count < 420 then
--         --     return
--         -- elseif count > 420 then
--         --     count = 0
--         -- end
--         -- -- print(count)

--         if not hs.window.focusedWindow() then return end
--         local keycodes = hs.keycodes.map
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         local focusedWindow = hs.window.focusedWindow()
--         local desktopWindow = hs.window.desktop()
--         local appFrame = hs.window.focusedWindow():frame()

--         -- If no apps are focused, focus the grid on the current screen.
--         if focusedWindow == desktopWindow then
--             appFrame = screenFrame
--         end

--         -- If the app frame has changed.
--         if appFrame.w ~= AppGridModule.cachedFrame.w
--             or appFrame.h ~= AppGridModule.cachedFrame.h
--             or appFrame.x ~= AppGridModule.cachedFrame.x
--             or appFrame.y ~= AppGridModule.cachedFrame.y
--         then
--             AppGridModule:deleteGrid()
--             AppGridModule.cachedFrame = appFrame
--             AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
--             mapGrid(AppGridModule, AppGridModule.cachedFrame, hlSize)
--         end

--         -- If the screen frame has changed.
--         if screenFrame.w ~= ScreenGridModule.cachedFrame.w or screenFrame.h ~= ScreenGridModule.cachedFrame.h then
--             -- ! Call the screen mapper here if the focused screen changes.
--             ScreenGridModule:deleteGrid()
--             ScreenGridModule.cachedFrame = screenFrame
--             ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
--             mapGrid(ScreenGridModule, ScreenGridModule.cachedFrame, hlSize)
--         end
--     end)
--     windowWatcher:start()
-- end


    -- -- print(clickThrough)
    -- if focusedWindow:application():name() == 'System Settings' then
    --     print('System Preferences window is active')
    -- end
    -- local focusedWin = hs.window.focusedWindow():application():name()
    -- print(focusedWin)

        -- local jumpKeyTable = {
        --     { key = keycodes['w'], value = { 6, 1, 6, 1 } }, -- Top left.
        --     { key = keycodes['e'], value = { 2, 1, 6, 1 } }, -- Top center.
        --     { key = keycodes['r'], value = { 6, 5, 6, 1 } }, -- Top right.
        --     { key = keycodes['s'], value = { 6, 1, 2, 1 } }, -- Center left.
        --     { key = keycodes['d'], value = { 2, 1, 2, 1 } }, -- Center.
        --     { key = keycodes['f'], value = { 6, 5, 2, 1 } }, -- Center right.
        --     { key = keycodes['x'], value = { 6, 1, 6, 5 } }, -- Bottom left.
        --     { key = keycodes['c'], value = { 2, 1, 6, 5 } }, -- Bottom center.
        --     { key = keycodes['v'], value = { 6, 5, 6, 5 } }, -- Bottom right.
        -- }

        -- -- Callback for mapping the jump coordinates of the chosen screen or app frame.
        -- function mapJumpCoords(frame, jumpCode)
        --     local widthDiv = jumpCode[1]
        --     local widthMul = jumpCode[2]
        --     local heightDiv = jumpCode[3]
        --     local heightMul = jumpCode[4]
        --     local posX = math.floor(frame.x + (frame.w / widthDiv) * widthMul)
        --     local posY = math.floor(frame.y + (frame.h / heightDiv) * heightMul)
        --     local pos = { x = posX, y = posY }
        --     return pos
        -- end

        -- -- If semi-colon is pressed, focus the grid on the currently focused app.
        -- if code == keycodes[';'] then
        --     -- chosenFrame = hs.window.focusedWindow():frame()
        --     modules.AppGrid.throttleScrollEvents = true
        --     if event:getType() == eventTypes.keyDown then
        --         modules.AppGrid:displayGrid()
        --         semicolonHeld = true
        --     elseif event:getType() == eventTypes.keyUp then
        --         semicolonHeld = false
        --         throttleInputRepeat = false
        --     end
        -- end

        -- -- If quote is pressed, focus it on the current screen.
        -- if code == keycodes["'"] then
        --     chosenFrame = screenFrame
        --     if event:getType() == eventTypes.keyDown then
        --         quoteHeld = true
        --     elseif event:getType() == eventTypes.keyUp then
        --         quoteHeld = false
        --         throttleInputRepeat = false
        --     end
        -- end

        -- -- Map the coords to a table if the relevant key is pressed.
        -- if semicolonHeld or quoteHeld then
        --     if throttleInputRepeat then
        --         return true
        --     else
        --         throttleInputRepeat = true
        --         modules.AppGrid:hideGrid()
        --         modules.AppGrid.throttleScrollEvents = true
        --         -- Check if the currently selected frame is the same as the last one.
        --         if chosenFrame == previousFrame then
        --             for i, v in pairs(mappedCoords) do
        --                 modules.AppGrid:mapCoords(i, v)
        --             end
        --         else
        --             mappedCoords = {} -- Clear the mappedCoords table.
        --             for i, v in ipairs(jumpKeyTable) do
        --                 local keycode = keycodes[v.key]
        --                 local value = v.value
        --                 local highlightPos = mapJumpCoords(chosenFrame, value)
        --                 mappedCoords[keycode] = highlightPos -- Save the coordinates in mappedCoords table.
        --                 modules.AppGrid:mapCoords(keycode, highlightPos)
        --             end
        --         end
        --         previousFrame = chosenFrame
        --     end
        -- end




        -- if modules.AppGrid.isGridDisplayed then
        --     -- ! There are duplicate objects being created when jump is activated.
        --     -- Possibly solved with keyUp condition, need to test.
        --     if event:getType() == eventTypes.keyUp then
        --         if jumpTriggerKeys[code] then
        --             modules.AppGrid:hideGrid()
        --             local highlightPos = mappedCoords[keycodes[code]]
        --             modules.CursorJump:go(highlightPos)
        --             modules.AppGrid.throttleScrollEvents = false
        --         end
        --     end
        -- end

        -- -- If the app fram has changed.
        -- if chosenFrame.w ~= modules.AppGrid.cachedFrame.w then
        --     modules.AppGrid.mappedCoords = {} -- Clear the modules.AppGrid.mappedCoords table.
        --     for i, v in ipairs(jumpKeyTable) do
        --         local keycode = keycodes[v.key]
        --         local value = v.value
        --         local highlightPos = mapJumpCoords(chosenFrame, value)
        --         modules.AppGrid.mappedCoords[keycode] = highlightPos -- Save the coordinates in modules.AppGrid.mappedCoords table.
        --         modules.AppGrid:mapCoords(keycode, highlightPos)
        --     end
        -- end


        -- -- If semi-colon is pressed focus the grid on the currently focused app, if quote focus it on the current screen.
        -- if code == keycodes[';'] or code == keycodes["'"] then
        --     modules.CursorHighlight:hide()

        --     -- Determine whether to create the grid on the currently focused screen or app.
        --     if code == keycodes[';'] then
        --         chosenFrame = hs.window.focusedWindow():frame()
        --     elseif code == keycodes["'"] then
        --         chosenFrame = screenFrame
        --     end

        --     -- Only map the grid on a key up event to prevent function calls from spamming.
        --     if event:getType() == eventTypes.keyUp then
        --         -- Check if the currently selected frame is the same as the last one.
        --         if chosenFrame == previousFrame then
        --             for i, v in ipairs(mappedCoords) do
        --                 local key = v.key
        --                 local highlightPos = v.value
        --                 modules.CursorHighlight:showJumpCoords(key, highlightPos)
        --             end
        --         else
        --             -- Clear the mappedCoords table if it exists so it can be repopulated with new coords.
        --             mappedCoords = {}
        --             for i, v in ipairs(jumpKeyTable) do
        --                 local key = hs.keycodes.map[v.key]
        --                 local value = v.value
        --                 local highlightPos = mapJumpCoords(chosenFrame, value)
        --                 local currentCoordTable = {
        --                     key = key,
        --                     value = highlightPos
        --                 }
        --                 table.insert(mappedCoords, currentCoordTable)
        --                 modules.CursorHighlight:showJumpCoords(key, highlightPos)
        --             end
        --         end
        --         previousFrame = chosenFrame
        --     end
        -- end


        -- if modules.CursorHighlight.isGridDisplayed then
        --     if event:getType() == eventTypes.keyUp then
        --         if code == keycodes[mappedCoords.key] then
        --             print(mappedCoords.key)
        --         end
        --     end
        -- end

        -- if mappedCoords[code] then
        --     local highlightPos = mappedCoords[code]
        --     -- modules.CursorHighlight:showJumpCoords(code, highlightPos)
        --     print(highlightPos)
        -- end


        -- -- If the jump grid is displayed and one of the corresponding jump key is pressed perform a grid jump.
        -- if modules.CursorHighlight.isGridDisplayed then
        --     -- -- Create a key lookup table.
        --     -- local mappedCoordsLookup = {}
        --     -- for i, v in ipairs(mappedCoords) do
        --     --     local key = v.key
        --     --     mappedCoordsLookup[key] = v.value
        --     -- end

        --     if event:getType() == eventTypes.keyUp then

        --         -- local key = hs.keycodes.map[code]
        --         -- local highlightPos = mappedCoordsLookup[code]

        --         local highlightPos = mappedCoords[code]
        --         if highlightPos then
        --             modules.CursorHighlight:show(highlightPos)
        --         end

        --         if mappedCoords[code] then
        --             local highlightPos = mappedCoords[code]
        --             modules.CursorHighlight:show(highlightPos)
        --         end

        --     end
        -- end

        -- -- if jumpKeyTable[code] then
        -- if mappedCoords[code] then
        --     -- local entry = jumpKeyTable[code]
        --     -- local key = keycodes[entry.key]
        --     local entry = mappedCoords[code]
        --     local key = entry.key
        --     print(key)
        -- end

        -- -- After populating the mappedCoords table
        -- for i, v in ipairs(mappedCoords) do
        --     local key = v.key
        --     print(key)
        -- end

------------------------------------------------------------------------------------------------------------------

        -- hs.timer.doAfter(i * 0.01, function()
        --     modules.CursorHighlight:showJumpCoords(key, highlightPos)
        -- end)

        -- if code == keycodes[';'] or code == keycodes["'"] then
        --     -- Determine whether to create the grid on the currently focused screen or app.
        --     if code == keycodes[';'] then
        --         chosenFrame = hs.window.focusedWindow():frame()
        --     elseif code == keycodes["'"] then
        --         chosenFrame = screenFrame
        --     end

        --     if event:getType() == eventTypes.keyUp then
        --         -- Check if the currently selected frame is the same as the last one.
        --         if chosenFrame == previousFrame then
        --             sameFrameSelected = true
        --         end
        --         previousFrame = chosenFrame

        --         for i, entry in ipairs(jumpKeyTable) do
        --             local key = hs.keycodes.map[entry.key]
        --             local value = entry.value
        --             local highlightPos = mapJumpCoords(chosenFrame, value)

        --             local currentCoordTable = {
        --                 key = key,
        --                 value = highlightPos
        --             }
        --             table.insert(mappedCoords, currentCoordTable)

        --             -- print('Key:', currentCoordTable.key)
        --             -- print('Value-X:', currentCoordTable.value.x)
        --             -- print('Value-Y:', currentCoordTable.value.y)
        --             -- print('-------------------------')

        --             hs.timer.doAfter(i * 0.04, function()
        --                 modules.CursorHighlight:showJumpCoords(highlightPos, key, value)
        --             end)
        --         end

        --     end
        -- end


        -- local sameFrameSelected = false

        -- if code == keycodes[';'] or code == keycodes["'"] then
        --     -- Determine whether to create the grid on the currently focused screen or app.
        --     if code == keycodes[';'] then
        --         chosenFrame = hs.window.focusedWindow():frame()
        --     elseif code == keycodes["'"] then
        --         chosenFrame = screenFrame
        --     end

        --     if event:getType() == eventTypes.keyUp then
        --         -- Check if the currently selected frame is the same as the last one.
        --         if chosenFrame == previousFrame then
        --             sameFrameSelected = true
        --         else
        --             sameFrameSelected = false
        --         end
        --         previousFrame = chosenFrame

        --         if sameFrameSelected then
        --             for i, v in ipairs(mappedCoords) do
        --                 local key = v.key
        --                 local highlightPos = v.value

        --                 print('second')

        --                 hs.timer.doAfter(i * 0.04, function()
        --                     modules.CursorHighlight:showJumpCoords(key, highlightPos)
        --                 end)
        --             end
        --         else
        --             for i, v in ipairs(jumpKeyTable) do
        --                 local key = hs.keycodes.map[v.key]
        --                 local value = v.value
        --                 local highlightPos = mapJumpCoords(chosenFrame, value)

        --                 print('first')

        --                 local currentCoordTable = {
        --                     key = key,
        --                     value = highlightPos
        --                 }
        --                 table.insert(mappedCoords, currentCoordTable)

        --                 hs.timer.doAfter(i * 0.04, function()
        --                     modules.CursorHighlight:showJumpCoords(key, highlightPos)
        --                 end)
        --             end
        --         end
        --     end
        -- end


        -- for i, v in ipairs(mappedCoords) do
        --     print('Key:', v.key)
        --     print('Value-X:', v.value.x)
        --     print('Value-Y:', v.value.y)
        --     print('-------------------------')
        -- end

        -- print('Key:', key)
        -- print('Value-X:', highlightPos.x)
        -- print('Value-Y:', highlightPos.y)
        -- print('-------------------------')



            -- Here we create a new table to store the last mapped coords so that
            -- we don't need to call the mapJumpCoords function again if the same
            -- frame is chosen to map the coords on.

            -- -- local mappedCoords = {}
            -- mappedCoords = {}
            -- mappedCoords[key] = highlightPos

            -- -- Print the results of the new table.
            -- for key, value in pairs(mappedCoords) do
            --     print('Key:', key)
            --     print('Value-X:', value.x)
            --     print('Value-Y:', value.y)
            --     print('-------------------------')
            -- end

            -- ! You still need to set up conditional logic to determine if the
            -- ! chosen frame is the same as the last one and thus skip over
            -- ! remapping the jump coords.


        -------------------------------------------------------------------------------------------------------------------------------------

        -- -- Sets the up/down state of the 'o' key when pressed or released.
        -- if code == keycodes[';'] then
        --     if event:getType() == eventTypes.keyDown then
        --         semicolonHeld = true
        --     elseif event:getType() == eventTypes.keyUp then
        --         semicolonHeld = false
        --     end
        -- end

        -- -- Sets the up/down state of the 'quote' key when pressed or released.
        -- if code == keycodes["'"] then
        --     if event:getType() == eventTypes.keyDown then
        --         quoteHeld = true
        --     elseif event:getType() == eventTypes.keyUp then
        --         quoteHeld = false
        --     end
        -- end

        -- -- Hold down 'quote' or 'semi-colon' to activate layers containing keybindings for each jump location relative to the current screen or app.
        -- -- if not flags.shift and not flags.cmd then
        -- if semicolonHeld or quoteHeld then
        --     local chosenFrame = nil

        --     -- If 'quote' is held center the grid on the current screen, if 'semi-colon' is held center it on the focused window.
        --     if quoteHeld then
        --         chosenFrame = screenFrame
        --     elseif hs.window.focusedWindow():frame() == nil then
        --         chosenFrame = screenFrame
        --     elseif semicolonHeld then
        --         chosenFrame = hs.window.focusedWindow():frame()
        --     else
        --         chosenFrame = screenFrame
        --     end

        --     -- The following keys jump the cursor to it's corresponding location on the grid.
        --     if code == keycodes['w'] then
        --         cursorJump(chosenFrame, 6, 1, 6, 1) -- Top left.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['e'] then
        --         cursorJump(chosenFrame, 2, 1, 6, 1) -- Top middle.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['r'] then
        --         cursorJump(chosenFrame, 6, 5, 6, 1) -- Top right.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['s'] then
        --         cursorJump(chosenFrame, 6, 1, 2, 1) -- Middle left.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['d'] then
        --         cursorJump(chosenFrame, 2, 1, 2, 1) -- Center.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['f'] then
        --         cursorJump(chosenFrame, 6, 5, 2, 1) -- Middle right.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['x'] then
        --         cursorJump(chosenFrame, 6, 1, 6, 5) -- Bottom left.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['c'] then
        --         cursorJump(chosenFrame, 2, 1, 6, 5) -- Bottom middle.
        --         modules.CursorHighlight:showOnTimer()
        --     elseif code == keycodes['v'] then
        --         cursorJump(chosenFrame, 6, 5, 6, 5) -- Bottom right.
        --         modules.CursorHighlight:showOnTimer()
        --     end

        --     -- 'G' key jumps the cursor to the next display.
        --     if code == keycodes['g'] then
        --         if event:getType() == eventTypes.keyUp then
        --             local currentScreen = hs.mouse.getCurrentScreen()
        --             local nextScreen = currentScreen:next()
        --             local rect = nextScreen:fullFrame()
        --             local center = hs.geometry.rectMidPoint(rect)
        --             hs.mouse.absolutePosition(center)
        --             modules.CursorHighlight:showOnTimer()
        --         end
        --     end
        -- end


        -- -- Jumps to a set of coordinates relative to the currently focused app or screen.
        -- function cursorJump(frame, widthDiv, widthMul, heightDiv, heightMul)
        --     local posX = frame.x + (frame.w / widthDiv) * widthMul
        --     local posY = frame.y + (frame.h / heightDiv) * heightMul
        --     hs.mouse.absolutePosition({ x = posX, y = posY })
        --     interrupt = true
        --     CursorHighlight:showOnTimer()
        -- end

        -- -- Jumps to a set of coordinates relative to the currently focused app or screen.
        -- function gridHighlight(frame, widthDiv, widthMul, heightDiv, heightMul)
        --     local posX = frame.x + (frame.w / widthDiv) * widthMul
        --     local posY = frame.y + (frame.h / heightDiv) * heightMul
        --     CursorHighlight:showOnTimer()
        -- end

        -- local jumpKeyTable = {
        --     [keycodes['w']] = true,
        --     [keycodes['e']] = true,
        --     [keycodes['r']] = true,
        --     [keycodes['s']] = true,
        --     [keycodes['d']] = true,
        --     [keycodes['f']] = true,
        --     [keycodes['x']] = true,
        --     [keycodes['c']] = true,
        --     [keycodes['v']] = true
        -- }


        -- -- if jumpKeyTable[code] then
        -- if code == keycodes[';'] then
        --     if event:getType() == eventTypes.keyUp then
        --         -- local chosenFrame = hs.window.focusedWindow():frame()
        --         local chosenFrame = screenFrame

        --         for i, jumpCode in pairs(jumpKeyTable) do
        --             local highlightPos = mapJumpCoords(chosenFrame, jumpCode)
        --             modules.CursorHighlight:show(highlightPos)
        --         end
        --     end
        -- end

        -- -- Sets the up/down state of the 'o' key when pressed or released.
        -- if code == keycodes[';'] then
        --     local chosenFrame = hs.window.focusedWindow():frame()
        --     local jumpCode = jumpKeyTable[code]
        --     local highlightPos = mapJumpCoords(chosenFrame, jumpCode)
        --     CursorHighlight:show(highlightPos)
        -- end



        -- -- Determine whether to create the grid on the currently focused screen or app.
        -- if code == keycodes[';'] then
        --     chosenFrame = hs.window.focusedWindow():frame()
        -- elseif code == keycodes["'"] then
        --     chosenFrame = screenFrame
        -- end

        -- local chosenFrame = hs.window.focusedWindow():frame()


-- local jumpKeyTable = {
--     { key = keycodes['w'], value = '6161' }, -- Top left.
--     { key = keycodes['e'], value = '2161' }, -- Top center.
--     { key = keycodes['r'], value = '6561' }, -- Top right.
--     { key = keycodes['s'], value = '6121' }, -- Center left.
--     { key = keycodes['d'], value = '2121' }, -- Center.
--     { key = keycodes['f'], value = '6521' }, -- Center right.
--     { key = keycodes['x'], value = '6165' }, -- Bottom left.
--     { key = keycodes['c'], value = '2165' }, -- Bottom center.
--     { key = keycodes['v'], value = '6565' }, -- Bottom right.
-- }

-- function mapJumpCoords(frame, jumpCode)
--     local widthDiv = tonumber(jumpCode:sub(1, 1))
--     local widthMul = tonumber(jumpCode:sub(2, 2))
--     local heightDiv = tonumber(jumpCode:sub(3, 3))
--     local heightMul = tonumber(jumpCode:sub(4, 4))
--     local posX = math.floor(frame.x + (frame.w / widthDiv) * widthMul)
--     local posY = math.floor(frame.y + (frame.h / heightDiv) * heightMul)
--     local pos = { x = posX, y = posY }
--     return pos
-- end


    -- -- local circle = self.circle
    -- -- local mouseCirclePoint = highlightPos
    -- local mouseCirclePoint = hs.mouse.absolutePosition()

    -- -- local color = nil

    -- -- Create a canvas object.
    -- local canvas = hs.canvas.new(hs.geometry.rect(mouseCirclePoint.x - 20, mouseCirclePoint.y - 20, 40, 40))

    -- -- Draw a circle with the desired stroke color and width.
    -- local strokeWidth = 4
    -- local radius = (80 - strokeWidth) / 2

    -- local grow = 38
    -- local offSet = 38
    -- local opac = 1

    -- canvasTimer = hs.timer.new(0.05, function()
        -- local canvas = hs.canvas.new(hs.geometry.rect(mouseCirclePoint.x - offSet, mouseCirclePoint.y - offSet, grow, grow))

        -- strokeWidth = strokeWidth + 1
        -- grow = grow + 2
        -- offSet = offSet + 1
        -- opac = opac - 0.1

        -- print(grow)

        -- if grow > 60 then
        --     canvas:hide()
        --     canvasTimer:stop()
        -- end

        -- canvas[1] = {
        --     type = 'circle',
        --     action = 'strokeAndFill',
        --     fillColor = { red = 1, blue = 1, green = 1, alpha = 0.1 }, -- White.
        --     strokeColor = { red = 1, blue = 0, green = 0, alpha = 1 }, -- Red.
        --     strokeWidth = strokeWidth,
        --     arcRadii = false, -- Prevent the line being drawn from the center of the circle.
        --     clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
        --     -- frame = {
        --     --     x = tostring(offSet),
        --     --     y = tostring(offSet),
        --     --     w = tostring(grow),
        --     --     h = tostring(grow)
        --     -- }
        -- }
        -- canvas:show()


    -- end)
    -- canvasTimer:start()

    -- canvas:bringToFront(true) -- Bring the canvas to the front.
    -- canvas:show(0.5) -- Show the canvas with animation
    -- self.circle = canvas -- Assign the canvas to a variable if needed.
    -- return self



        -- -- This is the letter that corresponds to the jump coordinate.
        -- innerLetter[1] = {
        --     type = 'text',
        --     text = letter,
        --     textColor = { red = 1 },
        --     textAlignment = 'center',
        --     textSize = 24,
        -- }
        -- -- innerLetter:show()

        -- local innerLetter = hs.canvas.new({
        --     x = posX,
        --     y = posY + 4,
        --     w = borderSize,
        --     h = borderSize,
        -- })




-- function CursorHighlight:showJumpCoords(highlightPos)
--     local canvasTimer = nil
--     local endAngle = 1
--     local diameter = 60
--     local offSet = diameter / 2
--     local canvas = hs.canvas.new(hs.geometry.rect(highlightPos.x - offSet, highlightPos.y - offSet, diameter, diameter))
--     -- local canvas2 = hs.canvas.new(hs.geometry.rect(highlightPos.x - offSet, highlightPos.y - offSet, diameter, diameter))

--     -- canvasTimer = hs.timer.new(0.017, function()
--     canvasTimer = hs.timer.new(0.04, function()
--         endAngle = endAngle + endAngle
--         if endAngle >= 360 then
--             canvasTimer:stop()
--         end

--         -- canvas:appendElements({
--         canvas[1] = {
--             type = 'ellipticalArc',
--             action = 'stroke',
--             strokeWidth = 5,
--             strokeColor = { red = 1, green = 0, blue = 0, alpha = 1 }, -- Red.
--             arcRadii = false, -- Prevent the line being drawn from the center of the circle.
--             clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--             startAngle = 0,
--             endAngle = endAngle
--         }
--         -- })
--         canvas:show()
--     end)
--     canvasTimer:start()
-- end






-- -- Only post mouse events when within the edges of the screen to prevent out of bounds bug.
-- if inBoundsX and inBoundsY then
--     postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
-- else
--     hs.mouse.absolutePosition(coords)
-- end

-- -------------------------------------------------------------------------------------------------------------------------------------
-- -- Enable mouse clicking and dragging when the spacebar is held down.
-- -------------------------------------------------------------------------------------------------------------------------------------
-- if code == keycodes.space then
--     if repeating ~= 0 then
--         return true -- This prevents click inputs spamming when the space bar is held down.
--     end

--     -- Enable right click with the shift flag.
--     local btn = 'left'
--     if flags.shift and not flags.alt then
--         btn = 'right'
--     end

--     -- Send only one mouse click if the interval between clicks is greater than the double click threshold set by the OS.
--     local now = hs.timer.secondsSinceEpoch()
--     if now - mousepressTime > hs.eventtap.doubleClickInterval() then
--         mousepress = 1
--     end

--     -- Toggle click and drag by pressing and releasing the space bar.
--     if event:getType() == eventTypes.keyUp then
--         dragging = false
--         -- postMouseEvent(eventTypes[btn..'MouseUp'], coords, flags, mousepress)
--     elseif event:getType() == eventTypes.keyDown then
--         dragging = true
--         -- Send a double click event if the spacebar is pressed twice within a 0.2 second window.
--         if now - mousedownTime <= 0.22 then
--             mousepress = mousepress + 1
--             mousepressTime = now
--         end

--         -- Post dragging events while the space bar is held down.
--         mousedownTime = hs.timer.secondsSinceEpoch()
--         -- postMouseEvent(eventTypes[btn..'MouseDown'], coords, flags, mousepress)
--     end
--     -- orig_coords = coords
-- end

---------------------------------------------------------------------------------------------------------------------------------------------

-- local inBoundsLeft = true
-- local inBoundsRight = true
-- local inBoundsUp = true
-- local inBoundsDown = true

-- if coords.x - (step * 2) <= 0 then inBoundsLeft = false end
-- if coords.x + (step * 2) >= currentScreenFrame.w then inBoundsRight = false end
-- if coords.y - (step * 2) <= 0 then inBoundsUp = false end
-- if coords.y + (step * 2) >= currentScreenFrame.h then inBoundsDown = false end

-- if coords.x - step <= 0 then inBoundsLeft = false end
-- if coords.x + step >= currentScreenFrame.w then inBoundsRight = false end
-- if coords.y - step <= 0 then inBoundsUp = false end
-- if coords.y + step >= currentScreenFrame.h then inBoundsDown = false end


-- -- Handler for mouse move events.
-- mouseHandler = hs.eventtap.new({eventTypes.mouseMoved}, function(event)
--     if not ctrl_keyDown then
--         if keyHeld then
--             acceleration = acceleration + 1
--         else
--             acceleration = 1
--         end
--     end
-- end)

---------------------------------------------------------------------------------------------------------------------------------------------

-- function postKeyStrokes(postFlag, keyStr, isDown)
--     local e = hs.eventtap.event.newKeyEvent(postFlag, keyStr, isDown)
--     e:setProperty(eventPropTypes.keyboardEventAutorepeat, 1)
--     e:post()
-- end

-- Experimental capslock led falsh.
--
-- local switch = false
-- capslockTimer = hs.timer.new(1, function()
--     if switch == false then
--         switch = true
--     elseif switch == true then
--         switch = false
--     end
--     hs.hid.capslock.set(switch)
-- end)



-- function postKeyStrokes(postFlag, keyStr, isDown)
--     local e = hs.eventtap.event.newKeyEvent(postFlag, keyStr, isDown)
--     e:setProperty(eventPropTypes.keyboardEventAutorepeat, 1)
--     print('hello')
--     if interrupt then
--         e:setProperty(eventPropTypes.keyboardEventAutorepeat, 0)
--         keyAutoRepeating = nil
--         print('interrupt')
--     elseif not keyHeld then
--         e:setProperty(eventPropTypes.keyboardEventAutorepeat, 0)
--         keyAutoRepeating = nil
--         print('not keyHeld')
--     elseif shift_keyDown then
--         e:setProperty(eventPropTypes.keyboardEventAutorepeat, 0)
--         keyAutoRepeating = nil
--         print('shift isDown')
--     end
--     e:post()
-- end

-------------------------------------------------------------------------------------------------------------------------------------
-- Logic block responsible for calling main movement functions.
-------------------------------------------------------------------------------------------------------------------------------------


-- if code == keycodes['k'] then
--     if event:getType() == eventTypes.keyDown then
--         KeyRepeat.cancelTimer = false
--         KeyRepeat.k = true
--     elseif event:getType() == eventTypes.keyUp then
--         KeyRepeat.k = false
--     end
-- end

-- if code == keycodes['i'] then
--     if event:getType() == eventTypes.keyDown then
--         KeyRepeat.cancelTimer = false
--         KeyRepeat.i = true
--     elseif event:getType() == eventTypes.keyUp then
--         KeyRepeat.i = false
--     end
-- end

-- if code == keycodes['l'] then
--     if event:getType() == eventTypes.keyDown then
--         KeyRepeat.cancelTimer = false
--         KeyRepeat.l = true
--     elseif event:getType() == eventTypes.keyUp then
--         KeyRepeat.l = false
--     end
-- end

-- if code == keycodes['t'] then
--     if event:getType() == eventTypes.keyDown then
--         KeyRepeat.cancelTimer = false
--         KeyRepeat.t = true
--     elseif event:getType() == eventTypes.keyUp then
--         KeyRepeat.t = false
--     end
-- end


-- if code == keycodes['k'] then
--     if event:getType() == eventTypes.keyDown then
--         -- KeyRepeat.k = true
--         -- KeyRepeat.keyHeld = true
--         -- interrupt = true
--         halt = false
--         k_keyDown = true
--         -- keyHeld = true
--     elseif event:getType() == eventTypes.keyUp then
--         -- KeyRepeat.k = false
--         -- interrupt = false
--         k_keyDown = false
--     -- else
--         -- KeyRepeat.keyHeld = false
--         -- keyHeld = false
--     end
-- end

-- if code == keycodes['i'] then
--     if event:getType() == eventTypes.keyDown then
--         -- KeyRepeat.i = true
--         -- KeyRepeat.keyHeld = true
--         -- interrupt = true
--         halt = false
--         i_keyDown = true
--         -- keyHeld = true
--     elseif event:getType() == eventTypes.keyUp then
--         -- KeyRepeat.i = false
--         -- interrupt = false
--         i_keyDown = false
--     -- else
--         -- KeyRepeat.keyHeld = false
--         -- keyHeld = false
--     end
-- end

-- if code == keycodes['l'] then
--     if event:getType() == eventTypes.keyDown then
--         -- KeyRepeat.l = true
--         -- KeyRepeat.keyHeld = true
--         -- interrupt = true
--         halt = false
--         l_keyDown = true
--         -- keyHeld = true
--     elseif event:getType() == eventTypes.keyUp then
--         -- KeyRepeat.l = false
--         -- interrupt = false
--         l_keyDown = false
--     -- else
--         -- KeyRepeat.keyHeld = false
--         -- keyHeld = false
--     end
-- end

-- if code == keycodes['t'] then
--     if event:getType() == eventTypes.keyDown then
--         -- KeyRepeat.t = true
--         -- KeyRepeat.keyHeld = true
--         -- interrupt = true
--         halt = false
--         t_keyDown = true
--         -- keyHeld = true
--     elseif event:getType() == eventTypes.keyUp then
--         -- KeyRepeat.t = false
--         -- interrupt = false
--         t_keyDown = false
--     -- else
--         -- KeyRepeat.keyHeld = false
--         -- keyHeld = false
--     end
-- end


--------------------------------------------------------------------------------------------------------------------


-- local move_x = 2
-- local move_y = 2

-- if not flags.cmd and not flags.alt then

--     if code == keycodes['i'] then
--         if event:getType() == eventTypes.keyDown then
--             i_keyDown = true
--             interrupt = true
--             keyHeld = true
--         elseif event:getType() == eventTypes.keyUp then
--             i_keyDown = false
--             interrupt = false
--             if t_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(-step, 'x') -- Right.

--                 -- modules.KeyRepeat:begin(-move_x, nil) -- Right.
--             elseif l_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(step, 'x') -- Left.

--                 -- modules.KeyRepeat:begin(move_x, nil) -- Left.
--             else
--                 keyHeld = false
--             end
--         end
--     end

--     if code == keycodes['t'] then
--         if event:getType() == eventTypes.keyDown then
--             t_keyDown = true
--             interrupt = true
--             keyHeld = true
--         elseif event:getType() == eventTypes.keyUp then
--             t_keyDown = false
--             interrupt = false
--             if i_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(-step, 'y') -- Up.

--                 -- modules.KeyRepeat:begin(nil, -move_y) -- Up.
--             elseif k_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(step, 'y') -- Down.

--                 -- modules.KeyRepeat:begin(nil, move_y) -- Down.
--             else
--                 keyHeld = false
--             end
--         end
--     end

--     if code == keycodes['k'] then
--         if event:getType() == eventTypes.keyDown then
--             k_keyDown = true
--             interrupt = true
--             keyHeld = true
--         elseif event:getType() == eventTypes.keyUp then
--             k_keyDown = false
--             interrupt = false
--             if t_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(-step, 'x') -- Right.

--                 -- modules.KeyRepeat:begin(-move_x, nil) -- Right.
--             elseif l_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(step, 'x') -- Left.

--                 -- modules.KeyRepeat:begin(move_x, nil) -- Left.
--             else
--                 keyHeld = false
--             end
--         end
--     end

--     if code == keycodes['l'] then
--         if event:getType() == eventTypes.keyDown then
--             l_keyDown = true
--             interrupt = true
--             keyHeld = true
--         elseif event:getType() == eventTypes.keyUp then
--             l_keyDown = false
--             interrupt = false
--             if i_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(-step, 'y') -- Up.

--                 -- modules.KeyRepeat:begin(nil, -move_y) -- Up.
--             elseif k_keyDown then
--                 keyAutoRepeating = true
--                 -- modules.MoveCursor:keyRepeat(step, 'y') -- Down.

--                 -- modules.KeyRepeat:begin(nil, move_y) -- Down.
--             else
--                 keyHeld = false
--             end
--         end
--     end

-- end



-- if i_keyDown then
--     if t_keyDown then
--         modules.MoveCursor:diagonally(-step, -step) -- Up and left.
--     else
--         modules.MoveCursor:vertically(-step) -- Up.
--     end
-- end

-- ------------------------------------------------------------------------------------------------------------------------

-- if t_keyDown then
--     if k_keyDown then
--         modules.MoveCursor:diagonally(-step, step) -- Down and left.
--     else
--         modules.MoveCursor:horizontally(-step) -- Left.
--     end
-- end

-- ------------------------------------------------------------------------------------------------------------------------

-- if k_keyDown then
--     if l_keyDown then
--         modules.MoveCursor:diagonally(step, step) -- Down and right.
--     else
--         modules.MoveCursor:vertically(step) -- Down.
--     end
-- end

-- ------------------------------------------------------------------------------------------------------------------------

-- if l_keyDown then
--     if i_keyDown then
--         modules.MoveCursor:diagonally(step, -step) -- Up and right.
--     else
--         modules.MoveCursor:horizontally(step) -- Right.
--     end
-- end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


        -- local axisTable = {
        --     vertical = {
        --         [hs.keycodes.map['k']] = 8,
        --         [hs.keycodes.map['i']] = -8
        --     },
        --     horizontal = {
        --         [hs.keycodes.map['l']] = 8,
        --         [hs.keycodes.map['t']] = -8
        --     }
        -- }

        -- local vert = next(axisTable)
        -- local hori = next(axisTable, firstKey)
        -- -- print(hori)
        -- -- print(vert)

        -- local kiltKeys = {
        --     hs.keycodes.map['k'],
        --     hs.keycodes.map['i'],
        --     hs.keycodes.map['l'],
        --     hs.keycodes.map['t']
        -- }

        -- if kiltKeys[code] then
        --     print(code)
        -- end


        -- if code == keycodes['y'] then
        --     if event:getType() == eventTypes.keyDown then
        --         y_keyDown = true
        --     elseif event:getType() == eventTypes.keyUp then
        --         y_keyDown = false
        --     end
        -- end


        -- local kiltKeys = {
        --     kv = {
        --         [hs.keycodes.map['k']] = 8,
        --         [hs.keycodes.map['i']] = -8,
        --         [hs.keycodes.map['l']] = 8,
        --         [hs.keycodes.map['t']] = -8
        --     }
        -- }

        -- if kiltKeys.kv[code] then
        --     -- print(code)
        --     modules.KeyRepeat:begin(code)
        -- end

        -- letter = keycodes[code] -- Alphabetical keycode.


        -- if axisTable.vertical[code] then
            -- local step_y = axisTable.vertical[code]
            -- step_y = axisTable.vertical[code]
            -- letter = keycodes[code] -- Alphabetical keycode.
            -- print(letter)
            -- print(code) -- Numeric keycode.
            -- modules.KeyRepeat:yAxis('y')
        -- end

        -- if axisTable.horizontal[code] then
            -- local step_x = axisTable.horizontal[code]
            -- step_x = axisTable.horizontal[code]
            -- letter = keycodes[code] -- Alphabetical keycode.
            -- print(letter)
            -- print(code) -- Numeric keycode.
            -- modules.KeyRepeat:xAxis('x', step_x)
            -- modules.KeyRepeat:xAxis('x')
        -- end

        -- local axisTable = {
        --     vertical {
        --         hs.keycodes.map['k'] = 'y',
        --         hs.keycodes.map['i'] = 'y',
        --     },
        --     horizontal {
        --         hs.keycodes.map['l'] = 'x',
        --         hs.keycodes.map['t'] = 'x',
        --     }
        -- }

        -- local kilt = {}
        -- for i, key in ipairs(kiltKeys) do
        --     kilt[key] = true
        -- end

        -- -- Now you can perform lookups on the kilt table
        -- if kilt[code] then
        --     print('Keycode ' .. code)
        -- end



        -- -- Return the vertical or horizontal value
        -- for k in pairs(axisTable) do
        --     print(k)
        -- end




        -- local axisTable = {
        --     vertical = {
        --         [hs.keycodes.map['k']] = 2,
        --         [hs.keycodes.map['i']] = -2
        --     },
        --     horizontal = {
        --         [hs.keycodes.map['l']] = 2,
        --         [hs.keycodes.map['t']] = -2
        --     }
        -- }
        -- -- if k_keyDown or i_keyDown or l_keyDown or t_keyDown then
        -- if event:getType() == eventTypes.keyUp then







        -- if event:getType() == eventTypes.keyDown then
        --     if axisTable.vertical[code] then
        --         local yIncrement = axisTable.vertical[code]
        --         modules.KeyRepeat:yAxis('y', yIncrement, code)
        --     end

        --     if axisTable.horizontal[code] then
        --         local xIncrement = axisTable.horizontal[code]
        --         modules.KeyRepeat:xAxis('x', xIncrement, code)
        --     end
        -- end

        -- if event:getType() == eventTypes.keyUp then
        --     if axisTable.vertical[code] then
        --         local yIncrement = axisTable.vertical[code]
        --         -- print('y')
        --         modules.KeyRepeat:yAxis('y', yIncrement, code)
        --     end

        --     if axisTable.horizontal[code] then
        --         local xIncrement = axisTable.horizontal[code]
        --         -- print('x')
        --         modules.KeyRepeat:xAxis('x', xIncrement, code)
        --     end
        -- end

        -- if axisTable.vertical[code] then
        --     modules.KeyRepeat:begin('y', move_y) -- Down.
        -- end



        -- -- Loop through the axisTable
        -- for axis, keyTable in pairs(axisTable) do
        --     print('Axis:', axis)

        --     -- Loop through the keyTable for each axis
        --     for keycode, value in pairs(keyTable) do
        --         -- print('Keycode:', keycode, 'Value:', value)
        --     end
        -- end



        -- local code = event:getKeyCode()
        -- local keycodes = hs.keycodes.map
        -- local eventPropTypes = hs.eventtap.event.properties

        -- if event:getType() == eventTypes.keyUp then
        --     if t_keyDown or l_keyDown then
        --         local step_x = axisTable.horizontal[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:xAxis('x', step_x, letter)
        --     end

        --     if i_keyDown or k_keyDown then
        --         local step_y = axisTable.vertical[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:yAxis('y', step_y, letter)
        --     end
        -- end



        -- if k_keyDown then
        --     -- if axisTable.horizontal[code] then
        --         local step_y = axisTable.horizontal[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:k('y', step_y, k_keyDown)
        --     -- end
        -- end

        -- if i_keyDown then
        --     -- if axisTable.horizontal[code] then
        --         local step_y = axisTable.horizontal[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:i('y', step_y, i_keyDown)
        --     -- end
        -- end

        -- if l_keyDown then
        --     -- if axisTable.horizontal[code] then
        --         local step_x = axisTable.horizontal[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:l('x', step_x, l_keyDown)
        --     -- end
        -- end

        -- if t_keyDown then
        --     -- if axisTable.horizontal[code] then
        --         local step_x = axisTable.horizontal[code]
        --         local letter = keycodes[code] -- Alphabetical keycode.
        --         modules.KeyRepeat:t('x', step_x, t_keyDown)
        --     -- end
        -- end


        -- if axisTable.vertical[code] then
        --     local key = nil
        --     for k, v in pairs(keycodes) do
        --         if v == code then
        --             key = k
        --             break
        --         end
        --     end

        --     -- print(key)
        -- end

        -- -- Print the key and value of sub-tables
        -- for a, kT in pairs(axisTable) do
        --     print(a)
        --     for k, v in pairs(kT) do
        --         print(k, v)
        --     end
        -- end

        -- -- Loop through the keyTable for each axis
        -- for keycode, value in pairs(keyTable) do
        --     -- print('Keycode:', keycode, 'Value:', value)
        -- end


        -- -- Loop through the axisTable
        -- for axis, keyTable in pairs(axisTable) do
        --     print('Axis:', axis)
        --     -- Loop through the keyTable for each axis
        --     for keycode, value in pairs(keyTable) do
        --         print('Keycode:', keycode, 'Value:', value)
        --     end
        -- end





        -- local kiltKeys = {
        --     hs.keycodes.map['k'],
        --     hs.keycodes.map['i'],
        --     hs.keycodes.map['l'],
        --     hs.keycodes.map['t']
        -- }

        -- local indexOrder = {
        --     [hs.keycodes.map['k']] = 1,
        --     [hs.keycodes.map['i']] = 2,
        --     [hs.keycodes.map['l']] = 3,
        --     [hs.keycodes.map['t']] = 4
        -- }

        -- local kilt = {}
        -- for i, key in ipairs(kiltKeys) do
        --     kilt[indexOrder[key]] = key
        -- end

        -- -- Print the kilt table
        -- for index, keycode in ipairs(kilt) do
        --     print('Index:', index, 'Keycode:', keycode)
        -- end



        -- local move_x = 2
        -- local move_y = 2

        -- if i_keyDown then
        --     print('i down')
        -- elseif not i_keyDown then
        --     print('i up')
        -- end
        -- if t_keyDown then
        --     print('t down')
        -- elseif not t_keyDown then
        --     print('t up')
        -- end

        -- print(keyHeld)
        -- print(repeating)
        -- Try to use repeating to initiate the repeat timer. 1 is keyDown 0 is keyUp

        -- if event:getType() == eventTypes.keyDown then

        --     if k_keyDown and t_keyDown then
        --         modules.KeyRepeat:begin(-move_x, move_y) -- Down and Right.
        --     end

        --     -- if k_keyDown then
        --     --     modules.KeyRepeat:begin(nil, move_y) -- Down.
        --     -- end

        --     -- if i_keyDown then
        --     --     modules.KeyRepeat:begin(nil, -move_y) -- Up.
        --     -- end

        --     -- if l_keyDown then
        --     --     modules.KeyRepeat:begin(move_x, nil) -- Left.
        --     -- end

        --     -- if t_keyDown then
        --     --     modules.KeyRepeat:begin(-move_x, nil) -- Right.
        --     -- end

        -- end







-------------------------------------------------------------------------------------------------------------------------------------
        -- if shift_keyDown or not keyHeld or cancelTimer then
        -- if shift_keyDown or KeyRepeat.cancelTimer then

        -- if KeyRepeat.k_keyDown then coords.y = coords.y + step end
        -- if KeyRepeat.i_keyDown then coords.y = coords.y + -step end
        -- if KeyRepeat.l_keyDown then coords.x = coords.x + step end
        -- if KeyRepeat.t_keyDown then coords.x = coords.x + -step end

        -- if k_keyDown then coords.y = coords.y + step end
        -- if i_keyDown then coords.y = coords.y + -step end
        -- if l_keyDown then coords.x = coords.x + step end
        -- if t_keyDown then coords.x = coords.x + -step end

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-- function updateCursorCoords(step_x, step_y)
--     local eventTypes = hs.eventtap.event.types
--     local coords = hs.mouse.absolutePosition()

--     if ctrl_keyDown then
--         if step_x then
--             step_x = step_x / 4
--         end
--         if step_y then
--             step_y = step_y / 4
--         end
--     end

--     if step_x then
--         coords.x = coords.x + step_x
--     end
--     if step_y then
--         coords.y = coords.y + step_y
--     end

--     postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
-- end

-- -- function updateCursorCoords(axis, step)
-- function updateCursorCoords(axis)
--     local eventTypes = hs.eventtap.event.types
--     local coords = hs.mouse.absolutePosition()

--     if ctrl_keyDown then
--         step = step / 4
--     end

--     -- if t_keyDown or l_keyDown then
--     --     coords.x = coords.x + step_x
--     -- if i_keyDown or k_keyDown then
--     --     coords.y = coords.y + step_y
--     -- end

--     if axis == 'x' then
--         coords.x = coords.x + step_x
--     end

--     if axis == 'y' then
--         coords.y = coords.y + step_y
--     end

--     postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
-- end

-- function updateCursorCoords()
--     local eventTypes = hs.eventtap.event.types
--     local coords = hs.mouse.absolutePosition()
--     local step = 24

--     if ctrl_keyDown then
--         step = step / 4
--     end

--     if k_keyDown then
--         coords.y = coords.y + step
--     end
--     if i_keyDown then
--         coords.y = coords.y + -step
--     end
--     if l_keyDown then
--         coords.x = coords.x + step
--     end
--     if t_keyDown then
--         coords.x = coords.x + -step
--     end

--     postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
-- end

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-- function KeyRepeat:xAxis(axis)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local xTimer

--     if KeyRepeat.xAxisRepeating then
--         return
--     end
--     KeyRepeat.xAxisRepeating = axis

--     xTimer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()
--         local dom = nil

--         -- print(step)
--         -- print(letter)

--         if t_keyDown then
--             dom = t_keyDown
--         elseif l_keyDown then
--             dom = l_keyDown
--         end

--         if shift_keyDown or not dom then
--             KeyRepeat.xAxisRepeating = false
--             xTimer:stop()
--         else
--             -- updateCursorCoords(axis, step)
--             updateCursorCoords(axis)
--         end
--     end)
--     xTimer:start()
-- end

-- function KeyRepeat:yAxis(axis)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local yTimer

--     if KeyRepeat.yAxisRepeating then
--         return
--     end
--     KeyRepeat.yAxisRepeating = axis

--     yTimer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()
--         local dom = nil

--         if i_keyDown then
--             dom = i_keyDown
--         elseif k_keyDown then
--             dom = k_keyDown
--         end

--         if shift_keyDown or not dom then
--             -- postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)
--             KeyRepeat.yAxisRepeating = false
--             yTimer:stop()
--         else
--             -- updateCursorCoords(axis, step)
--             updateCursorCoords(axis)
--         end
--     end)
--     yTimer:start()
-- end


-- function KeyRepeat:yAxis(axis, step, yKey)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local yTimer

--     if KeyRepeat.yAxisRepeating then
--         return
--     end
--     KeyRepeat.yAxisRepeating = yKey

--     yTimer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         -- if shift_keyDown or not keyHeld then
--         if shift_keyDown or not i_keyDown then
--             -- postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)

--             KeyRepeat.yAxisRepeating = false
--             yTimer:stop()
--         else
--             updateCursorCoords(axis, step)
--         end
--     end)
--     yTimer:start()
-- end


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------


-- function KeyRepeat:k(axis, step, key)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local k_Timer

--     if KeyRepeat.xAxisRepeating then
--         return
--     end
--     KeyRepeat.xAxisRepeating = key

--     k_Timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         if shift_keyDown or i_keyDown or not k_keyDown then
--             KeyRepeat.xAxisRepeating = false
--             k_Timer:stop()
--         else
--             updateCursorCoords(axis, step)
--         end
--     end)
--     k_Timer:start()
-- end


-- function KeyRepeat:i(axis, step, key)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local i_Timer

--     if KeyRepeat.xAxisRepeating then
--         return
--     end
--     KeyRepeat.xAxisRepeating = key

--     i_Timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         if shift_keyDown or k_keyDown or not i_keyDown then
--             KeyRepeat.xAxisRepeating = false
--             i_Timer:stop()
--         else
--             updateCursorCoords(axis, step)
--         end
--     end)
--     i_Timer:start()
-- end


-- function KeyRepeat:l(axis, step, key)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local l_Timer

--     if KeyRepeat.xAxisRepeating then
--         return
--     end
--     KeyRepeat.xAxisRepeating = key

--     l_Timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         if shift_keyDown or t_keyDown or not l_keyDown then
--             KeyRepeat.xAxisRepeating = false
--             l_Timer:stop()
--         else
--             updateCursorCoords(axis, step)
--         end
--     end)
--     l_Timer:start()
-- end


-- function KeyRepeat:t(axis, step, key)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local t_Timer

--     if KeyRepeat.xAxisRepeating then
--         return
--     end
--     KeyRepeat.xAxisRepeating = key

--     t_Timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         if shift_keyDown or l_keyDown or not t_keyDown then
--             KeyRepeat.xAxisRepeating = false
--             t_Timer:stop()
--         else
--             updateCursorCoords(axis, step)
--         end
--     end)
--     t_Timer:start()
-- end



-------------------------------------------------------------------------------------------------------------------------------------

-- function KeyRepeat:begin(step_x, step_y)
--     local keyRepeateRate = hs.eventtap.keyRepeatInterval()
--     local eventTypes = hs.eventtap.event.types
--     local timer

--     if KeyRepeat.isRepeating then
--         return
--     end
--     KeyRepeat.isRepeating = true

--     timer = hs.timer.new(keyRepeateRate, function()
--         local coords = hs.mouse.absolutePosition()

--         -- If another key is pressed or the active key is released stop repeating key strokes.
--         -- if interrupt or shift_keyDown or not keyHeld then
--         if shift_keyDown or not keyHeld then
--             -- postMouseEvent(eventTypes.leftMouseUp, coords, flags, 0)

--             KeyRepeat.isRepeating = false
--             timer:stop()
--         else
--             updateCursorCoords(step_x, step_y)
--         end
--     end)
--     timer:start()
-- end

-------------------------------------------------------------------------------------------------------------------------------------

-- function postKeyStrokes(postFlag, keyStr, isDown)
--     local e = hs.eventtap.event.newKeyEvent(postFlag, keyStr, isDown)
--     e:setProperty(eventPropTypes.keyboardEventAutorepeat, 1)

--     print('hello')

--     e:post()
-- end

-- function KeyRepeat:vertically(delta, direction)
--     local timer
--     timer = hs.timer.new(keyRepeateRate, function()

--         -- If another key is pressed or the active key is released stop repeating key strokes.
--         if interrupt then
--             timer:stop()
--             keyAutoRepeating = nil
--         elseif not keyHeld then
--             timer:stop()
--             keyAutoRepeating = nil
--         elseif shift_keyDown then
--             timer:stop()
--             keyAutoRepeating = nil
--         else
--             local mousePoint = hs.mouse.getRelativePosition()
--             local everyScreen = hs.screen.allScreens()
--             local currentScreen = hs.mouse.getCurrentScreen()
--             local screenFrame = currentScreen:fullFrame()
--             local step = 24

--             -- Slow down cursor movement while ctrl is held.
--             if ctrl_keyDown then
--                 step = 6
--             end

--             -- Determine which screen the mouse is on.
--             for i, screen in ipairs(everyScreen) do
--                 if currentScreen == screen then
--                     currentScreenFrame = screen:fullFrame()
--                 end
--             end

--             -- If the space bar is held post a left mouse click and drag event.
--             if spaceBarHeld then
--                 postMouseEvent(eventTypes.leftMouseDragged, coords, flags, 0)
--             end

--             -- Determine which axis to move on.
--             delta = step * direction
--             if t_keyDown or l_keyDown then
--                 coords.x = coords.x + delta
--             elseif i_keyDown or k_keyDown then
--                 coords.y = coords.y + delta
--             end

--             -- Only post mouse events if the cursor is within the boundaries of the current screen to prevent out of bounds movement.
--             if mousePoint.x > step and mousePoint.x < (currentScreenFrame.w - step) and mousePoint.y > step and mousePoint.y < (currentScreenFrame.h - step) then
--                 postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
--             else
--                 hs.mouse.absolutePosition(coords)
--             end

--         end
--     end)
--     timer:start()
-- end


-------------------------------------------------------------------------------------------------------------------------------------
-- This is a timer function responsible for generating automated key stroke repeats when a key remains held down after the
-- event stream is interrupted by another key event and that key event is ceased.
-------------------------------------------------------------------------------------------------------------------------------------

-- function keyRepeat(delta, direction)
--     local timer
--     timer = hs.timer.new(keyRepeateRate, function()
--         -- If another key is pressed or the active key is released stop repeating key strokes.
--         if interrupt then
--             timer:stop()
--             keyAutoRepeating = nil
--         elseif not keyHeld then
--             timer:stop()
--             keyAutoRepeating = nil
--         elseif shift_keyDown then
--             timer:stop()
--             keyAutoRepeating = nil
--         else
--             local mousePoint = hs.mouse.getRelativePosition()
--             local everyScreen = hs.screen.allScreens()
--             local currentScreen = hs.mouse.getCurrentScreen()
--             local screenFrame = currentScreen:fullFrame()
--             local step = 24

--             -- Slow down cursor movement while ctrl is held.
--             if ctrl_keyDown then
--                 step = 6
--             end

--             -- Determine which screen the mouse is on.
--             for i, screen in ipairs(everyScreen) do
--                 if currentScreen == screen then
--                     currentScreenFrame = screen:fullFrame()
--                 end
--             end

--             -- If the space bar is held post a left mouse click and drag event.
--             if spaceBarHeld then
--                 postMouseEvent(eventTypes.leftMouseDragged, coords, flags, 0)
--             end

--             -- Determine which axis to move on.
--             delta = step * direction
--             if t_keyDown or l_keyDown then
--                 coords.x = coords.x + delta
--             elseif i_keyDown or k_keyDown then
--                 coords.y = coords.y + delta
--             end

--             -- Only post mouse events if the cursor is within the boundaries of the current screen to prevent out of bounds movement.
--             if mousePoint.x > step and mousePoint.x < (currentScreenFrame.w - step) and mousePoint.y > step and mousePoint.y < (currentScreenFrame.h - step) then
--                 postMouseEvent(eventTypes.mouseMoved, coords, flags, 0)
--             else
--                 hs.mouse.absolutePosition(coords)
--             end

--         end
--     end)
--     timer:start()
-- end




-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- function CursorHighlight:show()
--     local circle = self.circle
--     local timer = self.timer

--     mouseCirclePoint = hs.mouse.absolutePosition()

--     local color = nil
--     if (self.color) then
--         color = self.color
--     else
--         color = { red = 1, blue = 0, green = 0, alpha = 1 }
--     end

--     -- Create a canvas object.
--     local canvas = hs.canvas.new(hs.geometry.rect(mouseCirclePoint.x - 40, mouseCirclePoint.y - 40, 80, 80))

--     -- Draw a circle with the desired stroke color and width.
--     local strokeWidth = 5
--     local radius = (80 - strokeWidth) / 2
--     canvas[1] = {
--         type = 'circle',
--         action = 'strokeAndFill',
--         fillColor = color,
--         strokeWidth = strokeWidth,
--         frame = {
--             x = tostring(radius),
--             y = tostring(radius),
--             w = tostring(radius * 2),
--             h = tostring(radius * 2)
--         }
--     }

--     -- Bring the canvas to the front.
--     canvas:bringToFront(true)
--     -- Show the canvas with animation.
--     canvas:show(0.5)
--     -- Assign the canvas to a variable if needed.
--     self.circle = canvas

--     return self
-- end


-- function CursorJump:go(highlightPos, Var)
--     if self.isHighlightPresent then
--         -- self.isHighlightPresent = false
--         return
--     end
--     self.isHighlightPresent = true

--     postMouseJump(highlightPos)
--     -- hs.mouse.absolutePosition(highlightPos)

--     local circleTimer = nil
--     -- local diameter = 50
--     -- local diameter = (size - 10)
--     local diameter = (Var.highlightSize - 10)
--     local borderSize = diameter + (diameter / 10)
--     local margin = (borderSize - diameter) / 2
--     local posX = highlightPos.x - (borderSize / 2)
--     local posY = highlightPos.y - (borderSize / 2)
--     local outerCircle = nil
--     local innerCircle = nil
--     -- local opacity = 1.2
--     local opacity = 1
--     local origPosX = posX
--     local origPosY = posY

--     -- Create the larger canvas for the outer circle.
--     circleTimer = hs.timer.new(0.017, function()
--     -- self.circleTimer = hs.timer.new(0.017, function()
--         borderSize = borderSize + 6
--         posX = posX - 3
--         posY = posY - 3
--         opacity = opacity - 0.1

--         -- Delete the highlight if it already exists to prevent the animation from continuously creating duplicates.
--         if outerCircle or innerCircle then
--             outerCircle:hide()
--             innerCircle:hide()
--             -- outerCircle:delete()
--             -- innerCircle:delete()
--         end

--         -- Create the outer and inner circle canvases.
--         outerCircle = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize })
--         innerCircle = hs.canvas.new({ x = (origPosX + margin), y = (origPosY + margin), w = diameter, h = diameter })

--         -- Once the opacity reached 0, delete the canvases and stop the animation loop.
--         if opacity <= 0 then
--             -- isTimerActive = false
--             outerCircle:delete()
--             innerCircle:delete()
--             innerCircle = nil
--             outerCircle = nil
--             circleTimer:stop()
--             self.isHighlightPresent = false
--             return
--         end

--         -- Apply the updated opacity values to the canvas objects.
--         outerCircle[1] = {
--             type = 'circle',
--             action = 'fill',
--             fillColor = { red = 1, blue = 0, green = 0, alpha = opacity }, -- Red.
--         }
--         innerCircle[1] = {
--             type = 'circle',
--             action = 'fill',
--             fillColor = { red = 1, blue = 1, green = 1, alpha = opacity }, -- White.
--         }

--         -- Display the cursor highlight.
--         outerCircle:show()
--         innerCircle:show()
--     end)
--     circleTimer:start()

--     -- self.circleTimer:start()
--     return self
-- end


    -- local nextScreenCenter = hs.geometry.rectMidPoint(currentScreen:next():fullFrame())
    -- local prevScreenCenter = hs.geometry.rectMidPoint(currentScreen:previous():fullFrame())


-- function CursorJump:toScreen(dir)
--     local currentScreen = hs.mouse.getCurrentScreen()
--     local nextScreenCenter = hs.geometry.rectMidPoint(currentScreen:[dir]():fullFrame())
--     -- local prevScreenCenter = hs.geometry.rectMidPoint(currentScreen:previous():fullFrame())
--     hs.mouse.absolutePosition(nextScreenCenter)
-- end


-- return CursorJump

-------------------------------------------------------------------------------------------------------------------------------------

-- -- Jumps to a set of coordinates relative to the currently focused app or screen.
-- function cursorJump(frame, widthDiv, widthMul, heightDiv, heightMul)
--     local posX = frame.x + (frame.w / widthDiv) * widthMul
--     local posY = frame.y + (frame.h / heightDiv) * heightMul
--     hs.mouse.absolutePosition({ x = posX, y = posY })
--     -- interrupt = true
-- end

-- function mapJumpCoords(frame, widthDiv, widthMul, heightDiv, heightMul)
--     local posX = math.floor(frame.x + (frame.w / widthDiv) * widthMul)
--     local posY = math.floor(frame.y + (frame.h / heightDiv) * heightMul)
--     local pos = { x = posX, y = posY }
-- end



-- function mapJumpCoords(frame, jumpCode)
--     local widthDiv = tonumber(jumpCode:sub(1, 1))
--     local widthMul = tonumber(jumpCode:sub(2, 2))
--     local heightDiv = tonumber(jumpCode:sub(3, 3))
--     local heightMul = tonumber(jumpCode:sub(4, 4))

--     local posX = math.floor(frame.x + (frame.w / widthDiv) * widthMul)
--     local posY = math.floor(frame.y + (frame.h / heightDiv) * heightMul)

--     local pos = { x = posX, y = posY }
--     return pos
-- end


-- print(pos.x)


-- -- Jumps to a set of coordinates relative to the currently focused app or screen.
-- function gridHighlight(frame, widthDiv, widthMul, heightDiv, heightMul)
--     local posX = frame.x + (frame.w / widthDiv) * widthMul
--     local posY = frame.y + (frame.h / heightDiv) * heightMul
--     CursorHighlight:showOnTimer()
-- end


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-- -- Jumps to a set of coordinates relative to the currently focused app or screen.
-- function cursorJump(frame, widthDiv, widthMul, heightDiv, heightMul)
--     local posX = frame.x + (frame.w / widthDiv) * widthMul
--     local posY = frame.y + (frame.h / heightDiv) * heightMul
--     hs.mouse.absolutePosition({x=posX, y=posY})
--     interrupt = true
--     cursorHighlight:show()
-- end

-- -- Sets the up/down state of the 'o' key when pressed or released.
-- if code == keycodes['o'] then
--     if event:getType() == eventTypes.keyDown then
--         o_keyDown = true
--     elseif event:getType() == eventTypes.keyUp then
--         o_keyDown = nil
--     end
-- end

-- -- Hold down 'quote' to activate layers containing keybindings for each jump location relative to the current app or screen.

-- if event:getType() == eventTypes.keyUp then
--     if not flags.shift and not flags.cmd then
--         local chosenFrame = nil

--         -- If 'o' is held center the grid on the current screen, otherwise center it on the focused window.
--         if o_keyDown then
--             chosenFrame = screenFrame
--         elseif hs.window.focusedWindow():frame() == nil then
--             chosenFrame = screenFrame
--         else
--             chosenFrame = hs.window.focusedWindow():frame()
--         end

--         -- The following keys jump the cursor to it's corresponding location on the grid.
--         if code == keycodes['w'] then
--             cursorJump(chosenFrame, 6, 1, 6, 1) -- Top left.
--         elseif code == keycodes['e'] then
--             cursorJump(chosenFrame, 2, 1, 6, 1) -- Top middle.
--         elseif code == keycodes['r'] then
--             cursorJump(chosenFrame, 6, 5, 6, 1) -- Top right.
--         elseif code == keycodes['s'] then
--             cursorJump(chosenFrame, 6, 1, 2, 1) -- Middle left.
--         elseif code == keycodes['d'] then
--             cursorJump(chosenFrame, 2, 1, 2, 1) -- Center.
--         elseif code == keycodes['f'] then
--             cursorJump(chosenFrame, 6, 5, 2, 1) -- Middle right.
--         elseif code == keycodes['x'] then
--             cursorJump(chosenFrame, 6, 1, 6, 5) -- Bottom left.
--         elseif code == keycodes['c'] then
--             cursorJump(chosenFrame, 2, 1, 6, 5) -- Bottom middle.
--         elseif code == keycodes['v'] then
--             cursorJump(chosenFrame, 6, 5, 6, 5) -- Bottom right.
--         end

--         -- 'N' key jumps the cursor to the next display.
--         if code == keycodes['n'] then
--             local nextScreen = currentScreen:next()
--             local rect = nextScreen:fullFrame()
--             local center = hs.geometry.rectMidPoint(rect)
--             hs.mouse.absolutePosition(center)
--             cursorHighlight:show()
--         end
--     end
-- end
