------------
-- TEST 2 --
------------
--
-- NOTE: win:application():activate() (or maybe some other method) is required
-- for the app to take focus AXRaise, AXFocused, or AXMain can't focus the app
-- on their own.
--
-- TODO: play around with this
--     local win = app:focusedWindow() or app:allWindows()[1]
--
local function test_force_focus(win)
    local ax = hs.axuielement.windowElement(win)

    if not ax then
        return false
    end

    print(
        '\n________ BEFORE ________' ..
        '\nAXMain:    ' .. tostring(ax:attributeValue('AXMain'))
    )

    win:application():activate()

    ax:performAction('AXRaise')
    ax:setAttributeValue('AXMain', true)

    local focused = hs.window.focusedWindow()

    print(
        '\n________ AFTER ________\n' ..
        '\nAXMain:    ' .. tostring(ax:attributeValue('AXMain')) ..
        '\nHS focused:', focused and focused:id(),
        '\ntarget:    ', win:id() .. '\n'
    )

    if focused and focused:id() == win:id() then
        return true
    end

    return false
end

-- 2026-08-18 22:19:30:
-- ________ BEFORE ________
-- AXMain:    false
-- 2026-08-18 22:19:30:
-- ________ AFTER ________
--
-- AXMain:    true
-- HS focused:  27837
-- target:      27837
--
-- 2026-08-18 22:19:30:
-- ________ BEFORE ________
-- AXMain:    true
-- 2026-08-18 22:19:30:
-- ________ AFTER ________
--
-- AXMain:    true
-- HS focused:  26548
-- target:      26548
--
-- 2026-08-18 22:19:31:
-- ________ BEFORE ________
-- AXMain:    true
-- 2026-08-18 22:19:31:
-- ________ AFTER ________
--
-- AXMain:    true
-- HS focused:  20620
-- target:      20620
--
-- 2026-08-18 22:19:31:
-- ________ BEFORE ________
-- AXMain:    false
-- 2026-08-18 22:19:31:
-- ________ AFTER ________
--
-- AXMain:    true
-- HS focused:  26970
-- target:      26970



--------------------------------------------------------------------------------



------------
-- TEST 1 --
------------
local function test_force_focus(win)
    local ax = hs.axuielement.windowElement(win)

    if not ax then
        return false
    end

    print(
        '\n________ BEFORE ________' ..
        '\nAXMain:    ' .. tostring(ax:attributeValue('AXMain')) ..
        '\nAXFocused: ' .. tostring(ax:attributeValue('AXFocused')) .. '\n'
    )

    win:application():activate()

    ax:performAction('AXRaise')
    ax:setAttributeValue('AXMain', true)
    ax:setAttributeValue('AXFocused', true)

    local focused = hs.window.focusedWindow()

    print(
        '\n________ AFTER ________\n' ..
        '\nAXMain:    ' .. tostring(ax:attributeValue('AXMain')) ..
        '\nAXFocused: ' .. tostring(ax:attributeValue('AXFocused')) .. '\n' ..
        '\nHS focused:', focused and focused:id(),
        '\ntarget:    ', win:id() .. '\n'
    )

    if focused and focused:id() == win:id() then
        return true
    end

    return false
end

-- 2026-08-18 22:03:00:
-- ________ BEFORE ________
-- AXMain:    true
-- AXFocused: false
--
-- 2026-08-18 22:03:00:
-- ________ AFTER ________
--
-- AXMain:    true
-- AXFocused: false
--
-- HS focused: 26548
-- target:     26548
--
-- 2026-08-18 22:03:02:
-- ________ BEFORE ________
-- AXMain:    true
-- AXFocused: false
--
-- 2026-08-18 22:03:02:
-- ________ AFTER ________
--
-- AXMain:    true
-- AXFocused: false
--
-- HS focused: 20620
-- target:     20620
--
--
-- ERROR OCCURS ON THE NEXT ITERATION (or maybe the previous one)
--
--
-- 2026-08-18 22:03:02:
-- ________ BEFORE ________
-- AXMain:    false
-- AXFocused: false
--
-- 2026-08-18 22:03:02:
-- ________ AFTER ________
--
-- AXMain:    false
-- AXFocused: false
--
-- HS focused: 26970
-- target:     27837
-- 2026-08-18 22:03:13:
-- ________ BEFORE ________
-- AXMain:    false
-- AXFocused: false
--
-- 2026-08-18 22:03:13:
-- ________ AFTER ________
--
-- AXMain:    true
-- AXFocused: false
--
-- HS focused:  27837
-- target:      27837






