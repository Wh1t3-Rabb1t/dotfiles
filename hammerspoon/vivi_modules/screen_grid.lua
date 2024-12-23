
local Var = require('../vivi_modules/global_variables')

local ScreenGrid = {
    isDisplayed = false,
    throttleScrollEvents = false,
    mappedCoords = {},
    subGridMappedCoords = {},
    topLeft = {},
    topCenter = {},
    topRight = {},
    centerLeft = {},
    center = {},
    centerRight = {},
    bottomLeft = {},
    bottomCenter = {},
    bottomRight = {},
}

--------------------------------------------------------------------------------------------------------

local percentagePositions = {
    [Var.topLeft] = { x = '16.66%', y = '16.66%' },
    [Var.topCenter] = { x = '50%', y = '16.66%' },
    [Var.topRight] = { x = '83.34%', y = '16.66%' },
    [Var.centerLeft] = { x = '16.66%', y = '50%' },
    [Var.centerRight] = { x = '83.34%', y = '50%' },
    [Var.bottomLeft] = { x = '16.66%', y = '83.34%' },
    [Var.bottomCenter] = { x = '50%', y = '83.34%' },
    [Var.bottomRight] = { x = '83.34%', y = '83.34%' },
}

--------------------------------------------------------------------------------------------------------

local letterPercentagePositions = {
    [Var.topLeft] = { x = 0.1666, y = 0.1666 },
    [Var.topCenter] = { x = 0.50, y = 0.1666 },
    [Var.topRight] = { x = 0.8334, y = 0.1666 },
    [Var.centerLeft] = { x = 0.1666, y = 0.50 },
    [Var.centerRight] = { x = 0.8334, y = 0.50 },
    [Var.bottomLeft] = { x = 0.1666, y = 0.8334 },
    [Var.bottomCenter] = { x = 0.50, y = 0.8334 },
    [Var.bottomRight] = { x = 0.8334, y = 0.8334 },
}

--------------------------------------------------------------------------------------------------------

