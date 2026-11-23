
local conf = require('config')

local M = {
    isDisplayed = false,
}

local positions = {
    { key = conf.grid.topLeft,      x = 1 / 6, y = 1 / 6 },
    { key = conf.grid.topCenter,    x = 1 / 2, y = 1 / 6 },
    { key = conf.grid.topRight,     x = 5 / 6, y = 1 / 6 },
    { key = conf.grid.centerLeft,   x = 1 / 6, y = 1 / 2 },
    { key = conf.grid.center,       x = 1 / 2, y = 1 / 2 },
    { key = conf.grid.centerRight,  x = 5 / 6, y = 1 / 2 },
    { key = conf.grid.bottomLeft,   x = 1 / 6, y = 5 / 6 },
    { key = conf.grid.bottomCenter, x = 1 / 2, y = 5 / 6 },
    { key = conf.grid.bottomRight,  x = 5 / 6, y = 5 / 6 },
}

local canvas

local function create_canvas()
    local screen = hs.screen.mainScreen():frame()

    canvas = hs.canvas.new(screen)

    for i, position in ipairs(positions) do
        canvas[i] = {
            type          = 'text',
            text          = position.key,
            textColor     = conf.grid.color,
            textSize      = conf.grid.textSize,
            textFont      = conf.grid.font,
            textAlignment = 'center',
            frame = {
                x = string.format('%.2f%%', position.x * 100),
                y = string.format('%.2f%%', position.y * 100),
                w = conf.grid.size,
                h = conf.grid.size,
            },
        }
    end

    return canvas
end

function M.show()
    if not canvas then
        create_canvas()
    end

    canvas:show(0)
    M.isDisplayed = true
end

function M.hide()
    if canvas and M.isDisplayed then
        canvas:hide(0)
        M.isDisplayed = false
    end
end

return M
