-- Server name:    'jsonls'
-- Mason pkg name: 'vscode-json-language-server'
return {
    cmd = {
        'vscode-json-language-server',
        '--stdio',
    },
    filetypes = {
        'json',
        'jsonc',
        'hjson',
    },
    settings = {
        json = {
            validate = { enable = true },
        }
    }
}
