
-- ! Add single pixel movement on tap

local Var = require('../vivi_modules/global_variables')
local eventTypes = hs.eventtap.event.types
local eventPropTypes = hs.eventtap.event.properties

local MouseEvt = {
    timer = nil,
    isActive = false,
    space = false,
    clicks = 0,
    deceleration = 1,
    acceleration = 1,
    flags = {
        cmd = false,
        ctrl = false,
        shift = false,
    },
    up = false,
    down = false,
    left = false,
    right = false,
    slow = false,
    fast = false,
}

----------------------------------------------------------------------------------------------------------------

local function postMouseEvent(evtType, coords, modKeys, clicks)
    local evt = hs.eventtap.event.newMouseEvent(evtType, coords, modKeys)
    if clicks > 3 then clicks = 3 end
    evt:setFlags(modKeys)
    evt:setProperty(eventPropTypes.mouseEventClickState, clicks)
    evt:post()
end

-- This function is used to display the dock and prevent out of bounds movement on the edges of the screen,
-- first get the cursors position relative to the screen it's currently on, then get the absolute position
-- and post a mouse event at those coords. This ensures that the mouse event is posted on exactly the first
-- or last pixel of the screen that it's on, regardless of monitor layout.
local function keepCursorInBounds()
    local mousePoint = hs.mouse.getRelativePosition()
    hs.mouse.setRelativePosition(mousePoint)
    local coords = hs.mouse.absolutePosition()
    if MouseEvt.space then
        postMouseEvent(eventTypes.leftMouseDragged, coords, {}, 1)
    else
        postMouseEvent(eventTypes.mouseMoved, coords, {}, 0)
    end
end

----------------------------------------------------------------------------------------------------------------

function MouseEvt:move()
    -- If the timer is already running cancel repeated execution.
    if self.isActive then
        return
    end
    self.isActive = true

    -- Begin the timer and start updating cursor coordinates.
    self.timer = hs.timer.new(0.017, function()
        local coords = hs.mouse.absolutePosition()
        local mousePoint = hs.mouse.getRelativePosition()
        local everyScreen = hs.screen.allScreens()
        local distance = Var.standardSpeed
        -- local currentScreen = hs.mouse.getCurrentScreen()

        local activeScreen = hs.mouse.getCurrentScreen()
        local currentScreen = activeScreen:fullFrame()

        -- Cursor speed up and acceleration.
        if self.fast then
            distance = Var.fastSpeed
            if Var.accelerationEnabled then
                self.acceleration = self.acceleration + 0.01
                local cursorAcceleration = Var.accelerationMultiplier * math.log(self.acceleration)
                distance = distance + cursorAcceleration
            end
        else
            self.acceleration = 1
        end

        -- Cursor slow down and deceleration.
        if self.slow then
            distance = Var.slowSpeed
            if Var.decelerationEnabled then
                self.deceleration = self.deceleration + 0.01
                local cursorDeceleration = Var.decelerationMultiplier * math.log(self.deceleration)
                distance = distance - cursorDeceleration
            end
        else
            self.deceleration = 1
        end

        -- Set the min and max speed of cursor movement after other multipliers are applied.
        if distance > Var.maxSpeed then distance = Var.maxSpeed end
        if distance < Var.minSpeed then distance = Var.minSpeed end

        -- Hypotenuse (calculated with the Pythagorean theorem), this is used to standardize the
        -- cursor travel speed regardless of whether moving on one or two axis' simultaneoulsy.
        local singleAxisSpeed = math.sqrt(distance ^ 2 + distance ^ 2)
        local doubleAxisSpeed = distance

        -- If any two of the movement trigger keys are pressed at the same time, slow the cursor movement down.
        local count = (self.up and 1 or 0) + (self.down and 1 or 0) + (self.left and 1 or 0) + (self.right and 1 or 0)
        if count >= 2 then
            distance = doubleAxisSpeed
        else
            distance = singleAxisSpeed
        end

        -- Calculate the distance from the closest edge of the current screen on each axis.
        local distanceFromEdgeX = math.min(coords.x - currentScreen.x, currentScreen.x + currentScreen.w - coords.x)
        local distanceFromEdgeY = math.min(coords.y - currentScreen.y, currentScreen.y + currentScreen.h - coords.y)
        local inBoundsX = (distanceFromEdgeX > distance)
        local inBoundsY = (distanceFromEdgeY > distance)

        -- Update the cursor coordinates.
        if self.up then coords.y = coords.y - distance end -- Up.
        if self.down then coords.y = coords.y + distance end -- Down.
        if self.left then coords.x = coords.x - distance end -- Left.
        if self.right then coords.x = coords.x + distance end -- Right.

        -- Only post mouse events when within the edges of the screen to prevent out of bounds movement.
        if not inBoundsX or not inBoundsY then
            hs.mouse.absolutePosition(coords)
            keepCursorInBounds()
        else
            if self.space then
                postMouseEvent(eventTypes.leftMouseDragged, coords, {}, 1)
            else
                postMouseEvent(eventTypes.mouseMoved, coords, {}, 0)
            end
        end
    end)
    self.timer:start()
