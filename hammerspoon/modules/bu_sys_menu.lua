local M = {}

local state = require('state')
local cache = require('cache')
local menu = state.menu
local assets = cache.assets


-- Close menu
--------------------------------------------------------------------------------
function M.close_menu()
    menu.tap_active = false
    assets.system:delete()
    assets.brave_browser:delete()
    assets.tap:stop()
end


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


-- Launch menu
--------------------------------------------------------------------------------
function M.launch_menu()
    if menu.tap_active then
        return
    end

    menu.tap_active = true
    assets.tap:start()
    assets.system:show(0.15)
    assets.brave_browser:show(0.15)
end

return M


-- local app = hs.application.frontmostApplication():name()
-- asset.brave_browser:topLeft(M.calc_popup_coords(app))
-- asset.system:topLeft({ x = 1200, y = 300 })



-- -- TODO: needs heavy work
-- --
-- -- Calculate popup coords
-- --------------------------------------------------------------------------------
-- function M.calc_popup_coords(app)
--     local win = hs.window.focusedWindow()
--     local frame = win:frame()
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
