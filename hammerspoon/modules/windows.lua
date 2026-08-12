local M = {}

local state = require('state')
local cache = require('cache')



-- function M.debug_slots()
--     return function(done)
--         local screen = hs.mouse.getCurrentScreen()
--         local id     = screen:id()
--         local layout = state.screens[id].layout
--         if layout.left then
--             local lhs = layout.left:application():name()
--             hs.alert.show('id: ' .. id  .. '  lhs: ' .. lhs)
--         end
--         if layout.right then
--             local rhs = layout.right:application():name()
--             hs.alert.show('id: ' .. id  .. '  rhs: ' .. rhs)
--         end
--         if layout.maximized then
--             local max = layout.maximized:application():name()
--             hs.alert.show('id: ' .. id  .. '  max: ' .. max)
--         end
--         done()
--     end
-- end



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
    local win_frame    = win:frame()
    local screen       = win:screen()
    local screen_frame = screen:fullFrame()
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


-- Remove windows from layout state
--------------------------------------------------------------------------------
local function remove_window(layout, win)
    if layout.left      == win then layout.left      = false end
    if layout.right     == win then layout.right     = false end
    if layout.maximized == win then layout.maximized = false end
end


-- Assign windows to layout state.
--
-- If a window is fullscreen at the forefront and a new window that is NOT
-- fullscreen is focused on the same screen, fullscreen the new window.
--
-- The 'left' and 'right' slots are retained until explicitly overwritten
-- (i.e. they are unaffected by the 'fullscreen' slot).
--------------------------------------------------------------------------------
local function assign_window(layout, existing, win)
    if is_fullscreen(win) then
        layout.maximized = win

        -- Exit early
        return
    end

    if layout.maximized then
        if layout.right == win then
            layout.left = layout.maximized
        elseif layout.left == win then
            layout.right = layout.maximized
        end

        layout.maximized = win

        -- Exit early
        return
    end

    layout.maximized = false

    local side = get_side(win)

    if existing and get_side(existing) == side then
        local opposite = (side == 'left') and 'right' or 'left'
        layout[opposite] = win
    else
        layout[side] = win
    end
end


-- Iterate index of focused windows
--------------------------------------------------------------------------------
local function iterate_window_index(wins, idx, direction)
    local count = #wins

    if count == 0 then
        return false
    end

    if direction == 'next' then
        idx = idx % count + 1
    elseif direction == 'prev' then
        idx = (idx - 2) % count + 1
    else
        return false
    end

    return idx
end


-- Get all open windows
--------------------------------------------------------------------------------
local function get_open_windows()
    local open_apps = hs.application.runningApplications()
    local wins      = {}

    -- All open windows
    wins.all = {
        idx  = 1,
        wins = {},
    }

    for _, app in ipairs(open_apps) do
        local name     = app:name()
        local app_wins = {}

        for _, win in ipairs(app:allWindows()) do
            if win:isStandard() and win:isVisible() then
                table.insert(wins.all.wins, win)
                table.insert(app_wins, win)
            end
        end

        if #app_wins > 0 then
            wins[name] = {
                idx  = 1,
                wins = app_wins,
            }
        end
    end

    return wins
end


--------------------------------------------------------------------------------
-- Maximize focused window
--------------------------------------------------------------------------------
function M.maximize()
    return function(done)
        local win    = state.menu.curr_win
        local id     = win:screen():id()
        local layout = state.screens[id].layout

        layout.maximized = win

        done()
    end
end


--------------------------------------------------------------------------------
-- Re-align window divider
--------------------------------------------------------------------------------
function M.resize(direction, step_val)
    return function(done)
        local step    = step_val or 0.01
        local win     = state.menu.curr_win
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

        -- If window is maximized, snap back to splits layout
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


--------------------------------------------------------------------------------
-- Swap left/right window slots
--------------------------------------------------------------------------------
function M.swap()
    return function(done)
        local win    = state.menu.curr_win
        local id     = win:screen():id()
        local layout = state.screens[id].layout
        local lhs    = layout.left
        local rhs    = layout.right

        layout.left  = rhs
        layout.right = lhs

        done()
    end
end


--------------------------------------------------------------------------------
-- Move window to the next/previous connected screen
--------------------------------------------------------------------------------
function M.move_to_screen()
    return function(done)
        local win         = state.menu.curr_win
        local curr_screen = win:screen()
        local next_screen = curr_screen:next()

        local old_layout = state.screens[curr_screen:id()].layout
        local new_layout = state.screens[next_screen:id()].layout

        remove_window(old_layout, win)

        win:moveToScreen(next_screen)

        assign_window(new_layout, nil, win)

        done()
    end
end


--------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------
-- Launch or focus target app
--------------------------------------------------------------------------------
function M.launch_or_focus(app)
    return function(done)
        local existing = hs.window.focusedWindow()

        local function finish(new)
            state.menu.curr_win = new

            if existing and new and existing:id() ~= new:id() then
                local id     = new:screen():id()
                local layout = state.screens[id].layout

                assign_window(layout, existing, new)
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


--------------------------------------------------------------------------------
-- Cycle focus between main apps (the twin cats)
--------------------------------------------------------------------------------
function M.cycle_main_apps()
    return function(done)
        local existing = hs.window.focusedWindow()

        local target_app = 'kitty'

        if existing and existing:application():name() == 'kitty' then
            target_app = 'Brave Browser'
        end

        local wf = hs.window.filter.new(target_app)

        wf:subscribe(
            hs.window.filter.windowFocused,
            function(target_win)
                wf:unsubscribeAll()
                wf = nil

                local id     = target_win:screen():id()
                local layout = state.screens[id].layout

                assign_window(layout, existing, target_win)

                state.menu.curr_win = target_win

                done()
            end
        )

        hs.application.launchOrFocus(target_app)
    end
end


--------------------------------------------------------------------------------
-- Cycle between the currently focused apps open windows
--------------------------------------------------------------------------------
function M.cycle_app_specific(direction)
    return function(done)
        local focused = state.menu.curr_win

        if not focused then
            done()
            return
        end

        local app  = focused:application():name()
        local wins = state.wins[app].wins

        if not wins then
            hs.alert.show('Window is not tracked by state.lua')
            return
        end

        if #wins < 2 then
            done()
            return
        end

        local idx     = state.wins[app].idx
        local new_idx = iterate_window_index(wins, idx, direction)

        -- Update state and focus new window
        if new_idx then
            local win = wins[new_idx]

            state.wins[app].idx = new_idx
            state.menu.curr_win = win

            win:focus()
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle between all open windows
--------------------------------------------------------------------------------
function M.cycle_open(direction)
    return function(done)
        local wins    = state.wins.all.wins
        local idx     = state.wins.all.idx
        local new_idx = iterate_window_index(wins, idx, direction)

        -- Update state and focus new window
        if new_idx then
            local win = wins[new_idx]

            state.wins.all.idx  = new_idx
            state.menu.curr_win = win

            win:focus()
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Init
------------------------------------------------------------------------------
function M.init()
    local win = hs.window.focusedWindow()
    local app = win:application():name()

    -- Init layout if the focused window is compatible
    if cache.assets[app] then
        local id     = win:screen():id()
        local layout = state.screens[id].layout

        assign_window(layout, nil, win)
    end

    local all_wins = get_open_windows()

    state.wins = all_wins
end

return M
