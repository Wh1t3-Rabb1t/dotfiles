local M = {}

local state = require("state")

local alert_fmt = {
    strokeWidth  = 5,
    textFont = 'Optima-BoldItalic',
    textSize  = 24,
    atScreenEdge = 1,  -- (1) Align to the top
    fadeOutDuration = 1,
}

local function init_overlay(screen, id)
    local overlay = hs.canvas.new(screen:fullFrame())

    overlay:appendElements({
        type = 'rectangle',
        action = 'fill',
        fillColor = {
            red = 0,
            green = 0,
            blue = 0,
            alpha = 0,
        },
    })

    overlay:level(hs.canvas.windowLevels.overlay)
    overlay:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    overlay:show()

    -- Init state module
    state.brightness[id] = 100
    state.overlays[id] = overlay
end

-- Adjust brightness (shader opacity values)
--------------------------------------------------------------------------------
function M.adjust_brightness(direction)
    local screen = hs.mouse.getCurrentScreen()
    local id = screen:getUUID()

    -- Init overlay it doesn't exist
    if not state.overlays[id] then
        init_overlay(screen, id)
    end

    local step = 5
    local brightness = state.brightness[id]

    if direction == 'up' then
        brightness = math.min(brightness + step, 100)
    elseif direction == 'down' then
        brightness = math.max(brightness - step, 5)
    end

    -- Update state module
    state.brightness[id] = brightness
    state.overlays[id][1].fillColor.alpha = 1 - brightness / 100

    -- Display brightness value as popup
    hs.alert.show("Brightness: " .. brightness,
        alert_fmt,  -- Format table
        screen,     -- Target screen
        0.25        -- Alert duration (not including fade-out)
    )
end

-- Print brightness values on each connected screen
--------------------------------------------------------------------------------
function M.print_brightness_values()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:getUUID()
        local brightness = state.brightness[id] or 100

        -- Display brightness value as popup
        hs.alert.show("Brightness: " .. brightness,
            alert_fmt,
            screen,
            0.5
        )
    end
end

return M