function ScreenGrid:mapCoords(position, highlightPos, subGridPlacement)
    local diameter = Var.highlightSize
    local borderSize = diameter + (diameter / 10)
    local margin = (borderSize - diameter) / 2
    local strokeWidth = math.ceil(borderSize / 10)
    local posX = highlightPos.x - (borderSize / 2)
    local posY = highlightPos.y - (borderSize / 2)
    local textSize = diameter / 2
    local subGridPos = subGridPlacement[position]
    local subGridSize = subGridPlacement.size
    local letter = Var[position] -- The letter associated with each jump position.

    -- Create the outer/inner ring and position canvases.
    self[position] = {
        outerRing = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize }),
        innerRing = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter }),
        jumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
        subGridJumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
        subJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
        alteredSubJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
    }
    local outerRing = self[position].outerRing
    local innerRing = self[position].innerRing
    local jumpLetter = self[position].jumpLetter
    local subJumpGrid = self[position].subJumpGrid
    local subGridJumpLetter = self[position].subGridJumpLetter
    local alteredSubJumpGrid = self[position].alteredSubJumpGrid

    -- Add attributes to the jump coord highlights.
    outerRing[1] = {
        type = 'ellipticalArc',
        action = 'stroke',
        strokeWidth = strokeWidth,
        strokeColor = { red = 1, green = 0, blue = 0, alpha = 1 }, -- Red.
        arcRadii = false, -- Prevent the line being drawn from the center of the circle.
        clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
        startAngle = 0,
        endAngle = 360,
    }

    innerRing[1] = {
        type = 'ellipticalArc',
        action = 'stroke',
        strokeWidth = strokeWidth,
        strokeColor = { red = 1, green = 1, blue = 1, alpha = 1 }, -- White.
        arcRadii = false, -- Prevent the line being drawn from the center of the circle.
        clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
        startAngle = 0,
        endAngle = 360,
    }

    jumpLetter[1] = {
        type = 'text',
        -- text = letter,
        text = letter,
        textColor = { white = 1 },
        textAlignment = 'center',
        textSize = textSize,
        textFont = 'Courier',
        withShadow = true,
        shadow = {
            blurRadius = 15,
            color = { black = 1, alpha = 1 },
            offset = { h = 0, w = 0 },
        },
    }

    subGridJumpLetter[1] = {
        type = 'text',
        -- text = 'd',
        text = Var.center,
        textColor = { white = 1 },
        textAlignment = 'center',
        textSize = textSize,
        textFont = 'Courier',
        withShadow = true,
        shadow = {
            blurRadius = 15,
            color = { black = 1, alpha = 1 },
            offset = { h = 0, w = 0 },
        },
    }

    -- Create circular canvas objects for the subGrid jump positions.
    local count = 0
    for _, v in pairs(percentagePositions) do
        local pos = v
        count = count + 1
        if count >= 9 then count = 0 return end

        subJumpGrid[count] = {
            type = 'circle',
            action = 'strokeAndFill',
            fillColor = { black = 1 },
            strokeColor = { white = 1 },
            strokeWidth = 2,
            clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
            center = pos,
            radius = Var.smallHighlightSize,
        }

        alteredSubJumpGrid[count] = {
            type = 'circle',
            action = 'strokeAndFill',
            fillColor = { black = 1 },
            strokeColor = { white = 1 },
            strokeWidth = 2,
            clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
            center = pos,
            radius = Var.smallHighlightSize,
        }
    end

    -- Apply letters to the subGrid.
    local letterCount = 8
    for i, v in pairs(letterPercentagePositions) do
        local subLetter = i
        local pos = v
        letterCount = letterCount + 1
        if letterCount >= 17 then letterCount = 8 return end

        local radius = Var.smallHighlightSize
        local canvasWidth = subGridSize.w
        local canvasHeight = subGridSize.h
        local posX = pos.x * canvasWidth - (radius / 2)
        local posY = pos.y * canvasHeight - (radius / 2)
        local posXPercentage = string.format('%.2f%%', posX * 100 / canvasWidth)
        local posYPercentage = string.format('%.2f%%', posY * 100 / canvasHeight)

        subJumpGrid[letterCount] = {
            type = 'text',
            text = letter .. subLetter,
            -- text = subLetter,
            textColor = { white = 1 },
            textSize = (radius / 5 * 4),
            textFont = 'Courier',
            textAlignment = 'center',
            frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
        }

        alteredSubJumpGrid[letterCount] = {
            type = 'text',
            text = subLetter,
            textColor = { white = 1 },
            textSize = (radius / 5 * 4),
            textFont = 'Courier',
            textAlignment = 'center',
            frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
        }
    end

    subJumpGrid[17] = {
        type = 'rectangle',
        action = 'stroke',
        strokeWidth = 1,
        strokeColor = { white = 1, alpha = 1 },
        roundedRectRadii = { xRadius = 8, yRadius = 8 }, -- Give the rectangle rounded corners.
    }

    -- ! From the HS docs.
    -- trackMouseEnterExit - Default false. Generates a callback when the mouse enters or exits the canvas element.
    -- For canvas and text types, the frame of the element defines the boundaries of the tracking area.
end

--------------------------------------------------------------------------------------------------------

local jumpPositions = {
    'topLeft',
    'topCenter',
    'topRight',
    'centerLeft',
    'center',
    'centerRight',
    'bottomLeft',
    'bottomCenter',
    'bottomRight',
}

--------------------------------------------------------------------------------------------------------

function ScreenGrid:displayGrid()
    self.isDisplayed = true
    for _, v in ipairs(jumpPositions) do
        local canvas = self[v]
        if canvas then
            canvas.outerRing:show(0)
            canvas.innerRing:show(0)
            canvas.jumpLetter:show(0)
            canvas.subJumpGrid:show(0)
        end
    end
end

--------------------------------------------------------------------------------------------------------

function ScreenGrid:hideGrid()
    if self.isDisplayed then
        self.isDisplayed = false
        for _, v in ipairs(jumpPositions) do
            local canvas = self[v]
            if canvas then
                canvas.outerRing:hide(0)
                canvas.innerRing:hide(0)
                canvas.jumpLetter:hide(0)
                canvas.subJumpGrid:hide(0)
                canvas.alteredSubJumpGrid:hide(0)
                canvas.subGridJumpLetter:hide(0)
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------

