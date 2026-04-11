-- Server name:    'html'
-- Mason pkg name: 'vscode-html-language-server'
return {
    cmd = {
        'vscode-html-language-server',
        '--stdio',
    },
    filetypes = { 'html' },
    embeddedLanguages = {
        css = true,
        javascript = true,
    }
}
