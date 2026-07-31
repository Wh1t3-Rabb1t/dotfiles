local M = {}

local state = require('state')


-- Process action queue
--------------------------------------------------------------------------------
function M.queue(...)
    local jobs = { ... }

    for _, job in ipairs(jobs) do
        table.insert(state.action_queue.items, job)
    end

    if state.action_queue.running then
        return
    end

    state.action_queue.running = true

    local function next_job()
        local job = table.remove(state.action_queue.items, 1)

        if not job then
            state.action_queue.running = false
            return
        end

        job(next_job)
    end

    next_job()
end

return M
