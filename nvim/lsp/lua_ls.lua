return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    -- Root markers tell Neovim where the project "starts"
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.git'
    },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = { 'vim' },  -- Stop the 'undefined global vim' warning
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            }
        }
    }
}
