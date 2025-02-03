--            _           _
--  __      _(_)_ __   __| | _____      __
--  \ \ /\ / / | '_ \ / _` |/ _ \ \ /\ / /
--   \ V  V /| | | | | (_| | (_) \ V  V /
--    \_/\_/ |_|_| |_|\__,_|\___/ \_/\_/
-- =============================================================================

local M = {}

-- WINDOW COUNT
--------------------------------------------------------------------------------
function M.open_win_count()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local visible_wins = 0

    for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)

        -- Ignore floating and other non-normal windows
        if not config.relative or config.relative == '' then
            visible_wins = visible_wins + 1
        end
    end

    return visible_wins
end


-- CLOSE WINDOW
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
    if M.open_win_count() ~= 1 then
        vim.cmd("q")
    end
end


-- CLEANUP WINDOWS
--------------------------------------------------------------------------------
function M.cleanup_windows()
    local excluded_ft = {
        "checkhealth",
        "aerial",
        "neo-tree",
    }

    -- Close unwanted buffers if open
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local ft = vim.bo[bufnr].filetype

        if vim.tbl_contains(excluded_ft, ft) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end
end


-- NAVIGATE WINDOWS HORIZONTALLY
--------------------------------------------------------------------------------
local cached_win_width

function M.navigate_horizontally(direction)
    if M.open_win_count() == 1 then return end

    local neotree_id
    local aerial_id
    local width = vim.o.columns

    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local ft = vim.bo[bufnr].filetype

        if ft == "neo-tree" then
            neotree_id = winid
            width = width - 35
        elseif ft == "aerial" then
            aerial_id = winid
            width = width - 30
        end

        if neotree_id and aerial_id then
            break
        end
    end

    local initial_win = vim.fn.winnr()
    local initial_win_width = vim.api.nvim_win_get_width(0)

    vim.cmd("wincmd " .. direction)

    local moving_onto_screen_edge = vim.fn.winnr() == initial_win
    local current_win_width = vim.api.nvim_win_get_width(0)
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
    if neotree_id then vim.api.nvim_win_set_width(neotree_id, 35) end
    if aerial_id then vim.api.nvim_win_set_width(aerial_id, 30) end

    -- Disable line wrap on minimized vertical splits
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf_width = vim.api.nvim_win_get_width(winid)
        if buf_width < 80 then
            vim.wo[winid].wrap = false
        else
            vim.wo[winid].wrap = true
        end
    end
end


-- NAVIGATE WINDOWS VERTICALLY
--------------------------------------------------------------------------------
local cached_win_height

function M.navigate_vertically(direction)
    local excluded_ft = { "lazy", "mason", "neo-tree", "aerial", "grapple" }
    local keys = { ["k"] = "<Up>", ["j"] = "<Down>" }

    -- Enable arrow key navigation in certain buffers
    if vim.tbl_contains(excluded_ft, vim.bo.filetype) then
        vim.api.nvim_feedkeys(vim.keycode(keys[direction]), "n", true)
        return
    end

    if M.open_win_count() == 1 then return end

    local qf_id
    local qf_length = 0

    -- If quickfix window is open...
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            local num = #vim.fn.getqflist()
            if num == 0 then qf_length = 10 else qf_length = num end
            qf_id = win.winid
            break
        end
    end

    local initial_win = vim.fn.winnr()
    local initial_win_height = vim.api.nvim_win_get_height(0)

    vim.cmd("wincmd " .. direction)

    if vim.bo.filetype == "qf" then return end

    local moving_onto_screen_edge = vim.fn.winnr() == initial_win
    local current_win_height = vim.api.nvim_win_get_height(0)
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
    if qf_id then
        vim.api.nvim_win_set_height(qf_id, qf_length)
    end
end


-- RESIZE WINDOWS
--------------------------------------------------------------------------------
function M.relative_resize(direction)
    if M.open_win_count() == 1 then return end

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

return M
