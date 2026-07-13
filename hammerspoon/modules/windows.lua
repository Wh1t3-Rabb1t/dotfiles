-- MENTAL MODEL:
----------------
-- The only windows that get stored are those at the forefront of the given
-- screen. If a new window is focused, it will only be 'snapped' into the
-- (left|right) container if it is not fullscreen.
--
-- If a window is fullscreen at the forefront of the current screen and a new
-- window that is NOT fullscreen is focused on the same screen, fullscreen the
-- newly focused window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).

local M = {}

local state = require('state')
local cache = require('cache')


-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    local existing_win = hs.window.focusedWindow()

    hs.application.launchOrFocus(app)

    hs.timer.doAfter(
        0.002,
        function()
            local win = hs.window.focusedWindow()
            local app_name = win:application():name()

            -- Exit if called on an already focused window
            if win:id() == existing_win:id() then
                -- Invoke 'send_keys({"cmd"}, "`")'
                return
            end

            if cache.supported_apps[app_name] then
                M.snap_windows(
                    win,
                    M.window_appeared(existing_win, win)
                )
            end

            -- M.snap_windows(
            --     win,
            --     M.window_appeared(existing_win, win)
            -- )


        end
    )
end


-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap_splits()
    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local layout = state.screens[id].layout
    local left_slot = layout.left
    local right_slot = layout.right

    layout.left = right_slot
    layout.right = left_slot

    M.snap_windows(win, 'split')
end


-- Re-align window divider
--------------------------------------------------------------------------------
function M.move_window_divider(direction, step)
    step = step or 0.01

    local win = hs.window.focusedWindow()
    local id = win:screen():id()
    local curr_screen = state.screens[id]
    local divider = curr_screen.divider
    local layout = curr_screen.layout

    if direction == 'left' then
        divider = divider - step
    elseif direction == 'right' then
        divider = divider + step
    end

    local num = math.min(0.80, math.max(0.20, divider))
    curr_screen.divider = (num * 100) / 100

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
function M.maximize_window(win)
    win = win or hs.window.focusedWindow()

    local id = win:screen():id()
    local layout = state.screens[id].layout
    local frame = cache.screens[id].frame

    layout.maximized = win
    layout.maximized:setFrame(frame)
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

    -- Set new window to the fullscreen slot if it fills the usable screen space
    if M.is_window_fullscreen(win) then
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

    local side = M.window_side(win)
    local opposite = (side == 'left') and 'right' or 'left'

    if M.window_side(existing_win) == side then
        layout[opposite] = win
    else
        layout[side] = win
    end

    return 'split'
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


-- Calculate left/right slot frames
--------------------------------------------------------------------------------
function M.slot_frames(id, border)
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


-- Snap windows into their respective slot coords
--------------------------------------------------------------------------------
function M.snap_windows(win, target_layout)
    local id = win:screen():id()
    local layout = state.screens[id].layout
    local frames = M.slot_frames(id)

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
    local cached_frame = cache.screens[id].frame

    local frames = frames_equal(
        win:frame(),
        cached_frame
    )

    return frames
end


-- Calculate the available screen (total screen frame minus the dock)
--------------------------------------------------------------------------------
function M.usable_screen_frame(screen)
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


-- Create overlay
--------------------------------------------------------------------------------
function M.create_overlay(screen)
    local overlay = hs.canvas.new(screen:fullFrame())

    overlay:appendElements({
        type = 'rectangle',
        action = 'fill',
        fillColor = {
            red = 0,
            green = 0,
            blue = 0,
            alpha = 0,
        }
    })
    overlay:level(hs.canvas.windowLevels.overlay)
    overlay:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    overlay:show()

    return overlay
end


-- Init
--------------------------------------------------------------------------------
function M.init()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:id()

        cache.screens[id] = {
            overlay = M.create_overlay(screen),
            frame = M.usable_screen_frame(screen),
        }

        state.screens[id] = {
            brightness = 100,
            divider = 0.35,
            layout = {
                maximized = false,
                left = false,
                right = false,
            }
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
-- log_screen_slots('swap_splits' .. '(' .. win:application():name() .. ')')
-- log_screen_slots('move_window_divider' .. '(' .. direction .. ')')
-- log_screen_slots('maximize_window()')
-- log_screen_slots('slot_frames(screen_obj)')
-- log_screen_slots('window_side' .. '(' .. win:application():name() .. ')')


-- --------------------------------------------------------------------------------
-- function M.cycle_app_specific_windows(app)
--     local application = hs.application.get(app)
--
--     if not application then
--         return
--     end
--
--     local windows = application:visibleWindows()
--     local focused = hs.window.focusedWindow()
--
--     for i, win in ipairs(windows) do
--         if win == focused then
--             local next = windows[i + 1] or windows[1]
--             next:focus()
--             return
--         end
--     end
-- end
