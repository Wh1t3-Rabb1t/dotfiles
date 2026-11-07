local M = {}

local state = require('state')
local conf  = require('config')
local util  = require('util')


-- Clear window assignments from the screen layout.
--
-- Parameters:
--   target (table | number):
--     hs.window      (table):   Clear the slot assigned to this window
--     hs.screen:id() (number):  Clear every slot on the screen with this ID
--
-- State changes:
--   state.screens[screen_id].layout.maximized
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
local function clear_slots(target)
    local clear_all = type(target) == 'number'
    local screen_id = clear_all and target or target:screen():id()
    local layout    = state.screens[screen_id].layout

    for _, name in ipairs({ 'maximized', 'left', 'right' }) do
        if clear_all or layout[name] == target then
            layout[name] = false
        end
    end
end


-- Determine whether or not a window is maximized.
--
-- Parameters:
--   win (table):  hs.window object
--
-- Returns:
--   true  (bool):  win:frame() is equal to the usable screen frame
--   false (bool):  win:frame() is NOT equal to the usable screen frame
--------------------------------------------------------------------------------
local function is_fullscreen(win)
    local win_frame    = win:frame()
    local screen_frame = state.screens[win:screen():id()].frame

    local tolerance = 1

    return math.abs(win_frame.x - screen_frame.x) <= tolerance
       and math.abs(win_frame.y - screen_frame.y) <= tolerance
       and math.abs(win_frame.w - screen_frame.w) <= tolerance
       and math.abs(win_frame.h - screen_frame.h) <= tolerance
end


