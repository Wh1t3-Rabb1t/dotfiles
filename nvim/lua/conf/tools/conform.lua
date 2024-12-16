--                    __
--    ___ ___  _ __  / _| ___  _ __ _ __ ___
--   / __/ _ \| '_ \| |_ / _ \| '__| '_ ` _ \
--  | (_| (_) | | | |  _| (_) | |  | | | | | |
--   \___\___/|_| |_|_|  \___/|_|  |_| |_| |_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "conform")
    if not status_ok then return end

    -- Create `Format` user command
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({
            async = true,
            lsp_fallback = false,
            range = range
        })
    end, { range = true })

    -- Setup
    require("conform").setup({
        formatters_by_ft = {
            -- Conform will run multiple formatters sequentially
            -- python = { "isort", "black" },
            -- Use a sub-list to run only the first available formatter
            -- python = { { "isort", "black" } },

            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            go = { "gofmt" },
        }
    })
end

return M
