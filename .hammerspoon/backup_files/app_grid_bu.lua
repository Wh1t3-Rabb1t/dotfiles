
local AppGrid = {
    isDisplayed = false,
    throttleScrollEvents = false,
    mappedCoords = {},
    subGridMappedCoords = {},
    w = {},
    e = {},
    r = {},
    s = {},
    d = {},
    f = {},
    x = {},
    c = {},
    v = {},
}

local percentagePositions = {
    w = { x = '16.66%', y = '16.66%' },
    e = { x = '50%', y = '16.66%' },
    r = { x = '83.34%', y = '16.66%' },
    s = { x = '16.66%', y = '50%' },
    f = { x = '83.34%', y = '50%' },
    x = { x = '16.66%', y = '83.34%' },
    c = { x = '50%', y = '83.34%' },
    v = { x = '83.34%', y = '83.34%' },
}

local letterPercentagePositions = {
    w = { x = 0.1666, y = 0.1666 },
    e = { x = 0.50, y = 0.1666 },
    r = { x = 0.8334, y = 0.1666 },
    s = { x = 0.1666, y = 0.50 },
    f = { x = 0.8334, y = 0.50 },
    x = { x = 0.1666, y = 0.8334 },
    c = { x = 0.50, y = 0.8334 },
    v = { x = 0.8334, y = 0.8334 },
}

function AppGrid:mapCoords(letter, highlightPos, subGridPlacement, Var)
    local diameter = Var.highlightSize
    local borderSize = diameter + (diameter / 10)
    local margin = (borderSize - diameter) / 2
    local strokeWidth = math.ceil(borderSize / 10)
    local posX = highlightPos.x - (borderSize / 2)
    local posY = highlightPos.y - (borderSize / 2)
    local textSize = diameter / 2
    local subGridPos = subGridPlacement[letter]
    local subGridSize = subGridPlacement.size

    -- Create the outer/inner ring and letter canvases.
    self[letter] = {
        outerRing = hs.canvas.new({ x = posX, y = posY, w = borderSize, h = borderSize }),
        innerRing = hs.canvas.new({ x = (posX + margin), y = (posY + margin), w = diameter, h = diameter }),
        jumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
        subGridJumpLetter = hs.canvas.new({ x = posX, y = (posY + margin), w = borderSize, h = borderSize }),
        subJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
        alteredSubJumpGrid = hs.canvas.new({ x = subGridPos.x, y = subGridPos.y, w = subGridSize.w, h = subGridSize.h }),
    }
    local outerRing = self[letter].outerRing
    local innerRing = self[letter].innerRing
    local jumpLetter = self[letter].jumpLetter
    local subJumpGrid = self[letter].subJumpGrid
    local subGridJumpLetter = self[letter].subGridJumpLetter
    local alteredSubJumpGrid = self[letter].alteredSubJumpGrid

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
        text = 'd',
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

        ---------------------------------------------------------------------------------

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
            textColor = { white = 1 },
            textSize = (radius / 5 * 4),
            textFont = 'Courier',
            textAlignment = 'center',
            frame = { x = posXPercentage, y = posYPercentage, w = radius, h = radius },
        }

        ---------------------------------------------------------------------------------

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

function AppGrid:displayGrid()
    self.isDisplayed = true
    for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
        local canvas = self[v]
        canvas.outerRing:show(0)
        canvas.innerRing:show(0)
        canvas.jumpLetter:show(0)
        canvas.subJumpGrid:show(0)
    end
end

function AppGrid:hideGrid()
    if self.isDisplayed then
        self.isDisplayed = false
        for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
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

function AppGrid:displaySubGrid(firstKeyPressed)
    for i, v in ipairs({'w', 'e', 'r', 's', 'd', 'f', 'x', 'c', 'v'}) do
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

-- return AppGrid
