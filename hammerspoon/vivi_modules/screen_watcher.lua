
local Var = require('../vivi_modules/global_variables')

local ScreenWatcher = {
    isActive = false,
    appCachedFrame = {},
    screenCachedFrame = {},
    mouseControlEnabled = false,
    displayBorders = {},
    screenBorder = nil,
}

------------------------------------------------------------------------------------

local jumpKeyTable = {
    { key = 'topLeft', value = { 6, 1, 6, 1 } }, -- Top left.
    { key = 'topCenter', value = { 2, 1, 6, 1 } }, -- Top center.
    { key = 'topRight', value = { 6, 5, 6, 1 } }, -- Top right.
    { key = 'centerLeft', value = { 6, 1, 2, 1 } }, -- Center left.
    { key = 'center', value = { 2, 1, 2, 1 } }, -- Center.
    { key = 'centerRight', value = { 6, 5, 2, 1 } }, -- Center right.
    { key = 'bottomLeft', value = { 6, 1, 6, 5 } }, -- Bottom left.
    { key = 'bottomCenter', value = { 2, 1, 6, 5 } }, -- Bottom center.
    { key = 'bottomRight', value = { 6, 5, 6, 5 } }, -- Bottom right.
}

------------------------------------------------------------------------------------

-- Callback for mapping the jump coordinates of the chosen screen or app frame.
local function mapJumpCoords(frame, jumpAlgo)
    local widthDiv = jumpAlgo[1]
    local widthMul = jumpAlgo[2]
    local heightDiv = jumpAlgo[3]
    local heightMul = jumpAlgo[4]
    local posX = frame.x + (frame.w / widthDiv) * widthMul
    local posY = frame.y + (frame.h / heightDiv) * heightMul
    local pos = { x = posX, y = posY }
    return pos
end

------------------------------------------------------------------------------------

-- Callback for mapping the sub-jump coords that correspond to each initial point.
local function mapSubCoords(jumpCoords, gridSize)
    local function plus(num1, num2) return num1 + num2 end
    local function minus(num1, num2) return num1 - num2 end
    local subPos = {
        topLeft = { -- Top left.
            x = minus(jumpCoords.x, gridSize.width),
            y = minus(jumpCoords.y, gridSize.height),
        },
        topCenter = { -- Top center.
            x = jumpCoords.x,
            y = minus(jumpCoords.y, gridSize.height),
        },
        topRight = { -- Top right.
            x = plus(jumpCoords.x, gridSize.width),
            y = minus(jumpCoords.y, gridSize.height),
        },
        centerLeft = { -- Center left.
            x = minus(jumpCoords.x, gridSize.width),
            y = jumpCoords.y,
        },
        centerRight = { -- Center right.
            x = plus(jumpCoords.x, gridSize.width),
            y = jumpCoords.y,
        },
        bottomLeft = { -- Bottom left.
            x = minus(jumpCoords.x, gridSize.width),
            y = plus(jumpCoords.y, gridSize.height),
        },
        bottomCenter = { -- Bottom center.
            x = jumpCoords.x,
            y = plus(jumpCoords.y, gridSize.height),
        },
        bottomRight = { -- Bottom right.
            x = plus(jumpCoords.x, gridSize.width),
            y = plus(jumpCoords.y, gridSize.height),
        }
    }
    return subPos
end

------------------------------------------------------------------------------------