-- Need to store certain macOS default key combos in the system table
-- i.e.
--
-- cmd + n
-- cmd + w
-- cmd + t ? (can bind kitty split open to cmd + t)
-- cmd + t


-- When multiple windows of the same app are open, hs.window:focus() can fail to raise the intended target.
-- This happens because macOS accessibility APIs sometimes misinterpret requests for background windows,
-- defaulting focus back to the app's currently active window on your main screen.Why the Bug HappensmacOS
-- Focus Restrictions: The operating system tightly controls application activation, making it difficult to
-- force-focus a non-key window belonging to an already active app.API Confusion: Hammerspoon calls native
-- accessibility hooks that can target the parent application process rather than the specific window UUID
-- if another window from that same app is already frontmost.How to Fix or Workaround ItRaise Application
-- First: Bring the application layer forward using hs.application:activate() before calling the focus
-- method on the specific window object.Raise the Window Explicitly: Use win:raise() right before or alongside
-- win:focus() to force the window server to redraw and elevate the specific frame.Alternative Scripting Logic:
-- Loop through the target application's windows array cleanly instead of relying on a raw single-line :focus() command.


-- local ax = hs.axuielement.windowElement(win)
-- local name = win:application():name()
-- print(name .. ' attributeNames: ' .. hs.inspect(ax:attributeNames()))
-- print(name .. ' actionNames: ' .. hs.inspect(ax:actionNames()))

-- Hammerspoon attributeNames: {
--     "AXFocused",
--     "AXFullScreen",
--     "AXTitle",
--     "AXChildrenInNavigationOrder",
--     "AXFrame",
--     "AXPosition",
--     "AXGrowArea",
--     "AXMinimizeButton",
--     "AXDocument",
--     "AXSections",
--     "AXCloseButton",
--     "AXMain",
--     "AXActivationPoint",
--     "AXFullScreenButton",
--     "AXProxy",
--     "AXDefaultButton",
--     "AXMinimized",
--     "AXChildren",
--     "AXRole",
--     "AXParent",
--     "AXTitleUIElement",
--     "AXCancelButton",
--     "AXModal",
--     "AXSubrole",
--     "AXZoomButton",
--     "AXRoleDescription",
--     "AXSize",
--     "AXToolbarButton",
--     "AXIdentifier"
-- }
-- Hammerspoon actionNames: { "AXRaise" }

-- kitty attributeNames: {
--     "AXFocused",
--     "AXFullScreen",
--     "AXTitle",
--     "AXChildrenInNavigationOrder",
--     "AXFrame",
--     "AXPosition",
--     "AXGrowArea",
--     "AXMinimizeButton",
--     "AXDocument",
--     "AXSections",
--     "AXCloseButton",
--     "AXMain",
--     "AXActivationPoint",
--     "AXFullScreenButton",
--     "AXProxy",
--     "AXDefaultButton",
--     "AXMinimized",
--     "AXChildren",
--     "AXRole",
--     "AXParent",
--     "AXTitleUIElement",
--     "AXCancelButton",
--     "AXModal",
--     "AXSubrole",
--     "AXZoomButton",
--     "AXRoleDescription",
--     "AXSize",
--     "AXToolbarButton"
-- }
-- kitty actionNames: { "AXRaise" }

-- Brave Browser attributeNames: {
--     "AXFocused",
--     "AXFullScreen",
--     "AXTitle",
--     "AXChildrenInNavigationOrder",
--     "AXFrame",
--     "AXPosition",
--     "AXGrowArea",
--     "AXMinimizeButton",
--     "AXDocument",
--     "AXSections",
--     "AXCloseButton",
--     "AXMain",
--     "AXActivationPoint",
--     "AXFullScreenButton",
--     "AXProxy",
--     "AXDefaultButton",
--     "AXMinimized",
--     "AXChildren",
--     "AXRole",
--     "AXParent",
--     "AXTitleUIElement",
--     "AXCancelButton",
--     "AXModal",
--     "AXSubrole",
--     "AXZoomButton",
--     "AXRoleDescription",
--     "AXSize",
--     "AXToolbarButton"
-- }
-- Brave Browser actionNames: { "AXRaise" }
