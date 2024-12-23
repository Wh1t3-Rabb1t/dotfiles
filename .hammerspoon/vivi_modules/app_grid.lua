
local Var = require('../vivi_modules/global_variables')

local AppGrid = {
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

function AppGrid:mapCoords(position, highlightPos, subGridPlacement)
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
    for i, v in pairs(percentagePositions) do
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

function AppGrid:displayGrid()
    self.isDisplayed = true
    for i, v in ipairs(jumpPositions) do
        local canvas = self[v]
        canvas.outerRing:show(0)
        canvas.innerRing:show(0)
        canvas.jumpLetter:show(0)
        canvas.subJumpGrid:show(0)
    end
end

--------------------------------------------------------------------------------------------------------

function AppGrid:hideGrid()
    if self.isDisplayed then
        self.isDisplayed = false
        for i, v in ipairs(jumpPositions) do
            local canvas = self[v]
            canvas.outerRing:hide(0)
            canvas.innerRing:hide(0)
            canvas.jumpLetter:hide(0)
            canvas.subJumpGrid:hide(0)
            canvas.alteredSubJumpGrid:hide(0)
            canvas.subGridJumpLetter:hide(0)
        end
    end
end

--------------------------------------------------------------------------------------------------------

function AppGrid:displaySubGrid(firstKeyPressed)
    for i, v in ipairs(jumpPositions) do
        local canvas = self[v]
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


return AppGrid




























-- local AppGrid = {
--     isDisplayed = false,
--     throttleScrollEvents = false,
--     mappedCoords = {},
--     subGridMappedCoords = {},
--     w = {},
--     e = {},
--     r = {},
--     s = {},
--     d = {},
--     f = {},
--     x = {},
--     c = {},
--     v = {},
-- }

-- local percentagePositions = {
--     w = { x = '16.66%', y = '16.66%' },
--     e = { x = '50%', y = '16.66%' },
--     r = { x = '83.34%', y = '16.66%' },
--     s = { x = '16.66%', y = '50%' },
--     f = { x = '83.34%', y = '50%' },
--     x = { x = '16.66%', y = '83.34%' },
--     c = { x = '50%', y = '83.34%' },
--     v = { x = '83.34%', y = '83.34%' },
-- }

-- local letterPercentagePositions = {
--     w = { x = 0.1666, y = 0.1666 },
--     e = { x = 0.50, y = 0.1666 },
--     r = { x = 0.8334, y = 0.1666 },
--     s = { x = 0.1666, y = 0.50 },
--     f = { x = 0.8334, y = 0.50 },
--     x = { x = 0.1666, y = 0.8334 },
--     c = { x = 0.50, y = 0.8334 },
--     v = { x = 0.8334, y = 0.8334 },
-- }

-- function AppGrid:mapCoords(letter, highlightPos, subGridPlacement, Var)
--     local diameter = Var.highlightSize
--     local borderSize = diameter + (diameter / 10)
--     local margin = (borderSize - diameter) / 2
--     local strokeWidth = math.ceil(borderSize / 10)
--     local posX = highlightPos.x - (borderSize / 2)
--     local posY = highlightPos.y - (borderSize / 2)
--     local textSize = diameter / 2
--     local subGridPos = subGridPlacement[letter]
--     local subGridSize = subGridPlacement.size

--     -- Create the outer/inner ring and letter canvases.
--     self[letter] = {
--         outerRing = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize }),
--         innerRing = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter }),
--         jumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
--         subGridJumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
--         subJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
--         alteredSubJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
--     }
--     local outerRing = self[letter].outerRing
--     local innerRing = self[letter].innerRing
--     local jumpLetter = self[letter].jumpLetter
--     local subJumpGrid = self[letter].subJumpGrid
--     local subGridJumpLetter = self[letter].subGridJumpLetter
--     local alteredSubJumpGrid = self[letter].alteredSubJumpGrid

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

