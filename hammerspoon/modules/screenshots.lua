local M = {}

local screenshot_dir = os.getenv('HOME') .. '/Desktop/screenshots/'

local function sanitize_name(path)
    return path:gsub("%s+", "-")
end

function M.move_screenshots(files)
    for _, file in ipairs(files) do
        if file:match("Screenshot") then
            hs.timer.doAfter(0.5, function()
                local new_file = sanitize_name(file)

                if os.rename(file, new_file) then
                    local destination = screenshot_dir .. new_file:match("([^/]+)$")
                    os.rename(new_file, destination)
                end
            end)
        end
    end
end

function M.init()
    M.watcher = hs.pathwatcher.new(
        os.getenv('HOME') .. '/Desktop/',
        M.move_screenshots
    )

    M.watcher:start()
end

return M
