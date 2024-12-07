--                                            _
--   _   _ ___  ___ _ __    ___ _ __ ___   __| |___
--  | | | / __|/ _ \ '__|  / __| '_ ` _ \ / _` / __|
--  | |_| \__ \  __/ |    | (__| | | | | | (_| \__ \
--   \__,_|___/\___|_|     \___|_| |_| |_|\__,_|___/
-- =============================================================================

local usercmd = vim.api.nvim_create_user_command

-- SAVE BARBAR TAB ORDER IN SESSION FILE
----------------------------------------------------------------------------
usercmd(
    "Mksession",
    function(attr)
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
        vim.cmd.mksession { bang = attr.bang, args = attr.fargs }
    end,
    {
        bang = true,
        complete = "file",
        desc = "Save barbar with :mksession",
        nargs = "?"
    }
)
