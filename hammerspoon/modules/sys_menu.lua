local M = {}

local state = require('state')
local cache = require('cache')


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
function M.close_menu()
    local win = state.menu.active_win
    local app_name = win:application():name()

    if cache.assets[app_name] then
        cache.assets[app_name].popup:delete()
        state.menu.active_win = false
    end

    state.menu.tap_active = false
    cache.assets.system.popup:delete()
    cache.assets.tap:stop()
end


-- Calculate popup coords
--------------------------------------------------------------------------------
function M.calc_popup_coords(win)
    local app_frame = win:frame()
    local app_name = win:application():name()
    local popup_frame = cache.assets[app_name].frame

    return {
        app = {
            x = app_frame.x + 50,
            y = app_frame.y + 50,
        },
        system = {
            x = app_frame.x + 50,
            y = app_frame.y + (popup_frame.h + 75),
        }
    }
end


-- Show popups
--------------------------------------------------------------------------------
function M.show_popups(win)
    local app_name = win:application():name()

    if cache.assets[app_name] then
        local coords = M.calc_popup_coords(win)

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




-- local app_name = win:application():name()
-- if cache.assets[app_name] then
--     local coords = M.calc_popup_coords(win)
--
--     cache.assets[app_name].popup:topLeft(coords.app)
--     cache.assets[app_name].popup:show(0.15)
--     cache.assets.system.popup:topLeft(coords.system)
--     cache.assets.system.popup:show(0.15)
--
--     state.menu.active_win = win
-- else
--     local frame = win:frame() or hs.mainScreen:fullFrame()
--
--     cache.assets.system.popup:topLeft({
--         x = frame.x + 50,
--         y = frame.y + 50,
--     })
--     cache.assets.system.popup:show(0.15)
-- end



-- local app = hs.application.frontmostApplication():name()
-- asset.brave_browser:topLeft(M.calc_popup_coords(app))
-- asset.system:topLeft({ x = 1200, y = 300 })





-- TODO: needs heavy work
--
-- NOTE: could incorporate splits logic here to determine which windows
--       occupy which coords.
--
-- Get focused screen frame
-- local screen = hs.mouse.getCurrentScreen() or hs.screen.primaryScreen()
-- local frame = screen:fullFrame()
-- x = (frame.w / 2),
-- y = (frame.h / 2),
