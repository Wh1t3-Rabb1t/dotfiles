local M = {}

local state = require('state')
local cache = require('cache')


-- Get popups x and y coords
--------------------------------------------------------------------------------
local function get_x_y(popups, spacing, layout)
    local x = 0
    local y = 0

    local coords = {}

    for i, popup in ipairs(popups) do
        if layout == 'horizontal' then
            coords[i] = {
                x = x,
                y = 0,
            }

            x = x + popup.frame.w + spacing
        elseif layout == 'vertical' then
            coords[i] = {
                x = 0,
                y = y,
            }

            y = y + popup.frame.h + spacing
        end
    end

    return coords
end


-- Get the current popups width and height
--------------------------------------------------------------------------------
local function get_w_h(popups, spacing, layout)
    local width = 0
    local height = 0

    for i, popup in ipairs(popups) do
        if layout == 'vertical' then
            width = math.max(width, popup.frame.w)
            height = height + popup.frame.h

            if i < #popups then
                height = height + spacing
            end
        elseif layout == 'horizontal' then
            width = width + popup.frame.w
            height = math.max(height, popup.frame.h)

            if i < #popups then
                width = width + spacing
            end
        end
    end

    local dimensions = {
        w = width,
        h = height,
    }

    return dimensions
end


-- Get popup anchor position
--------------------------------------------------------------------------------
local function get_anchor(frame, width, height, corner)
    local padding = 25

    local anchor = {}

    if corner == 'top_left' then
        anchor.x = frame.x + padding
        anchor.y = frame.y + padding
    elseif corner == 'top_right' then
        anchor.x = frame.x + frame.w - width - padding
        anchor.y = frame.y + padding
    elseif corner == 'bottom_left' then
        anchor.x = frame.x + padding
        anchor.y = frame.y + frame.h - height - padding
    elseif corner == 'bottom_right' then
        anchor.x = frame.x + frame.w - width - padding
        anchor.y = frame.y + frame.h - height - padding
    end

    return anchor
end


-- Get currently displayed popups
--------------------------------------------------------------------------------
local function get_current(win)
    local app_name = win:application():name()

    local popups = {}

    -- App specific popup (if supported)
    if cache.assets[app_name] then
        table.insert(popups, cache.assets[app_name])
    end

    -- System popup
    table.insert(popups, cache.assets.system)

    return popups
end


-- Calculate popup coordinates relative to the focused window
--------------------------------------------------------------------------------
local function get_coords(win, popups, corner, layout)
    local app_frame = win:frame()
    local id = win:screen():id()
    local screen_frame = cache.screens[id].frame

    local spacing = 25

    local coords = {}
    local dimensions = {}

    dimensions = get_w_h(popups, spacing, layout)

    -- Arrange popups side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = get_w_h(popups, spacing, 'horizontal')
        coords = get_x_y(popups, spacing, 'horizontal')
    else
        coords = get_x_y(popups, spacing, layout)
    end

    local anchor = get_anchor(app_frame, dimensions.w, dimensions.h, corner)

    for _, coord in ipairs(coords) do
        coord.x = coord.x + anchor.x
        coord.y = coord.y + anchor.y
    end

    return coords
end


-- Cycle menu corner positions
--------------------------------------------------------------------------------
function M.cycle_corner_pos(win)
    win = win or state.menu.active_win

    local job = function(done)
        local corners = {
            'bottom_right',
            'top_right',
            'bottom_left',
            'top_left',
        }

        local current_corner = state.menu.corner
        local current_index = 1

        -- Find the index of the current corner
        for i, c in ipairs(corners) do
            if c == current_corner then
                current_index = i
                break
            end
        end

        -- Calculate the next index, wrapping around using modulo arithmetic
        local new_index = (current_index % #corners) + 1
        local new_corner = corners[new_index]

        -- Update state
        state.menu.corner = new_corner
        state.menu.active_win = win

        done()
    end

    return job
end


-- Cycle menu layout (vertical/horizontal stacking)
--------------------------------------------------------------------------------
function M.cycle_stacking(win)
    win = win or state.menu.active_win

    local job = function(done)
        local layout = state.menu.stack
        local new_layout = (layout == 'vertical') and 'horizontal' or 'vertical'

        -- Update state
        state.menu.stack = new_layout
        state.menu.active_win = win

        done()
    end

    return job
end


-- Set poppup opacity
--------------------------------------------------------------------------------
function M.opacity(direction, win)
    win = win or state.menu.active_win

    local job = function(done)
        local step = 0.1
        local opacity = state.menu.opacity
        local app_name = win:application():name()

        if direction == 'up' then
            opacity = math.min(opacity + step, 1.0)
        elseif direction == 'down' then
            opacity = math.max(opacity - step, 0.1)
        end

        -- Update state
        state.menu.opacity = opacity

        -- App specific popup (if supported)
        if cache.assets[app_name] then
            cache.assets[app_name].popup:alpha(opacity)
        end

        -- System popup
        cache.assets.system.popup:alpha(opacity)

        done()
    end

    return job
end


-- Show popups
--------------------------------------------------------------------------------
function M.show(win, corner, layout)
    corner = corner or state.menu.corner
    layout = layout or state.menu.stack

    local job = function(done)
        local popups = get_current(win)
        local coords = get_coords(win, popups, corner, layout)
        local opacity = state.menu.opacity

        for i, v in ipairs(popups) do
            v.popup:topLeft(coords[i])
            v.popup:alpha(opacity)
            v.popup:show(0.15)
        end

        -- Update state
        state.menu.active_win = win

        done()
    end

    return job
end


-- Hide popups
--------------------------------------------------------------------------------
function M.hide(win)
    win = win or state.menu.active_win

    local job = function(done)
        local app_name = win:application():name()

        if cache.assets[app_name] then
            cache.assets[app_name].popup:delete()
            state.menu.active_win = false
        end

        cache.assets.system.popup:delete()

        done()
    end

    return job
end

return M