-- Callback for caching the relevant grid coords.
local function mapGrid(ChosenModule, frame)
    local gridSize = {
        x = frame.x,
        y = frame.y,
        w = frame.w / 3,
        h = frame.h / 3,
        width = frame.w / 9,
        height = frame.h / 9,
    }

    local subGridPlacement = {
        topLeft = { x = gridSize.x, y = gridSize.y },
        topCenter = { x = gridSize.x + gridSize.w, y = gridSize.y },
        topRight = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y },
        centerLeft = { x = gridSize.x, y = gridSize.y + gridSize.h },
        center = { x = gridSize.x + gridSize.w, y = gridSize.y + gridSize.h },
        centerRight = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + gridSize.h },
        bottomLeft = { x = gridSize.x, y = gridSize.y + (gridSize.h * 2) },
        bottomCenter = { x = gridSize.x + gridSize.w, y = gridSize.y + (gridSize.h * 2) },
        bottomRight = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + (gridSize.h * 2) },
        size = { w = gridSize.w, h = gridSize.h },
    }

    for i, v in ipairs(jumpKeyTable) do
        local position = v.key
        local jumpAlgo = v.value
        local jumpCoords = mapJumpCoords(frame, jumpAlgo)
        local subCoords = mapSubCoords(jumpCoords, gridSize)
        ChosenModule.mappedCoords[position] = jumpCoords -- Save the coordinates in ChosenModule.mappedCoords table.
        ChosenModule.subGridMappedCoords[position] = subCoords -- Save the coordinates in ChosenModule.subGridMappedCoords table.
        ChosenModule:mapCoords(position, jumpCoords, subGridPlacement)
    end
end

--------------------------------------------------------------------------------------

