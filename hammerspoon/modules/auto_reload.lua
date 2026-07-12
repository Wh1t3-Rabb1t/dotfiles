local M = {}

function M.hs_config(files)
    local do_reload = false

    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            do_reload = true
        end
    end
    if do_reload then
        hs.reload()
    end
end

return M
