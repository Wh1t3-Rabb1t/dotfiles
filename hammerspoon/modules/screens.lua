local M = {}

local state = require('state')
local util  = require('util')


-- Create screen watcher
--------------------------------------------------------------------------------
local function create_watcher()
    local watcher = hs.screen.watcher.new(function()
        local screen_data = {}

        for _, screen in ipairs(hs.screen.allScreens()) do
            local id = screen:id()

            if util.tbl(state.screens[id]) then
                screen_data[id] = state.screens[id]
            end
        end

        state.screens = screen_data
    end)

    return watcher
end


-- Create overlay
--------------------------------------------------------------------------------
local function create_overlay(screen)
    local overlay = hs.canvas.new(screen:fullFrame())

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

    return {
        x = full.x,
        y = usable.y,
        w = full.w,
        h = full.h - (usable.y - full.y),
    }
end


-- Init data for all connected screens
--------------------------------------------------------------------------------
local function get_screen_data(screen)
    return {
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
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:id()

        if not util.tbl(state.screens[id]) then
            local data = get_screen_data(screen)

            if data then
                state.screens[id] = data
            end
        end
    end

    if not state.screen_watcher then
        state.screen_watcher = create_watcher()
        state.screen_watcher:start()
    end
end


-- function M.init()
--     for _, screen in ipairs(hs.screen.allScreens()) do
--         local id   = screen:id()
--         local data = get_screen_data(screen)
--
--         if data then
--             state.screens[id] = data
--         end
--     end
-- end

return M
