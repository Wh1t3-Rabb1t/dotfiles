local M = {}

local state = require('state')
local cache = require('cache')


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(a, b)
    local mods, key

    if b == nil then
        mods = {}
        key = a
    else
        mods = a or {}
        key = b
    end

    state.menu.ignore_until = hs.timer.secondsSinceEpoch() + 0.05

    hs.timer.doAfter(0, function()
        hs.eventtap.keyStroke(mods, key, 0)
    end)
end


-- Get popups x and y coords
--------------------------------------------------------------------------------
function M.get_x_y(popups, spacing, layout)
    spacing = spacing or 25

    local coords = {}
    local x = 0
    local y = 0

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


-- Get popups width and height
--------------------------------------------------------------------------------
function M.get_w_h(popups, spacing, layout)
    spacing = spacing or 25

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
function M.get_anchor(frame, width, height, corner)
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


-- Calculate popup coordinates relative to the focused window
--------------------------------------------------------------------------------
function M.get_popup_coords(win, popups, corner)
    corner = corner or 'top_right'

    local app_frame = win:frame()
    local id = win:screen():id()
    local screen_frame = cache.screens[id].frame

    local coords
    local dimensions
    local spacing = 25

    dimensions = M.get_w_h(popups, spacing, 'vertical')

    -- Arrange popups side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = M.get_w_h(popups, spacing, 'horizontal')
        coords = M.get_x_y(popups, spacing, 'horizontal')
    else
        coords = M.get_x_y(popups, spacing, 'vertical')
    end

    local anchor = M.get_anchor(app_frame, dimensions.w, dimensions.h, corner)

    for _, coord in ipairs(coords) do
        coord.x = coord.x + anchor.x
        coord.y = coord.y + anchor.y
    end

    return coords
end


-- Show popups
--------------------------------------------------------------------------------
function M.show_popups(win, position)
    position = position or 'bottom_right'

    local app_name = win:application():name()

    local popups = {}

    if cache.assets[app_name] then
        table.insert(popups, cache.assets[app_name])
    end

    table.insert(popups, cache.assets.system)

    local coords = M.get_popup_coords(win, popups, position)

    for i, v in ipairs(popups) do
        v.popup:topLeft(coords[i])
        v.popup:show(0.15)
    end

    state.menu.active_win = win
end


-- Hide popups
--------------------------------------------------------------------------------
function M.hide_popups(win)
    win = win or state.menu.active_win

    local app_name = win:application():name()

    if cache.assets[app_name] then
        cache.assets[app_name].popup:delete()
        state.menu.active_win = false
    end

    cache.assets.system.popup:delete()
end


-- Start event tap
--------------------------------------------------------------------------------
function M.set_event_tap(set_to)
    if set_to == 'on' then
        state.menu.tap_active = true
        cache.assets.tap:start()
    elseif set_to == 'off' then
        state.menu.tap_active = false
        cache.assets.tap:stop()
    end
end


-- Close menu
--------------------------------------------------------------------------------
function M.close_menu(win)
    M.set_event_tap('off')
    M.hide_popups(win)
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    M.set_event_tap('on')
    M.show_popups(hs.window.focusedWindow())
end

return M