-- Pass in a reference to the AppGrid module.
function ScreenWatcher:initiate(AppGridModule, ScreenGridModule)
    -- If the timer is already running cancel repeated execution.
    if self.isActive then
        return
    end
    self.isActive = true
    hs.alert('Screen watcher is operational.')
    print('Screen watcher is operational.')

    -- windowWatcher = hs.timer.new(0.25, function()
    windowWatcher = hs.timer.new(1, function()
        local currentScreen = hs.mouse.getCurrentScreen()
        local screenFrame = currentScreen:fullFrame()
        local desktopWindow = hs.window.desktop()
        local appFrame = nil

        if hs.window.focusedWindow() == desktopWindow then
            appFrame = screenFrame
        elseif not hs.window.focusedWindow() then
            appFrame = screenFrame
        else
            local focusedWindow = hs.window.focusedWindow()
            if focusedWindow then
                appFrame = focusedWindow:frame()
            else
                return -- Avoid further execution if focusedWindow is still nil.
            end
        end

        -- If the currently focused app frame has changed.
        if appFrame.w ~= self.appCachedFrame.w
            or appFrame.h ~= self.appCachedFrame.h
            or appFrame.x ~= self.appCachedFrame.x
            or appFrame.y ~= self.appCachedFrame.y
        then
            AppGridModule:hideGrid()
            self.appCachedFrame = appFrame
            AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
            mapGrid(AppGridModule, self.appCachedFrame)
        end

        -- If the currently focused screen frame has changed.
        if screenFrame.w ~= self.screenCachedFrame.w
            or screenFrame.h ~= self.screenCachedFrame.h
            or screenFrame.x ~= self.screenCachedFrame.x
            or screenFrame.y ~= self.screenCachedFrame.y
        then
            -- Update which screen the border is on if the cursor moves to a different screen.
            if self.mouseControlEnabled then
                self:toggleScreenBorder('on')
            end

            ScreenGridModule:hideGrid()
            self.screenCachedFrame = screenFrame
            ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
            mapGrid(ScreenGridModule, self.screenCachedFrame)
        end
    end)
    windowWatcher:start()
end

--------------------------------------------------------------------------------------

function ScreenWatcher:createScreenBorder()
    self.displayBorders = {}
    local everyScreen = hs.screen.allScreens()
    for i, v in ipairs(everyScreen) do
        local frame = v:fullFrame()
        local screenBorder = hs.canvas.new({ x = frame.x, y = frame.y, w = frame.w, h = frame.h })
        screenBorder[1] = {
            type = 'rectangle',
            action = 'stroke',
            strokeWidth = 4,
            strokeColor = { white = 1, alpha = 1 },
        }
        self.displayBorders[v] = screenBorder -- Store the canvas for each screen.
    end
end

--------------------------------------------------------------------------------------

function ScreenWatcher:toggleScreenBorder(state)
    local currentScreen = hs.mouse.getCurrentScreen()
    for i, v in pairs (self.displayBorders) do
        if state == 'on' then
            if i == currentScreen then
                v:show()
            else
                v:hide()
            end
        else
            v:hide()
        end
    end
end

--------------------------------------------------------------------------------------

function ScreenWatcher:terminate()
    if windowWatcher then
        windowWatcher:stop()
        windowWatcher = nil
        self.isActive = false
        print('Screen watcher has stopped.')
    end
end

return ScreenWatcher





-- function ScreenWatcher:createScreenBorder()
--     local everyScreen = hs.screen.allScreens()
--     local screenBorders = {} -- Store screen borders in a table
--     for i, v in ipairs(everyScreen) do
--         local frame = v:fullFrame()
--         local screenBorder = hs.canvas.new({ x = frame.x, y = frame.y, w = frame.w, h = frame.h })
--         screenBorder[1] = {
--             type = 'rectangle',
--             action = 'stroke',
--             strokeWidth = 4,
--             strokeColor = { white = 1, alpha = 1 },
--         }
--         screenBorders[v] = screenBorder -- Store the canvas for each screen
--     end
--     self.displayBorders = screenBorders -- Store the table of screen borders
-- end


-- function ScreenWatcher:toggleScreenBorder(currentScreen)
--     -- print('oi')
--     for i, v in pairs (self.displayBorders) do
--         if currentScreen then
--             if i == currentScreen then
--                 v:show()
--             else
--                 v:hide()
--             end
--         else
--             v:hide()
--         end
--     end
-- end


    -- for i, v in ipairs(self.displayBorders) do
    --     -- print(i)
    --     -- print(v)
    --     -- v:show() -- Show each screen border canvas
    -- end






-- -- Pass in a reference to the AppGrid module.
-- function ScreenWatcher:initiate(AppGridModule, ScreenGridModule, Var)
--     -- If the timer is already running cancel repeated execution.
--     if self.isActive then
--         return
--     end
--     self.isActive = true
--     hs.alert('Screen watcher is operational.')
--     print('Screen watcher is operational.')

--     windowWatcher = hs.timer.new(0.25, function()
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         local desktopWindow = hs.window.desktop()
--         local appFrame = nil

--         if hs.window.focusedWindow() == desktopWindow then
--             appFrame = screenFrame
--         elseif not hs.window.focusedWindow() then
--             appFrame = screenFrame
--         else
--             local focusedWindow = hs.window.focusedWindow()
--             if focusedWindow then
--                 appFrame = focusedWindow:frame()
--             else
--                 return -- Avoid further execution if focusedWindow is still nil.
--             end
--         end

--         -- If the currently focused app frame has changed.
--         if appFrame.w ~= self.appCachedFrame.w
--             or appFrame.h ~= self.appCachedFrame.h
--             or appFrame.x ~= self.appCachedFrame.x
--             or appFrame.y ~= self.appCachedFrame.y
--         then
--             AppGridModule:hideGrid()
--             self.appCachedFrame = appFrame
--             AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
--             mapGrid(AppGridModule, self.appCachedFrame, Var)
--         end

--         -- If the currently focused screen frame has changed.
--         if screenFrame.w ~= self.screenCachedFrame.w
--             or screenFrame.h ~= self.screenCachedFrame.h
--         then
--             ScreenGridModule:hideGrid()
--             self.screenCachedFrame = screenFrame
--             ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
--             mapGrid(ScreenGridModule, self.screenCachedFrame, Var)
--         end
--     end)
--     windowWatcher:start()
-- end
-- --------------------------------------------------------------------------------------

-- local jumpKeyTable = {
--     { key = 'w', value = { 6, 1, 6, 1 } }, -- Top left.
--     { key = 'e', value = { 2, 1, 6, 1 } }, -- Top center.
--     { key = 'r', value = { 6, 5, 6, 1 } }, -- Top right.
--     { key = 's', value = { 6, 1, 2, 1 } }, -- Center left.
--     { key = 'd', value = { 2, 1, 2, 1 } }, -- Center.
--     { key = 'f', value = { 6, 5, 2, 1 } }, -- Center right.
--     { key = 'x', value = { 6, 1, 6, 5 } }, -- Bottom left.
--     { key = 'c', value = { 2, 1, 6, 5 } }, -- Bottom center.
--     { key = 'v', value = { 6, 5, 6, 5 } }, -- Bottom right.
-- }

-- -- Callback for mapping the sub-jump coords that correspond to each initial point.
-- local function mapSubCoords(jumpCoords, gridSize)
--     local function plus(num1, num2) return num1 + num2 end
--     local function minus(num1, num2) return num1 - num2 end
--     local subPos = {
--         w = { -- Top left.
--             x = minus(jumpCoords.x, gridSize.width),
--             y = minus(jumpCoords.y, gridSize.height),
--         },
--         e = { -- Top center.
--             x = jumpCoords.x,
--             y = minus(jumpCoords.y, gridSize.height),
--         },
--         r = { -- Top right.
--             x = plus(jumpCoords.x, gridSize.width),
--             y = minus(jumpCoords.y, gridSize.height),
--         },
--         s = { -- Center left.
--             x = minus(jumpCoords.x, gridSize.width),
--             y = jumpCoords.y,
--         },
--         f = { -- Center right.
--             x = plus(jumpCoords.x, gridSize.width),
--             y = jumpCoords.y,
--         },
--         x = { -- Bottom left.
--             x = minus(jumpCoords.x, gridSize.width),
--             y = plus(jumpCoords.y, gridSize.height),
--         },
--         c = { -- Bottom center.
--             x = jumpCoords.x,
--             y = plus(jumpCoords.y, gridSize.height),
--         },
--         v = { -- Bottom right.
--             x = plus(jumpCoords.x, gridSize.width),
--             y = plus(jumpCoords.y, gridSize.height),
--         }
--     }
--     return subPos
-- end



-- -- Callback for caching the relevant grid coords.
-- local function mapGrid(ChosenModule, frame, Var)
--     local gridSize = {
--         x = frame.x,
--         y = frame.y,
--         w = frame.w / 3,
--         h = frame.h / 3,
--         width = frame.w / 9,
--         height = frame.h / 9,
--     }

--     local subGridPlacement = {
--         w = { x = gridSize.x, y = gridSize.y },
--         e = { x = gridSize.x + gridSize.w, y = gridSize.y },
--         r = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y },
--         s = { x = gridSize.x, y = gridSize.y + gridSize.h },
--         d = { x = gridSize.x + gridSize.w, y = gridSize.y + gridSize.h },
--         f = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + gridSize.h },
--         x = { x = gridSize.x, y = gridSize.y + (gridSize.h * 2) },
--         c = { x = gridSize.x + gridSize.w, y = gridSize.y + (gridSize.h * 2) },
--         v = { x = gridSize.x + (gridSize.w * 2), y = gridSize.y + (gridSize.h * 2) },
--         size = { w = gridSize.w, h = gridSize.h },
--     }

