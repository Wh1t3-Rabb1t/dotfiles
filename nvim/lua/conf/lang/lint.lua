--   _ _       _
--  | (_)_ __ | |_
--  | | | '_ \| __|
--  | | | | | | |_
--  |_|_|_| |_|\__|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "lint")
    if not status_ok then return end

    -- Setup
    local lint = require("lint")
    lint.linters_by_ft = {
        lua = { "luacheck" },
        go = { "golangcilint" },
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        -- svelte = { "eslint_d" },
    }
    lint.linters.luacheck.args = { "--config" }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
            lint.try_lint()
        end
    })

    -- Show linters for the current buffer's file type
    vim.api.nvim_create_user_command("LintInfo", function()
        local filetype = vim.bo.filetype
        local linters = require("lint").linters_by_ft[filetype]
        if linters then
            vim.notify("Active linter: " .. table.concat(linters, ", "), vim.log.levels.INFO)
        else
            vim.notify("No linters configured for: " .. filetype, vim.log.levels.WARN)
        end
    end, {})

end

return M
