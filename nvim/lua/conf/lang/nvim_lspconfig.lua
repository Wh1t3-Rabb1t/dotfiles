--              _             _                            __ _
--   _ ____   _(_)_ __ ___   | |___ _ __   ___ ___  _ __  / _(_) __ _
--  | '_ \ \ / / | '_ ` _ \  | / __| '_ \ / __/ _ \| '_ \| |_| |/ _` |
--  | | | \ V /| | | | | | | | \__ \ |_) | (_| (_) | | | |  _| | (_| |
--  |_| |_|\_/ |_|_| |_| |_| |_|___/ .__/ \___\___/|_| |_|_| |_|\__, |
-- ================================|_|==========================|___/===========

local M = {}

-- CONFIG
--------------------------------------------------------------------------------
function M.config()
    local status_ok = pcall(require, "lspconfig")
    if not status_ok then return end

    local lsp = require("lspconfig")

    -- Icons for diagnostic errors
    ----------------------------------------------------------------------------
    vim.fn.sign_define("DiagnosticSignError", {
        text =  " ",
        texthl = "DiagnosticSignError"
    })
    vim.fn.sign_define("DiagnosticSignWarn", {
        text = " ",
        texthl = "DiagnosticSignWarn"
    })
    vim.fn.sign_define("DiagnosticSignInfo", {
        text = " ",
        texthl = "DiagnosticSignInfo"
    })
    vim.fn.sign_define("DiagnosticSignHint", {
        text = "󱠂 ",
        texthl = "DiagnosticSignHint"
    })

    -- Bash
    ----------------------------------------------------------------------------
    lsp.bashls.setup({
        filetypes = {
            "bash",
            "sh",
            "zsh",
        }
    })

    -- Go
    ----------------------------------------------------------------------------
    lsp.gopls.setup({
        -- Disable semanticTokens
        on_init = function(client, _)
            if client.supports_method "textDocument/semanticTokens" then
                client.server_capabilities.semanticTokensProvider = nil
            end
        end
    })

    -- JS / HTML / CSS
    ----------------------------------------------------------------------------
    lsp.ts_ls.setup({})
    lsp.cssls.setup({})
    lsp.html.setup({})

    -- JSON
    ----------------------------------------------------------------------------
    lsp.jsonls.setup({
        filetypes = {
            "json",
            "hjson",
        }
    })

    -- Emmet
    ----------------------------------------------------------------------------
    lsp.emmet_language_server.setup({
        filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "svelte",
        }
    })

    -- Lua
    -- https://luals.github.io/wiki/settings/
    ----------------------------------------------------------------------------
    lsp.lua_ls.setup({
        settings = {
            Lua = {
                -- Make the language server recognize select undefined globals
                diagnostics = {
                    globals = {
                        "vim",
                        "hs",  -- Hammerspoon
                    }
                },
                runtime = {
                    version = "LuaJIT"
                },
                semantic = {
                    enable = false
                },
                telemetry = {
                    enable = false
                },
                workspace = {
                    -- Make language server aware of runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    }
                }
            }
        }
    })
end

return M