--     for i, v in ipairs(jumpKeyTable) do
--         local letter = v.key
--         local jumpCode = v.value
--         local jumpCoords = mapJumpCoords(frame, jumpCode)
--         local subCoords = mapSubCoords(jumpCoords, gridSize)
--         ChosenModule.mappedCoords[letter] = jumpCoords -- Save the coordinates in ChosenModule.mappedCoords table.
--         ChosenModule.subGridMappedCoords[letter] = subCoords -- Save the coordinates in ChosenModule.subGridMappedCoords table.
--         ChosenModule:mapCoords(letter, jumpCoords, subGridPlacement, Var)
--     end
-- end

-- ! ERROR: LuaSkin: hs.canvas:invalid percentage string specified for field x of frame for element 16
-- ! ERROR: .hammerspoon////vivi_modules/screen_watcher.lua:237: attempt to index a nil value (local 'appFrame')






-- function ScreenWatcher:mapScreens()
--     local currentScreen = hs.mouse.getCurrentScreen()
--     local nextScreenCenter = hs.geometry.rectMidPoint(currentScreen:next():fullFrame())
--     local prevScreenCenter = hs.geometry.rectMidPoint(currentScreen:previous():fullFrame())
--     -- hs.mouse.absolutePosition(prevScreenCenter)
--     -- local everyScreen = hs.screen.allScreens()
--     -- for i, v in ipairs(everyScreen) do
--     --     if currentScreen == v then
--     --         currentScreenFrame = v:fullFrame()
--     --     end
--     -- end
-- end


