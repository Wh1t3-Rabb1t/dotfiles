local M = {}

local state = require('state')
local cache = require('cache')


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


-- Init data for all connected screens
--------------------------------------------------------------------------------
local function get_screen_data(screen)
    local screen_data = {
        cache = {
            overlay = create_overlay(screen),
            frame   = get_usable_frame(screen),
        },
        state = {
            brightness = 100,
            divider    = 0.35,
            layout = {
                maximized = false,
                left      = false,
                right     = false,
            }
        }
    }

    return screen_data
end


--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function M.init()
    -- Init screen data if required
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id          = screen:id()
        local screen_data = get_screen_data(screen)

        cache.screens[id] = screen_data.cache
        state.screens[id] = screen_data.state
    end
end

return M
