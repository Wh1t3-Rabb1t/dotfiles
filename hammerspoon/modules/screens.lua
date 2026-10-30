local M = {}

local state = require('state')
local util  = require('util')


-- Create screen watcher.
--
-- Calls:
--   util.tbl()
--
-- State changes:
--   state.screens
--
-- Returns:
--   watcher (fn):  Preserves screen state tables if they already exist
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


-- Create overlay.
--
-- Returns:
--   overlay (table):  An overlay to be used as a shader for the screen
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


-- Calculate the available screen (total screen frame minus the dock).
--
-- Returns:
--   (table):  Frame data for the screen
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


-- Get data for all connected screens.
--
-- Calls:
--   get_usable_frame()
--   create_overlay()
--
-- Returns:
--   (table):  State data for the screen
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
-- Init module.
--
-- Calls:
--   util.tbl()
--   get_screen_data()
--   create_watcher()
--
-- State changes:
--   state.watchers
--   state.screens
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

    if not state.watchers.initialized then
        state.watchers.screen = create_watcher()
        state.watchers.screen:start()

        state.watchers.initialized = true
    end
end

return M
