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

    if type(mods) == 'string' then
        mods = { mods }
    end

    state.menu.ignore_until = hs.timer.secondsSinceEpoch() + 0.05

    hs.timer.doAfter(0, function()
        hs.eventtap.keyStroke(mods, key, 0)
    end)
end


-- Get anchor position relative to the focused window
--------------------------------------------------------------------------------
function M.get_anchor(frame, width, height, corner)
    local padding = 50

    if corner == 'top_left' then
        return {
            x = frame.x + padding,
            y = frame.y + padding,
        }
    elseif corner == 'top_right' then
        return {
            x = frame.x + frame.w - width - padding,
            y = frame.y + padding,
        }
    elseif corner == 'bottom_left' then
        return {
            x = frame.x + padding,
            y = frame.y + frame.h - height - padding,
        }
    elseif corner == 'bottom_right' then
        return {
            x = frame.x + frame.w - width - padding,
            y = frame.y + frame.h - height - padding,
        }
    end
end


-- Calculate popup coordinates relative to the focused window
--------------------------------------------------------------------------------
function M.get_popup_coords(win, corner)
    corner = corner or 'top_right'

    local spacing = 25

    local app_frame = win:frame()
    local app_name = win:application():name()

    local app_popup = cache.assets[app_name].frame
    local sys_popup = cache.assets.system.frame

    local width = math.max(app_popup.w, sys_popup.w)
    local height = app_popup.h + spacing + sys_popup.h

    local anchor = M.get_anchor(app_frame, width, height, corner)

    local coords = {
        app = {
            x = anchor.x,
            y = anchor.y,
        },
        system = {
            x = anchor.x,
            y = anchor.y + app_popup.h + spacing,
        },
    }

    return coords
end


-- Show popups
--------------------------------------------------------------------------------
function M.show_popups(win)
    local app_name = win:application():name()

    if cache.assets[app_name] then
        local coords = M.get_popup_coords(win, 'top_right')

        cache.assets[app_name].popup:topLeft(coords.app)
        cache.assets[app_name].popup:show(0.15)
        cache.assets.system.popup:topLeft(coords.system)
        cache.assets.system.popup:show(0.15)
    else
        local frame = win:frame() or hs.mainScreen:fullFrame()

        cache.assets.system.popup:topLeft({
            x = frame.x + 50,
            y = frame.y + 50,
        })
        cache.assets.system.popup:show(0.15)
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
