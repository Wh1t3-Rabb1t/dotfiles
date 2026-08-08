local M = {}

-- Sanitize screenshot name, leaving only alphanumeric chars
--------------------------------------------------------------------------------
local function sanitize_name(path)
    return path:gsub("%s+", "-")
end


-- Rename screenshot (move)
--------------------------------------------------------------------------------
local function rename_screenshot(file, new_file)
    if os.rename(file, new_file) then
        local screenshot_dir = os.getenv('HOME') .. '/Desktop/screenshots/'
        local destination    = screenshot_dir .. new_file:match("([^/]+)$")

        os.rename(new_file, destination)
    end
end


--------------------------------------------------------------------------------
-- Move screenshots to target directory
--------------------------------------------------------------------------------
function M.move_screenshots(files)
    for _, file in ipairs(files) do
        if file:match('Screenshot') then
            hs.timer.doAfter(0.5, function()
                local new_file = sanitize_name(file)

                rename_screenshot(file, new_file)
            end)
        end
    end
end

return M
