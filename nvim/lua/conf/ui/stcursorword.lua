--       _                                                       _
--   ___| |_ ___ _   _ _ __ ___  ___  _ ____      _____  _ __ __| |
--  / __| __/ __| | | | '__/ __|/ _ \| '__\ \ /\ / / _ \| '__/ _` |
--  \__ \ || (__| |_| | |  \__ \ (_) | |   \ V  V / (_) | | | (_| |
--  |___/\__\___|\__,_|_|  |___/\___/|_|    \_/\_/ \___/|_|  \__,_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "stcursorword")
    if not status_ok then return end

    -- Setup
    require("stcursorword").setup({
        max_word_length = 100,
        min_word_length = 2,
        excluded = {
            filetypes = {
                "grapple",
                "neo-tree",
                "aerial",
                "rip-substitute"
            },
            buftypes = {
                -- "nofile",
                -- "terminal",
            },
            patterns = {  -- The pattern to match with the file path
                -- "%.png$",
                -- "%.jpg$",
                -- "%.jpeg$",
                -- "%.pdf$",
                -- "%.zip$",
                -- "%.tar$",
                -- "%.tar%.gz$",
                -- "%.tar%.xz$",
                -- "%.tar%.bz2$",
                -- "%.rar$",
                -- "%.7z$",
                -- "%.mp3$",
                -- "%.mp4$",
            }
        },
        highlight = {
            underline = true,
            bold = true,
            italic = false,
        }
    })
end

return M
