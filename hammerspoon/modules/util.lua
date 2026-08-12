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

return M
