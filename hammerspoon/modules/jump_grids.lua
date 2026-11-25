
local state = require('state')
local conf  = require('config').grid

local M = {
    isDisplayed = false,
}

-- Position coords
local positions = {
    { key = conf.topLeft,      x = 1 / 6, y = 1 / 6 },  -- Top left
    { key = conf.topCenter,    x = 1 / 2, y = 1 / 6 },  -- Top center
    { key = conf.topRight,     x = 5 / 6, y = 1 / 6 },  -- Top right
    { key = conf.centerLeft,   x = 1 / 6, y = 1 / 2 },  -- Center left
    { key = conf.center,       x = 1 / 2, y = 1 / 2 },  -- Center center
    { key = conf.centerRight,  x = 5 / 6, y = 1 / 2 },  -- Center right
    { key = conf.bottomLeft,   x = 1 / 6, y = 5 / 6 },  -- Bottom left
    { key = conf.bottomCenter, x = 1 / 2, y = 5 / 6 },  -- Bottom center
    { key = conf.bottomRight,  x = 5 / 6, y = 5 / 6 },  -- Bottom right
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


-- Update letter geometry and corresponding ring radius.
--
-- Parameters:
--   text_size (number):  Desired font size
--   frame     (table):   Current canvas frame
--
-- State changes:
--   Updates canvas textSize, text frames and circle radii.
--------------------------------------------------------------------------------
local function set_visual_size(text_size, frame)
    local scale         = text_size / conf.textSize
    local text_box_size = conf.textBoxSize * scale

    for _, element in ipairs(letter_elements) do
        local position = element.position

        canvas[element.index].textSize = text_size

        canvas[element.index].frame = {
            x = position.x * frame.w - text_box_size / 2,
            y = position.y * frame.h - text_box_size / 2 + conf.textOffsetY * scale,
            w = text_box_size,
            h = text_box_size,
        }
    end

    for _, element in ipairs(ring_elements) do
        canvas[element].radius = conf.ringRadius * scale
    end
end


-- Add an element to the canvas table.
--
-- Parameters:
--   element (table):  hs.canvas compatible config tables
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
                type        = 'circle',
                action      = 'stroke',
                radius      = conf.ringRadius,
                strokeWidth = conf.ringStroke,
                strokeColor = conf.ringColor,
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
            type          = 'text',
            textAlignment = 'center',
            text          = position.key,
            textSize      = conf.textSize,
            textFont      = conf.font,
            textColor     = { white = 1 },
            frame = {
                x = position.x * win_frame.w - conf.textBoxSize / 2,
                y = position.y * win_frame.h - conf.textBoxSize / 2 + conf.textOffsetY,
                w = conf.textBoxSize,
                h = conf.textBoxSize,
            }
        })

        letter_elements[#letter_elements + 1] = {
            index    = idx,
            position = position,
        }
    end

    return canvas
end


-- Show the jump grid.
--
-- Parameters:
--   jump_key (string):  If passed display the sub grid associated with this key
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
    return function(done)
        done = done or function() end

        local window = state.windows.curr_win or hs.window.focusedWindow()

        if not window then
            return
        end

        local window_frame = window:frame()

        if not canvas then
            create_canvas(window_frame)
        end

        if not canvas then
            return
        end

        local frame       = window_frame
        local letter_size = conf.textSize

        if jump_key then
            local position = get_position(jump_key)

            if not position then
                return
            end

            frame = get_subgrid_frame(window_frame, position)

            letter_size = math.max(
                conf.textSize / 3,
                conf.minTextSize
            )
        end

        canvas:frame(frame)

        set_visual_size(letter_size, frame)

        canvas:show(0)

        M.isDisplayed = true

        done()
    end
end


-- Hide the jump grid.
--
-- State changes:
--   M.isDisplayed
--------------------------------------------------------------------------------
function M.hide()
    return function(done)
        done = done or function() end

        if canvas and M.isDisplayed then
            canvas:hide(0)

            M.isDisplayed = false
        end

        done()
    end
end

return M
