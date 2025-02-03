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
function M.cursor_up()
    vim.cmd([[ :execute "normal! g\<Up>" ]])
end
function M.cursor_down()
    vim.cmd([[ :execute "normal! g\<Down>" ]])
end


-- JUMP BACKWARDS / FORWARDS BY WORD / LINE
--------------------------------------------------------------------------------
function M.forwards_word()
    vim.cmd([[ :execute "normal! b" ]])
end
function M.backwards_word()
    vim.cmd([[ :execute "normal! el" ]])
end
function M.line_start()
    vim.cmd([[ :execute "normal! g^" ]])
end
function M.line_end()
    vim.cmd([[ :execute "normal! g$" ]])
end

return M
