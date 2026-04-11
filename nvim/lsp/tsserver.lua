-- Server name:    'tsserver'
-- Mason pkg name: 'typescript-language-server'
return {
    cmd = {
        'typescript-language-server',
        '--stdio',
    },
    filetypes = {
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
    }
}