---------------------------------------------------------------------------------------------------------------------------------------------

-- -- Pass the reference to the AppGrid module.
-- function ScreenWatcher:initiate(AppGridModule, ScreenGridModule, Var)
--     hs.alert('Screen watcher is operational.')
--     print('Screen watcher is operational.')

--     function updateAppFrame(wframe)
--         if not hs.window.focusedWindow() then return end
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         local focusedWindow = hs.window.focusedWindow()
--         local desktopWindow = hs.window.desktop()
--         local appFrame = hs.window.focusedWindow():frame()
--         -- If no apps are focused, focus the grid on the current screen.
--         if focusedWindow == desktopWindow then
--             appFrame = screenFrame
--         end

--         AppGridModule:deleteGrid()
--         self.appCachedFrame = appFrame
--         AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
--         mapGrid(AppGridModule, self.appCachedFrame, Var)
--     end
--     updateAppFrame()

--     -- ! Need to look into unsubscribing from windows when they change.
--     local wf = hs.window.filter
--     local appFrameWatcher = wf.new():setFilters({ wf.focusCurrent })
--     appFrameWatcher:subscribe(wf.windowMoved, function(win) updateAppFrame() end)
--     appFrameWatcher:subscribe(wf.windowFocused, function(win) updateAppFrame() end)

--     function screenChangeWatcher()
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         -- If the currently focused screen frame has changed.
--         ScreenGridModule:deleteGrid()
--         self.screenCachedFrame = screenFrame
--         ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
--         mapGrid(ScreenGridModule, self.screenCachedFrame, Var)
--     end
--     screenChangeWatcher()
-- end



---------------------------------------------------------------------------------------------------------------------------------------------

-- -- Pass the reference to the AppGrid module.
-- function ScreenWatcher:initiate(AppGridModule, ScreenGridModule, hlSize)
--     windowWatcher = hs.timer.new(0.25, function()
--         if not hs.window.focusedWindow() then return end
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         local focusedWindow = hs.window.focusedWindow()
--         local desktopWindow = hs.window.desktop()
--         local appFrame = hs.window.focusedWindow():frame()

--         -- ! Look into hs window to subscribe to window resize events.

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
--         if screenFrame.w ~= ScreenGridModule.cachedFrame.w
--             or screenFrame.h ~= ScreenGridModule.cachedFrame.h
--         then
--             -- ! Call the screen mapper here if the focused screen changes.
--             ScreenGridModule:deleteGrid()
--             ScreenGridModule.cachedFrame = screenFrame
--             ScreenGridModule.mappedCoords = {} -- Clear the ScreenGridModule.mappedCoords table.
--             mapGrid(ScreenGridModule, ScreenGridModule.cachedFrame, hlSize)
--         end
--     end)
--     windowWatcher:start()
-- end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------


