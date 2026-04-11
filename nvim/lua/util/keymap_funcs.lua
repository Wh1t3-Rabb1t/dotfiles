--   _                                       __
--  | | _____ _   _ _ __ ___   __ _ _ __    / _|_   _ _ __   ___ ___
--  | |/ / _ \ | | | '_ ` _ \ / _` | '_ \  | |_| | | | '_ \ / __/ __|
--  |   <  __/ |_| | | | | | | (_| | |_) | |  _| |_| | | | | (__\__ \
--  |_|\_\___|\__, |_| |_| |_|\__,_| .__/  |_|  \__,_|_| |_|\___|___/
-- ===========|___/================|_|==========================================

-- +-------+
-- | INDEX |
-- +-------+------------------------------
-- LEADER                              _01
-- ARROW NAVIGATION                    _01
-- COMMENTS                            _02
-- JUMP TO START / END OF WORD / LINE  _03
-- DELETE BINDINGS                     _04
-- UNDO / REDO                         _05
-- PASTE                               _06
-- `f` and `/` SEARCH                  _07
-- MARKS                               _08
-- QUICKFIX                            _09
-- WINDOW                              _10
-- SAVE CHANGES                        _11
-- QUIT                                _12

local M = {}

local util = require("util.utils")

-- LEADER                                                                    _00
--------------------------------------------------------------------------------
function M.set_column_hl()    vim.cmd("set colorcolumn=80") end
function M.rm_column_hl()     vim.cmd("set colorcolumn=''") end
function M.v_split_layout()   vim.cmd("windo wincmd H") end
function M.h_split_layout()   vim.cmd("windo wincmd K") end
function M.open_lazy()        vim.cmd("Lazy") end
function M.open_mason()       vim.cmd("Mason") end
function M.toggle_column_hl() vim.wo.cursorcolumn = not vim.wo.cursorcolumn end
function M.toggle_wrap()      vim.wo.wrap = not vim.wo.wrap end
function M.open_link()        vim.ui.open(vim.fn.expand("<cfile>")) end
function M.delete_all_marks() vim.cmd.delm({ bang = true }) end


-- ARROW NAVIGATION                                                          _01
--------------------------------------------------------------------------------
function M.cursor_up_ins()   vim.cmd([[ :execute "normal! g\<Up>" ]]) end
function M.cursor_down_ins() vim.cmd([[ :execute "normal! g\<Down>" ]]) end
function M.cursor_up_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! gk" : "normal! k" ]])
end
function M.cursor_down_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! gj" : "normal! j" ]])
end


-- COMMENTS                                                                  _02
--------------------------------------------------------------------------------
function M.comment_line()
    vim.go.operatorfunc = "v:lua.require'vim._comment'.operator"
    local keys = vim.api.nvim_replace_termcodes("g@_", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end

function M.comment_visual()
    vim.go.operatorfunc = "v:lua.require'vim._comment'.operator"
    local keys = vim.api.nvim_replace_termcodes("g@", true, false, true)
    vim.api.nvim_feedkeys(keys, "x", false)
end


-- JUMP TO START / END OF WORD / LINE                                        _03
--------------------------------------------------------------------------------
function M.forwards_word()  vim.cmd([[ :execute "normal! el" ]]) end
function M.backwards_word() vim.cmd([[ :execute "normal! b" ]]) end
function M.line_start_ins() vim.cmd([[ :execute "normal! g^" ]]) end
function M.line_end_ins()   vim.cmd([[ :execute "normal! g$" ]]) end
function M.line_start_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! g^" : "normal! ^" ]])
end
function M.line_end_cmd()
    vim.cmd([[ :execute v:count == 0 ? "normal! g$h" : "normal! $" ]])
end


-- DELETE BINDINGS                                                           _04
--------------------------------------------------------------------------------
function M.del_word_left()  vim.cmd([[ :execute 'normal! "_db']]) end
function M.del_word_right() vim.cmd([[ :execute 'normal! "_de']]) end
function M.del_line_left()  vim.cmd([[ :execute 'normal! "_d^']]) end
function M.del_line_right() vim.cmd([[ :execute 'normal! "_d$']]) end


-- UNDO / REDO                                                               _05
--------------------------------------------------------------------------------
function M.undo() vim.cmd([[ :execute "normal! u" ]]) end
function M.redo() vim.cmd([[ :execute "normal! U" ]]) end


-- PASTE                                                                     _06
--------------------------------------------------------------------------------
-- Make paste respect indentation in insert
function M.paste() vim.cmd([[ :execute 'normal! ""]Pl' ]]) end


-- `f` and `/` SEARCH                                                        _07
--------------------------------------------------------------------------------
function M.toggle_search_hl()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    else
        vim.cmd("set hls")
    end
end

function M.regex_selection()
    vim.cmd('normal! ""y')
    local selection = vim.fn.getreg('"')
    local escaped_selection = vim.fn.escape(selection, "\\/.*$^~[]")

    -- Replace newlines with literal "\n" so multi-line searches work
    escaped_selection = escaped_selection:gsub("\n", "\\n")

    -- Build the search command and feed it as keypresses
    local search_cmd = "/" .. escaped_selection .. "\n"
    local keys = vim.api.nvim_replace_termcodes(search_cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
    vim.fn.setreg('"', '')
end


-- MARKS                                                                    _08
--------------------------------------------------------------------------------
function M.toggle_mark()
    local buf = 0
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- PASS 1: Remove mark if it exists on this line
    for i = string.byte("a"), string.byte("z") do
        local mark = string.char(i)
        local pos = vim.fn.getpos("'" .. mark)

        if pos[2] == row then
            vim.api.nvim_buf_del_mark(buf, mark)
            vim.notify("Removed mark '" .. mark)
            return mark
        end
    end

    -- PASS 2: Add first available mark
    for i = string.byte("a"), string.byte("z") do
        local mark = string.char(i)
        local pos = vim.fn.getpos("'" .. mark)

        if pos[2] == 0 then
            vim.api.nvim_buf_set_mark(buf, mark, row, col, {})
            vim.notify("Set mark '" .. mark)
            return mark
        end
    end

    vim.notify("No available marks", vim.log.levels.WARN)
end

function M.jump_to_mark_above()
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local best_mark = nil
    local fallback_mark = nil
    local best_row = -1
    local fallback_row = -1  -- Max row (bottom-most)

    for i = string.byte("a"), string.byte("z") do
        local mark = string.char(i)
        local pos = vim.fn.getpos("'" .. mark)
        local row = pos[2]

        if row > 0 then
            -- Normal case (above)
            if row < current_row and row > best_row then
                best_row = row
                best_mark = mark
            end

            -- Fallback (bottom-most mark)
            if row > fallback_row then
                fallback_row = row
                fallback_mark = mark
            end
        end
    end

    local target = best_mark or fallback_mark

    if target then
        vim.cmd("keepjumps normal! '" .. target)
    end
end

function M.jump_to_mark_below()
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local best_mark = nil
    local fallback_mark = nil
    local best_row = math.huge
    local fallback_row = math.huge  -- Min row (top-most)

    for i = string.byte("a"), string.byte("z") do
        local mark = string.char(i)
        local pos = vim.fn.getpos("'" .. mark)
        local row = pos[2]

        if row > 0 then
            -- Normal case (below)
            if row > current_row and row < best_row then
                best_row = row
                best_mark = mark
            end

            -- Fallback (top-most mark)
            if row < fallback_row then
                fallback_row = row
                fallback_mark = mark
            end
        end
    end

    local target = best_mark or fallback_mark

    if target then
        vim.cmd("keepjumps normal! '" .. target)
    end
end


-- QUICKFIX                                                                 _09
--------------------------------------------------------------------------------
function M.toggle_quickfix_win()
    if vim.bo.filetype == "qf" then
        vim.cmd("bo cclose")
    else
        vim.cmd("bo copen")
    end
end

function M.add_line_to_quickfix()
    -- Add line under cursor to the quickfix list
    local line = vim.api.nvim_get_current_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]

    -- Create a quickfix entry
    local item = {
        bufnr = bufnr,
        lnum = lnum,
        text = line,
    }

    -- Append the entry to the quickfix list
    vim.fn.setqflist({}, "a", { items = { item } })
    vim.notify(
        "Line #" .. lnum .. " added to quickfix list",
        vim.log.levels.INFO
    )
end


-- NAVIGATE WINDOWS HORIZONTALLY                                             _10
--------------------------------------------------------------------------------
local cached_win_width

function M.navigate_horizontally(direction)
    local win_count = util.open_win_count()

    if win_count == 1 then return end

    local explorer_id
    local explorer_width
    local no_resize = false
    local width = vim.o.columns
    local get_width = vim.api.nvim_win_get_width
    local set_width = vim.api.nvim_win_set_width

    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local ft = vim.bo[bufnr].filetype

        if ft == "snacks_picker_list" then
            explorer_id = winid
            explorer_width = get_width(winid)
            width = width - explorer_width
        end

        if explorer_id then
            if win_count == 2 then
                no_resize = true
            end
            break
        end
    end

    local initial_win = vim.fn.winnr()
    local initial_win_width = get_width(0)

    vim.cmd("wincmd " .. direction)

    -- Return without resizing if only the explorer and one buffer is open
    if no_resize == true then return end

    local moving_onto_screen_edge = vim.fn.winnr() == initial_win
    local current_win_width = get_width(0)
    local maximized_win_width = width - 12

    if moving_onto_screen_edge then
        if current_win_width < maximized_win_width then
            cached_win_width = current_win_width
            vim.cmd("vertical resize " .. maximized_win_width)
        else
            if cached_win_width then
                vim.cmd("vertical resize " .. cached_win_width)
            end
        end
    else
        if current_win_width <= 24 then
            vim.cmd("vertical resize " .. initial_win_width)
        end
    end

    -- Fix sidebar sizes when resizing windows
    if explorer_id then set_width(explorer_id, explorer_width) end

    -- Disable line wrap on minimized vertical splits
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf_width = get_width(winid)
        if buf_width < 80 then
            vim.wo[winid].wrap = false
        else
            vim.wo[winid].wrap = true
        end
    end
end


-- NAVIGATE WINDOWS VERTICALLY                                               _10
--------------------------------------------------------------------------------
local cached_win_height

function M.navigate_vertically(direction)
    local excluded_ft = { "lazy", "mason" }
    local keys = { ["k"] = "<Up>", ["j"] = "<Down>" }

    -- Enable arrow key navigation in desired buffers
    if vim.tbl_contains(excluded_ft, vim.bo.filetype) then
        vim.api.nvim_feedkeys(vim.keycode(keys[direction]), "n", true)
        return
    end

    if util.open_win_count() == 1 then return end

    local qf_id
    local qf_length = 0
    local get_height = vim.api.nvim_win_get_height
    local set_height = vim.api.nvim_win_set_height

    -- If quickfix window is open...
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            local num = #vim.fn.getqflist()
            if num < 10 then qf_length = 10 else qf_length = num end
            qf_id = win.winid
            break
        end
    end

    local initial_win = vim.fn.winnr()
    local initial_win_height = get_height(0)

    vim.cmd("wincmd " .. direction)

    if vim.bo.filetype == "qf" then return end

    local moving_onto_screen_edge = vim.fn.winnr() == initial_win
    local current_win_height = get_height(0)
    local maximized_win_height = (vim.o.lines - vim.o.cmdheight - qf_length) - 6

    if moving_onto_screen_edge then
        if current_win_height < maximized_win_height then
            cached_win_height = current_win_height
            vim.cmd("resize " .. maximized_win_height)
        else
            if cached_win_height then
                vim.cmd("resize " .. cached_win_height)
            end
        end
    else
        if current_win_height <= 10 then
            vim.cmd("resize " .. initial_win_height)
        end
    end

    -- Prevent miscalculations because I'm an idiot
    if qf_id then set_height(qf_id, qf_length) end
end


-- RESIZE WINDOWS                                                            _10
--------------------------------------------------------------------------------
function M.relative_resize(direction)
    if util.open_win_count() == 1 then return end

    local function neighbor(target)
        local cur = vim.fn.winnr()
        local cur_pos = vim.fn.win_screenpos(0)
        local comp = vim.fn.winnr(target)

        if cur == comp then return false end

        local comp_pos = vim.fn.win_screenpos(comp)

        if target == "k" or target == "j" then
            return comp_pos[0] == cur_pos[0]
        else
            return comp_pos[1] == cur_pos[1]
        end
    end

    local top, bottom = neighbor("k"), neighbor("j")
    local left, right = neighbor("h"), neighbor("l")

    local modifier
    if direction == "up" then
        if top and bottom then
            modifier = "-"
        elseif top then
            modifier = "+"
        elseif bottom then
            modifier = "-"
        end
    elseif direction == "down" then
        if top and bottom then
            modifier = "+"
        elseif top then
            modifier = "-"
        elseif bottom then
            modifier = "+"
        end
    elseif direction == "left" then
        if left and right then
            modifier = "-"
        elseif left then
            modifier = "+"
        elseif right then
            modifier = "-"
        elseif top then
             modifier = "+"  -- Prevent no modifier edge case
        end
    elseif direction == "right" then
        if left and right then
            modifier = "+"
        elseif left then
            modifier = "-"
        elseif right then
            modifier = "+"
        elseif top then
            modifier = "-"  -- Prevent no modifier edge case
        end
    end

    if not modifier then return end

    if direction == "up" or direction == "down" then
        vim.cmd("resize " .. modifier .. "2")
    else
        vim.cmd("vertical resize " .. modifier .. "2")
    end
end


-- CLOSE WINDOW                                                              _10
--------------------------------------------------------------------------------
function M.close_window()
    if vim.bo.filetype == "checkhealth" then
        vim.api.nvim_buf_delete(
            vim.api.nvim_get_current_buf(), {
                force = true
            }
        )
    end

    -- Don't quit if only one window is open
    if util.open_win_count() ~= 1 then
        vim.cmd("q")
    end
end


-- SAVE CHANGES                                                              _11
--------------------------------------------------------------------------------
function M.save_changes()
    local current_ft = vim.o.filetype
    local excluded_ft = { "diff", "lazy", "mason" }

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


-- QUIT (never quit)                                                         _12
--------------------------------------------------------------------------------
function M.quit_session()
    -- Save session if nvim was launched via session file
    if vim.tbl_contains(vim.v.argv, "-S") then
        vim.cmd("Mksession!")
    end

    vim.cmd("qa")
end

return M
