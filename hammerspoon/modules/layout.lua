
-- MENTAL MODEL:
-- -------------
-- The only windows that get stored are those at the forefront of the given
-- screen. If a new window is focused, it will only be 'snapped' into the
-- (left|right) container if it is not fullscreen.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, snap the previously focused
-- fullscreen window in to the adjacent container.



local M = {}

local state = require('state').layout


-- TODO: move this fn elsewhere later
--
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    hs.application.launchOrFocus(app)
    hs.timer.doAfter(
        0.1,
        function()
            local win = hs.window.frontmostWindow()

            M.window_appeared(win)
            M.snap_windows(win)
        end
    )
end


-- Snap window into their respective slot coords
--------------------------------------------------------------------------------
function M.snap_windows(win)
    local id = win:screen():id()
    local screen = state.screens[id]
    local layout = screen.layout
    local frame = screen.frame
    local divider = screen.divider

    local left_width = math.floor(frame.w * divider)
    local right_width = frame.w - left_width

    if layout.left then
        layout.left:setFrame({
            x = frame.x,
            y = frame.y,
            w = left_width,
            h = frame.h,
        })
    end

    if layout.right then
        layout.right:setFrame({
            x = frame.x + left_width,
            y = frame.y,
            w = right_width,
            h = frame.h,
        })
    end
end


-- Determine if a window is aligned more to the left or right of the screen
--------------------------------------------------------------------------------
function M.window_side(win)
    local screen = win:screen()

    if not screen then return nil end

    local screen_frame = screen:fullFrame()
    local win_frame = win:frame()
    local screen_mid = screen_frame.x + (screen_frame.w / 2)
    local win_mid = win_frame.x + (win_frame.w / 2)

    if win_mid < screen_mid then
        return 'left'
    else
        return 'right'
    end
end


-- Determine newly launched/focused windows layout
--------------------------------------------------------------------------------
function M.window_appeared(win)
    local id = win:screen():id()
    local screen = state.screens[id]
    local layout = screen.layout

    -- Case 1: The new window is fullscreen
    if M.is_window_fullscreen(win) then
        layout.fullscreen = win

        return
    end

    -- Case 2: A fullscreen window already exists
    if layout.fullscreen then
        local side = M.window_side(win)
        local opposite = (side == 'left') and 'right' or 'left'

        layout[side] = win
        layout[opposite] = layout.fullscreen
        layout.fullscreen = nil

        return
    end

    -- Case 3: Normal window
    layout[M.window_side(win)] = win
end


-- Calculate the available screen (total screen frame minus the dock)
--------------------------------------------------------------------------------
function M.usable_frame(screen)
    local full = screen:fullFrame()
    local usable = screen:frame()

    return {
        x = full.x,
        y = usable.y,
        w = full.w,
        h = full.h - (usable.y - full.y),
    }
end


-- Determine if two coordinate tables are equal to each other
--------------------------------------------------------------------------------
function M.frames_equal(a, b, tolerance)
    -- MacOS occasionally returns coords off by one pixel due to scaling,
    -- retina displays etc.
    tolerance = tolerance or 1

    return math.abs(a.x - b.x) <= tolerance
       and math.abs(a.y - b.y) <= tolerance
       and math.abs(a.w - b.w) <= tolerance
       and math.abs(a.h - b.h) <= tolerance
end


-- Determine whether or not a winodw is 'fullscreen'
--------------------------------------------------------------------------------
function M.is_window_fullscreen(win)
    return M.frames_equal(
        win:frame(),
        M.usable_frame(win:screen())
    )
end


-- Determine initial window layout
--------------------------------------------------------------------------------
function M.window_layout()
    local layout = {
        fullscreen = nil,
        left = nil,
        right = nil,
    }

    local win = hs.window.frontmostWindow()
    local app = win:application():name()

    if state.supported_apps[app] then
        if M.is_window_fullscreen(win) then
            layout.fullscreen = win
        else
            layout.left = win
        end
    end

    return layout
end


-- Init layout table
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        state.screens[screen:id()] = {
            divider = 0.40,
            layout = M.window_layout(),
            frame = M.usable_frame(screen),
        }
    end
end

return M


-- hs.console.hswindow():focus()  -- debug
-- print(win:title())
