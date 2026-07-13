local M = {}

-- Automatically move screenshots to the notes/images folder
function M.move_screenshots(files)
    local home = os.getenv('HOME')
    local screenshot_dir = home .. '/Desktop/screenshots/'

    for _,file in ipairs(files) do
        if file:match('Screenshot') then
            -- Rename the file to remove spaces
            local new_file_name = file:gsub("%s+", "-")
            os.rename(file, new_file_name)

            -- Move the file to the specified directory
            hs.execute("mv '" .. new_file_name .. "' " .. screenshot_dir)
        end
    end
end

function M.init()
     local screenshot_watcher = hs.pathwatcher.new('/Users/tillcappel/Desktop/', M.move_screenshots)
     screenshot_watcher:start()
end

return M



-- hs.execute("mv '" .. new_file_name .. "' /Users/tillcappel/Desktop/screenshots/")
-- -- Watch the desktop for new screenshots
-- moveSC = hs.pathwatcher.new('/Users/tillcappel/Desktop/', move_screenshots):start()
--
-- -- Copy the file name to clipboard
-- hs.execute("echo '" .. file .. "' | pbcopy")
