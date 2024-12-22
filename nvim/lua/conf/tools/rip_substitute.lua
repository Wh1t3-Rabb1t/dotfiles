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
        mode = { "n", "x" },
        "<A-r>",
        function() require("rip-substitute").sub() end,
        desc = "Rip Substitute",
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
            border = "single",
            matchCountHlGroup = "Keyword",
            noMatchHlGroup = "ErrorMsg",
            hideSearchReplaceLabels = false,
            position = "top",  -- top, bottom
        },
        prefill = {
            normal = "cursorWord",          -- "cursorWord", or false
            visual = "selectionFirstLine",  -- Cannot be false
            startInReplaceLineIfPrefill = true,
            alsoPrefillReplaceLine = false,
        },
        keymaps = {  -- Normal & visual mode, if not stated otherwise
            abort = "q",
            confirm = "<A-r>",
            insertModeConfirm = "<A-r>",
            prevSubst = "<Up>",
            nextSubst = "<Down>",
            toggleFixedStrings = "<C-f>",  -- ripgrep's `--fixed-strings`
            toggleIgnoreCase = "<A-i>",    -- ripgrep's `--ignore-case`
            openAtRegex101 = "R",
        },
        incrementalPreview = {
            matchHlGroup = "IncSearch",
            rangeBackdrop = {
                enabled = true,
                blend = 50,  -- Between 0 and 100
            }
        },
        regexOptions = {
            startWithFixedStringsOn = false,
            startWithIgnoreCase = false,
            -- pcre2 enables lookarounds and backreferences, but performs slower
            pcre2 = true,
            -- Disable if you use named capture groups (see README for details)
            autoBraceSimpleCaptureGroups = true,
        },
        editingBehavior = {
            -- When typing `()` in the `search` line, automatically adds `$n`
            -- to the `replace` line.
            autoCaptureGroups = false,
        },
        notification = {
            onSuccess = true,
            icon = "",
        }
    }
end

return M
