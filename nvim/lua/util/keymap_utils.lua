--  _                                            _   _ _
-- | | _____ _   _ _ __ ___   __ _ _ __    _   _| |_(_) |___
-- | |/ / _ \ | | | '_ ` _ \ / _` | '_ \  | | | | __| | / __|
-- |   <  __/ |_| | | | | | | (_| | |_) | | |_| | |_| | \__ \
-- |_|\_\___|\__, |_| |_| |_|\__,_| .__/   \__,_|\__|_|_|___/
-- ==========|___/================|_|===========================================

local M = {}

-- VISUAL MODE
--------------------------------------------------------------------------------
function M.swap_point_and_mark()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" then
        vim.cmd([[ :execute "normal! O" ]])
    else
        -- Default behaviour in vblock mode
        vim.api.nvim_feedkeys("A", "n", true)
    end
end


-- ARROW NAVIGATION
--------------------------------------------------------------------------------
function M.cursor_up_ins()
    vim.cmd([[ :execute "normal! g\<Up>" ]])
end

function M.cursor_down_ins()
    vim.cmd([[ :execute "normal! g\<Down>" ]])
end

function M.cursor_up_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! gk" : "normal! k" ]])
end

function M.cursor_down_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! gj" : "normal! j" ]])
end



-- JUMP BACKWARDS / FORWARDS BY WORD / LINE
--------------------------------------------------------------------------------
function M.forwards_word()
    vim.cmd([[ :execute "normal! b" ]])
end

function M.backwards_word()
    vim.cmd([[ :execute "normal! el" ]])
end

function M.line_start_ins()
    vim.cmd([[ :execute "normal! g^" ]])
end

function M.line_end_ins()
    vim.cmd([[ :execute "normal! g$" ]])
end

function M.line_start_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! g^" : "normal! ^" ]])
end

function M.line_end_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! g$h" : "normal! $" ]])
end


-- DELETE BINDINGS
--------------------------------------------------------------------------------
function M.del_word_left()
    vim.cmd([[ :execute 'normal! "_db']])
end

function M.del_word_right()
    vim.cmd([[ :execute 'normal! "_de']])
end

function M.del_line_left()
    vim.cmd([[ :execute 'normal! "_d^']])
end

function M.del_line_right()
    vim.cmd([[ :execute 'normal! "_d$']])
end


-- UNDO / REDO
--------------------------------------------------------------------------------
function M.undo()
    vim.cmd([[ :execute "normal! u" ]])
end

function M.redo()
    vim.cmd([[ :execute "normal! U" ]])
end


-- PASTE
--------------------------------------------------------------------------------
function M.paste()
    -- Make paste respect indentation in insert
    vim.cmd([[ :execute 'normal! "*]Pl' ]])
end


-- NAVIGATE `/` and `f` SEARCH RESULTS
--------------------------------------------------------------------------------
function M.toggle_search_hl()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    else
        vim.cmd("set hls")
    end
end

function M.search_for_selection()
    vim.cmd('normal! "9y')
    local selection = vim.fn.getreg('9')
    local escaped_selection = vim.fn.escape(selection, "\\/.*$^~[]")

    -- Replace newlines with literal "\n" so multi-line searches work
    escaped_selection = escaped_selection:gsub("\n", "\\n")

    -- Build the search command and feed it as keypresses
    local search_cmd = "/" .. escaped_selection .. "\n"
    local keys = vim.api.nvim_replace_termcodes(search_cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
    vim.fn.setreg('9', '')
end


-- QUICKFIX
--------------------------------------------------------------------------------
function M.toggle_quickfix_window()
    if vim.bo.filetype == "qf" then
        vim.cmd("bo cclose")
    else
        vim.cmd("bo copen")
    end
end


-- SAVE CHANGES
--------------------------------------------------------------------------------
function M.save_changes()
    local current_ft = vim.o.filetype
    local excluded_ft = { "diff", "lazy", "mason", "neo-tree", "aerial" }

    -- Don't save when certain filetypes are focused
    if vim.tbl_contains(excluded_ft, current_ft) or vim.o.binary then
        return
    end

    vim.cmd("w")

    -- Return to normal mode if in insert mode
    if vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", true)
    end
end


-- QUIT (never quit)
--------------------------------------------------------------------------------
function M.quit_session()
    -- Save session if launched via session file
    if vim.tbl_contains(vim.v.argv, "-S") then
        vim.cmd("Mksession!")
    end

    vim.cmd("qa")
end

return M