-- -- Callback for mapping the sub-jump coords that correspond to each initial point.
-- local function mapSubCoords(highlightPos, subCoordSpacing)
--     local function plus(num1, num2) return num1 + num2 end
--     local function minus(num1, num2) return num1 - num2 end
--     local subPos = {
--         w = { x = minus(highlightPos.x, subCoordSpacing.x), y = minus(highlightPos.y, subCoordSpacing.y) }, -- Top left.
--         e = { x = highlightPos.x, y = minus(highlightPos.y, subCoordSpacing.y) }, -- Top center.
--         r = { x = plus(highlightPos.x, subCoordSpacing.x), y = minus(highlightPos.y, subCoordSpacing.y) }, -- Top right.
--         s = { x = minus(highlightPos.x, subCoordSpacing.x), y = highlightPos.y }, -- Center left.
--         f = { x = plus(highlightPos.x, subCoordSpacing.x), y = highlightPos.y }, -- Center right.
--         x = { x = minus(highlightPos.x, subCoordSpacing.x), y = plus(highlightPos.y, subCoordSpacing.y) }, -- Bottom left.
--         c = { x = highlightPos.x, y = plus(highlightPos.y, subCoordSpacing.y) }, -- Bottom center.
--         v = { x = plus(highlightPos.x, subCoordSpacing.x), y = plus(highlightPos.y, subCoordSpacing.y) }, -- Bottom right.
--     }
--     return subPos
-- end


    -- ! First you need to calculate the distance between 2 of the initial jump coords,
    -- then either divide that number by 3 x 1 to get the first number and 3 x 2 for the second.

    -- { key = 'w', value = { 12, 1, 12, 1 } }, -- Top left.
    -- { key = 'e', value = { 12, 2, 12, 1 } }, -- Top center.
    -- { key = 'r', value = { 12, 3, 12, 1 } }, -- Top right.
    -- { key = 's', value = { 12, 1, 12, 2 } }, -- Center left.
    -- { key = 'f', value = { 12, 3, 12, 2 } }, -- Center right.
    -- { key = 'x', value = { 12, 1, 12, 3 } }, -- Bottom left.
    -- { key = 'c', value = { 12, 2, 12, 3 } }, -- Bottom center.
    -- { key = 'v', value = { 12, 3, 12, 3 } }, -- Bottom right.


    -- local activeApplication = hs.application.frontmostApplication()
    -- local everyScreen = hs.screen.allScreens()
    -- local nextScreen = currentScreen:next()
    -- local prevScreen = currentScreen:previous()
    -- local nextCenter = hs.geometry.rectMidPoint(nextScreen:fullFrame())
    -- local prevCenter = hs.geometry.rectMidPoint(prevScreen:fullFrame())


-- -- Callback for mapping the jump coordinates of the chosen screen or app frame.
-- local function mapSubCoords(subGridBaseX, subGridBaseY)
--     local function minus(num) return -num end
--     local function plus(num) return num + num end
--     local subPos = {
--         w = { x = minus(subGridBaseX), y = minus(subGridBaseY) }, -- Top left.
--         e = { x = subGridBaseX, y = minus(subGridBaseY) }, -- Top center.
--         r = { x = plus(subGridBaseX), y = minus(subGridBaseY) }, -- Top right.
--         s = { x = minus(subGridBaseX), y = subGridBaseY }, -- Center left.
--         f = { x = plus(subGridBaseX), y = subGridBaseY }, -- Center right.
--         x = { x = minus(subGridBaseX), y = plus(subGridBaseY) }, -- Bottom left.
--         c = { x = subGridBaseX, y = plus(subGridBaseY) }, -- Bottom center.
--         v = { x = plus(subGridBaseX), y = plus(subGridBaseY) }, -- Bottom right.
--     }
--     return subPos
-- end


