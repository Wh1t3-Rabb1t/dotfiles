local M = {}

local state = require('state')


--------------------------------------------------------------------------------
-- Debug currently filled layout slots for each screen.
--------------------------------------------------------------------------------
function M.slot_data()
    for _, screen in ipairs(hs.screen.allScreens()) do
        local layout = state.screens[screen:id()].layout

        if layout.left      then print('left: ' .. layout.left:title())     end
        if layout.right     then print('right: ' .. layout.right:title())   end
        if layout.maximized then print('max: ' .. layout.maximized:title()) end
    end
end


--------------------------------------------------------------------------------
-- Benchmark function(s) execution time.
--
-- Usage:
--   benchmark('somename', function()
--       screens.init()
--       windows.init()
--       ...
--   end)
--------------------------------------------------------------------------------
function M.benchmark(name, fn)
    local start = hs.timer.absoluteTime()

    fn()

    local elapsed = hs.timer.absoluteTime() - start
    local ms      = elapsed / 1e9

    print(string.format("%s: %.3f ms", name, ms))
end

return M

