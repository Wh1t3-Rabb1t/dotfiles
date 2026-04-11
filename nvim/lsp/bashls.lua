-- Server name:    'bashls'
-- Mason pkg name: 'bash-language-server'
return {
    cmd = {
        'bash-language-server',
        'start',
    },
    filetypes = {
        'bash',
        'sh',
        'zsh',
    }
}