end

----------------------------------------------------------------------------------------------------------------

function MouseEvt:highlight(highlightPos, subGridFocused)
    if self.space then
        postMouseEvent(eventTypes.leftMouseDragged, highlightPos, {}, 1)
    else
        postMouseEvent(eventTypes.mouseMoved, highlightPos, {}, 0)
    end

    if jumpHighlight then jumpHighlight:hide() end
    local diameter = Var.highlightSize

    if subGridFocused then
        diameter = Var.smallHighlightSize * 2
    end

    local posX = highlightPos.x - (diameter / 2)
    local posY = highlightPos.y - (diameter / 2)
    local jumpHighlight = nil

    jumpHighlight = hs.canvas.new({ x = posX, y = posY, w = diameter, h = diameter })
    jumpHighlight[1] = {
        type = 'circle',
        action = 'fill',
        fillColor = { red = 1, blue = 1, green = 1, alpha = 1 }, -- White.
    }
    jumpHighlight:show()
    jumpHighlight:hide(0.4)
end

----------------------------------------------------------------------------------------------------------------

function MouseEvt:click(state)
    -- if self.shift then
    --     self.mouseButton = 'right'
    -- else
    --     self.mouseButton = 'left'
    -- end
    -- local mouseState = self.mouseButton .. state

    local mouseState = 'left' .. state
    postMouseEvent(eventTypes[mouseState], hs.mouse.absolutePosition(), self.flags, self.clicks)
end
-- postMouseEvent(eventTypes[mouseState], hs.mouse.absolutePosition(), {}, self.clicks)

----------------------------------------------------------------------------------------------------------------

function MouseEvt:stopMoving()
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
    self.up = false
    self.down = false
    self.left = false
    self.right = false
    self.isActive = false
    self.deceleration = 1
    self.acceleration = 1
end

----------------------------------------------------------------------------------------------------------------

function MouseEvt:resetProperties(mouseUp)
    -- self.mouseButton = 'left'
    self:stopMoving()
    self.clicks = 0
    self.slow = false
    self.fast = false
    self.flags = {}
    -- if self.space then
    if mouseUp then
        self.space = false
        self:click('MouseUp')
    end
end

return MouseEvt



-- mouseButton = 'left',
-- shift = false,

-- ! Need to break up the distance from edge checks into 2 axis or 4 sides and reduce the distance
-- on a side specific basis for consistency. Only apply this logic when a mouse event is being
-- posted rather than an update to absolute position. Be wary of cross screen travel though.
-- ! Add a condition to check if an absolutePosition() event is posted twice in a row
-- and if it is, then set the coords to 1 so that the dock can be activated easily.
-- ! A possible fix to the dock not displaying on the right side when the screens are ordered
-- main on the left and laptop on the right could be to retrieve the dock position with a zsh
-- command and adjust the script accordingly.

        -- -- Determine which screen the mouse is on and set the focused frame to that screen.
        -- for i, v in ipairs(everyScreen) do
        --     if currentScreen == v then
        --         currentScreen = v:fullFrame()
        --     end
        -- end

        -- -- Determine which screen the mouse is on and set the focused frame to that screen.
        -- for i, v in ipairs(everyScreen) do
        --     -- print(i)
        --     -- print(v)
        --     -- print('------------------------------------------------')
        -- end

-- -- Only post mouse events when within the edges of the screen to prevent out of bounds movement.
-- if inBoundsX and inBoundsY then
--     if self.space then
--         postMouseEvent(eventTypes.leftMouseDragged, coords, {}, 1)
--     else
--         postMouseEvent(eventTypes.mouseMoved, coords, {}, 0)
--     end
-- else
--     hs.mouse.absolutePosition(coords)
--     keepCursorInBounds()
-- end

-- -- Check if the same coordinates are detected (if a mouseMove event is posted to the same location multiple times in a row).
-- if mousePoint.x == prevX and mousePoint.y == prevY then
--     sameCoordinatesCount = sameCoordinatesCount + 1
-- else
--     showDock = false
--     sameCoordinatesCount = 0  -- Reset the counter if different coordinates are detected.
-- end
-- prevX, prevY = mousePoint.x, mousePoint.y

-- -- Initialize previous coordinate variables
-- local prevX, prevY = nil, nil
-- local sameCoordinatesCount = 0
-- local showDock = false
-- local sameCoordinates = (mousePoint.x == prevX and mousePoint.y == prevY)

-- -- Check if the same coordinates are detected the specified number of times in a row.
-- if sameCoordinatesCount >= 4 then
--     showDock = true
--     sameCoordinatesCount = 0  -- Reset the counter.
-- end

-- local edgeHit = (distance > distanceFromEdgeX or distance > distanceFromEdgeY)
-- -- if edgeHit then
-- if edgeHit then
--     -- print('oioi')
--     -- keepCursorInBounds()
-- end

