local M = {}

local state = require('state')
local cache = require('cache')


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(a, b)
    local mods
    local key

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


-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch
--------------------------------------------------------------------------------
function M.temporary_insert()
    local win = state.menu.active_win or hs.window.focusedWindow()
    local frame = win:frame()
    local opacity = state.menu.opacity
    local insert_popup = cache.assets.insert.popup

    local function end_insert_mode(hotkeys, popup)
        for _, hk in ipairs(hotkeys) do
            hk:disable()
        end

        popup:hide()
    end

    M.close_menu()

    local pos = {
        x = frame.x + 50,
        y = frame.y + 50,
    }

    insert_popup:topLeft(pos)
    insert_popup:alpha(opacity)
    insert_popup:show(0.15)

    local hotkeys = {}

    hotkeys[1] = hs.hotkey.bind({}, 'return', function()
        end_insert_mode(hotkeys, insert_popup)

        hs.eventtap.keyStroke({}, 'return')
        M.launch_menu()
    end)

    hotkeys[2] = hs.hotkey.bind({}, 'escape', function()
        end_insert_mode(hotkeys, insert_popup)
    end)
end


-- Cycle popup corner positions
--------------------------------------------------------------------------------
function M.cycle_popup_corner(win)
    win = win or state.menu.active_win

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

    M.hide_popups(win)
    M.show_popups(win, new_corner)
end


-- Cycle popup layout (vertical/horizontal stacking)
--------------------------------------------------------------------------------
function M.cycle_popup_layout(win)
    win = win or state.menu.active_win

    local layout = state.menu.stack
    local new_layout = (layout == 'vertical') and 'horizontal' or 'vertical'

    -- Update state
    state.menu.stack = new_layout

    M.hide_popups(win)
    M.show_popups(win, state.menu.corner, new_layout)
end


-- Set popup opacity
--------------------------------------------------------------------------------
function M.popup_opacity(direction, win)
    win = win or state.menu.active_win

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
end


-- Get popups x and y coords
--------------------------------------------------------------------------------
function M.get_x_y(popups, spacing, layout)
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


-- Get popups width and height
--------------------------------------------------------------------------------
function M.get_w_h(popups, spacing, layout)
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
function M.get_popup_coords(win, popups, corner, layout)
    local app_frame = win:frame()
    local id = win:screen():id()
    local screen_frame = cache.screens[id].frame

    local spacing = 25

    local coords = {}
    local dimensions = {}

    dimensions = M.get_w_h(popups, spacing, layout)

    -- Arrange popups side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = M.get_w_h(popups, spacing, 'horizontal')
        coords = M.get_x_y(popups, spacing, 'horizontal')
    else
        coords = M.get_x_y(popups, spacing, layout)
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
function M.show_popups(win, corner, layout)
    corner = corner or state.menu.corner
    layout = layout or state.menu.stack

    local popups = {}

    local app_name = win:application():name()

    -- App specific popup (if supported)
    if cache.assets[app_name] then
        table.insert(popups, cache.assets[app_name])
    end

    -- System popup
    table.insert(popups, cache.assets.system)

    local coords = M.get_popup_coords(win, popups, corner, layout)
    local opacity = state.menu.opacity

    for i, v in ipairs(popups) do
        v.popup:topLeft(coords[i])
        v.popup:alpha(opacity)
        v.popup:show(0.15)
    end

    -- Update state
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
