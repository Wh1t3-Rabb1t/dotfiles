local M = {}

local state = require('state')
local cache = require('cache')
local windows = require('windows')


-- Show popups
--------------------------------------------------------------------------------
function M.show_popups(win)
    local app_name = win:application():name()

    if cache.assets[app_name] then
        local coords = windows.calc_popup_coords(win)

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
end


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(key, mod)
    state.menu.ignore_until = hs.timer.secondsSinceEpoch() + 0.05

    local modifiers = mod or {}

    if type(modifiers) == 'string' then
        modifiers = { modifiers }
    end

    hs.timer.doAfter(0, function()
        hs.eventtap.keyStroke(modifiers, key, 0)
    end)
end


-- Close menu
--------------------------------------------------------------------------------
function M.close_menu(win)
    win = win or state.menu.active_win

    local app_name = win:application():name()

    if cache.assets[app_name] then
        cache.assets[app_name].popup:delete()
        state.menu.active_win = false
    end

    state.menu.tap_active = false
    cache.assets.system.popup:delete()
    cache.assets.tap:stop()
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if state.menu.tap_active then
        return
    end

    local win = hs.window.focusedWindow()

    M.show_popups(win)

    state.menu.active_win = win
    state.menu.tap_active = true
    cache.assets.tap:start()
end

return M
