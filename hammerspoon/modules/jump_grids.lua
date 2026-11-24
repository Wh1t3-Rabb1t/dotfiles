
local state = require('state')
local conf  = require('config').grid

local M = {
    isDisplayed = false,
}

local positions = {
    { key = conf.topLeft,      x = 1 / 6, y = 1 / 6 },
    { key = conf.topCenter,    x = 1 / 2, y = 1 / 6 },
    { key = conf.topRight,     x = 5 / 6, y = 1 / 6 },
    { key = conf.centerLeft,   x = 1 / 6, y = 1 / 2 },
    { key = conf.center,       x = 1 / 2, y = 1 / 2 },
    { key = conf.centerRight,  x = 5 / 6, y = 1 / 2 },
    { key = conf.bottomLeft,   x = 1 / 6, y = 5 / 6 },
    { key = conf.bottomCenter, x = 1 / 2, y = 5 / 6 },
    { key = conf.bottomRight,  x = 5 / 6, y = 5 / 6 },
}

local canvas

local function add_element(element)
    canvas[canvas:elementCount() + 1] = element
end

local function create_canvas()
    local window = state.windows.curr_win or hs.window.focusedWindow()

    if not window then
        return
    end

    window = window:frame()
    canvas = hs.canvas.new(window)

    -- Grid lines
    local gridLines = {
        {
            { x = '33.33%', y = '0%'   },
            { x = '33.33%', y = '100%' },
        },
        {
            { x = '66.67%', y = '0%'   },
            { x = '66.67%', y = '100%' },
        },
        {
            { x = '0%',   y = '33.33%' },
            { x = '100%', y = '33.33%' },
        },
        {
            { x = '0%',   y = '66.67%' },
            { x = '100%', y = '66.67%' },
        },
    }

    for _, coordinates in ipairs(gridLines) do
        add_element({
            type        = 'segments',
            action      = 'stroke',
            coordinates = coordinates,
            strokeWidth = conf.gridStroke,
            strokeColor = conf.gridColor,
        })
    end

    -- Position rings
    for _, position in ipairs(positions) do
        add_element({
            type        = 'circle',
            action      = 'stroke',
            center      = {
                x = string.format('%.2f%%', position.x * 100),
                y = string.format('%.2f%%', position.y * 100),
            },
            radius      = conf.ringRadius,
            strokeWidth = conf.ringStroke,
            strokeColor = conf.ringColor,
        })
    end

    -- Position letters
    for _, position in ipairs(positions) do
        add_element({
            type          = 'text',
            text          = position.key,
            textColor     = { white = 1 },
            textSize      = conf.textSize,
            textFont      = conf.font,
            textAlignment = 'center',
            frame         = {
                x = position.x * window.w - conf.textBoxSize / 2,
                y = position.y * window.h - conf.textBoxSize / 2,
                w = conf.textBoxSize,
                h = conf.textBoxSize,
            }
        })
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
