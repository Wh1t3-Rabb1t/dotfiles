local M = {}

-- TODO: Start a hs.uielement.watcher on the target application.
--
-- hs.uielement.watcher.focusedWindowChanged
-- hs.uielement.watcher.mainWindowChanged
-- hs.uielement.watcher.applicationActivated
-- hs.uielement.watcher.applicationDeactivated
--
-- 'focusedWindowChanged' gives you the relevant child element.

-- OULINE:
function M.window_watcher(win)
    local app = hs.uielement.applicationElement(win:application())

    local watcher = app:newWatcher(function(element, event)
        print(
            'UI EVENT:',
            event,
            element and element:asHSWindow() and element:asHSWindow():id()
        )
    end)

    watcher:start({
        hs.uielement.watcher.applicationActivated,
        hs.uielement.watcher.mainWindowChanged,
        hs.uielement.watcher.focusedWindowChanged,
    })
end

-- NOTE 1:
----------
-- Instead of polling:
--     hs.window.focusedWindow()
--
-- Queue can advance when macOS actually emits:
--     focusedWindowChanged
--
-- Hammerspoon specifically notes that focusedWindowChanged can occur even when
-- the application itself isn't activated, so it is a distinct signal from
-- application activation.

-- NOTE 2:
----------
-- Shouldn't build the queue around frontmostApplication() becoming the synchronization point.
--
-- Instead investigate this hierarchy:
--     applicationActivated
--     ↓
--     mainWindowChanged
--     ↓
--     focusedWindowChanged
--     ↓
--     hs.window.focusedWindow()
--
-- And see what happens on a successful cross-app transition versus a failed one.

return M
