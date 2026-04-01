-- basic LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf
        local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = buf })
        end

        map("gd", vim.lsp.buf.definition)
        map("gr", vim.lsp.buf.references)
        map("K", vim.lsp.buf.hover)
        map("<leader>rn", vim.lsp.buf.rename)
        map("<leader>ca", vim.lsp.buf.code_action)
    end,
})

-- enable servers (0.12 style)
local servers = {
    "lua_ls",
    "tsserver",
    "bashls",
}

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end