-- Iterate window index.
--
-- Parameters:
--   app_name  (string):  'kitty', 'Brave Browser' etc.
--   direction (string):  'next' or 'prev'
--
-- Returns:
--   idx (number):  Index of the next/prev window in the state table
--------------------------------------------------------------------------------
local function iterate_window_idx(app_name, direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    local wins
    local idx

    if app_name == 'all' then
        wins = state.windows.wins
        idx  = state.windows.idx
    else
        wins = state.apps[app_name].wins
        idx  = state.apps[app_name].idx
    end

    local count = #wins

    if direction == 'next' then
        idx = idx % count + 1
    elseif direction == 'prev' then
        idx = (idx - 2) % count + 1
    end

    return idx
end


-- Find a windows index in the state table.
--
-- Parameters:
--   wins (table):  An array of hs.window objects
--   win  (table):  hs.window object
--
-- Returns:
--   idx (number):  Index of the target window if it exists in the state table
--------------------------------------------------------------------------------
local function get_window_idx(wins, win)
    for idx, window in ipairs(wins) do
        if window == win then
            return idx
        end
    end
end


-- Determine which side of the screen the target window is aligned to.
--
-- Parameters:
--   win (table):  hs.window object
--
-- Returns:
--   side (string):  'left' or 'right'
--------------------------------------------------------------------------------
local function get_window_alignment(win)
    local win_frame    = win:frame()
    local screen_frame = win:screen():fullFrame()
    local screen_mid   = screen_frame.x + (screen_frame.w / 2)
    local win_mid      = win_frame.x + (win_frame.w / 2)

    local side = 'right'

    if win_mid < screen_mid then
        side = 'left'
    end

    return side
end


-- Calculate left/right slot coordinates of the target screen.
--
-- Parameters:
--   screen_id (number):  hs.screen:id()
--
-- Returns:
--   (table):  x, y, width, and height data for each slot on the screen
--------------------------------------------------------------------------------
local function get_slot_coords(screen_id)
    local border = 8

    local frame   = state.screens[screen_id].frame
    local divider = state.screens[screen_id].divider

    local left_width  = frame.w * divider
    local right_width = frame.w - left_width

    return {
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
end


-- Assign windows to layout state.
--
-- Parameters:
--   win (table):  hs.window object
--
-- Calls:
--   is_fullscreen()
--   get_window_alignment()
--
-- State changes:
--   state.screens[screen_id].layout.maximized
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
local function set_slots(win)
    local layout = state.screens[win:screen():id()].layout

    if is_fullscreen(win) then
        layout.maximized = win
    else
        layout[get_window_alignment(win)] = win
    end
end


-- Populate all empty slot on the target screen.
--
-- Parameters:
--   screen_id (number):  hs.screen:id()
--
-- Calls:
--   is_fullscreen()
--   get_window_alignment()
--
-- State changes:
--   state.screens[screen_id].layout.maximized
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
local function set_empty_slots(screen_id)
    local layout = state.screens[screen_id].layout

    for _, win in ipairs(hs.window.orderedWindows()) do
        local win_is_std     = win:isStandard() and win:isVisible()
        local on_same_screen = win:screen():id() == screen_id
        local disallowed     = conf.disallowed_apps[win:application():name()]

        local slot

        if win_is_std and on_same_screen and not disallowed then
            if is_fullscreen(win) then
                slot = 'maximized'
            else
                slot = get_window_alignment(win)
            end
        end

        if slot and not layout[slot] then
            layout[slot] = win
        end
    end
end


-- Update focused window state.
--
-- Parameters:
--   win (table):   hs.window object
--   idx (number):  Index of a window stored in the state table
--
-- Calls:
--   get_window_idx()
--
-- State changes:
--   state.apps[app_name].idx
--   state.windows.idx
--   state.windows.curr_win
--------------------------------------------------------------------------------
local function set_window_state(win, idx)
    local curr_app = state.apps[win:application():name()]

    curr_app.idx = get_window_idx(curr_app.wins, win)

    state.windows.idx      = idx
    state.windows.curr_win = win
end



-- Snap windows into their respective slot positions.
--
-- Calls:
--   get_slot_coords()
--   util.toggle_border()
--------------------------------------------------------------------------------
local function snap_layout()
    local win       = state.windows.curr_win
    local screen_id = win:screen():id()
    local layout    = state.screens[screen_id].layout
    local frames    = get_slot_coords(screen_id)

    if layout.maximized then
        layout.maximized:setFrame(state.screens[screen_id].frame, 0.02)
    else
        if layout.left then
            layout.left:raise()
            layout.left:setFrame(frames.left, 0.02)
        end
        if layout.right then
            layout.right:raise()
            layout.right:setFrame(frames.right, 0.02)
        end
    end

    win:raise()

    util.toggle_border('on')
end


-- Focus target window and set the mouse at the center of its frame.
--
-- Notes:
--   https://github.com/Hammerspoon/hammerspoon/issues/370
--
--   Resolved incorrect window focus issue by turning off the:
--   'Displays have separate Spaces'
--   option for Mission Control. (logout is required for it to take effect)
--
-- Returns:
--   win (table):  hs.window object
--------------------------------------------------------------------------------
local function focus_window(win)
    if not win then
        return false
    end

    win:application():activate()

    hs.timer.usleep(10000)

    win:focus()

    local frame = win:frame()

    hs.mouse.absolutePosition({
        x = frame.x + (frame.w / 2),
        y = frame.y + (frame.h / 2)
    })

    return win
end


--------------------------------------------------------------------------------
-- Maximize focused window.
--
-- Calls:
--   snap_layout()
--   util.toggle_popups()
--
-- State changes:
--   state.screens[screen_id].layout.maximized
--------------------------------------------------------------------------------
function M.maximize()
    return function(done)
        done = done or function() end

        local win    = state.windows.curr_win
        local layout = state.screens[win:screen():id()].layout

        layout.maximized = win

        snap_layout()
        util.toggle_popups('off', 'on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Re-align window divider.
--
-- Parameters:
--   direction (string):  'left' or 'right'
--
-- Calls:
--   snap_layout()
--   util.toggle_popups()
--
-- State changes:
--   state.screens[screen_id].divider
--   state.screens[screen_id].layout.maximized
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
function M.resize(direction)
    assert(
        direction == 'left' or direction == 'right',
        "direction must be 'left' or 'right'"
    )

    return function(done)
        done = done or function() end

        local step    = 0.01
        local win     = state.windows.curr_win
        local screen  = state.screens[win:screen():id()]
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
            layout.maximized = false

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
        end

        snap_layout()
        util.toggle_popups('off', 'on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Swap left/right window slots.
--
-- Calls:
--   snap_layout()
--   util.toggle_popups()
--
-- State changes:
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
function M.swap()
    return function(done)
        done = done or function() end

        local win    = state.windows.curr_win
        local layout = state.screens[win:screen():id()].layout
        local lhs    = layout.left
        local rhs    = layout.right

        layout.left  = rhs
        layout.right = lhs

        snap_layout()
        util.toggle_popups('off', 'on')

        done()
    end
end


--------------------------------------------------------------------------------
-- Move window to the next/previous connected screen.
--
-- Parameters:
--   direction (string):  'next' or 'prev'
--
-- Calls:
--   clear_slots()
--   set_slots()
--   snap_layout()
--------------------------------------------------------------------------------
function M.move_to_screen(direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    return function(done)
        done = done or function() end

        local win = state.windows.curr_win

        local target_screen

        if direction == 'next' then
            target_screen = win:screen():next()
        elseif direction == 'prev' then
            target_screen = win:screen():previous()
        end

        if target_screen then
            clear_slots(win)

            win:moveToScreen(target_screen)

            set_slots(win)
            snap_layout()
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Move focused window to the adjacent layout slot.
--
-- Parameters:
--   direction (string):  'left' or 'right'
--
-- Calls:
--   clear_slots()
--   snap_layout()
--   util.toggle_popups()
--   set_empty_slots()
--
-- State changes:
--   state.screens[screen_id].layout.left
--   state.screens[screen_id].layout.right
--------------------------------------------------------------------------------
function M.move_to_slot(direction)
    assert(
        direction == 'left' or direction == 'right',
        "direction must be 'left' or 'right'"
    )

    return function(done)
        done = done or function() end

        local win       = state.windows.curr_win
        local screen_id = win:screen():id()
        local layout    = state.screens[screen_id].layout

        clear_slots(win)

        layout[direction] = win

        snap_layout()
        util.toggle_popups('off', 'on')
        set_empty_slots(screen_id)

        done()
    end
end


--------------------------------------------------------------------------------
-- Traverse layout slots.
--
-- Parameters:
--   direction (string):  'next' or 'prev'
--
-- Notes:
--   If current window is in the:
--     MAXIMIZED slot, then look for the first available slot on the next
--     screen. Maximized is always prioritized first, (if a window is maximized,
--     the left/right slot windows won't be visible).
--
--     RIGHT slot, and direction == 'next' then look for the first available
--     slot on the next screen.
--
--     LEFT slot, and direction == 'prev' then look for the first available
--     slot on the next screen.
--
--     LEFT or RIGHT slot, and there are no slots available on the next screen
--     then focus the adjacent slot on the same screen
--     (i.e. cycle between left/right).
--
-- Calls:
--   next_layout()
--   get_window_idx()
--   focus_window()
--   set_window_state()
--   util.toggle_popups()
--   util.toggle_border()
--------------------------------------------------------------------------------
function M.traverse_slots(direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    return function(done)
        done = done or function() end

        local reverse     = direction == 'prev'
        local screen_step = reverse and -1 or 1
        local slot_order  = reverse
            and { 'maximized', 'right', 'left' }
            or  { 'maximized', 'left', 'right' }

        local function next_layout(start_id, skip)
            local screens = hs.screen.allScreens()
            local start_idx

            for i, screen in ipairs(screens) do
                if screen:id() == start_id then
                    start_idx = i

                    break
                end
            end

            if not start_idx then
                return
            end

            -- Search every other screen, starting with the adjacent one
            for step = 1, #screens - 1 do
                local idx       = (start_idx - 1 + step * screen_step) % #screens + 1
                local screen_id = screens[idx]:id()
                local layout    = state.screens[screen_id].layout

                for _, name in ipairs(slot_order) do
                    if layout[name] then
                        local slot = layout[name]

                        if slot ~= skip and slot:screen():id() == screen_id then
                            return slot
                        end
                    end
                end
            end
        end

        local win       = state.windows.curr_win
        local screen_id = win:screen():id()
        local slot      = state.screens[screen_id].layout

        local target_slot

        -- Maximized (always traverse to another screen)
        if slot.maximized == win then
            target_slot = next_layout(screen_id, win)

        -- Left
        elseif slot.left == win then
            if reverse then
                target_slot = next_layout(screen_id, win) or slot.right
            else
                target_slot = slot.right or next_layout(screen_id, win)
            end

        -- Right
        elseif slot.right == win then
            if not reverse then
                target_slot = next_layout(screen_id, win) or slot.left
            else
                target_slot = slot.left or next_layout(screen_id, win)
            end
        end

        if not target_slot then
            done()
            return
        end

        local win_idx = get_window_idx(state.windows.wins, target_slot)
        local new_win = focus_window(target_slot)

        if new_win then
            set_window_state(new_win, win_idx)

            util.toggle_popups('off', 'on')
            util.toggle_border('off', 'on')
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle between all open windows.
--
-- Parameters:
--   direction (string):  'next' or 'prev'
--
-- Calls:
--   iterate_window_idx()
--   focus_window()
--   set_window_state()
--   set_slots()
--   util.toggle_popups()
--   util.toggle_border()
--------------------------------------------------------------------------------
function M.cycle_open(direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    return function(done)
        done = done or function() end

        local wins = state.windows.wins

        if #wins < 2 then
            done()
            return
        end

        local idx = iterate_window_idx('all', direction)
        local win = focus_window(wins[idx])

        if win then
            set_window_state(win, idx)
            set_slots(win)

            util.toggle_popups('off', 'on')
            util.toggle_border('off', 'on')
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle between the currently focused apps open windows.
--
-- Parameters:
--   direction (string):  'next' or 'prev'
--
-- Calls:
--   iterate_window_idx()
--   focus_window()
--   get_window_idx()
--   set_window_state()
--   util.toggle_border()
--------------------------------------------------------------------------------
function M.cycle_app_specific(direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    return function(done)
        done = done or function() end

        local app_name = state.windows.curr_win:application():name()
        local curr_app = state.apps[app_name]

        if not curr_app or #curr_app.wins < 2 then
            done()
            return
        end

        local idx = iterate_window_idx(app_name, direction)
        local win = focus_window(curr_app.wins[idx])

        if win then
            -- Need to set this to the index of the 'windows' table because
            -- we use the app specific index table to iterate the window
            -- within the same app group.
            idx = get_window_idx(state.windows.wins, win)

            set_window_state(win, idx)
            util.toggle_border('on')
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle between all running applications (i.e. cmd tab).
--
-- Parameters:
--   direction (string):  'next' or 'prev'
--
-- Calls:
--   get_window_idx()
--   set_window_state()
--   set_slots()
--   util.toggle_popups()
--   util.toggle_border()
--------------------------------------------------------------------------------
function M.cycle_all_apps(direction)
    assert(
        direction == 'next' or direction == 'prev',
        "direction must be 'next' or 'prev'"
    )

    return function(done)
        done = done or function() end

        local curr_app = state.windows.curr_win:application()
        local apps     = state.apps.list
        local count    = #apps
        local app_idx  = 0

        for i, v in ipairs(apps) do
            if v:name() == curr_app:name() then
                if direction == 'next' then
                    app_idx = i % count + 1
                elseif direction == 'prev' then
                    app_idx = (i - 2) % count + 1
                end

                break
            end
        end

        local target_app = apps[app_idx]

        hs.application.launchOrFocus(target_app:name())
        hs.timer.usleep(10000)

        local win = target_app:focusedWindow()

        if win then
            local idx = get_window_idx(state.windows.wins, win)

            set_window_state(win, idx)
            set_slots(win)

            util.toggle_popups('off', 'on')
            util.toggle_border('off', 'on')
        end

        done()
    end
end


--------------------------------------------------------------------------------
-- Cycle focus between main apps (kitty and Brave).
--
-- Calls:
--   get_window_idx()
--   set_window_state()
--   set_slots()
--   util.toggle_popups()
--   util.toggle_border()
--------------------------------------------------------------------------------
function M.cycle_main_apps()
    return function(done)
        done = done or function() end

        local win = state.windows.curr_win

        local target_app = 'kitty'

        if win and win:application():name() == 'kitty' then
            target_app = 'Brave Browser'
        end

        local wf = hs.window.filter.new(target_app)

        wf:subscribe(
            hs.window.filter.windowFocused,
            function(target_win)
                wf:unsubscribeAll()
                wf = nil

                local idx = get_window_idx(state.windows.wins, target_win)

                set_window_state(target_win, idx)
                set_slots(target_win)

                util.toggle_popups('off', 'on')
                util.toggle_border('off', 'on')

                done()
            end
        )

        hs.application.launchOrFocus(target_app)
    end
end


--------------------------------------------------------------------------------
-- Init module.
--
-- Calls:
--   get_window_idx()
--   clear_slots()
--   set_empty_slots()
--   snap_layout()
--
-- State changes:
--   state.windows
--------------------------------------------------------------------------------
function M.init()
    local focused_win = hs.window.focusedWindow()

    -- Kind of a hack. This prevents breakage when closing the last open window
    -- of an application without quitting the app.
    if not focused_win then
        for _, app in ipairs(state.apps.list) do
            for _, win in ipairs(state.apps[app:name()].wins) do
                if win then
                    win:application():activate()
                    focused_win = win

                    break
                end
            end
        end
    end

    local window_data = {
        curr_win = focused_win,
        idx      = 1,
        wins     = {},
    }

    for _, app in ipairs(state.apps.list) do
        for _, win in ipairs(state.apps[app:name()].wins) do
            table.insert(window_data.wins, win)
        end
    end

    if #window_data.wins > 0 then
        state.windows = window_data

        -- Establish 'all' idx from the currently focused window
        state.windows.idx = get_window_idx(
            state.windows.wins,
            state.windows.curr_win
        )

        for _, screen in ipairs(hs.screen.allScreens()) do
            clear_slots(screen:id())
            set_empty_slots(screen:id())
        end

        snap_layout()
    end
end

return M
