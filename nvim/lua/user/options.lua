--               _   _
--    ___  _ __ | |_(_) ___  _ __  ___
--   / _ \| '_ \| __| |/ _ \| '_ \/ __|
--  | (_) | |_) | |_| | (_) | | | \__ \
--   \___/| .__/ \__|_|\___/|_| |_|___/
-- =======|_|===================================================================

-- See: `:help vim.o`

local options = {
    -- A -----------------------------------------------------------------------
    autoindent = true,       -- Match indentation level when opening new lines

    -- B -----------------------------------------------------------------------
    backup = false,          -- Make a persistent backup before overwriting a file
    breakindent = true,      -- Wrapped lines match indentation level

    -- C -----------------------------------------------------------------------
    cmdheight = 1,           -- Command line height
    conceallevel = 0,        -- Make `` is visible in markdown files
    cursorline = true,       -- Highlight the current line
    cursorcolumn = false,    -- Highlight the current column

    -- E -----------------------------------------------------------------------
    equalalways = false,     -- Prevent window resizing when closing splits
    expandtab = true,        -- Convert tabs to spaces

    -- F -----------------------------------------------------------------------
    fileencoding = "utf-8",  -- The encoding written to a file
    fillchars = {
        eob = " ",           -- Hide the tildes on empty lines
        foldclose = "󰅂",
        foldopen = "󰅀",
        foldsep = "│",
    },
    fixendofline = false,    -- Add a line break to the EOF if missing
    foldclose = "all",       -- Automatically close folds when not under the cursor
    foldcolumn = "auto",     -- Automatically create fold column when required
    foldmethod = "manual",   -- Must be "manual" or "marker" for fold motions to work

    -- H -----------------------------------------------------------------------
    hlsearch = true,         -- Highlight all search pattern matches

    -- I -----------------------------------------------------------------------
    ignorecase = true,       -- Ignore case in search patterns
    incsearch = true,        -- Highlight search matches as you type

    -- L -----------------------------------------------------------------------
    linebreak = true,        -- Don't split words when wrapping lines

    -- M -----------------------------------------------------------------------
    matchpairs = "(:),{:},[:],<:>",
    mouse = "nv",

    -- N -----------------------------------------------------------------------
    number = true,           -- Set numbered lines
    numberwidth = 4,         -- Set number column width to 4

    -- P -----------------------------------------------------------------------
    pumheight = 10,          -- Pop up menu height

    -- R -----------------------------------------------------------------------
    relativenumber = true,   -- Set relative numbered lines

    -- S -----------------------------------------------------------------------
    scrolloff = 8,           -- Number of lines to keep above and below the cursor
    sessionoptions = {
        "globals",           -- Global variables that start with an uppercase letter
        "buffers",           -- Hidden and unloaded buffers, not just those in windows
        "curdir",            -- The current directory
        "tabpages",          -- All tabs; without this only the current tab is restored
        "winsize",           -- Window sizes
        "winpos",            -- Position of the whole Vim window
        "skiprtp",           -- Exclude 'runtimepath' and 'packpath' from the options
        "folds",             -- Fold options
        "help",              -- The help window
    },
    shiftwidth = 4,          -- The number of spaces inserted for each indentation
    showbreak = "󰌑 ",        -- Icon shown at the beginning of wrapped lines
    showmode = false,        -- Hide current mode
    showtabline = 1,         -- Show tabline if there are at least two tab pages
    sidescrolloff = 8,       -- Number of columns either side of cursor if wrap is off
    signcolumn = "yes",      -- Persistent sign column
    smartcase = true,        -- Override ignorecase if search contains upper case chars
    smartindent = true,      -- Automatically insert indents when opening new lines
    softtabstop = 4,         -- Number of spaces `tab` counts for while editing
    spell = false,           -- Cmp spelling suggestions
    spelllang = {
        "en",
        "en_us",
    },
    spelloptions = "camel",  -- Count camel case words separately when spell checking
    splitbelow = true,       -- Open horizontal splits below current window
    splitright = true,       -- Open vertical splits right of current window
    swapfile = false,        -- Disable swapfiles

    -- T -----------------------------------------------------------------------
    tabstop = 4,             -- Insert 4 spaces for a tab
    termguicolors = true,    -- Set term gui colors (most terminals support this)
    timeout = true,          -- Cancel key sequence after "timeoutlen" if true
    timeoutlen = 420,        -- Time to wait for a key sequence to complete (in ms)

    -- U -----------------------------------------------------------------------
    undofile = false,        -- Disable persistent undo caching
    updatetime = 4000,       -- If idle for this time write swap file (4000ms default)

    -- V -----------------------------------------------------------------------
    virtualedit = {
        "onemore",           -- Allow cursor to sit on the end of the line
        "block",             -- Allow cursor to move anywhere in visual block mode
        "insert",            -- Allow cursor to move anywhere in insert mode
    },

    -- W -----------------------------------------------------------------------
    whichwrap = "bshl",      -- Which "horizontal" keys can to travel to prev/next line
    wrap = true,             -- Break lines that extend beyond the window boundary
    writebackup = true,      -- Make a temporary backup before overwriting a file
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
