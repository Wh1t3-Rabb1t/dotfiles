--                                     _           _        _ _
--   _ __ ___   __ _ ___  ___  _ __   (_)_ __  ___| |_ __ _| | | ___ _ __
--  | '_ ` _ \ / _` / __|/ _ \| '_ \  | | '_ \/ __| __/ _` | | |/ _ \ '__|
--  | | | | | | (_| \__ \ (_) | | | | | | | | \__ \ || (_| | | |  __/ |
--  |_| |_| |_|\__,_|___/\___/|_| |_| |_|_| |_|___/\__\__,_|_|_|\___|_|
-- =============================================================================

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "mason-tool-installer")
    if not status_ok then return end

    -- Setup
    require("mason-tool-installer").setup({
        ensure_installed = {
            -- Lua
            "lua-language-server",         -- Language server
            "luacheck",                    -- Linter (maintainer passed away RIP)
            "stylua",                      -- Formatter

            -- Shell
            "bash-language-server",        -- Language server
            "shellcheck",                  -- Linter
            "shfmt",                       -- Formatter

            -- Go
            "gopls",                       -- Language server
            "golangci-lint",               -- Linter
            "delve",                       -- Debugger

            -- JS
            "typescript-language-server",  -- Language server
            "emmet-language-server",       -- Language server

            -- CSS
            "css-lsp",                     -- Language server

            -- HTML
            "html-lsp",                    -- Language server

            -- JSON
            "json-lsp",                    -- Language server

            -- "prettier", -- formatter
            -- "eslint-lsp", -- linter
            -- "stylelint", -- linter
            -- "editorconfig-checker",
            -- "gofumpt",
            -- "golines",
            -- "gomodifytags",
            -- "gotests",
            -- "impl",
            -- "json-to-struct",
            -- "revive",
            -- "staticcheck",
        },

        -- If set to true this will check each tool for updates. If updates
        -- are available the tool will be updated. This setting does not
        -- affect :MasonToolsUpdate or :MasonToolsInstall.
        -- Default: false
        auto_update = false,

        -- Automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use :MasonToolsInstall or
        -- :MasonToolsUpdate to install tools and check for updates.
        -- Default: true
        run_on_start = true,

        -- Set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 3000,  -- 3 second delay

        -- Only attempt to install if 'debounce_hours' number of hours has
        -- elapsed since the last time Neovim was started. This stores a
        -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
        -- This is only relevant when you are using 'run_on_start'. It has no
        -- effect when running manually via ':MasonToolsInstall' etc....
        -- Default: nil
        debounce_hours = 0,  -- At least 5 hours between attempts to install/update

        -- By default all integrations are enabled. If you turn on an integration
        -- and you have the required module(s) installed this means you can use
        -- alternative names, supplied by the modules, for the thing that you want
        -- to install. If you turn off the integration (by setting it to false) you
        -- cannot use these alternative names. It also suppresses loading of those
        -- module(s) (assuming any are installed) which is sometimes wanted when
        -- doing lazy loading.
        integrations = {
            ["mason-lspconfig"] = true,
            ["mason-null-ls"] = false,
            ["mason-nvim-dap"] = true,
        }
    })
end

return M
