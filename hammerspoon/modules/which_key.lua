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


-- Calculate popup coordinates relative to the focused window
--------------------------------------------------------------------------------
function M.get_popup_coords(win)
    local app_frame = win:frame()
    local app_name = win:application():name()
    local popup_frame = cache.assets[app_name].frame

    local coords = {
        app = {
            x = app_frame.x + 50,
            y = app_frame.y + 50,
        },
        system = {
            x = app_frame.x + 50,
            y = app_frame.y + (popup_frame.h + 75),
        }
    }

    return coords
end


-- Show popups
--------------------------------------------------------------------------------
function M.show_popups(win)
    local app_name = win:application():name()

    if cache.assets[app_name] then
        local coords = M.get_popup_coords(win)

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
