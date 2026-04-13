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

-- Add servers to PATH
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH


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
    spec = { { import = "plugins" } },
    defaults = { lazy = true },                   -- Lazy load plugins
    install = { colorscheme = { "catppuccin" } }, -- Lazy ui colorscheme
    checker = { enabled = true },                 -- Auto check for updates
    dev = { path = "~/workspace/nvim-plugins" },  -- Plugin development dir
    change_detection = { enabled = false },       -- Hot reload on config change
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