-- print('distance from edge X: ' .. distanceFromEdgeX)
-- print('distance from edge Y: ' .. distanceFromEdgeY)
-- local inBoundsX = (mousePoint.x > distance and mousePoint.x < (currentScreen.w - distance))
-- local inBoundsY = (mousePoint.y > distance and mousePoint.y < (currentScreen.h - distance))

-- if distance > distanceFromEdgeX then -- Left side.
    -- distance = (distanceFromEdgeX - 1)
    -- distance = distanceFromEdgeX
    -- keepCursorInBounds()
-- end

-- print(edgeHit)
-- -- Determine whether or not the cursor is within the boundaries of the screen it's on.
-- if showDock then
--     if distance > distanceFromEdgeX then -- Left side.
--         keepCursorInBounds()
--     end
--     if distance > distanceFromEdgeY then -- Left side.
--         keepCursorInBounds()
--     end
-- end

-- if mousePoint.y > (currentScreen.h - distance) then -- Bottom side.
--     -- mousePoint.y = (currentScreen.h - 1)
--     -- postMouseEvent(eventTypes.mouseMoved, mousePoint, {}, 0)
--     -- keepCursorInBounds(eventTypes.mouseMoved, coords, mousePoint)
--     -- hs.mouse.setRelativePosition(mousePoint)
-- end

-- -- if mousePoint.x > (currentScreen.w - distance) then -- Right side.
-- if distance > distanceFromEdgeX then -- Right side.
--     -- print('right')
--     -- hs.mouse.setRelativePosition(mouskePoint)
--     -- mousePoint.x = mousePoint.x - 1
--     -- postMouseEvent(eventTypes.mouseMoved, mousePoint, {}, 0)
--     -- keepCursorInBounds(eventTypes.mouseMoved, mousePoint1, mousePoint2)
-- end

-- -- Determine whether or not the cursor is within the boundaries of the screen it's on.
-- if mousePoint.x > distance and mousePoint.x < (currentScreen.w - distance) then
--     inBoundsX = true
-- end
-- if mousePoint.y > distance and mousePoint.y < (currentScreen.h - distance) then
--     inBoundsY = true
-- end

-- -- Check if the current coordinates are the same as the previous coordinates
-- if prevX and prevY and mousePoint.x == prevX and mousePoint.y == prevY then
--     sameCoordsTwice = true
-- else
--     sameCoordsTwice = false
-- end
-- -- prevX, prevY = mousePoint.x, mousePoint.y
-- if sameCoordsTwice then
--     print('same coords')
-- end

-- local distanceFromEdgeX = math.min(coords.x - currentScreen.x, currentScreen.x + currentScreen.w - coords.x)
-- -- print('distance: ' .. distance)
-- -- print('distance from edge: ' .. distanceFromEdgeX)

-- if distanceFromEdgeX <= distance then
--     coords.x = 1
--     postMouseEvent(eventTypes.mouseMoved, coords, {}, 0)
--     -- distance = randomFloatNumber
--     -- if distance < 0.3 then distance = 0.3 end
-- end

-- local screenFrame = currentScreen:fullFrame()
-- local origScreenFrame = hs.mouse.getCurrentScreen():fullFrame()
-- local currentScreen = hs.mouse.getCurrentScreen()
-- local currentScreenFrame = hs.mouse.getCurrentScreen()
-- local screenFrame = currentScreenFrame:fullFrame()

-- -- Determine which screen the mouse is on.
-- for i, v in ipairs(everyScreen) do
--     if currentScreen == v then
--         currentScreenFrame = v:fullFrame()
--     end
-- end

-- -- If the screen that the cursor is currently on changes then update the screen grid.
-- if origScreenFrame ~= currentScreenFrame then
--     origScreenFrame = currentScreenFrame
--     -- screenChangeWatcher()
-- end




-- distance = 1
-- if distanceFromEdgeX < distance then
--     -- distance = (distanceFromEdgeX / 4)
--     -- print(distance)
--     -- if distance < 2 then
--     --     distance = 1
--     -- end
-- end

-- function MouseEvt:move(Var)
--     -- If the timer is already running cancel repeated execution.
--     if self.isActive then
--         return
--     end
--     self.isActive = true

--     -- Begin the timer and start updating cursor coordinates.
--     self.timer = hs.timer.new(0.017, function()
--         local coords = hs.mouse.absolutePosition()
--         local mousePoint = hs.mouse.getRelativePosition()
--         local everyScreen = hs.screen.allScreens()
--         local currentScreen = hs.mouse.getCurrentScreen()
--         local distance = Var.standardSpeed
--         -- Update the cursor coordinates.
--         if self.k then coords.y = coords.y + distance end -- Down.
--         if self.i then coords.y = coords.y - distance end -- Up.
--         if self.l then coords.x = coords.x + distance end -- Right.
--         if self.t then coords.x = coords.x - distance end -- Left.
--         hs.mouse.absolutePosition(coords)
--     end)
--     self.timer:start()
-- end