--     subGridJumpLetter[1] = {
--         type = 'text',
--         text = 'd',
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

--     -- Create circular canvas objects for the subGrid jump positions.
--     local count = 0
--     for i, v in pairs(percentagePositions) do
--         local pos = v
--         count = count + 1
--         if count >= 9 then count = 0 return end

--         subJumpGrid[count] = {
--             type = 'circle',
--             action = 'strokeAndFill',
--             fillColor = { black = 1 },
--             strokeColor = { white = 1 },
--             strokeWidth = 2,
--             clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--             center = pos,
--             radius = Var.smallHighlightSize,
--         }

--         ---------------------------------------------------------------------------------

--         alteredSubJumpGrid[count] = {
--             type = 'circle',
--             action = 'strokeAndFill',
--             fillColor = { black = 1 },
--             strokeColor = { white = 1 },
--             strokeWidth = 2,
--             clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
--             center = pos,
--             radius = Var.smallHighlightSize,
--         }
--     end

--     -- Apply letters to the subGrid.
--     local letterCount = 8
--     for i, v in pairs(letterPercentagePositions) do
--         local subLetter = i
--         local pos = v
--         letterCount = letterCount + 1
--         if letterCount >= 17 then letterCount = 8 return end

--         local radius = Var.smallHighlightSize
--         local canvasWidth = subGridSize.w
--         local canvasHeight = subGridSize.h
--         local posX = pos.x * canvasWidth - (radius / 2)
--         local posY = pos.y * canvasHeight - (radius / 2)
--         local posXPercentage = string.format('%.2f%%', posX * 100 / canvasWidth)
--         local posYPercentage = string.format('%.2f%%', posY * 100 / canvasHeight)

--         subJumpGrid[letterCount] = {
--             type = 'text',
--             text = letter .. subLetter,
--             textColor = { white = 1 },
--             textSize = (radius / 5 * 4),
--             textFont = 'Courier',
--             textAlignment = 'center',
--             frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
--         }

--         ---------------------------------------------------------------------------------

--         alteredSubJumpGrid[letterCount] = {
--             type = 'text',
--             text = subLetter,
--             textColor = { white = 1 },
--             textSize = (radius / 5 * 4),
--             textFont = 'Courier',
--             textAlignment = 'center',
--             frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
--         }
--     end

--     subJumpGrid[17] = {
--         type = 'rectangle',
--         action = 'stroke',
--         strokeWidth = 1,
--         strokeColor = { white = 1, alpha = 1 },
--         roundedRectRadii = { xRadius = 8, yRadius = 8 }, -- Give the rectangle rounded corners.
--     }

--     -- ! From the HS docs.
--     -- trackMouseEnterExit - Default false. Generates a callback when the mouse enters or exits the canvas element.
--     -- For canvas and text types, the frame of the element defines the boundaries of the tracking area.
-- end

-- function AppGrid:displayGrid()
--     self.isDisplayed = true
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         canvas.outerRing:show(0)
--         canvas.innerRing:show(0)
--         canvas.jumpLetter:show(0)
--         canvas.subJumpGrid:show(0)
--     end
-- end

-- function AppGrid:hideGrid()
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

-- function AppGrid:displaySubGrid(firstKeyPressed)
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

-- return AppGrid



-- function AppGrid:toggleSubGridFocus(firstKeyPressed, newLetter)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         -- Hide the sub-grid border for all sub-grids including the currently focused one.
--         if v == firstKeyPressed then
--             if canvas then
--                 local element = canvas.jumpLetter[1]
--                 element.text = newLetter
--                 canvas.alteredSubJumpGrid:show(0)
--             end
--         elseif v ~= firstKeyPressed then
--             if canvas then
--                 canvas.outerRing:hide(0)
--                 canvas.innerRing:hide(0)
--                 canvas.jumpLetter:hide(0)
--                 canvas.subJumpGrid:hide(0)
--                 canvas.alteredSubJumpGrid:hide(0)
--                 -- canvas.subGridJumpLetter:hide(0)
--             end
--         end
--     end
-- end





-- function AppGrid:showAlteredSubJumpGrid(firstKeyPressed, newLetter)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         if v == firstKeyPressed then
--             local canvas = self[v]
--             if canvas then
--                 local element = canvas.jumpLetter[1]
--                 element.text = newLetter
--                 -- canvas.subJumpGrid:hide(0)
--                 canvas.alteredSubJumpGrid:show(0)
--             end
--         end
--     end
-- end

-- function AppGrid:focusSubGrid(jumpLetter)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         local canvas = self[v]
--         -- Hide the sub-grid border for all sub-grids including the currently focused one.
--         -- canvas.alteredSubJumpGrid:hide(0)
--         if v ~= jumpLetter then
--             if canvas then
--                 canvas.outerRing:hide(0)
--                 canvas.innerRing:hide(0)
--                 canvas.jumpLetter:hide(0)
--                 canvas.subJumpGrid:hide(0)
--             end
--         end
--     end
-- end


-- function AppGrid:showAlteredSubJumpGrid(firstKeyPressed, newLetter)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         if v == firstKeyPressed then
--             local canvas = self[v]
--             if canvas then
--                 local element = canvas.jumpLetter[1]
--                 element.text = newLetter
--                 -- canvas.subJumpGrid:hide(0)
--                 canvas.alteredSubJumpGrid:show(0)
--             end
--         end
--     end
-- end







-- function AppGrid:alterSubGridAppearance(firstKeyPressed, newLetter, hardReset)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         if v == firstKeyPressed then
--             local canvas = self[v]
--             if canvas then
--                 local element = canvas.jumpLetter[1] -- Assuming the jumpLetter is always at index 1
--                 element.text = newLetter
--                 -- Update subJumpGrid
--                 if hardReset then
--                     for j, k in ipairs(canvas.subJumpGrid) do
--                         local resetLetter = k.text
--                         k.text = newLetter .. resetLetter
--                     end
--                 else
--                     for j, k in ipairs(canvas.subJumpGrid) do
--                         local someLetters = k.text
--                         local updatedLetter = string.sub(someLetters, 2, 2)
--                         k.text = updatedLetter
--                     end
--                 end
--             end
--         end
--     end
-- end






-- function AppGrid:alterSubGridAppearance(firstKeyPressed, newLetter)
--     for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
--         if v == firstKeyPressed then
--             local canvas = self[v]
--             if canvas then
--                 local element = canvas.jumpLetter[1] -- Assuming the jumpLetter is always at index 1
--                 element.text = newLetter
--             end
--         end
--     end
-- end


-- function AppGrid:hideGrid()
--     if self.isDisplayed then
--         self.isDisplayed = false
--         -- If the grid exists, loop through the grid icons and hide them.
--         for i, v in pairs(self) do
--             if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--                 v.outerRing:hide(0)
--                 v.innerRing:hide(0)
--                 v.jumpLetter:hide(0)
--                 v.subJumpGrid:hide(0)
--             end
--         end
--     end
-- end

-- function AppGrid:deleteGrid()
--     self.isDisplayed = false
--     -- If the grid exists, loop through the grid icons and delete them.
--     for i, v in pairs(self) do
--         if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--             v.outerRing:delete(0)
--             v.innerRing:delete(0)
--             v.jumpLetter:delete(0)
--             v.subJumpGrid:delete(0)
--             self[i] = nil
--         end
--     end
-- end






-- function AppGrid:displayGrid()
--     self.isDisplayed = true
--     for i, v in pairs(self) do
--         -- print(v)
--         if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--             v.outerRing:show(0)
--             v.innerRing:show(0)
--             v.jumpLetter:show(0)
--             -- if v.subJumpGrid then
--             --     for i, v in ipairs(v.subJumpGrid) do
--             --         v:show(0)
--             --     end
--             -- end
--         end
--     end
-- end
-- function AppGrid:hideGrid()
--     if self.isDisplayed then
--         self.isDisplayed = false
--         -- If the grid exists, loop through the grid icons and hide them.
--         for i, v in pairs(self) do
--             if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--                 v.outerRing:hide(0)
--                 v.innerRing:hide(0)
--                 v.jumpLetter:hide(0)
--                 -- if v.subJumpGrid then
--                 --     for _, subGrid in ipairs(v.subJumpGrid) do
--                 --         subGrid:hide()
--                 --     end
--                 -- end
--             end
--         end
--     end
-- end
-- function AppGrid:deleteGrid()
--     self.isDisplayed = false
--     -- If the grid exists, loop through the grid icons and delete them.
--     for i, v in pairs(self) do
--         if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--             v.outerRing:delete(0)
--             v.innerRing:delete(0)
--             v.jumpLetter:delete(0)
--             -- if v.subJumpGrid then
--             --     for _, subGrid in ipairs(v.subJumpGrid) do
--             --         subGrid:delete()
--             --     end
--             -- end
--             self[i] = nil
--         end
--     end
-- end






-- function AppGrid:displayGrid()
--     self.isDisplayed = true
--     for _, canvas in ipairs(self.canvasList) do
--         canvas:show()
--     end
-- end
-- function AppGrid:hideGrid()
--     if self.isDisplayed then
--         self.isDisplayed = false
--         for _, canvas in ipairs(self.canvasList) do
--             canvas:hide()
--         end
--     end
-- end
-- function AppGrid:deleteGrid()
--     self.isDisplayed = false
--     for i, v in ipairs(self.canvasList) do
--         v:delete()
--         self[i] = nil
--     end
-- end



    -- -- self.canvasList = {}
    -- for i, v in pairs(self) do
    --     if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
    --         table.insert(self.canvasList, v.outerRing)
    --         table.insert(self.canvasList, v.innerRing)
    --         table.insert(self.canvasList, v.jumpLetter)
    --         if v.subJumpGrid then
    --             for _, subGrid in ipairs(v.subJumpGrid) do
    --                 table.insert(self.canvasList, subGrid)
    --             end
    --         end
    --     end
    -- end

-- function AppGrid:displayGrid()
--     self.isDisplayed = true
--     local combinedCanvas = hs.canvas.new({ x = 0, y = 0, w = 100, h = 100 }) -- Adjust the width and height accordingly.
--     for i, v in pairs(self) do
--         if type(v) == 'table' and v.outerRing and v.innerRing and v.jumpLetter then
--             combinedCanvas:insertElement(v.outerRing)
--             combinedCanvas:insertElement(v.innerRing)
--             combinedCanvas:insertElement(v.jumpLetter)
--             if v.subJumpGrid then
--                 for _, subGrid in ipairs(v.subJumpGrid) do
--                     combinedCanvas:insertElement(subGrid)
--                 end
--             end
--         end
--     end
--     combinedCanvas:show()
-- end







    -- local letterCount = 8
    -- -- for i, v in pairs(self.subGridMappedCoords[letter]) do
    -- for i, v in pairs(percentagePositions) do
    --     local subLetter = i
    --     local pos = v
    --     letterCount = letterCount + 1
    --     if letterCount >= 17 then letterCount = 8 return end
    --     local radius = 20
    --     local wid = (subGridPos.w / 100)
    --     local hei = (subGridPos.h / 100)
    --     local letterPosX = roundNumber(radius / wid)
    --     local letterPosY = roundNumber(radius / hei)
    --     subJumpGrid[letterCount] = {
    --         type = 'text',
    --         text = letter .. subLetter,
    --         textColor = { white = 1 },
    --         textSize = 16,
    --         textFont = 'Courier',
    --         textAlignment = 'center',
    --         -- frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
    --         frame = { x = pos.x, y = pos.y, w = radius, h = radius },
    --     }
    -- end







-- function AppGrid:displayGrid()
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


-- function AppGrid:hideGrid()
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


-- function AppGrid:deleteGrid()
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


-- ! Include jump icons for previous and next screens as well.




    -- ! Add a callback containing a for loop to loop through the subCoords table and create the canvases for each coord.

    -- for i, v in pairs(subCoords) do
    --     local subLetter = i
    --     local coords = v
    --     subGrid = hs.canvas.new({ x = coords.x, y = coords.y, w = 30, h = 30 })
    --     subGrid[1] = {
    --         type = 'circle',
    --         action = 'fill',
    --         fillColor = { black = 1 }, -- White.
    --     }
    --     subGrid[2] = {
    --         type = 'text',
    --         text = letter .. subLetter,
    --         textColor = { white = 1 },
    --         textAlignment = 'center',
    --         textSize = 18,
    --         textFont = 'Courier',
    --     }
    -- end

    -- subGrid:show()
        -- print('X: ' .. coords.x)
        -- print('Y: ' .. coords.y)
        -- print('--------------------------------')




-- local AppGrid = {
--     isDisplayed = false,
--     throttleScrollEvents = false,
--     mappedCoords = {},
--     w = nil,
--     e = nil,
--     r = nil,
--     s = nil,
--     d = nil,
--     f = nil,
--     x = nil,
--     c = nil,
--     v = nil,
-- }




    -- function createSubGrid()
    --     local subGrids = {}
    --     for i, v in pairs(subCoords) do
    --         local subLetter = i
    --         local coords = v
    --         subGrid = hs.canvas.new({ x = coords.x, y = coords.y, w = 30, h = 30 })
    --         subGrid[1] = {
    --             type = 'circle',
    --             action = 'strokeAndFill',
    --             fillColor = { black = 1 },
    --             strokeColor = { white = 1 },
    --             strokeWidth = 2,
    --             clipToPath = true, -- Prevent the edges of the line clipping out of the canvas.
    --         }
    --         subGrid[2] = {
    --             type = 'text',
    --             text = letter .. subLetter,
    --             textColor = { white = 1 },
    --             textAlignment = 'center',
    --             textSize = 18,
    --             textFont = 'Courier',
    --         }
    --         table.insert(subGrids, subGrid)
    --     end
    --     return subGrids
    -- end

    -- subJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridPos.w, h = subGridPos.h }),
    -- alteredSubJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridPos.w, h = subGridPos.h }),