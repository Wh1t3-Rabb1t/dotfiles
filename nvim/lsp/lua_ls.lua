-- Server name:    'lua_ls'
-- Mason pkg name: 'lua-language-server'
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {  -- Root markers tell Neovim where the project "starts"
        '.luarc.json',
        '.luarc.jsonc',
        '.git',
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
