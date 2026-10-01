local M = {}

--------------------------------------------------------------------------------
-- Check if tables have been initialized
--------------------------------------------------------------------------------
function M.tbl(obj)
    local done = false

    if type(obj) == 'table' and next(obj) ~= nil then
        done = true
    end

    return done
end

--------------------------------------------------------------------------------
-- Benchmark function(s) execution time
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
