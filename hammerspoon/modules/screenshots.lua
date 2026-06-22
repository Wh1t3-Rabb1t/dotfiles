local M = {}

-- Automatically move screenshots to the notes/images folder
function M.move_screenshots(files)
    for _,file in ipairs(files) do
        if file:match('Screenshot') then
            -- Rename the file to remove spaces
            local newFilename = file:gsub("%s+", "-")
            os.rename(file, newFilename)

            -- Move the file to the specified directory
            hs.execute("mv '" .. newFilename .. "' /Users/tillcappel/Desktop/SWE-Projects/Notes/images/")

            -- Copy filename to the clipboard and format it for markdown preview in VSCode
            local filename = newFilename:match(".+/([^/]+)")
            hs.pasteboard.setContents("![Alt text](images/" .. filename .. ")")
        end
    end
end

return M

-- -- Watch the desktop for new screenshots
-- moveSC = hs.pathwatcher.new('/Users/tillcappel/Desktop/', move_screenshots):start()
--
-- -- Copy the file name to clipboard
-- hs.execute("echo '" .. file .. "' | pbcopy")
