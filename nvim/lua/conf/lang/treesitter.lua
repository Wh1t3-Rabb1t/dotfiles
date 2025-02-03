--   _                      _ _   _
--  | |_ _ __ ___  ___  ___(_) |_| |_ ___ _ __
--  | __| '__/ _ \/ _ \/ __| | __| __/ _ \ '__|
--  | |_| | |  __/  __/\__ \ | |_| ||  __/ |
--   \__|_|  \___|\___||___/_|\__|\__\___|_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "nvim-treesitter")
    if not status_ok then return end

    -- Setup
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "c",
            "cpp",
            "go",
            "lua",
            "python",
            "markdown",
            "markdown_inline",
            "bash",
            "gitignore",
            "dockerfile",
            "rust",
            "tsx",
            "html",
            "css",
            "json",
            "hjson",
            "javascript",
            "typescript",
            "vimdoc",
            "vim",
            "yaml",
            "toml",
            "regex",
        },

        auto_install = false,  -- Auto-install languages that are not installed
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        autopairs = { enable = true },

        -- Expand selection
        textsubjects = {
            enable = true,
            prev_selection = "R",
            keymaps = {
                ["W"] = "textsubjects-smart",
            }
        }
    })
end

return M
