
local state = require('state')
local conf  = require('config').grid

local M = {
    isDisplayed = false,
}

-- Position coords
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

local canvas
local curr_text_size  = conf.textSize
local letter_elements = {}
local ring_elements   = {}


-- Calculate the enclosing cell for a selected position.
--
-- Returns:
--   (table):  The x, y, w, h values for the target position
--------------------------------------------------------------------------------
local function get_subgrid_frame(window, position)
    local width  = window.w / 3
    local height = window.h / 3

    local centerX = window.x + (position.x * window.w)
    local centerY = window.y + (position.y * window.h)

    return {
        x = centerX - width / 2,
        y = centerY - height / 2,
        w = width,
        h = height,
    }
end


-- Find a position using its assigned key.
--
-- Parameters:
--   key (string):  The letter associated with the target position
--
-- Returns:
--   position (table):  The key, x, y values for the target position
--------------------------------------------------------------------------------
local function get_position(key)
    for _, position in ipairs(positions) do
        if position.key == key then
            return position
        end
    end
end


-- Update the font size and corresponding ring radius.
--
-- Parameters:
--   text_size (number): Desired font size.
--
-- State changes:
--   Updates canvas textSize and circle radius attributes.
--------------------------------------------------------------------------------
local function set_visual_size(text_size)
    local scale = text_size / conf.textSize

    for _, index in ipairs(letter_elements) do
        canvas[index].textSize = text_size
    end

    for _, index in ipairs(ring_elements) do
        canvas[index].radius = conf.ringRadius * scale
    end

    curr_text_size = text_size
end


-- Add an element to the canvas table.
--
-- Returns:
--   idx (number):  Index of the canvas element in its parent table
--------------------------------------------------------------------------------
local function add_element(element)
    local idx = canvas:elementCount() + 1

    canvas[idx] = element

    return idx
end


-- Format and create the jump grid canvas.
--
-- Parameters:
--   win_frame (table):  hs.window:frame() object
--
-- Calls:
--   add_element()
--
-- Returns:
--   canvas (table):  hs.canvas object
--------------------------------------------------------------------------------
local function create_canvas(win_frame)
    canvas = hs.canvas.new(win_frame)

    -- Grid lines
    if conf.lineVisible then
        for _, coordinates in ipairs(gridLines) do
            add_element({
                type        = 'segments',
                action      = 'stroke',
                coordinates = coordinates,
                strokeWidth = conf.lineStroke,
                strokeColor = conf.lineColor,
            })
        end
    end

    -- Position rings
    if conf.ringVisible then
        for _, position in ipairs(positions) do
            local idx = add_element({
                type         = 'circle',
                action       = 'stroke',
                absoluteSize = false,
                radius       = conf.ringRadius,
                strokeWidth  = conf.ringStroke,
                strokeColor  = conf.ringColor,
                center = {
                    x = string.format('%.2f%%', position.x * 100),
                    y = string.format('%.2f%%', position.y * 100),
                }
            })

            ring_elements[#ring_elements + 1] = idx
        end
    end

    -- Position letters
    for _, position in ipairs(positions) do
        local idx = add_element({
            type = 'text',

            -- Both absolute size and position need to be false for dynamic
            -- resizing of text elements i.e. letters within each jump ring.
            absolutePosition = false,
            absoluteSize     = false,

            text          = position.key,
            textSize      = conf.textSize,
            textFont      = conf.font,
            textAlignment = 'center',
            textColor     = { white = 1 },
            frame = {
                x = position.x * win_frame.w - conf.textBoxSize / 2,
                y = position.y * win_frame.h - conf.textBoxSize / 2 + conf.textOffsetY,
                w = conf.textBoxSize,
                h = conf.textBoxSize,
            }
        })

        letter_elements[#letter_elements + 1] = idx
    end

    return canvas
end


-- Show the jump grid letters.
--
-- Parameters:
--   jump_key (string):  The letter associated with the target position
--
-- Calls:
--   create_canvas()
--   get_position()
--   get_subgrid_frame()
--   set_visual_size()
--
-- State changes:
--   M.isDisplayed
--------------------------------------------------------------------------------
function M.show(jump_key)
    local window      = state.windows.curr_win or hs.window.focusedWindow()
    local letter_size = conf.textSize

    if not window then
        return
    end

    local frame = window:frame()

    if not canvas then
        create_canvas(frame)
    end

    if not canvas then
        return
    end

    -- Display sub grid
    if jump_key then
        local position = get_position(jump_key)

        if not position then
            return
        end

        frame = get_subgrid_frame(frame, position)

        letter_size = curr_text_size / 3

        -- Do not create a grid that would require text smaller than the minimum
        if letter_size < conf.minTextSize then
            letter_size = conf.minTextSize
        end
    end

    canvas:frame(frame)

    set_visual_size(letter_size)

    canvas:show(0)

    M.isDisplayed = true
end


-- Hide the jump grid letters.
--
-- State changes:
--   M.isDisplayed
--------------------------------------------------------------------------------
function M.hide()
    if canvas and M.isDisplayed then
        canvas:hide(0)

        M.isDisplayed = false
    end
end

return M
