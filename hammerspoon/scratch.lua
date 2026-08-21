-- Switching between brave windows (using mouse clicks):
--------------------------------------------------------
-- 2026-08-20 19:36:20: UI EVENT:   AXFocusedWindowChanged
-- element =    hs.window: (99+) offlinekattpaccino - Twitch - Brave - Music (0x9086eddf8)  focused =   3661
--
-- 2026-08-20 19:36:20: UI EVENT:   AXMainWindowChanged
-- element =    hs.window: (99+) offlinekattpaccino - Twitch - Brave - Music (0x9086ed978)  focused =   3661
--
-- 2026-08-20 19:36:23: UI EVENT:   AXFocusedWindowChanged
-- element =    hs.window: Fix Window Watcher - Brave - Music (0x9086ef238) focused =   3551
--
-- 2026-08-20 19:36:23: UI EVENT:   AXMainWindowChanged
-- element =    hs.window: Fix Window Watcher - Brave - Music (0x9086ee478) focused =   3551
--
-- 2026-08-20 19:36:36: UI EVENT:   AXApplicationDeactivated
-- element =    hs.application: Brave Browser (0x908148338) focused =   652


-- Switching between a kitty and Brave window. (i.e. kitty, Brave, kitty, Brave):
---------------------------------------------------------------------------------
-- 2026-08-20 19:38:41: UI EVENT:   AXApplicationDeactivated
-- element =    hs.application: kitty (0x908095178) focused =   3551
--
-- 2026-08-20 19:38:43: UI EVENT:   AXApplicationActivated
-- element =    hs.application: kitty (0x9080960b8) focused =   3638
--
-- 2026-08-20 19:38:45: UI EVENT:   AXApplicationDeactivated
-- element =    hs.application: kitty (0x9080976b8) focused =   3551
--
-- 2026-08-20 19:38:46: UI EVENT:   AXApplicationActivated
-- element =    hs.application: kitty (0x9080952b8) focused =   3638
--
-- 2026-08-20 19:38:49: UI EVENT:   AXApplicationDeactivated
-- element =    hs.application: kitty (0x9081ebbf8) focused =   652

--------------------------------------------------------------------------------

print(hs.uielement)
print(hs.uielement.watcher)
print(hs.uielement.watcher.focusedWindowChanged)

local el = hs.uielement.focusedElement()
print(el)
print(el and el:isApplication())
print(el and el:isWindow())

-- 2026-08-20 19:00:34: -- Loading extension: uielement
-- 2026-08-20 19:00:34: table: 0x90815c100
-- 2026-08-20 19:00:34: table: 0x90815ff40
-- 2026-08-20 19:00:34: AXFocusedWindowChanged
-- 2026-08-20 19:00:34: hs.uielement: 0x90828b7b8
-- 2026-08-20 19:00:34: false
-- 2026-08-20 19:00:34: false

--------------------------------------------------------------------------------

-- Need to store certain macOS default key combos in the system table
-- i.e.
--
-- cmd + w
-- cmd + n
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
