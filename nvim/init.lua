--   ,
--  / \               _   /\
--  \  \          ___(_) /  \        ____
--   \  \        /  /__ |    \      /    |
--    \  \      /  /|  ||     \    /     |
--     \  \    /  / |  ||  |\  \  /  /|  |
--      \  \  /  /  |  ||  | \  \/  / |  |
--       \  \/  /   |  ||  |  \    /  |  |
--        \    /    |  ||  |   \__/   |  |
--     Neo \  /     |__||__|           \ |
-- ======== \/ ======================== \| =====================================


-- USER SETTINGS
--------------------------------------------------------------------------------
require("user.auto_cmds")
require("user.keymaps")
require("user.options")


-- LSP
--------------------------------------------------------------------------------
local servers = {
    "lua_ls",
    "bashls",
    "jsonls",
    "tsserver",
    "emmet_ls",
    "html",
    "cssls",
}

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end


-- LAZY
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup
require("lazy").setup({
    -- Import your plugins
    spec = { { import = "plugins" } },

    -- Lazy load plugins
    defaults = { lazy = true },

    -- Colorscheme that will be used when installing plugins
    install = { colorscheme = { "catppuccin" } },

    -- Automatically check for plugin updates
    checker = { enabled = true },

    -- Dir where you store your local plugin projects
    dev = { path = "~/workspace/nvim-plugins" },

    -- Automatically check for config file changes and reload the ui
    change_detection = { enabled = false },

    performance = {
        rtp = {
            -- Don't disable "man" for use of the MANPAGER from zsh
            disabled_plugins = {
                "gzip",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            }
        }
    }
})
