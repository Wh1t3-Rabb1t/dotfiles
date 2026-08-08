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
    local width  = 0
    local height = 0

    for i, popup in ipairs(popups) do
        if layout == 'vertical' then
            width  = math.max(width, popup.frame.w)
            height = height + popup.frame.h

            if i < #popups then
                height = height + spacing
            end
        elseif layout == 'horizontal' then
            width  = width + popup.frame.w
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
local function get_coords(win, popups, corner, stack)
    local id           = win:screen():id()
    local app_frame    = win:frame()
    local screen_frame = cache.screens[id].frame

    local spacing = 25

    local coords     = {}
    local dimensions = {}

    dimensions = get_w_h(popups, spacing, stack)

    -- Arrange popups side by side if the stack height exceeds the screen height
    if dimensions.h > screen_frame.h then
        dimensions = get_w_h(popups, spacing, 'horizontal')
        coords     = get_x_y(popups, spacing, 'horizontal')
    else
        coords = get_x_y(popups, spacing, stack)
    end

    local anchor = get_anchor(app_frame, dimensions.w, dimensions.h, corner)

    for _, coord in ipairs(coords) do
        coord.x = coord.x + anchor.x
        coord.y = coord.y + anchor.y
    end

    return coords
end


--------------------------------------------------------------------------------
-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(mods, key)
    return function(done)
        state.menu.tap_active = false
        cache.assets.tap:stop()

        hs.eventtap.keyStroke(mods, key, 0)

        state.menu.tap_active = true
        cache.assets.tap:start()

        done()
    end
end


--------------------------------------------------------------------------------
-- Toggle event tap
--------------------------------------------------------------------------------
function M.turn_eventtap(set_to)
    return function (done)
        if set_to == 'on' then
            state.menu.tap_active = true
            cache.assets.tap:start()
        elseif set_to == 'off' then
            state.menu.tap_active = false
            cache.assets.tap:stop()
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle menu corner positions
--------------------------------------------------------------------------------
function M.cycle_corner_pos()
    return function(done)
        local corners = {
            'bottom_right',
            'top_right',
            'bottom_left',
            'top_left',
        }

        local current_corner = state.menu.corner
        local current_index  = 1

        -- Find the index of the current corner
        for i, c in ipairs(corners) do
            if c == current_corner then
                current_index = i
                break
            end
        end

        -- Calculate the next index, wrapping around using modulo arithmetic
        local new_index  = (current_index % #corners) + 1
        local new_corner = corners[new_index]

        -- Update state
        state.menu.corner = new_corner

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle menu layout (vertical/horizontal stacking)
--------------------------------------------------------------------------------
function M.cycle_stacking()
    return function(done)
        local stack     = state.menu.stack
        local new_stack = (stack == 'vertical') and 'horizontal' or 'vertical'

        -- Update state
        state.menu.stack = new_stack

        done()
    end
end


--------------------------------------------------------------------------------
-- Set poppup opacity
--------------------------------------------------------------------------------
function M.menu_opacity(direction, target_win)
    return function(done)
        local win     = target_win or state.menu.curr_win
        local app     = win:application():name()
        local opacity = state.menu.opacity

        local step = 0.1

        if direction == 'up' then
            opacity = math.min(opacity + step, 1.0)
        elseif direction == 'down' then
            opacity = math.max(opacity - step, 0.1)
        end

        -- App specific popup (if supported)
        if cache.assets[app] then
            cache.assets[app].popup:alpha(opacity)
        end

        -- System popup
        cache.assets.system.popup:alpha(opacity)

        -- Update state
        state.menu.opacity = opacity

        done()
    end
end


--------------------------------------------------------------------------------
-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch
--------------------------------------------------------------------------------
function M.temporary_insert()
    return function(done)
        local win     = state.menu.curr_win or hs.window.focusedWindow()
        local frame   = win:frame()
        local opacity = state.menu.opacity
        local popup   = cache.assets.insert.popup

        local function end_insert_mode(hotkeys, active_popup)
            for _, hk in ipairs(hotkeys) do
                hk:disable()
            end

            active_popup:hide()
        end

        local pos = {
            x = frame.x + 10,
            y = frame.y + 10,
        }

        popup:topLeft(pos)
        popup:alpha(opacity)
        popup:show(0.15)

        local hotkeys = {}

        hotkeys[1] = hs.hotkey.bind({}, 'return', function()
            end_insert_mode(hotkeys, popup)

            hs.eventtap.keyStroke({}, 'return')
            M.launch_menu()
        end)

        hotkeys[2] = hs.hotkey.bind({}, 'escape', function()
            end_insert_mode(hotkeys, popup)
        end)

        done()
    end
end


--------------------------------------------------------------------------------
-- Hide popups
--------------------------------------------------------------------------------
function M.hide_menu()
    return function(done)
        local win = state.menu.curr_win or hs.window.focusedWindow()
        local app = win:application():name()

        if cache.assets[app] then
            cache.assets[app].popup:delete()
        end

        cache.assets.system.popup:delete()

        done()
    end
end


--------------------------------------------------------------------------------
-- Show popups
--------------------------------------------------------------------------------
function M.show_menu(target_win, target_corner, target_stack)
    return function(done)
        local win    = target_win    or state.menu.curr_win
        local corner = target_corner or state.menu.corner
        local stack  = target_stack  or state.menu.stack

        local opacity = state.menu.opacity
        local popups  = get_current(win)
        local coords  = get_coords(win, popups, corner, stack)

        for i, v in ipairs(popups) do
            v.popup:topLeft(coords[i])
            v.popup:alpha(opacity)
            v.popup:show(0.15)
        end

        -- Update state with focused window
        state.menu.curr_win = win

        done()
    end
end


--------------------------------------------------------------------------------
-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    state.menu.tap_active = true
    cache.assets.tap:start()

    local init_fn = M.show_menu(hs.window.focusedWindow())

    init_fn(function()
        -- Call done()
    end)
end

return M
