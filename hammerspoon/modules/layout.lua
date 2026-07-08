
-- MENTAL MODEL:
-- -------------
-- The only windows that get stored are those at the forefront of the given
-- screen. If a new window is focused, it will only be 'snapped' into the
-- (left|right) container if it is not fullscreen.

-- NEW: If a window is fullscreen at the forefront and a new window that is
-- NOT fullscreen is focused on the same screen, fullscreen the newly focused
-- window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).


local M = {}

local state = require('state').layout

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

            -- -- Exit if called on an already focused window
            -- if win:id() == existing_win:id() then
            --     return
            -- end

            M.snap_windows(
                win,
                M.window_appeared(existing_win, win)
            )
        end
    )
end


-- Determine newly launched/focused windows layout.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, fullscreen the new window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).
--------------------------------------------------------------------------------
function M.window_appeared(existing_win, win)
    local id = win:screen():id()
    local layout = state.screens[id].layout

    -- New window wants fullscreen mode
    if M.is_window_fullscreen(win) then
        layout.maximized = win

        return 'maximized'
    end

    -- Already in fullscreen mode; replace the fullscreen window only
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

    local side = M.window_side(win)
    local opposite = (side == 'left') and 'right' or 'left'

    if M.window_side(existing_win) == side then
        layout[opposite] = win
    else
        layout[side] = win
    end

    return 'split'
end


-- Snap windows into their respective slot coords
--------------------------------------------------------------------------------
function M.snap_windows(win, target_layout)
    local id = win:screen():id()
    local screen = state.screens[id]
    local layout = screen.layout
    local frames = M.slot_frames(screen)

    if target_layout == 'maximized' then
        layout.maximized:setFrame(screen.frame, 0.02)
    elseif target_layout == 'split' then
        if layout.left then
            layout.left:setFrame(frames.left, 0.02)
        end
        if layout.right then
            layout.right:setFrame(frames.right, 0.02)
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
    local curr_screen = state.screens[id]
    local num = curr_screen.divider
    local layout = curr_screen.layout

    if direction == 'left' then
        num = num - 0.01
    elseif direction == 'right' then
        num = num + 0.01
    end

    curr_screen.divider = math.floor(num * 100) / 100

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

    M.snap_windows(win, 'split')
end


-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize_window()
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local curr_screen = state.screens[id]
    local layout = curr_screen.layout
    local frame = curr_screen.frame

    layout.maximized = win
    layout.maximized:setFrame(frame)
end


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
function M.slot_frames(target_screen)
    local frame = target_screen.frame
    local left_width = math.floor(frame.w * target_screen.divider)
    local right_width = frame.w - left_width

    local frames = {
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

    return frames
end


-- Is window aligned to the left or right of the screen
--------------------------------------------------------------------------------
function M.window_side(win)
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


-- Determine whether or not a winodw is maximized
--------------------------------------------------------------------------------
function M.is_window_fullscreen(win)
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
    local curr_screen = state.screens[id]

    local frames = frames_equal(
        win:frame(),
        curr_screen.frame
    )

    return frames
end


-- Init layout table
--------------------------------------------------------------------------------
function M.init()
    -- Calculate the available screen (total screen frame minus the dock)
    local function usable_frame(screen)
        local full = screen:fullFrame()
        local usable = screen:frame()

        local frame = {
            x = full.x,
            y = usable.y,
            w = full.w,
            h = full.h - (usable.y - full.y),
        }

        return frame
    end

    for _, screen in ipairs(hs.screen.allScreens()) do
        state.screens[screen:id()] = {
            divider = 0.36,
            layout = {
                maximized = false,
                left = false,
                right = false,
            },
            frame = usable_frame(screen),
        }
    end
end

return M



-- local function clear_log()
--     local log_file = os.getenv('HOME') .. '/.local/state/logs/log'
--     local file = io.open(log_file, 'w')
--     if file then
--         file:close()
--     end
-- end

-- local function log_screen_slots(caller)
--     local screen = hs.screen.mainScreen()
--     local curr_screen = state.screens[screen:id()]
--
--     local function hs_log(msg)
--         local log_file = os.getenv('HOME') .. '/.local/state/logs/log'
--         local file = io.open(log_file, 'a')  -- 'a' = append
--         if not file then
--             return
--         end
--
--         file:write(os.date("[%H:%M:%S] "))
--         file:write(msg .. "\n")
--         file:close()
--     end
--
--     -- Section title:
--     hs_log('-------\n' .. '           CALLER: ' .. caller)
--
--     for k, v in pairs(curr_screen.layout) do
--         if v then
--             hs_log(k .. ': ' .. v:application():name())
--         else
--             hs_log(k .. ': EMPTY')
--         end
--     end
-- end

-- log_screen_slots('launch_or_focus' .. '(' .. app .. ')')
-- log_screen_slots('window_appeared' .. '(' .. win:application():name() .. ')')
-- log_screen_slots('snap_windows' .. '(' .. win:application():name() .. ', ' .. target_layout .. ')')
-- log_screen_slots('swap_window_slots' .. '(' .. win:application():name() .. ')')
-- log_screen_slots('move_window_divider' .. '(' .. direction .. ')')
-- log_screen_slots('maximize_window()')
-- log_screen_slots('slot_frames(screen_obj)')
-- log_screen_slots('window_side' .. '(' .. win:application():name() .. ')')


-- Initial call (layout is empty)
--------------------------------------------------------------------------------
-- [04:16:50] -------
--            CALLER: launch_or_focus(Brave Browser)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: EMPTY
-- [04:16:50] -------
--            CALLER: window_appeared(Brave Browser)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: EMPTY
-- [04:16:50] -------
--            CALLER: window_side(Brave Browser)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: EMPTY
-- [04:16:50] -------
--            CALLER: window_side(kitty)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: EMPTY
-- [04:16:50] -------
--            CALLER: slot_frames(screen_obj)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: Brave Browser
-- [04:16:50] -------
--            CALLER: snap_windows(Brave Browser, split)
-- [04:16:50] maximized: EMPTY
-- [04:16:50] right: EMPTY
-- [04:16:50] left: Brave Browser
--
--
-- Second call (Brave is stored in layout.left)
--------------------------------------------------------------------------------
-- [04:17:37] -------
--            CALLER: launch_or_focus(kitty)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: EMPTY
-- [04:17:37] left: Brave Browser
-- [04:17:37] -------
--            CALLER: window_appeared(kitty)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: EMPTY
-- [04:17:37] left: Brave Browser
-- [04:17:37] -------
--            CALLER: window_side(kitty)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: EMPTY
-- [04:17:37] left: Brave Browser
-- [04:17:37] -------
--            CALLER: window_side(Brave Browser)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: EMPTY
-- [04:17:37] left: Brave Browser
-- [04:17:37] -------
--            CALLER: slot_frames(screen_obj)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: kitty
-- [04:17:37] left: Brave Browser
-- [04:17:37] -------
--            CALLER: snap_windows(kitty, split)
-- [04:17:37] maximized: EMPTY
-- [04:17:37] right: kitty
-- [04:17:37] left: Brave Browser
