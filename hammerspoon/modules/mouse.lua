local M = {}

local util  = require('util')
local state = require('state')
local cache = require('cache')


-- Configuration.
--------------------------------------------------------------------------------
-- Movement interval/distance
local MOVE_INTERVAL = 0.03
local MOVE_STEP     = 10

-- Scrolling
local SCROLL_ACCELERATION = 0.5
local SCROLL_MAX_SPEED    = 6
local SCROLL_RESET_DELAY  = 0.25

-- Mouse circle
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
local mouse_circle
local movement_timer
local animation_timer

local is_pressed   = false
local move_actions = setmetatable({}, { __mode = 'k' })

local scroll_state = {
    direction   = false,
    delta       = 1,
    last_scroll = 0,
}


-- Move the mouse location.
--------------------------------------------------------------------------------
local function move_mouse()
    local dx, dy = 0, 0

    for _, direction in pairs(state.mouse.active_directions) do
        if direction == 'left' then
            dx = dx - 1
        elseif direction == 'right' then
            dx = dx + 1
        elseif direction == 'up' then
            dy = dy - 1
        elseif direction == 'down' then
            dy = dy + 1
        end
    end

    -- Nothing to move
    if dx == 0 and dy == 0 then
        return
    end

    -- Normalize movement, including diagonals
    local magnitude = math.sqrt(dx * dx + dy * dy)

    dx = dx / magnitude
    dy = dy / magnitude

    local pos = hs.mouse.absolutePosition()

    pos.x = pos.x + dx * MOVE_STEP
    pos.y = pos.y + dy * MOVE_STEP

    hs.mouse.absolutePosition(pos)
end


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


--------------------------------------------------------------------------------
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
        mouse_circle:level('floating')

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


--------------------------------------------------------------------------------
-- Mouse drag.
--
-- Parameters:
--   point (table):  Mouse position containing x and y coordinates
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


--------------------------------------------------------------------------------
-- Mouse up.
--
-- Parameters:
--   point (table | nil):  Optional final mouse x and y coordinates
--
-- Notes:
--   Ignores mouse-up events that do not correspond to an active press.
--   Starts an animation that expands and fades the mouse indicator.
--   Hides the indicator when the animation completes.
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
    if not is_pressed then
        return
    end

    if point then
        move_circle(point)
    end

    is_pressed = false

    if not mouse_circle then
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


--------------------------------------------------------------------------------
-- Send an accelerated scroll event at the current mouse location.
--
-- Parameters:
--   direction (string):  'up' or 'down'
--
-- Notes:
--   Acceleration is driven by repeated keyDown invocations.
--   Changing direction resets acceleration.
--   Inactivity resets acceleration after SCROLL_RESET_DELAY seconds.
--
-- Calls:
--   util.toggle_tap()
--
-- State changes:
--   scroll_state.direction
--   scroll_state.delta
--   scroll_state.last_scroll
--------------------------------------------------------------------------------
function M.scroll(direction)
    assert(
        direction == 'up' or direction == 'down',
        "direction must be 'up' or 'down'"
    )

    return function(done)
        done = done or function() end

        local now = hs.timer.secondsSinceEpoch()

        -- Reset acceleration after inactivity or direction change
        if scroll_state.direction ~= direction
        or now - scroll_state.last_scroll > SCROLL_RESET_DELAY then
            scroll_state.delta = 1
        else
            scroll_state.delta = math.min(
                scroll_state.delta + SCROLL_ACCELERATION,
                SCROLL_MAX_SPEED
            )
        end

        scroll_state.direction   = direction
        scroll_state.last_scroll = now

        local delta = direction == 'up'
            and scroll_state.delta
            or - scroll_state.delta

        hs.eventtap.scrollWheel({0, delta}, {}, 'line')

        done()
    end
end


--------------------------------------------------------------------------------
-- Move the mouse position.
--
-- Parameters:
--   direction (string):  One of: 'up', 'down', 'left', 'right'
--
-- Calls:
--   move_mouse()
--
-- Returns:
--   action (function):  Directional movement fn
--------------------------------------------------------------------------------
function M.move(direction)
    assert(
        direction == 'up'
            or direction == 'down'
            or direction == 'left'
            or direction == 'right',
        "direction must be one of: 'up', 'down', 'left', 'right'"
    )

    local function action(done)
        done = done or function() end

        if next(state.mouse.active_directions) == nil then
            return
            done()
        end

        if movement_timer and movement_timer:running() then
            return
            done()
        end

        -- Move immediately rather than waiting for the first timer tick
        move_mouse()

        if not movement_timer then
            movement_timer = hs.timer.new(MOVE_INTERVAL, move_mouse)
        end

        movement_timer:start()

        done()
    end

    move_actions[action] = direction

    return action
end


--------------------------------------------------------------------------------
-- Retrieve the direction associated with a movement action.
--------------------------------------------------------------------------------
function M.get_move_direction(action)
    return move_actions[action]
end


--------------------------------------------------------------------------------
-- Stop the movement timer.
--
-- State changes:
--   movement_timer
--------------------------------------------------------------------------------
function M.stop_movement_timer()
    return function(done)
        done = done or function() end

        if movement_timer and movement_timer:running() then
            movement_timer:stop()
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Quit the mouse control module.
--
-- Calls:
--   util.toggle_popups()
--   util.toggle_border()
--   util.toggle_tap()
--   M.stop_movement_timer()()
--------------------------------------------------------------------------------
function M.quit()
    return function(done)
        done = done or function() end

        util.toggle_popups('mouse', 'off')
        util.toggle_border('off')
        util.toggle_tap('mouse', 'off')

        M.stop_movement_timer()()

        local mouse = state.mouse

        for key in pairs(mouse.active_directions) do
            mouse.active_directions[key] = nil
        end

        for key in pairs(mouse.consumed) do
            mouse.consumed[key] = nil
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Start the mouse control module.
--
-- Calls:
--   screens.init()
--   apps.init()
--   windows.init()
--   runtime_assets.init()
--   util.toggle_popups()
--   util.toggle_tap()
--------------------------------------------------------------------------------
function M.launch()
    if state.mouse.tap_active then
        return
    end

    require('screens').init()
    require('apps').init()
    require('windows').init()

    -- Init runtime_assets if not already existing
    if not cache.initialized then
        require('runtime_assets').init()
    end

    util.toggle_popups('mouse', 'on')
    util.toggle_tap('mouse', 'on')
end

return M
