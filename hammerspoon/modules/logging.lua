local M = {}

-- NOTE: Only certain AX attributes are actually settable.
----------------------------------------------------------
--
-- local ax = hs.axuielement.windowElement(win)
-- print(tostring(win:application():name()), 'AXMain settable:', ax:isAttributeSettable('AXMain'))
-- print(tostring(win:application():name()), 'AXFocused settable:', ax:isAttributeSettable('AXFocused'))
--
-- 2026-08-19 22:46:27: Hammerspoon   - AXMain settable:    true
-- 2026-08-19 22:46:27: Hammerspoon   - AXFocused settable: false
-- 2026-08-19 22:46:30: Brave Browser - AXMain settable:    true
-- 2026-08-19 22:46:30: Brave Browser - AXFocused settable: false
-- 2026-08-19 22:46:32: kitty         - AXMain settable:    true
-- 2026-08-19 22:46:32: kitty         - AXFocused settable: false


-- Make a call before activation, immediately after activation, immediately
-- after AX operations, and after a verified focus event.
function M.focus_event(win, label)
    local app         = win:application()
    local front       = hs.application.frontmostApplication()
    local focused     = hs.window.focusedWindow()
    local app_focused = app:focusedWindow()
    local axapp       = hs.axuielement.applicationElement(app)
    local axwin       = hs.axuielement.windowElement(win)

    local function wid(w) return w and w:id()  or nil end
    local function pid(a) return a and a:pid() or nil end

    print(
        '\n========== ' .. label .. ' ==========' ..
        '\nTARGET WIN:       ' .. tostring(win:id()) ..
        '\nTARGET APP:       ' .. tostring(app:pid()) ..
        '\nFRONTMOST APP:    ' .. tostring(pid(front)) ..
        '\nHS FOCUSED WIN:   ' .. tostring(wid(focused)) ..
        '\nAPP FOCUSED WIN:  ' .. tostring(wid(app_focused)) ..
        '\nAX WIN MAIN:      ' .. tostring(axwin and axwin:attributeValue('AXMain')) ..
        '\nAX WIN FOCUSED:   ' .. tostring(axwin and axwin:attributeValue('AXFocused')) ..
        '\nAX APP FOCUSED:   ' .. tostring(axapp and axapp:attributeValue('AXFocusedWindow')) ..
        '\n'
    )
end

function M.ax_focused_window(win)
    local axapp      = hs.axuielement.applicationElement(win:application())
    local focused_ax = axapp:attributeValue('AXFocusedWindow')

    if focused_ax then
        local focused_win = focused_ax:asHSWindow()
        print('AX APP FOCUSED ID:', focused_win and focused_win:id())
    end
end


-- 1. Capture return values / errors from every AX operation.
-------------------------------------------------------------
-- local ok, err = ax:performAction('AXRaise')
-- print('AXRaise:', ok, err)
--
-- local ok2, err2 = ax:setAttributeValue('AXMain', true)
-- print('AXMain:', ok2, err2)
--
-- The hs.axuielement API returns success/error information for these operations.
-- Can check whether macOS is explicitly rejecting an operation or silently
-- accepting it and applying it later.


-- 2. Log window identity much more aggressively.
-------------------------------------------------
-- When cycling same-app windows, log:

function M.same_app_window_id(win)
    print(
        'id=   ', win:id(),
        'title=', win:title(),
        'app=  ', win:application():name(),
        'pid=  ', win:application():pid(),
        'frame=', hs.inspect(win:frame())
    )

    local focused = hs.window.focusedWindow()

    if focused then
        print(
            'FOCUSED:',
            focused:id(),
            focused:title(),
            focused:application():pid()
        )
    end
end

-- 3. Check isValid() on both hs.window and AX object.
------------------------------------------------------
-- Check before an operation:
--
-- print('HS valid:', win:isValid())
-- print('AX valid:', ax:isValid())
--
-- Hammerspoon explicitly notes that an AX element can become invalid
-- independently of your Lua reference.


-- 4. Log whether the target is actually visible/minimized.
-----------------------------------------------------------
-- A window could potentially be valid and known to the state table while not
-- being eligible to become the active window.
--
-- For each failure:

function M.window_visibility(win)
    print(
        'visible:  ', win:isVisible(),
        'minimized:', win:isMinimized(),
    )

    local app = win:application()

    print(
        'app focused: ', app:focusedWindow() and app:focusedWindow():id(),
        'visible wins:', #app:visibleWindows()
    )
end


-- 5. Log screen/Space information.
-----------------------------------

function M.screens_and_spaces(win)
    print('SCREEN:', win:screen() and win:screen():id())
    print('SPACES:', hs.inspect(win:spaces()))

    local focused = hs.window.focusedWindow()

    if focused then
        print('FOCUSED SCREEN:', focused:screen() and focused:screen():id())
        print('FOCUSED SPACES:', hs.inspect(focused:spaces()))
    end
end


-- 6. Log the exact event ordering.
-----------------------------------
-- Put a monotonically increasing sequence number on every operation:

local seq = 0

function M.log(...)
    seq = seq + 1
    print(string.format('[%04d]', seq), ...)
end

-- [0101] REQUEST focus 384
-- [0102] activate Brave
-- [0103] activate returned true
-- [0104] applicationActivated
-- [0105] AXRaise 384
-- [0106] AXMain 384
-- [0107] mainWindowChanged 384
-- [0108] focusedWindowChanged 384
-- [0109] hs.focusedWindow = 384
-- [0110] COMMIT state


-- 7. Minimum diagnostic payload for each focus attempt.
--------------------------------------------------------
--     REQUEST
--     target window ID
--     target app PID
--
--     AFTER ACTIVATE
--     activate return
--     frontmost PID
--
--     AFTER AX
--     AXRaise result
--     AXMain result
--     target AXMain
--     target AXFocused
--
--     CURRENT STATE
--     hs.window.focusedWindow ID
--     target app:focusedWindow ID
--     AX app:AXFocusedWindow ID
--
-- Plus the UI watcher events with sequence numbers.

return M
