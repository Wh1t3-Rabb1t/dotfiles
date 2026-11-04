local M = {}

local state = require('state')
local conf  = require('config')
local util  = require('util')


-- Local state.
--------------------------------------------------------------------------------
local watchers = {
    initialized = false,
    screen      = {},
}


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
-- Adjust brightness (shader opacity values).
--
-- Parameters:
--   direction (string):  'up' or 'down'
--
-- State changes:
--   state.screens[id].brightness
--   state.screens[id].overlay
--------------------------------------------------------------------------------
function M.brightness(direction)
    assert(
        direction == 'up' or direction == 'down',
        "direction must be 'up' or 'down'"
    )

    return function(done)
        done = done or function() end

        local screen     = hs.mouse.getCurrentScreen()
        local id         = screen:id()
        local brightness = state.screens[id].brightness
        local step       = 5

        if direction == 'up' then
            brightness = math.min(brightness + step, 100)
        elseif direction == 'down' then
            brightness = math.max(brightness - step, 5)
        end

        state.screens[id].brightness                 = brightness
        state.screens[id].overlay[1].fillColor.alpha = 1 - brightness / 100

        local shader = state.screens[id].overlay

        if not shader:isShowing() then
            shader:show()
        end

        hs.alert.show('Brightness: ' .. brightness,
            conf.alert_fmt,
            screen,
            0.25
        )

        done()
    end
end


--------------------------------------------------------------------------------
-- Print brightness values on each connected screen.
--------------------------------------------------------------------------------
function M.print_brightness()
    return function(done)
        done = done or function() end

        for _, screen in ipairs(hs.screen.allScreens()) do
            local brightness = state.screens[screen:id()].brightness or 100

            hs.alert.show('Brightness: ' .. brightness,
                conf.alert_fmt,
                screen,
                0.5
            )
        end

        done()
    end
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
--   watchers.initialized
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

    if not watchers.initialized then
        watchers.screen = create_watcher()
        watchers.screen:start()

        watchers.initialized = true
    end
end

return M
