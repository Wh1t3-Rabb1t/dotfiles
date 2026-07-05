
-- MENTAL MODEL:
-- -------------
-- The only windows that get stored are those at the forefront of the given
-- screen. If a new window is focused, it will only be 'snapped' into the
-- (left|right) container if it is not fullscreen.
--
-- OLD: If a window is fullscreen at the forefront and a new window that is
-- NOT fullscreen is focused on the same screen, snap the previously focused
-- fullscreen window in to the adjacent container.

-- NEW: If a window is fullscreen at the forefront and a new window that is
-- NOT fullscreen is focused on the same screen, fullscreen the newly focused
-- window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).

-- To exit fullscreen mode: call 'move_window_divider()'


local M = {}

local state = require('state').layout


function M.debug_screen_slots()
    local screen = hs.screen.mainScreen()
    local scr = state.screens[screen:id()]
    for k, v in pairs(scr.layout) do
        if v then
            hs.alert.show(k .. ': ' .. v:application():name())
        end
    end
end


-- TODO: move this fn elsewhere later
--
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    local existing_win = hs.window.focusedWindow()

    hs.application.launchOrFocus(app)

    hs.timer.doAfter(
        0.002,
        function()
            local win = hs.window.focusedWindow()

            -- Exit if called on an already focused window
            if win:id() == existing_win:id() then
                return
            end

            M.snap_windows(
                win, M.window_appeared(existing_win, win)
            )

            M.debug_screen_slots()
        end
    )
end


-- Snap window into their respective slot coords
--------------------------------------------------------------------------------
function M.snap_windows(win, layout)
    local id = win:screen():id()
    local screen = state.screens[id]
    local frames = M.slot_frames(screen)

    if layout == 'fullscreen' then
        screen.layout.fullscreen:setFrame(screen.frame)
    elseif layout == 'split' then
        if screen.layout.left then
            screen.layout.left:setFrame(frames.left)
        end
        if screen.layout.right then
            screen.layout.right:setFrame(frames.right)
        end
    end
end


-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap_window_slots()
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local left = state.screens[id].layout.left
    local right = state.screens[id].layout.right

    state.screens[id].layout.left = right
    state.screens[id].layout.right = left

    M.snap_windows(win, 'split')
end


-- Re-align window divider
--------------------------------------------------------------------------------
function M.move_window_divider(direction)
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local num = state.screens[id].divider

    if direction == 'left' then
        num = num - 0.01
    elseif direction == 'right' then
        num = num + 0.01
    end

    state.screens[id].divider = math.floor(num * 100) / 100

    M.snap_windows(win, 'split')
end


-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize_window()
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local layout = state.screens[id].layout
    local frame = M.usable_frame(win:screen())

    if layout.left == win then
        layout.left = false
    end
    if layout.right == win then
        layout.right = false
    end

    layout.fullscreen = win
    layout.fullscreen:setFrame(frame)

    M.debug_screen_slots()
end


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
function M.slot_frames(screen_obj)
    local frame = screen_obj.frame

    local left_width = math.floor(frame.w * screen_obj.divider)
    local right_width = frame.w - left_width

    return {
        left = {
            x = frame.x,
            y = frame.y,
            w = left_width,
            h = frame.h,
        },
        right = {
            x = frame.x + left_width,
            y = frame.y,
            w = right_width,
            h = frame.h,
        }
    }
end


-- Is window aligned to the left or right of the screen
--------------------------------------------------------------------------------
function M.window_side(win)
    local screen = win:screen()

    if not screen then return false end

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
function M.window_appeared(existing_win, win)
    local id = win:screen():id()
    local layout = state.screens[id].layout

    -- Case 1: The new window is already fullscreen.
    if M.is_window_fullscreen(win) then
        layout.fullscreen = win

        return 'fullscreen'
    end

    -- Case 2: A fullscreen window already exists.
    -- Simply replace it. Leave the split layout untouched.
    if layout.fullscreen == existing_win then
        layout.fullscreen = win

        return 'fullscreen'
    end

    -- Case 3: Maintain/update the remembered split layout.
    local side = M.window_side(win)
    local opposite = (side == "left") and "right" or "left"

    if side == M.window_side(existing_win) then
        layout[side] = existing_win
        layout[opposite] = win
    else
        layout[side] = win
    end

    return 'split'
end


-- function M.window_appeared(existing_win, win)
--     local id = win:screen():id()
--     local focused_screen = state.screens[id]
--     local layout = focused_screen.layout
--
--     -- Case 1: The new window is fullscreen
--     if M.is_window_fullscreen(win) then
--         layout.fullscreen = win
--
--         return
--     end
--
--     local side = M.window_side(win)
--     local opposite = (side == 'left') and 'right' or 'left'
--
--     -- Case 2: A fullscreen window already exists
--     if layout.fullscreen then
--         layout[side]      = win
--         layout[opposite]  = layout.fullscreen
--         layout.fullscreen = false
--
--         return
--     end
--
--     -- Case 3: Normal window
--     --
--     -- If 'existing_win' occupies the same side that 'win' does, assign 'win'
--     -- to the opposite side and let 'existing_win' retain it's place.
--     if side == M.window_side(existing_win) then
--         layout[side]     = existing_win
--         layout[opposite] = win
--     else
--         layout[side]     = win
--     end
-- end


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


-- Init layout table
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        state.screens[screen:id()] = {
            divider = 0.34,
            layout = {
                fullscreen = false,
                left = false,
                right = false,
            },
            frame = M.usable_frame(screen),
        }
    end
end

return M



-- function M.init()
--     -- Determine initial window layout
--     local function window_layout(win)
--         -- NOTE: Defaulting to nil causes massive problems (attempt to index nil
--         -- val, something about nil pointers that I'm too dumb to know about).
--         local layout = {
--             fullscreen = false,
--             left = false,
--             right = false,
--         }
--
--         local app = win:application():name()
--
--         if state.supported_apps[app] then
--             -- Determine window alignment
--             if M.is_window_fullscreen(win) then
--                 layout.fullscreen = win
--             else
--                 layout[M.window_side(win)] = win
--             end
--         end
--
--         return layout
--     end
--
--     for _, screen in ipairs(hs.screen.allScreens()) do
--         local window = hs.window.frontmostWindow()
--
--         state.screens[screen:id()] = {
--             divider = 0.40,
--             layout = window_layout(window),
--             frame = M.usable_frame(screen),
--         }
--     end
-- end
