local M = {}

local brightness = 100
local overlay

function M.adjust_brightness(direction)
    local step = 5

    if direction == 'up' then
        brightness = math.min(brightness + step, 100)
    elseif direction == 'down' then
        brightness = math.max(brightness - step, 0)
    end

    overlay[1].fillColor.alpha = 1 - brightness / 100
end

function M.init_overlay()
    if not overlay then
        overlay = hs.canvas.new(hs.screen.mainScreen():fullFrame())

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
    end
end

return M
