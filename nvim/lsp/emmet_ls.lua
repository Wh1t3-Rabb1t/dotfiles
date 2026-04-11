-- Server name:    'emmet_ls'
-- Mason pkg name: 'emmet-language-server'
return {
    cmd = {
        'emmet-language-server',
        '--stdio',
    },
    filetypes = {
        'html',
        'css',
        'scss',
        'javascriptreact',
        'typescriptreact',
    }
}
