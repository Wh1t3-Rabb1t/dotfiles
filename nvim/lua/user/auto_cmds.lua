--               _                             _
--    __ _ _   _| |_ ___     ___ _ __ ___   __| |___
--   / _` | | | | __/ _ \   / __| '_ ` _ \ / _` / __|
--  | (_| | |_| | || (_) | | (__| | | | | | (_| \__ \
--   \__,_|\__,_|\__\___/   \___|_| |_| |_|\__,_|___/
-- =============================================================================

local util = require("util.utils")
local win = require("util.window")
local map = require("util.utils").map
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- KITTY KEY PASSTHROUGH INTEGRATION
--------------------------------------------------------------------------------
autocmd({ "VimEnter", "VimResume" }, {
    group = augroup("KittySetVarVimEnter", { clear = true }),
    callback = function()
        io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
    end
})

autocmd({ "VimLeave", "VimSuspend" }, {
    group = augroup("KittyUnsetVarVimLeave", { clear = true }),
    callback = function()
        io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
    end
})


-- OVERRIDE DEFAULT MAN / HELP PAGE BINDINGS
--------------------------------------------------------------------------------
autocmd("FileType", {
    group = augroup("ManPageBindings", { clear = true }),
    pattern = { "man", "help", "lazy" },
    callback = function()
        map({ "n", "v" }, "k", "j", { buffer = true })
        map("n", "<CR>", "<C-]>", { buffer = true })
        map("n", "<S-CR>", "<C-t>", { buffer = true })

        -- Hack to respect user declared 'i' binding in lazy ui
        require("lazy.view.config").commands.install.key_plugin = "G"
    end
})


-- COMMENT HJSON FILES
--------------------------------------------------------------------------------
autocmd("FileType", {
    group = augroup("HjsonComments", { clear = true }),
    pattern = "hjson",
    callback = function()
        vim.bo.commentstring = "#%s"
    end
})


-- SET QUICKFIX HEIGHT TO THE NUMBER OF ENTRIES IF > 10
--------------------------------------------------------------------------------
autocmd("FileType", {
    group = augroup("SetQfHeight", { clear = true }),
    pattern = "qf",
    callback = function()
        local entry_count = #vim.fn.getqflist()
        if entry_count > 10 then
            vim.cmd(entry_count .. "wincmd _")
        end
    end
})


-- TOGGLE SPELL SUGGESTIONS WHEN ENTERING / LEAVING INSERT MODE
--------------------------------------------------------------------------------
autocmd("InsertEnter", {
    group = augroup("EnableSpellSuggest", { clear = true }),
    callback = function()
        if vim.bo.filetype ~= "neo-tree-popup" then
            vim.o.spell = true
        end
    end
})

autocmd("InsertLeave", {
    group = augroup("DisableSpellSuggest", { clear = true }),
    callback = function() vim.o.spell = false end
})


-- UPDATE REGISTER STACK / HIGHLIGHT SELECTION ON YANK
--------------------------------------------------------------------------------
autocmd("TextYankPost", {
    group = augroup("YankUtils", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
        local register = vim.v.event.regname

        -- Copy to the alphabetical register stack
        if register == "*" then
            -- If there are no non whitespace chars
            if vim.fn.getreg(register):match("%S") == nil then return end

            -- Loop from register 'y' (ASCII 121) down to 'a' (ASCII 97)
            local carry = vim.fn.getreg("z")
            for i = 121, 97, -1 do
                local reg = string.char(i)
                local current = vim.fn.getreg(reg)
                vim.fn.setreg(reg, carry)
                if current == "" then break end
                carry = current
            end

            vim.fn.setreg("z", vim.fn.getreg("*"))
        end

        -- Copy to the numeric register stack
        if register == "+" then
            if vim.fn.getreg(register):match("%S") == nil then return end

            local carry = vim.fn.getreg("+")
            for i = 1, 9 do
                local reg = tostring(i)
                local current = vim.fn.getreg(reg)
                vim.fn.setreg(reg, carry)
                if current == "" then break end
                carry = current
            end
        end
    end
})


-- TRIM TRAILING WHITESPACE AND CONVERT TABS TO SPACES PRE SAVE
--------------------------------------------------------------------------------
autocmd("BufWritePre", {
    group = augroup("TrimWhiteSpaceAndRetab", { clear = true }),
    callback = function()
        -- Save the current view state
        local current_view = vim.fn.winsaveview()

        -- Save file, trim trailing whitespace, convert tabs to spaces
        vim.cmd([[
            :keeppatterns %s/\s\+$//e
            :retab
        ]])

        -- Restore view state
        vim.fn.winrestview(current_view)
    end
})


-- PRINT FILENAME WITH RELATIVE PATH, DATE & TIME POST SAVE
--------------------------------------------------------------------------------
autocmd("BufWritePost", {
    group = augroup("PrintDateAndTimeOnSave", { clear = true }),
    callback = function()
        local filename = vim.fn.expand("%:.")
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        print("Changes saved: " .. cwd .. "/" .. filename .. " │ " .. os.date())
    end
})


-- CLEANUP UNWANTED BUFFERS AND SAVE SESSION PRE EXIT
--------------------------------------------------------------------------------
autocmd("VimLeavePre", {
    group = augroup("CleanupOnVimExit", { clear = true }),
    callback = function()
        win.cleanup_windows()
        util.cleanup_marks()

        local session_in_cwd = vim.fn.filereadable("Session.vim") == 1
        if not session_in_cwd then
            util.cleanup_registers()
        end
    end
})
