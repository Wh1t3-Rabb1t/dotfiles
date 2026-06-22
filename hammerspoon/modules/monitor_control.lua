local M = {}

local state = require("state")

local function init_overlay(curr_scr, id)
    local overlay = hs.canvas.new(curr_scr:fullFrame())

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

function M.adjust_brightness(direction)
    local curr_scr = hs.mouse.getCurrentScreen()
    local id = curr_scr:getUUID()

    -- Init overlay it doesn't exist
    if not state.overlays[id] then
        init_overlay(curr_scr, id)
    end

    local step = 10
    local brightness = state.brightness[id]

    if direction == 'up' then
        brightness = math.min(brightness + step, 100)
    elseif direction == 'down' then
        brightness = math.max(brightness - step, 10)
    end

    -- Update state module
    state.brightness[id] = brightness
    state.overlays[id][1].fillColor.alpha = 1 - brightness / 100
end

return M