-- local secondJumpKeyTable = {
--     w = {

--         { key = 'w', value = { 12, 1, 12, 1 } }, -- Top left.
--         { key = 'e', value = { 12, 2, 12, 1 } }, -- Top center.
--         { key = 'r', value = { 12, 3, 12, 1 } }, -- Top right.
--         { key = 's', value = { 12, 1, 12, 2 } }, -- Center left.
--         { key = 'f', value = { 12, 3, 12, 2 } }, -- Center right.
--         { key = 'x', value = { 12, 1, 12, 3 } }, -- Bottom left.
--         { key = 'c', value = { 12, 2, 12, 3 } }, -- Bottom center.
--         { key = 'v', value = { 12, 3, 12, 3 } }, -- Bottom right.

--     }
-- }


-- local function minus(num)
--     return -num
-- end
-- local function plus(num)
--     return num + num
-- end

-- local subGridAlgos = {
--     { key = 'w', value = { minusX, minusY } }, -- Top left.
--     { key = 'e', value = { equalX, minusY } }, -- Top center.
--     { key = 'r', value = { plusX, minusY } }, -- Top right.
--     { key = 's', value = { minusX, equalY } }, -- Center left.
--     { key = 'f', value = { plusX, equalY } }, -- Center right.
--     { key = 'x', value = { minusX, plusY } }, -- Bottom left.
--     { key = 'c', value = { equalX, plusY } }, -- Bottom center.
--     { key = 'v', value = { plusX, plusY } }, -- Bottom right.
-- }

---------------------------------------------------------------------------------------------------------------------------------------------


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


-- local ScreenWatcher = {
--     w = { 6, 1, 6, 1 }, -- Top left.
--     e = { 2, 1, 6, 1 }, -- Top center.
--     r = { 6, 5, 6, 1 }, -- Top right.
--     s = { 6, 1, 2, 1 }, -- Center left.
--     d = { 2, 1, 2, 1 }, -- Center.
--     f = { 6, 5, 2, 1 }, -- Center right.
--     x = { 6, 1, 6, 5 }, -- Bottom left.
--     c = { 2, 1, 6, 5 }, -- Bottom center.
--     v = { 6, 5, 6, 5 }, -- Bottom right.
-- }

-- function mapGrid(ChosenModule, frame)
--     for i, v in ipairs(ScreenWatcher) do
--         -- local keycode = keycodes[v.key]
--         local keycode = v.key
--         local value = v.value
--         print(keycode)
--         local highlightPos = mapJumpCoords(frame, value)
--         ChosenModule.mappedCoords[keycode] = highlightPos -- Save the coordinates in ChosenModule.mappedCoords table.
--         ChosenModule:mapCoords(keycode, highlightPos)
--     end
-- end

-- ! Need to add a check to see if any windows exist and a check for new apps launching.




