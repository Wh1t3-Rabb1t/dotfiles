local M = {}

local state = require('state')
local cache = require('cache')


-- Get menus x and y coords
--------------------------------------------------------------------------------
local function get_x_y(menus, spacing, layout)
    local x = 0
    local y = 0

    local coords = {}

    for i, menu in ipairs(menus) do
        if layout == 'horizontal' then
            coords[i] = {
                x = x,
                y = 0,
            }

            x = x + menu.frame.w + spacing
        elseif layout == 'vertical' then
            coords[i] = {
                x = 0,
                y = y,
            }

            y = y + menu.frame.h + spacing
        end
    end

    return coords
end


-- Get the current menus width and height
--------------------------------------------------------------------------------
local function get_w_h(menus, spacing, layout)
    local width = 0
    local height = 0

    for i, menu in ipairs(menus) do
        if layout == 'vertical' then
            width = math.max(width, menu.frame.w)
            height = height + menu.frame.h

            if i < #menus then
                height = height + spacing
            end
        elseif layout == 'horizontal' then
            width = width + menu.frame.w
            height = math.max(height, menu.frame.h)

            if i < #menus then
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


-- Get menu anchor position
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


-- Get currently displayed menus
--------------------------------------------------------------------------------
local function get_current(win)
    local app_name = win:application():name()

    local menus = {}

    -- App specific menu (if supported)
    if cache.assets[app_name] then
        table.insert(menus, cache.assets[app_name])
    end

    -- System menu
    table.insert(menus, cache.assets.system)

    return menus
end


-- Calculate menu coordinates relative to the focused window
--------------------------------------------------------------------------------
local function get_coords(win, menus, corner, layout)
    local app_frame = win:frame()
    local id = win:screen():id()
    local screen_frame = cache.screens[id].frame

    local spacing = 25

    local coords = {}
    local dimensions = {}

    dimensions = get_w_h(menus, spacing, layout)

    -- Arrange menus side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = get_w_h(menus, spacing, 'horizontal')
        coords = get_x_y(menus, spacing, 'horizontal')
    else
        coords = get_x_y(menus, spacing, layout)
    end

    local anchor = get_anchor(app_frame, dimensions.w, dimensions.h, corner)

    for _, coord in ipairs(coords) do
        coord.x = coord.x + anchor.x
        coord.y = coord.y + anchor.y
    end

    return coords
end


-- Show menus
--------------------------------------------------------------------------------
function M.show(win, corner, layout)
    corner = corner or state.menu.corner
    layout = layout or state.menu.stack

    local menus = get_current(win)
    local coords = get_coords(win, menus, corner, layout)
    local opacity = state.menu.opacity

    for i, v in ipairs(menus) do
        v.popup:topLeft(coords[i])
        v.popup:alpha(opacity)
        v.popup:show(0.15)
    end

    -- Update state
    state.menu.active_win = win
end


-- Hide menus
--------------------------------------------------------------------------------
function M.hide(win)
    win = win or state.menu.active_win

    local app_name = win:application():name()

    if cache.assets[app_name] then
        cache.assets[app_name].popup:delete()
        state.menu.active_win = false
    end

    cache.assets.system.popup:delete()
end


-- Toggle event tap
--------------------------------------------------------------------------------
function M.turn_eventtap(set_to)
    if set_to == 'on' then
        state.menu.tap_active = true
        cache.assets.tap:start()
    elseif set_to == 'off' then
        state.menu.tap_active = false
        cache.assets.tap:stop()
    end
end

return M
