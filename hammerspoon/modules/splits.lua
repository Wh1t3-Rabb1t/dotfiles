local M = {}

local state = require('state')
local cache = require('cache')


-- Compare the dimensions of two frame objects
--------------------------------------------------------------------------------
local function frames_equal(a, b, tolerance)
    -- MacOS occasionally returns coords off by one pixel due to scaling,
    -- retina displays etc.
    tolerance = tolerance or 1

    return math.abs(a.x - b.x) <= tolerance
       and math.abs(a.y - b.y) <= tolerance
       and math.abs(a.w - b.w) <= tolerance
       and math.abs(a.h - b.h) <= tolerance
end


-- Determine whether or not a winodw is maximized
--------------------------------------------------------------------------------
local function is_fullscreen(win)
    local id           = win:screen():id()
    local cached_frame = cache.screens[id].frame

    local frames = frames_equal(
        win:frame(),
        cached_frame
    )

    return frames
end


-- Is window aligned to the left or right of the screen
--------------------------------------------------------------------------------
local function get_side(win)
    local screen = win:screen()

    if not screen then
        return false
    end

    local screen_frame = screen:fullFrame()
    local win_frame    = win:frame()
    local screen_mid   = screen_frame.x + (screen_frame.w / 2)
    local win_mid      = win_frame.x + (win_frame.w / 2)

    local side = 'right'

    if win_mid < screen_mid then
        side = 'left'
    end

    return side
end


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
local function get_coords(id, border)
    border = border or 8

    local frame       = cache.screens[id].frame
    local left_width  = frame.w * state.screens[id].divider
    local right_width = frame.w - left_width

    local frames = {
        left = {
            x = frame.x + border,
            y = frame.y + border,
            w = left_width - border,
            h = frame.h - (border * 2),
        },
        right = {
            x = frame.x + left_width + border,
            y = frame.y + border,
            w = right_width - (border * 2),
            h = frame.h - (border * 2),
        }
    }

    return frames
end


-- Determine newly launched/focused windows layout.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, fullscreen the new window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).
--------------------------------------------------------------------------------
local function set_layout(existing_win, win)
    local id     = win:screen():id()
    local layout = state.screens[id].layout

    -- Set new window to the fullscreen slot if it fills the usable screen space
    if is_fullscreen(win) then
        layout.maximized = win

        return
    end

    -- Already fullscreen; replace existing fullscreen window with the new one
    if layout.maximized then
        if layout.right == win then
            layout.left = layout.maximized
        elseif layout.left == win then
            layout.right = layout.maximized
        end

        layout.maximized = win

        return
    end

    -- Normal split mode
    if layout.maximized then
        layout.maximized = false
    end

    local side     = get_side(win)
    local opposite = (side == 'left') and 'right' or 'left'

    if get_side(existing_win) == side then
        layout[opposite] = win
    else
        layout[side] = win
    end
end


-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap()
    return function(done)
        local win    = state.menu.curr_win or hs.window.focusedWindow()
        local id     = win:screen():id()
        local layout = state.screens[id].layout
        local lhs    = layout.left
        local rhs    = layout.right

        layout.left  = rhs
        layout.right = lhs

        done()
    end
end


-- Re-align window divider
--------------------------------------------------------------------------------
function M.resize(direction, step_val)
    return function(done)
        local step    = step_val or 0.01
        local win     = state.menu.curr_win or hs.window.focusedWindow()
        local id      = win:screen():id()
        local screen  = state.screens[id]
        local divider = screen.divider
        local layout  = screen.layout

        if direction == 'left' then
            divider = divider - step
        elseif direction == 'right' then
            divider = divider + step
        end

        local num = math.min(0.80, math.max(0.20, divider))
        screen.divider = (num * 100) / 100

        if layout.maximized then
            if direction == 'left' then
                if layout.right == win then
                    layout.right = layout.left
                end

                layout.left = win
            elseif direction == 'right' then
                if layout.left == win then
                    layout.left = layout.right
                end

                layout.right = win
            end

            layout.maximized = false
        end

        done()
    end
end


-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize()
    return function(done)
        local win    = state.menu.curr_win or hs.window.focusedWindow()
        local id     = win:screen():id()
        local layout = state.screens[id].layout

        layout.maximized = win

        done()
    end
end


-- Snap windows into their respective slot coords
--------------------------------------------------------------------------------
function M.snap()
    return function(done)
        local win    = state.menu.curr_win or hs.window.focusedWindow()
        local id     = win:screen():id()
        local layout = state.screens[id].layout
        local frames = get_coords(id)

        if layout.maximized then
            layout.maximized:setFrame(cache.screens[id].frame, 0.02)
        else
            if layout.left then
                layout.left:setFrame(frames.left, 0.02)
            end
            if layout.right then
                layout.right:setFrame(frames.right, 0.02)
            end
        end

        done()
    end
end


-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    return function(done)
        local existing = hs.window.focusedWindow()

        local function finish(new)
            state.menu.curr_win = new

            if existing and new and existing:id() ~= new:id() then
                set_layout(existing, new)
            end

            done()
        end

        if existing and existing:application():name() == app then
            finish(existing)
            return
        end

        local wf = hs.window.filter.new(app)

        wf:subscribe(hs.window.filter.windowFocused, function(new)
            wf:unsubscribeAll()
            finish(new)
        end)

        hs.application.launchOrFocus(app)
    end
end

return M
