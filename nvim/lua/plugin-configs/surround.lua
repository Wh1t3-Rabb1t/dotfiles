--                                            _
--   ___ _   _ _ __ _ __ ___  _   _ _ __   __| |
--  / __| | | | '__| '__/ _ \| | | | '_ \ / _` |
--  \__ \ |_| | |  | | | (_) | |_| | | | | (_| |
--  |___/\__,_|_|  |_|  \___/ \__,_|_| |_|\__,_|
-- =============================================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {

    -- Change
    {                                     -- ''
        "<Leader>'",
        "<Plug>(nvim-surround-change)'",
        mode = { "n" },
        desc = " Change surrounding ''",
    },
    {                                     -- ""
        '<Leader>"',
        '<Plug>(nvim-surround-change)"',
        mode = { "n" },
        desc = ' Change surrounding ""',
    },
    {                                     -- ``
        "<Leader>`",
        "<Plug>(nvim-surround-change)`",
        mode = { "n" },
        desc = " Change surrounding ``",
    },
    {                                     -- {}
        "<Leader>{",
        "<Plug>(nvim-surround-change){",
        mode = { "n" },
        desc = " Change surrounding {}",
    },
    {                                     -- ()
        "<Leader>(",
        "<Plug>(nvim-surround-change)(",
        mode = { "n" },
        desc = " Change surrounding ()",
    },
    {                                     -- []
        "<Leader>[",
        "<Plug>(nvim-surround-change)[",
        mode = { "n" },
        desc = " Change surrounding []",
    },
    {                                     -- <>
        "<Leader><",
        "<Plug>(nvim-surround-change)<",
        mode = { "n" },
        desc = " Change surrounding <>",
    },

    -- Delete
    {                                     -- ''
        "<Leader>''",
        "<Plug>(nvim-surround-delete)'",
        mode = { "n" },
        desc = " Delete surrounding ''",
    },
    {                                     -- ""
        '<Leader>""',
        '<Plug>(nvim-surround-delete)"',
        mode = { "n" },
        desc = ' Delete surrounding ""',
    },
    {                                     -- ``
        "<Leader>``",
        "<Plug>(nvim-surround-delete)`",
        mode = { "n" },
        desc = " Delete surrounding ``",
    },
    {                                     -- {}
        "<Leader>{{",
        "<Plug>(nvim-surround-delete){",
        mode = { "n" },
        desc = " Delete surrounding {}",
    },
    {                                     -- ()
        "<Leader>((",
        "<Plug>(nvim-surround-delete)(",
        mode = { "n" },
        desc = " Delete surrounding ()",
    },
    {                                     -- []
        "<Leader>[[",
        "<Plug>(nvim-surround-delete)[",
        mode = { "n" },
        desc = " Delete surrounding []",
    },
    {                                     -- <>
        "<Leader><<",
        "<Plug>(nvim-surround-delete)<",
        mode = { "n" },
        desc = " Delete surrounding <>",
    },

    -- Add (visual mode)
    {                                     -- ''
        "'",
        "<Plug>(nvim-surround-visual)'",
        mode = { "v" },
        desc = " Add surrounding ''",
    },
    {                                     -- ""
        '"',
        '<Plug>(nvim-surround-visual)"',
        mode = { "v" },
        desc = ' Add surrounding ""',
    },
    {                                     -- ``
        "`",
        "<Plug>(nvim-surround-visual)`",
        mode = { "v" },
        desc = " Add surrounding ``",
    },
    {                                     -- {}
        "{",
        "<Plug>(nvim-surround-visual){",
        mode = { "v" },
        desc = " Add surrounding {}",
    },
    {                                     -- ()
        "(",
        "<Plug>(nvim-surround-visual)(",
        mode = { "v" },
        desc = " Add surrounding ()",
    },
    {                                     -- []
        "[",
        "<Plug>(nvim-surround-visual)[",
        mode = { "v" },
        desc = " Add surrounding []",
    },
    {                                     -- <>
        "<",
        "<Plug>(nvim-surround-visual)<",
        mode = { "v" },
        desc = " Add surrounding <>",
    }
}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "nvim-surround")
    if not status_ok then return end

    -- Setup
    require("nvim-surround").setup({
        -- Wrap content without adding spaces
        surrounds = {
            ["{"] = { add = { "{", "}" } },
            ["("] = { add = { "(", ")" } },
            ["["] = { add = { "[", "]" } },
            ["<"] = { add = { "<", ">" } },
        }
    })

    -- Prevent plugin from setting up bindings
    vim.keymap.del("n", "ys")
    vim.keymap.del("n", "ds")
    vim.keymap.del("n", "cs")

end

return M
