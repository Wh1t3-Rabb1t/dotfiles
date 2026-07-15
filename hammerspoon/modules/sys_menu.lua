local M = {}

local state = require('state')
local cache = require('cache')
local menu = state.menu
local assets = cache.assets


-- Send keystrokes (while bypassing active eventtap)
--------------------------------------------------------------------------------
function M.send_keys(key, mod)
    menu.ignore_until = hs.timer.secondsSinceEpoch() + 0.05

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
    local win = hs.window.focusedWindow()
    local app_name = win:application():name()

    if cache.assets[app_name] then
        assets[app_name]:delete()
    end

    menu.tap_active = false
    assets.system:delete()
    assets.tap:stop()
end


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if menu.tap_active then
        return
    end

    local win = hs.window.focusedWindow()
    local app_name = win:application():name()

    if cache.assets[app_name] then

        -- if active_window then
        -- local coords = M.calc_popup_coords(win)
        -- assets[active_window]:topLeft(M.calc_popup_coords(win))

        assets[app_name]:show(0.15)
        menu.active_win = win
    end

    menu.tap_active = true
    assets.system:show(0.15)
    assets.tap:start()
end

return M


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


-- -- TODO: needs heavy work
-- --
-- -- Calculate popup coords
-- --------------------------------------------------------------------------------
-- function M.calc_popup_coords(win)
--     local id = win:screen():id()
--
--     local curr_screen = state.screens[id]
--     local fullscreen = curr_screen.layout.maximized
--
--     if fullscreen then
--         -- put the app popup on the left/sytem on the right
--         local frame = cache.screens[id].frame
--     else
--        -- slot layout: put the apps popup within its window, put the system
--        -- popup in the adjacent window.
--     end
--
--     local coords = {}
--
--     if app == 'Brave Browser' then
--         coords.x = frame.x
--         coords.y = frame.y
--     else
--         coords.x = 300
--         coords.y = 400
--     end
--
--     return coords
-- end
