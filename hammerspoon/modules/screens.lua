-- local M = {}
--
-- local state = require('state')
-- local util  = require('util')
--
-- -- function screen_watcher(screen)
-- --     if not screen then
-- --         return
-- --     end
-- --
-- --     -- need the appropriate screen watcher
-- --     local watcher = app:newWatcher(function(element, event)
-- --         -- need the appropriate screen event
-- --         if event == 'AXFocusedWindowChanged' then
-- --             for _, screen in ipairs(hs.screen.allScreens()) do
-- --                 print('state invalid')
-- --             end
-- --         end
-- --     end)
-- --
-- --     watcher:start({
-- --         -- need the appropriate screen event
-- --         hs.uielement.watcher.focusedWindowChanged,
-- --     })
-- --
-- --     return watcher
-- -- end
--
-- function screen_watcher()
--     local watcher = hs.screen.watcher.new(function()
--         -- print("Screen configuration changed")
--
--         local screen_tbl = {}
--         screen_tbl[screen:id()] = true
--
--         for i, _ in pairs(state.screen_config) do
--             -- if 'i' is not present in the curr_screens table then remove the entry from
--             -- screen_config
--         end
--
--         -- for _, screen in ipairs(hs.screen.allScreens()) do
--         -- end
--
--
--             -- if not screen_config[screen:id()] then
--             -- end
--
--
--         -- Rebuild runtime screen state here.
--         -- Preserve M.screen_config.
--     end)
--
--     watcher:start()
--
--     return watcher
-- end
--
--
-- -- Create overlay
-- --------------------------------------------------------------------------------
-- local function create_overlay(screen)
--     local frame   = screen:fullFrame()
--     local overlay = hs.canvas.new(frame)
--
--     overlay:appendElements({
--         type   = 'rectangle',
--         action = 'fill',
--         fillColor = {
--             red   = 0,
--             green = 0,
--             blue  = 0,
--             alpha = 0,
--         }
--     })
--
--     overlay:level(hs.canvas.windowLevels.overlay)
--     overlay:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
--
--     return overlay
-- end
--
--
-- -- Calculate the available screen (total screen frame minus the dock)
-- --------------------------------------------------------------------------------
-- local function get_usable_frame(screen)
--     local full   = screen:fullFrame()
--     local usable = screen:frame()
--
--     return {
--         x = full.x,
--         y = usable.y,
--         w = full.w,
--         h = full.h - (usable.y - full.y),
--     }
-- end
--
--
-- -- Init data for all connected screens
-- --------------------------------------------------------------------------------
-- local function get_screen_data(screen)
--     return {
--         frame   = get_usable_frame(screen),
--         overlay = create_overlay(screen),
--         layout = {
--             maximized = false,
--             left      = false,
--             right     = false,
--         }
--     }
-- end
--
--
-- --------------------------------------------------------------------------------
-- -- Init
-- --------------------------------------------------------------------------------
-- function M.init()
--     for _, screen in ipairs(hs.screen.allScreens()) do
--         local id   = screen:id()
--         local data = get_screen_data(screen)
--
--         if data then
--             state.screens[id] = data
--
--             if not util.tbl(state.screen_config[id]) then
--                 state.screen_config[id] = {
--                     brightness = 100,
--                     divider    = 0.35,
--                 }
--             end
--         end
--     end
-- end
--
-- return M



local M = {}

local state = require('state')


-- Create overlay
--------------------------------------------------------------------------------
local function create_overlay(screen)
    local frame   = screen:fullFrame()
    local overlay = hs.canvas.new(frame)

    overlay:appendElements({
        type   = 'rectangle',
        action = 'fill',
        fillColor = {
            red   = 0,
            green = 0,
            blue  = 0,
            alpha = 0,
        }
    })

    overlay:level(hs.canvas.windowLevels.overlay)
    overlay:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

    return overlay
end


-- Calculate the available screen (total screen frame minus the dock)
--------------------------------------------------------------------------------
local function get_usable_frame(screen)
    local full   = screen:fullFrame()
    local usable = screen:frame()

    local frame = {
        x = full.x,
        y = usable.y,
        w = full.w,
        h = full.h - (usable.y - full.y),
    }

    return frame
end


-- Init data for all connected screens
--------------------------------------------------------------------------------
local function get_screen_data(screen)
    local data = {
        frame      = get_usable_frame(screen),
        overlay    = create_overlay(screen),
        brightness = 100,
        divider    = 0.35,
        layout = {
            maximized = false,
            left      = false,
            right     = false,
        }
    }

    return data
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id   = screen:id()
        local data = get_screen_data(screen)

        if data then
            state.screens[id] = data
        end
    end
end

return M
