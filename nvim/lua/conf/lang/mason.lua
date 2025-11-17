--
--   _ __ ___   __ _ ___  ___  _ __
--  | '_ ` _ \ / _` / __|/ _ \| '_ \
--  | | | | | | (_| \__ \ (_) | | | |
--  |_| |_| |_|\__,_|___/\___/|_| |_|
-- =============================================================================

local M = {}

-- ICONS
--------------------------------------------------------------------------------
local icons = {
    package_installed = "✓",
    package_pending = "➜",
    package_uninstalled = "✗",
}


-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "mason")
    if not status_ok then return end

    local options = {
        ensure_installed = {
            "lua-language-server",
            "luacheck",              -- Linter (maintainer passed away RIP)
            "stylua",                -- Formatter

            -- Shell
            "bash-language-server",  -- Language server
            "shellcheck",            -- Linter
            "shfmt",                 -- Formatter

            -- Go
            "gopls",                 -- Language server
            "golangci-lint",         -- Linter
            "delve",                 -- Debugger

            -- JSON
            "json-lsp",              -- Language server

            -- JS
            -- "typescript-language-server",  -- Language server
            -- "emmet-language-server",       -- Language server

            -- CSS
            -- "css-lsp",                     -- Language server

            -- HTML
            -- "html-lsp",                    -- Language server
        },
        max_concurrent_installers = 10,
        ui = {
            check_outdated_packages_on_open = true,
            border = "none",
            width = 0.8,
            height = 0.9,
            icons = {
                package_installed = icons.package_installed,
                package_pending = icons.package_pending,
                package_uninstalled = icons.package_uninstalled,
            },
            keymaps = {
                toggle_package_expand = "<CR>",       -- Expand a package
                install_package = "I",                -- Install package
                update_package = "u",                 -- Reinstall/update the package
                check_package_version = "c",          -- Check for new version of package
                update_all_packages = "U",            -- Update all installed packages
                check_outdated_packages = "C",        -- Check which installed packages are outdated
                uninstall_package = "X",              -- Uninstall package
                cancel_installation = "<C-c>",        -- Cancel package installation
                apply_language_filter = "<C-f>",      -- Apply language filter
                toggle_package_install_log = "<CR>",  -- Toggle viewing package installation log
                toggle_help = "?",                    -- Toggle help view
            }
        }
    }

    -- vim.system()

    require("mason").setup(options)

    vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
    end, {})

end

return M


-- -- Setup
-- require("mason").setup({
--     ui = {
--         check_outdated_packages_on_open = true,
--         border = "none",
--         width = 0.8,
--         height = 0.9,
--         icons = {
--             package_installed = icons.package_installed,
--             package_pending = icons.package_pending,
--             package_uninstalled = icons.package_uninstalled,
--         },
--         keymaps = {
--             toggle_package_expand = "<CR>",       -- Expand a package
--             install_package = "I",                -- Install package
--             update_package = "u",                 -- Reinstall/update the package
--             check_package_version = "c",          -- Check for new version of package
--             update_all_packages = "U",            -- Update all installed packages
--             check_outdated_packages = "C",        -- Check which installed packages are outdated
--             uninstall_package = "X",              -- Uninstall package
--             cancel_installation = "<C-c>",        -- Cancel package installation
--             apply_language_filter = "<C-f>",      -- Apply language filter
--             toggle_package_install_log = "<CR>",  -- Toggle viewing package installation log
--             toggle_help = "?",                    -- Toggle help view
--         }
--     }
-- })

