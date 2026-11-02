local M = {}

local util = require('util')


-- Configuration.
--------------------------------------------------------------------------------
local START_RADIUS   = 14
local END_RADIUS     = 44
local STROKE_WIDTH   = 3
local DURATION       = 0.5
local FRAME_INTERVAL = 1 / 60

local COLOR = {
    red   = 0.2,
    green = 0.8,
    blue  = 1,
    alpha = 1,
}

local PADDING     = STROKE_WIDTH + 2
local HALF_SIZE   = END_RADIUS + PADDING
local CANVAS_SIZE = HALF_SIZE * 2


-- State.
--------------------------------------------------------------------------------
local is_pressed = false
local mouse_circle
local animation_timer


-- Move the mouse indicator.
--
-- Parameters:
--   point (table):  Mouse position containing x and y coordinates
--
-- State changes:
--   mouse_circle
--------------------------------------------------------------------------------
local function move_circle(point)
    if not mouse_circle then
        return
    end

    mouse_circle:frame({
        x = point.x - HALF_SIZE,
        y = point.y - HALF_SIZE,
        w = CANVAS_SIZE,
        h = CANVAS_SIZE,
    })
end


-- Mouse down.
--
-- Notes:
--   Creates the mouse indicator canvas on its first invocation and reuses it
--   for subsequent clicks.
--   Cancels any previously running release animation.
--   The indicator is positioned at the current mouse location.
--
-- State changes:
--   is_pressed
--   animation_timer
--   mouse_circle
--------------------------------------------------------------------------------
function M.press()
    -- Cancel an animation left over from the previous click
    if animation_timer then
        animation_timer:stop()
        animation_timer = nil
    end

    is_pressed = true

    local mouse = hs.mouse.absolutePosition()

    if not mouse_circle then
        -- Create the canvas once; reuse it for subsequent clicks
        mouse_circle = hs.canvas.new({
            x = mouse.x - HALF_SIZE,
            y = mouse.y - HALF_SIZE,
            w = CANVAS_SIZE,
            h = CANVAS_SIZE,
        })

        mouse_circle:clickActivating(false)
        mouse_circle:level("floating")

        mouse_circle[1] = {
            type        = 'circle',
            action      = 'stroke',
            center      = { x = '50%', y = '50%' },
            radius      = START_RADIUS,
            strokeWidth = STROKE_WIDTH,
            strokeColor = COLOR,
        }
    else
        -- Move the existing canvas to the new click position
        mouse_circle:frame({
            x = mouse.x - HALF_SIZE,
            y = mouse.y - HALF_SIZE,
            w = CANVAS_SIZE,
            h = CANVAS_SIZE,
        })

        -- Reset the previous animation's final state
        mouse_circle[1].radius            = START_RADIUS
        mouse_circle[1].strokeColor.alpha = 1
    end

    mouse_circle:show()
    mouse_circle:bringToFront()
end


-- Mouse drag.
--
-- Parameters:
--   point (table):
--     Mouse position containing x and y coordinates.
--
-- Calls:
--   move_circle()
--------------------------------------------------------------------------------
function M.drag(point)
    if not is_pressed or not mouse_circle or not mouse_circle:isVisible() then
        return
    end

    move_circle(point)
end


-- Mouse up.
--
-- Notes:
--   Ignores mouse-up events that do not correspond to an active press.
--   Starts an animation that expands and fades the mouse indicator.
--   Hides the indicator when the animation completes.
--
-- Parameters:
--   point (table | nil):  Optional final mouse x and y coordinates
--
-- Calls:
--   move_circle()
--
-- State changes:
--   is_pressed
--   animation_timer
--   mouse_circle
--------------------------------------------------------------------------------
function M.release(point)
    -- Ignore stray mouse-up events or presses without a visible starting
    -- circle. Also prevents repeated mouse-up events restarting the animation.
    if not is_pressed then
        return
    end

    -- Capture the final position before starting the animation
    if point then
        move_circle(point)
    end

    is_pressed = false

    if not mouse_circle or not mouse_circle:isVisible() then
        return
    end

    local started_at = hs.timer.secondsSinceEpoch()
    local timer

    timer = hs.timer.doEvery(FRAME_INTERVAL, function()
        -- A newer press may have cancelled this timer
        if animation_timer ~= timer then
            timer:stop()
            return
        end

        local elapsed  = hs.timer.secondsSinceEpoch() - started_at
        local progress = math.min(elapsed / DURATION, 1)

        -- Expand the circle while linearly fading its stroke
        mouse_circle[1].radius =
            START_RADIUS + (END_RADIUS - START_RADIUS) * progress

        mouse_circle[1].strokeColor.alpha = 1 - progress

        if progress >= 1 then
            timer:stop()
            animation_timer = nil
            mouse_circle:hide()
        end
    end)

    animation_timer = timer
end


-- add acceleration to the scrolling fn. we may need to add a state variable
-- etc to track the

-- Send a scroll event at the current mouse location.
--
-- Parameters:
--   direction (string):  'up' or 'down'
--
-- Calls:
--   util.toggle_tap()
--------------------------------------------------------------------------------
function M.scroll(direction)
    return function(done)
        done = done or function() end

        assert(
            direction == 'up' or direction == 'down',
            "direction must be 'up' or 'down'"
        )

        local delta = direction == 'up' and 1 or -1

        util.toggle_tap('off')

        hs.eventtap.scrollWheel({0, delta}, {}, 'line')

        util.toggle_tap('on')

        done()
    end
end

return M
