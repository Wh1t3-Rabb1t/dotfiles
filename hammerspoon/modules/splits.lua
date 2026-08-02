local M = {}

local state = require('state')
local cache = require('cache')


-- Determine whether or not a winodw is maximized
--------------------------------------------------------------------------------
local function is_fullscreen(win)
    local function frames_equal(a, b, tolerance)
        -- MacOS occasionally returns coords off by one pixel due to scaling,
        -- retina displays etc.
        tolerance = tolerance or 1

        return math.abs(a.x - b.x) <= tolerance
           and math.abs(a.y - b.y) <= tolerance
           and math.abs(a.w - b.w) <= tolerance
           and math.abs(a.h - b.h) <= tolerance
    end

    local id = win:screen():id()
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
    local win_frame = win:frame()
    local screen_mid = screen_frame.x + (screen_frame.w / 2)
    local win_mid = win_frame.x + (win_frame.w / 2)

    local side = 'right'

    if win_mid < screen_mid then
        side = 'left'
    end

    return side
end


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
local function get_split_coords(id, border)
    border = border or 8

    local frame = cache.screens[id].frame
    local left_width = frame.w * state.screens[id].divider
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
function M.get_layout(existing_win, win)
    local id = win:screen():id()
    local layout = state.screens[id].layout

    -- Set new window to the fullscreen slot if it fills the usable screen space
    if is_fullscreen(win) then
        layout.maximized = win

        return 'maximized'
    end

    -- Already fullscreen; replace existing fullscreen window with the new one
    if layout.maximized then
        if layout.right == win then
            layout.left = layout.maximized
        elseif layout.left == win then
            layout.right = layout.maximized
        end

        layout.maximized = win

        return 'maximized'
    end

    -- Normal split mode
    if layout.maximized then
        layout.maximized = false
    end

    local side = get_side(win)
    local opposite = (side == 'left') and 'right' or 'left'

    if get_side(existing_win) == side then
        layout[opposite] = win
    else
        layout[side] = win
    end

    return 'split'
end


-- Snap windows into their respective slot coords
--------------------------------------------------------------------------------
function M.snap(win, target_layout)
    local id = win:screen():id()
    local layout = state.screens[id].layout
    local frames = get_split_coords(id)

    if target_layout == 'maximized' then
        layout.maximized:setFrame(cache.screens[id].frame, 0.02)
    elseif target_layout == 'split' then
        if layout.left then
            layout.left:setFrame(frames.left, 0.02)
        end
        if layout.right then
            layout.right:setFrame(frames.right, 0.02)
        end
    end
end

return M
