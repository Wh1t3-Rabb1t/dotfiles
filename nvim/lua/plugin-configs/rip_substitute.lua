--        _                   _         _   _ _         _
--   _ __(_)_ __    ___ _   _| |__  ___| |_(_) |_ _   _| |_ ___
--  | '__| | '_ \  / __| | | | '_ \/ __| __| | __| | | | __/ _ \
--  | |  | | |_) | \__ \ |_| | |_) \__ \ |_| | |_| |_| | ||  __/
--  |_|  |_| .__/  |___/\__,_|_.__/|___/\__|_|\__|\__,_|\__\___|
-- ========|_|==================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        desc = " Rip substitute",
        "<A-r>",
        function()
            -- Begin a vim substitute command if quickfix is focused
            if vim.bo.filetype == "qf" then
                vim.api.nvim_feedkeys(":%s/", "n", true)
            else
                require("rip-substitute").sub()
            end
        end,
        mode = { "n", "x" },
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "rip-substitute")
    if not status_ok then return end

    -- Setup
    require("rip-substitute").setup {
        popupWin = {
            title = "Rip-Substitute",
            position = "top",  -- (top|bottom)
        },
        prefill = {
            visual = "selectionFirstLine",  -- Cannot be false
            startInReplaceLineIfPrefill = true,
        },
        keymaps = {  -- Normal & visual mode, if not stated otherwise
            confirmAndSubstituteInBuffer = "<A-r>",
            insertModeConfirmAndSubstituteInBuffer = "<A-r>",
        }
    }
end

return M
