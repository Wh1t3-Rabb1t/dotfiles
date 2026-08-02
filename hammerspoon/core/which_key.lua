local M = {}

local state = require('state')
local cache = require('cache')
local util = require('util')
local splits = require('splits')
local menu = require('menu')


-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    local existing_win = hs.window.focusedWindow()

    local wf
    wf = hs.window.filter.new(app)

    wf:subscribe(hs.window.filter.windowFocused, function(win)
        wf:unsubscribeAll()
        wf = nil

        if existing_win and win:id() == existing_win:id() then
            return
        end

        menu.hide(existing_win)

        splits.snap(
            win, splits.get_layout(existing_win, win)
        )

        menu.show(win)
    end)

    hs.application.launchOrFocus(app)
end


-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap_splits()
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local layout = state.screens[id].layout
    local left_slot = layout.left
    local right_slot = layout.right

    layout.left = right_slot
    layout.right = left_slot

    menu.hide(win)

    splits.snap(win, 'split')

    menu.show(win)
end


-- Re-align window divider
--------------------------------------------------------------------------------
function M.resize_splits(direction, step)
    step = step or 0.01

    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local curr_screen = state.screens[id]
    local divider = curr_screen.divider
    local layout = curr_screen.layout

    if direction == 'left' then
        divider = divider - step
    elseif direction == 'right' then
        divider = divider + step
    end

    local num = math.min(0.80, math.max(0.20, divider))
    curr_screen.divider = (num * 100) / 100

    if layout.maximized then
        if direction == 'left' then
            if layout.right == win then
                layout.right = layout.left
            end

            layout.left = win
        elseif direction == 'right' then
            if layout.left == win then
                layout.left = layout.right
            end

            layout.right = win
        end

        layout.maximized = false
    end

    splits.snap(win, 'split')
end


-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize_split(win)
    win = win or hs.window.focusedWindow()

    local id = win:screen():id()
    local layout = state.screens[id].layout
    local frame = cache.screens[id].frame

    menu.hide(win)

    layout.maximized = win
    layout.maximized:setFrame(frame)

    menu.show(win)
end


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(mods, key)
    local job = function(done)
        menu.turn_eventtap('off')

        hs.eventtap.keyStroke(mods, key, 0)

        menu.turn_eventtap('on')

        done()
    end

    return job
end


-- Temporarily bind 'enter' to relaunch menu, 'escape' to cancel auto relaunch
--------------------------------------------------------------------------------
function M.temporary_insert()
    local job = function(done)
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

        local pos = {
            x = frame.x + 10,
            y = frame.y + 10,
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

        done()
    end

    return job
end


-- Cycle menu corner positions
--------------------------------------------------------------------------------
function M.cycle_menu_pos(win)
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

    menu.hide(win)
    menu.show(win, new_corner)
end


-- Cycle menu layout (vertical/horizontal stacking)
--------------------------------------------------------------------------------
function M.cycle_menu_layout(win)
    win = win or state.menu.active_win

    local layout = state.menu.stack
    local new_layout = (layout == 'vertical') and 'horizontal' or 'vertical'

    -- Update state
    state.menu.stack = new_layout

    menu.hide(win)
    menu.show(win, state.menu.corner, new_layout)
end


-- Set menu opacity
--------------------------------------------------------------------------------
function M.menu_opacity(direction, win)
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


-- Focus searchbar (Brave Browser)
--------------------------------------------------------------------------------
function M.focus_brave_searchbar()
    util.queue(
        M.send_keys({'cmd'}, 'l'),
        M.close_menu(),
        M.temporary_insert()
    )
end


-- Search tabs (Brave Browser)
--------------------------------------------------------------------------------
function M.search_brave_tabs()
    util.queue(
        M.send_keys({'cmd', 'shift'}, 'a'),
        M.close_menu(),
        M.temporary_insert()
    )
end


-- Search text (Brave Browser)
--------------------------------------------------------------------------------
function M.search_brave_text()
    util.queue(
        M.send_keys({'cmd'}, 'f'),
        M.close_menu(),
        M.temporary_insert()
    )
end


-- Close menu
--------------------------------------------------------------------------------
function M.close_menu(win)
    local job = function (done)
        menu.turn_eventtap('off')
        menu.hide(win)

        done()
    end

    return job
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    menu.turn_eventtap('on')
    menu.show(hs.window.focusedWindow())
end

return M
