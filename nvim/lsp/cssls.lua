-- Server name:    'cssls'
-- Mason pkg name: 'vscode-css-language-server'
return {
    cmd = {
        'vscode-css-language-server',
        '--stdio',
    },
    filetypes = {
        'css',
        'scss',
    },
    settings = {
        css = { validate = true },
        scss = { validate = true },
    }
}