function ScreenGrid:displaySubGrid(firstKeyPressed)
    for _, v in ipairs(jumpPositions) do
        local canvas = self[v]
        if canvas then
            if v == firstKeyPressed then
                canvas.subGridJumpLetter:show(0)
                canvas.alteredSubJumpGrid:show(0)
                canvas.jumpLetter:hide(0)
            elseif v ~= firstKeyPressed then
                canvas.outerRing:hide(0)
                canvas.innerRing:hide(0)
                canvas.jumpLetter:hide(0)
                canvas.subJumpGrid:hide(0)
            end
        end
    end
end

return ScreenGrid


--------------------------------------------------------------------------------------------------------


-- createScreenBorder()
-- self:createScreenBorder()

-- function ScreenGrid:createScreenBorder()
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

--         -- screenBorders[i] = screenBorder -- Store the canvas for each screen
--         screenBorders[v] = screenBorder -- Store the canvas for each screen
--     end
--     self.displayBorders = screenBorders -- Store the table of screen borders

--     -- for i, v in ipairs(self.displayBorders) do
--     --     -- print(i)
--     --     -- print(v)
--     --     -- v:show() -- Show each screen border canvas
--     -- end

-- end

-- function ScreenGrid:displayScreenBorder(currentScreen)
--     for i, v in pairs (self.displayBorders) do
--         -- print(i)
--         -- print(v)
--         -- print('-------------------------------------')

--         if i == currentScreen then
--             v:show()
--         else
--             v:hide()
--         end
--     end
-- end


    -- for _, border in ipairs(screenBorders) do
    --     border:show() -- Show each screen border canvas
    -- end


-- function ScreenGrid:createScreenBorder()
--     if screenBorder then screenBorder:hide() end
--     local currentScreen = hs.mouse.getCurrentScreen()
--     local screenFrame = currentScreen:fullFrame()
--     screenBorder = hs.canvas.new({ x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h })
--     screenBorder[1] = {
--         type = 'rectangle',
--         action = 'stroke',
--         strokeWidth = 4,
--         strokeColor = { white = 1, alpha = 1 },
--         roundedRectRadii = { xRadius = 8, yRadius = 8 }, -- Give the rectangle rounded corners.
--     }
--     -- screenBorder:show()
-- end

-- function ScreenGrid:createScreenBorder()
--     local everyScreen = hs.screen.allScreens()
--     local currentScreen = hs.mouse.getCurrentScreen()
--     local screenFrame = currentScreen:fullFrame()
--     self.screenBorder = hs.canvas.new({ x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h })
--     for i, v in ipairs(everyScreen) do
--         -- print(i) -- Numerical index of the display.
--         -- print(v) -- Name of the display.
--         -- local frame = v:fullFrame() -- This is the absolute position of the frame which account for your monitor layout.
--         self.screenBorder[i] = {
--             type = 'rectangle',
--             action = 'stroke',
--             strokeWidth = 4,
--             strokeColor = { white = 1, alpha = 1 },
--         }
--     end
--     self.screenBorder:show()
-- end


    -- if self.screenBorder then self.screenBorder:hide() end
    -- local currentScreen = hs.mouse.getCurrentScreen()
    -- local screenFrame = currentScreen:fullFrame()
    -- self.screenBorder = hs.canvas.new({ x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h })

    -- self.screenBorder[1] = {
    --     type = 'rectangle',
    --     action = 'stroke',
    --     strokeWidth = 4,
    --     strokeColor = { white = 1, alpha = 1 },
    --     -- roundedRectRadii = { xRadius = 8, yRadius = 8 }, -- Give the rectangle rounded corners.
    -- }
    -- self.screenBorder:show()

--------------------------------------------------------------------------------------------------------



-- function ScreenGrid:displayGrid()
--     self.isDisplayed = true
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         canvas.outerRing:show(0)
--         canvas.innerRing:show(0)
--         canvas.jumpLetter:show(0)
--         canvas.subJumpGrid:show(0)
--     end
-- end

-- function ScreenGrid:hideGrid()
--     if self.isDisplayed then
--         self.isDisplayed = false
--         for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--             local canvas = self[v]
--             canvas.outerRing:hide(0)
--             canvas.innerRing:hide(0)
--             canvas.jumpLetter:hide(0)
--             canvas.subJumpGrid:hide(0)
--             canvas.alteredSubJumpGrid:hide(0)
--             canvas.subGridJumpLetter:hide(0)
--         end
--     end
-- end

