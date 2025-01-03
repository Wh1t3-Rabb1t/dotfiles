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

-- See:
-- https://dotfyle.com/neovim/configurations/top
-- https://dotfyle.com/neovim/configurations/top?page=1&plugins=hrsh7th%2Fnvim-cmp
-- https://thevaluable.dev/vim-runtime-guide-example/
-- https://dev.to/vonheikemen/lazynvim-how-to-revert-a-plugin-back-to-a-previous-version-1pdp


-- USER SETTINGS
--------------------------------------------------------------------------------
require("user.auto_cmds")
require("user.keymaps")
require("user.options")


-- BOOTSTRAP LAZY
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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


-- SETUP LAZY
--------------------------------------------------------------------------------
require("lazy").setup({
    spec = {
        -- Import your plugins
        { import = "plugins" },
    },

    -- Configure any other settings here, see the documentation for more details
    defaults = {
        lazy = true,    -- Lazy loading
        version = nil,  -- Set "*" to install the latest stable versions of plugins

        -- Default "cond" you can use to globally disable a lot of plugins
        -- when running inside vscode for example
        cond = nil,  -- @type boolean|fun(self:LazyPlugin):boolean|nil
    },

    -- Colorscheme that will be used when installing plugins
    install = { colorscheme = { "catppuccin" } },

    -- Automatically check for plugin updates
    checker = {
        enabled = true,
        concurrency = nil,     -- Set to 1 to check for updates very slowly
        notify = true,         -- Get a notification when new updates are found
        frequency = 3600,      -- Check for updates every hour
        check_pinned = false,  -- Check for pinned packages that can't be updated
    },

    dev = {
        -- Directory where you store your local plugin projects
        path = "~/workspace/nvim-plugins",
        -- @type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {},     -- For example { "folke" }
        fallback = false,  -- Fallback to git when local plugin doesn't exist
    },

    -- Automatically check for config file changes and reload the ui
    change_detection = {
        enabled = false,
        notify = false,  -- Get a notification when changes are found
    },

    performance = {
        cache = {
            enabled = true
        },
        reset_packpath = true,    -- Reset the package path to improve startup time

        rtp = {
            reset = true,         -- Reset the runtime path to $VIMRUNTIME and your config directory
            -- @type string[]
            paths = {},           -- Add any custom paths here that you want to includes in the rtp

            -- @type string[] list any plugins you want to disable here
            disabled_plugins = {  -- Don't disable "man" for use of the MANPAGER from zsh
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
