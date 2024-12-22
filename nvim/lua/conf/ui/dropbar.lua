--       _                 _
--    __| |_ __ ___  _ __ | |__   __ _ _ __
--   / _` | '__/ _ \| '_ \| '_ \ / _` | '__|
--  | (_| | | | (_) | |_) | |_) | (_| | |
--   \__,_|_|  \___/| .__/|_.__/ \__,_|_|
-- =================|_|=========================================================

local M = {}

-- KEYS
--------------------------------------------------------------------------------
M.keys = {
    {
        mode = { "n" },
        "<Home>",
        function() require("dropbar.api").pick() end,
        desc = "Focus DropBar menu"
    }
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "dropbar")
    if not status_ok then return end

    -- Modified version of https://github.com/Bekaboo/dropbar.nvim/issues/2#issuecomment-1568244312
    local function bar_background_color_source()
        vim.api.nvim_set_hl(0, "WinBar", { bg = "#45475a", bold = true })

        local function set_highlight_take_foreground(opts, source_hl, target_hl)
            if target_hl == nil then
                target_hl = source_hl
            end
            local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(source_hl)), "fg#")

            if fg == "" then
                vim.api.nvim_set_hl(0, target_hl, opts)
            else
                vim.api.nvim_set_hl(0, target_hl, vim.tbl_extend("force", opts, { fg = fg }))
            end
        end

        local function color_symbols(symbols, opts)
            for _, symbol in ipairs(symbols) do
                local source_hl = symbol.icon_hl
                symbol.icon_hl = "DropbarSymbol" .. symbol.icon_hl
                symbol.name_hl = symbol.icon_hl
                set_highlight_take_foreground(opts, source_hl, symbol.icon_hl)
            end
            return symbols
        end

        return {
            get_symbols = function(buf, win, cursor)
                -- Use the background of the WinBar highlight group
                local opts = { bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("WinBar")), "bg#") }
                set_highlight_take_foreground(opts, "DropBarIconUISeparator")
                set_highlight_take_foreground(opts, "DropBarIconUIPickPivot")

                local sources = require("dropbar.sources")

                if vim.bo[buf].ft == "markdown" then
                    return color_symbols(sources.markdown.get_symbols(buf, win, cursor), opts)
                end

                if vim.bo[buf].ft == "terminal" then
                    return color_symbols(sources.terminal.get_symbols(buf, win, cursor), opts)
                end

                for _, source in ipairs({ sources.lsp, sources.treesitter }) do
                    local symbols = source.get_symbols(buf, win, cursor)
                    if not vim.tbl_isempty(symbols) then
                        return color_symbols(symbols, opts)
                    end
                end
                return {}
            end
        }
    end

    -- Setup
    require("dropbar").setup({
        bar = {
            update_debounce = 50,  -- Throttle refresh rate for performance (ms)
            sources = function(_, _)
                return { bar_background_color_source() }
            end,
            pick = {
                pivots = "asdfghtkl;yxcvbwerjzuio",
            }
        },
        menu = {
            keymaps = {
                ["i"] = false,
            }
        }
    })
end

return M
