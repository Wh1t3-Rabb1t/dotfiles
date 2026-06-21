local M = {}

local brightness = 100
local overlay

local function update_overlay()
    if not overlay then
        overlay = hs.canvas.new(hs.screen.mainScreen():fullFrame())

        overlay:appendElements({
            type = "rectangle",
            action = "fill",
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

    overlay[1].fillColor.alpha = 1 - brightness / 100
end

function M.adjust_brightness(direction)
    local step = 5

    if direction == "up" then
        brightness = math.min(brightness + step, 100)
    elseif direction == "down" then
        brightness = math.max(brightness - step, 0)
    end

    update_overlay()
end

function M.init()
    update_overlay()
end

return M
