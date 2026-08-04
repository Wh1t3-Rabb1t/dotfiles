local M = {}

local state = require('state')
local cache = require('cache')

local alert_fmt = {
    strokeWidth     = 5,
    textFont        = 'Optima-BoldItalic',
    textSize        = 24,
    atScreenEdge    = 1,  -- (1) Align to the top
    fadeOutDuration = 1,
}


-- Adjust brightness (shader opacity values)
--------------------------------------------------------------------------------
function M.adjust(direction)
    return function(done)
        local screen = hs.mouse.getCurrentScreen()
        local id     = screen:id()

        local step       = 5
        local brightness = state.screens[id].brightness

        if direction == 'up' then
            brightness = math.min(brightness + step, 100)
        elseif direction == 'down' then
            brightness = math.max(brightness - step, 5)
        end

        -- Update state/cache
        state.screens[id].brightness = brightness
        cache.screens[id].overlay[1].fillColor.alpha = 1 - brightness / 100

        -- Show the overlay if not already 'visible'
        local shader = cache.screens[id].overlay

        if not shader:isShowing() then
            shader:show()
        end

        -- Display brightness value in popup
        hs.alert.show('Brightness: ' .. brightness,
            alert_fmt,  -- Format table
            screen,     -- Target screen
            0.25        -- Alert duration (not including fade-out)
        )

        done()
    end
end


-- Print brightness values on each connected screen
--------------------------------------------------------------------------------
function M.print_values()
    return function(done)
        for _, screen in ipairs(hs.screen.allScreens()) do
            local id         = screen:id()
            local brightness = state.screens[id].brightness or 100

            -- Display brightness value in popup
            hs.alert.show('Brightness: ' .. brightness,
                alert_fmt,
                screen,
                0.5
            )
        end

        done()
    end
end

return M