-- local ScreenWatcher = {
--     w = { 6, 1, 6, 1 }, -- Top left.
--     e = { 2, 1, 6, 1 }, -- Top center.
--     r = { 6, 5, 6, 1 }, -- Top right.
--     s = { 6, 1, 2, 1 }, -- Center left.
--     d = { 2, 1, 2, 1 }, -- Center.
--     f = { 6, 5, 2, 1 }, -- Center right.
--     x = { 6, 1, 6, 5 }, -- Bottom left.
--     c = { 2, 1, 6, 5 }, -- Bottom center.
--     v = { 6, 5, 6, 5 }, -- Bottom right.
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

-- -- Pass the reference to the AppGrid module.
-- function ScreenWatcher:initiate(AppGridModule)
--     local appWatcher = hs.eventtap.new({ eventTypes.leftMouseUp, eventTypes.leftMouseDragged, eventTypes.keyUp }, function(event)
--         local everyScreen = hs.screen.allScreens()
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local screenFrame = currentScreen:fullFrame()
--         local chosenFrame = hs.window.focusedWindow():frame()

--         -- If the app frame has changed.
--         if chosenFrame.w ~= AppGridModule.cachedFrame.w or chosenFrame.h ~= AppGridModule.cachedFrame.h or chosenFrame.x ~= AppGridModule.cachedFrame.x or chosenFrame.y ~= AppGridModule.cachedFrame.y then
--             if event:getType() == eventTypes.leftMouseDragged then
--                 return
--             end

--             -- Add a condition here to only delete if it exists.
--             AppGridModule:deleteGrid()
--             AppGridModule.cachedFrame = chosenFrame

--             -- Possibly turn the block below into a callback to be used for each screen.
--             AppGridModule.mappedCoords = {} -- Clear the AppGridModule.mappedCoords table.
--             for key, value in pairs(ScreenWatcher) do
--                 local keycode = keycodes[key]
--                 local highlightPos = mapJumpCoords(chosenFrame, value)
--                 AppGridModule.mappedCoords[keycode] = highlightPos -- Save the coordinates in AppGridModule.mappedCoords table.
--                 AppGridModule:mapCoords(keycode, highlightPos)
--             end
--         end
--     end)
--     appWatcher:start()
-- end





        -- local desktopWindow = hs.window.desktop()
        -- local currentScreen = hs.mouse.getCurrentScreen()
        -- local screenFrame = currentScreen:fullFrame()
        -- local focusedWindow = hs.window.focusedWindow()
        -- local appFrame = hs.window.focusedWindow():frame()

        -- if not hs.window.focusedWindow() then
        --     appFrame = screenFrame
        -- end
        -- if hs.window.focusedWindow() then
        --     focusedWindow = hs.window.focusedWindow()
        --     appFrame = hs.window.focusedWindow():frame()
        -- end

        -- -- If no apps are focused, focus the grid on the current screen.
        -- if focusedWindow == desktopWindow then
        --     appFrame = screenFrame
        -- end

        -- if not hs.mouse.getCurrentScreen() then
        --     print('----------------------------')
        --     print('ERROR: No screen detected.')
        --     return
        -- end

    -- local subCoordSpacing = {
    --     x = frame.w / 9,
    --     y = frame.h / 9,
    -- }

-- -- Callback for mapping the sub-jump coords that correspond to each initial point.
-- local function mapSubCoords(jumpCoords, subCoordSpacing)
--     local function plus(num1, num2) return num1 + num2 end
--     local function minus(num1, num2) return num1 - num2 end
--     local subPos = {
--         w = { -- Top left.
--             x = minus(jumpCoords.x, subCoordSpacing.x),
--             y = minus(jumpCoords.y, subCoordSpacing.y),
--         },
--         e = { -- Top center.
--             x = jumpCoords.x,
--             y = minus(jumpCoords.y, subCoordSpacing.y),
--         },
--         r = { -- Top right.
--             x = plus(jumpCoords.x, subCoordSpacing.x),
--             y = minus(jumpCoords.y, subCoordSpacing.y),
--         },
--         s = { -- Center left.
--             x = minus(jumpCoords.x, subCoordSpacing.x),
--             y = jumpCoords.y,
--         },
--         f = { -- Center right.
--             x = plus(jumpCoords.x, subCoordSpacing.x),
--             y = jumpCoords.y,
--         },
--         x = { -- Bottom left.
--             x = minus(jumpCoords.x, subCoordSpacing.x),
--             y = plus(jumpCoords.y, subCoordSpacing.y),
--         },
--         c = { -- Bottom center.
--             x = jumpCoords.x,
--             y = plus(jumpCoords.y, subCoordSpacing.y),
--         },
--         v = { -- Bottom right.
--             x = plus(jumpCoords.x, subCoordSpacing.x),
--             y = plus(jumpCoords.y, subCoordSpacing.y),
--         }
--     }
--     return subPos
-- end

-- ChosenModule.subGridMappedCoords = subCoords -- Save the coordinates in ChosenModule.subGridMappedCoords table.
-- ChosenModule:mapCoords(letter, jumpCoords, subCoords, Var)