-- function ScreenGrid:displaySubGrid(firstKeyPressed)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         if v == firstKeyPressed then
--             canvas.subGridJumpLetter:show(0)
--             canvas.alteredSubJumpGrid:show(0)
--             canvas.jumpLetter:hide(0)
--         elseif v ~= firstKeyPressed then
--             canvas.outerRing:hide(0)
--             canvas.innerRing:hide(0)
--             canvas.jumpLetter:hide(0)
--             canvas.subJumpGrid:hide(0)
--         end
--     end
-- end



-- -- ! Include jump icons for previous and next screens as well.

-- -- function ScreenGrid:mapCoords(letter, highlightPos, Var)
-- function ScreenGrid:mapCoords(letter, highlightPos, subCoords, Var)
--     local diameter = Var.highlightSize
--     local borderSize = diameter + (diameter / 10)
--     local margin = (borderSize - diameter) / 2
--     local strokeWidth = math.ceil(borderSize / 10)
--     local posX = highlightPos.x - (borderSize / 2)
--     local posY = highlightPos.y - (borderSize / 2)
--     local textSize = diameter / 2

--     -- Create the outer/inner ring and letter canvases.
--     self[letter] = {
--         outerRing = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize }),
--         innerRing = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter }),
--         jumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize })
--     }
--     local outerRing = self[letter].outerRing
--     local innerRing = self[letter].innerRing
--     local jumpLetter = self[letter].jumpLetter

--     -- Add attributes to the jump coord highlights.
--     outerRing[1] = {
--         type = 'ellipticalArc',
--         action = 'stroke',
--         strokeWidth = strokeWidth,
--         strokeColor = { red = 1, green = 0, blue = 0, alpha = 1 }, -- Red.
--         arcRadii = false, -- Prevent the line being drawn from the center of the circle.
--         clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--         startAngle = 0,
--         endAngle = 360,
--     }
--     -----------------------------------------------------------------------------------
--     innerRing[1] = {
--         type = 'ellipticalArc',
--         action = 'stroke',
--         strokeWidth = strokeWidth,
--         strokeColor = { red = 1, green = 1, blue = 1, alpha = 1 }, -- White.
--         arcRadii = false, -- Prevent the line being drawn from the center of the circle.
--         clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--         startAngle = 0,
--         endAngle = 360,
--     }
--     -----------------------------------------------------------------------------------
--     jumpLetter[1] = {
--         type = 'text',
--         text = letter,
--         textColor = { white = 1 },
--         textAlignment = 'center',
--         textSize = textSize,
--         textFont = 'Courier',
--         withShadow = true,
--         shadow = {
--             blurRadius = 15,
--             color = { black = 1, alpha = 1 },
--             offset = { h = 0, w = 0 },
--         },
--     }
-- end

-- function ScreenGrid:displayGrid()
--     self.isDisplayed = true
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         if canvas and canvas.outerRing and canvas.innerRing and canvas.jumpLetter then
--             canvas.outerRing:show(0)
--             canvas.innerRing:show(0)
--             canvas.jumpLetter:show(0)
--         end
--     end
-- end

-- function ScreenGrid:hideGrid()
--     if self.isDisplayed then
--         self.isDisplayed = false
--         -- If the grid exists, loop through the grid icons and delete them.
--         for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--             local canvas = self[v]
--             if canvas then
--                 canvas.outerRing:hide(0)
--                 canvas.innerRing:hide(0)
--                 canvas.jumpLetter:hide(0)
--             end
--         end
--     end
-- end

-- return ScreenGrid


-- function ScreenGrid:deleteGrid()
--     self.isDisplayed = false
--     -- If the grid exists, loop through the grid icons and delete them.
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         if canvas then
--             canvas.outerRing:delete(0)
--             canvas.innerRing:delete(0)
--             canvas.jumpLetter:delete(0)
--             self[v] = nil
--         end
--     end
-- end



-- function ScreenGrid:screenWatcher(frame)
--     -- print('arg:' .. frame.w)
--     -- print('cached:' .. self.cachedFrame.w)
--     -- print('----------------------')
--     -- If the app frame has changed rerun then coord mapper.
--     if frame.w ~= self.cachedFrame.w or frame.h ~= self.cachedFrame.h then
--         self.cachedFrame = frame
--         -- self.mapCoords('a', frame)
--     end
-- end
