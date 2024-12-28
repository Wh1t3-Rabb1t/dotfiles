"   ,
"  / \               _   /\
"  \  \          ___(_) /  \        ____
"   \  \        /  /__ |    \      /    |
"    \  \      /  /|  ||     \    /     |
"     \  \    /  / |  ||  |\  \  /  /|  |
"      \  \  /  /  |  ||  | \  \/  / |  |
"       \  \/  /   |  ||  |  \    /  |  |
"        \    /    |  ||  |   \__/   |  |
" minimal \  /     |__||__|           \ | rc
" ======== \/ ======================== \| =================================== "


" ╭────────────╮
" │ HIGHLIGHTS │
" ╰────────────╯
" ---------------------------------------------------------------------------- "
" Syntax highlighting / colorscheme
syntax on
colorscheme pablo

" Hack to display underline in insert mode only
" autocmd InsertEnter,InsertLeave * set cul!

" Disable tildes at the end of the buffer
hi! link EndOfBuffer Ignore

" Highlight on yank
augroup highlightYankedText
autocmd!
autocmd TextYankPost * call FlashYankedText()
augroup END

function! FlashYankedText()
    if (!exists('g:yankedTextMatches'))
        let g:yankedTextMatches = []
    endif

    let matchId = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
    let windowId = winnr()

    call add(g:yankedTextMatches, [windowId, matchId])
    call timer_start(200, 'DeleteTemporaryMatch')
endfunction

function! DeleteTemporaryMatch(timerId)
    while !empty(g:yankedTextMatches)
        let match = remove(g:yankedTextMatches, 0)
        let windowID = match[0]
        let matchID = match[1]

        try
            call matchdelete(matchID, windowID)
        endtry
    endwhile
endfunction


" ╭─────────╮
" │ OPTIONS │
" ╰─────────╯
" ---------------------------------------------------------------------------- "
" Leave insert mode instantly
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=200
    augroup END
endif

" Set cursor style based on current mode
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[3 q"
let &t_ti .= "\e[2 q"
let &t_te .= "\e[3 q"

set virtualedit+=block,insert,onemore
set viminfo+=<0
set t_Co=256                " Set 256-color support
set ruler                   " Show cursor column / line number
set noshowmode              " Disable mode message
set laststatus=2            " Always show the status line
set showcmd                 " Show incomplete commands
set cmdheight=1             " Command line height
set backup                  " Enable backups
set undofile                " Enable undo
set shiftround              " Round indent to multiple shiftwidth
set nowrap                  " Don't wrap lines
set number                  " Show line numbers
set relativenumber          " Use relative line numbers
set shortmess+=c            " Shut off completion messages
set whichwrap+=<,>,h,l,[,]  " Autowrap to next line for cursor movements
set splitbelow              " When splitting windows put new ones below ...
set splitright              " ...and to the right
set path+=**                " Search subfolders recursively

" Searching
set hlsearch                " Highlight search results
set incsearch               " Show search matches as you type
set ignorecase              " Ignore case when searching
set smartcase               " When searching try to be smart about cases

" Scrolling
set scrolloff=8             " Start scrolling when we're 8 lines away from margins
set sidescroll=1            " Enable sidescrolling too
set sidescrolloff=8         " Start sidescrolling 8 chars away from margins

" Tabs, make them 4 spaces by default
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Use XDG paths
set viminfo='1000,n$XDG_CACHE_HOME/vim/info
set directory=$XDG_CACHE_HOME/vim/swap//
set undodir=$XDG_CACHE_HOME/vim/undo//
set spellfile=$XDG_DATA_HOME/vim/spell/en.utf-8.add
set backupdir=$XDG_CACHE_HOME/vim/backup//


" ╭─────────╮
" │ KEYMAPS │
" ╰─────────╯
" ---------------------------------------------------------------------------- "
let mapleader = " "


" Insert mode
" ---------------------------------------------------------------------------- "
nnoremap gi           i
nnoremap GI           I


" Visual mode
" ---------------------------------------------------------------------------- "
nnoremap s            v
nnoremap S            V
nnoremap <Leader>s    <C-v>
nnoremap <A-v>        msgv

vnoremap s            v
vnoremap S            V
vnoremap <Leader>s    <C-v>
vnoremap <A-v>        msgv
vnoremap a            o
vnoremap <Leader>a    O


" Command line mode
" ---------------------------------------------------------------------------- "
cnoremap <C-BS>       <C-u>
cnoremap <A-BS>       <C-w>
cnoremap <A-Del>      <S-Right><C-w>
cnoremap <A-Left>     <S-Left>
cnoremap <A-Right>    <S-Right>
cnoremap <S-Up>       <Up>
cnoremap <S-Down>     <Down>


" Arrow navigation
" ---------------------------------------------------------------------------- "
nnoremap i            <Up>
nnoremap k            <Down>
nnoremap l            <Right>
nnoremap t            <Left>

vnoremap i            <Up>
vnoremap k            <Down>
vnoremap l            <Right>
vnoremap t            <Left>

onoremap i            <Up>
onoremap k            <Down>
onoremap l            <Right>
onoremap t            <Left>


" Move lines up / down
" ---------------------------------------------------------------------------- "
nnoremap I            :m .-2<CR>==
nnoremap K            :m .+1<CR>==

vnoremap I            :m '<-2<CR>gv=gv
vnoremap K            :m '>+1<CR>gv=gv

" Indent / outdent
" ---------------------------------------------------------------------------- "
nnoremap L            >>
nnoremap T            <<

vnoremap L            >gv^
vnoremap T            <gv^


" Jump backwards / forwards by word
" ---------------------------------------------------------------------------- "
nnoremap o            w
nnoremap u            b
nnoremap O            e
nnoremap U            ge

vnoremap o            w
vnoremap u            b
vnoremap O            e
vnoremap U            ge


" Jump to start / end of line
" ---------------------------------------------------------------------------- "
nnoremap h            ^
nnoremap ;            g_

vnoremap h            ^
vnoremap ;            g_


" Jump 6 lines / between blocks
" ---------------------------------------------------------------------------- "
nnoremap e            6k
nnoremap d            6j
nnoremap E            ms{
nnoremap D            ms}

vnoremap e            6j
vnoremap d            6j
vnoremap E            ms{
vnoremap D            ms}


" Scroll page up / down
" ---------------------------------------------------------------------------- "
nnoremap <PageUp>     <C-u>zz
nnoremap <PageDown>   <C-d>zz

vnoremap <PageUp>     <C-u>zz
vnoremap <PageDown>   <C-d>zz


" Scroll to top / bottom of page
" ---------------------------------------------------------------------------- "
nnoremap <S-PageUp>   msgg
nnoremap <S-PageDown> msG

vnoremap <S-PageUp>   msgg
vnoremap <S-PageDown> msG


" Delete bindings (all deletions are sent to the black hole register)
" ---------------------------------------------------------------------------- "
" Char
nnoremap <BS>         "_X
nnoremap <Del>        "_x

vnoremap <BS>         "_x
vnoremap <Del>        "_x

" Word
nnoremap <A-BS>       "_db
nnoremap <A-Del>      "_de

" Line
nnoremap <S-Del>      "_dd
nnoremap <C-BS>       "_d^
nnoremap <C-Del>      "_d$


" Delete motions
" ---------------------------------------------------------------------------- "
nnoremap w            <Nop>

" Visual selection
vnoremap w            "_x

" Word
nnoremap wt           "_diw
nnoremap wo           "_de
nnoremap wu           "_db

" Line
nnoremap wl           "_dd
nnoremap wh           "_d^
nnoremap w;           "_d$

" Paragraph
nnoremap wi           "_d{
nnoremap wk           "_d}
nnoremap wp           "_dip

" To char
nnoremap w.           "_dt
nnoremap w,           "_dT


" Dot operator / undo / redo
" ---------------------------------------------------------------------------- "
nnoremap -            .
nnoremap <A-y>        u
nnoremap <A-S-y>      U


" Upper / lower / swap case
" ---------------------------------------------------------------------------- "
nnoremap _            ~

vnoremap _            mmU`m
vnoremap -            mmu`m


" Select in word / paragraph
" ---------------------------------------------------------------------------- "
nnoremap <A-Right>    viw

vnoremap <A-Right>    ip


" Select in surrounding
" ---------------------------------------------------------------------------- "
nnoremap '            msvi'
nnoremap "            msvi"
nnoremap `            msvi`
nnoremap {            msvi{
nnoremap (            msvi(
nnoremap [            msvi[
nnoremap <            msvi<


" Select bracketed code blocks
" ---------------------------------------------------------------------------- "
nnoremap }            msva{V
nnoremap )            msva(V
nnoremap ]            msva[V
nnoremap >            msva<V


" Copy
" ---------------------------------------------------------------------------- "
nnoremap c            <Nop>

" To system register
vnoremap c            mm"*y`m

" Word
nnoremap ct           mm"*yiw`m
nnoremap cu           mm"*yb`m
nnoremap co           "*ye

" Line
nnoremap cl           "*yy
nnoremap c;           "*y$
nnoremap ch           mm"*y^`m

" Paragraph
nnoremap ci           mm"*y{`m
nnoremap ck           "*y}
nnoremap cp           mm"*yip`m

" To char
nnoremap c.           "*yt
nnoremap c,           "*yT


" Cut
" ---------------------------------------------------------------------------- "
nnoremap x            <Nop>

" To system register
vnoremap x            "*d

" Word
nnoremap xt           "*diw
nnoremap xu           "*db
nnoremap xo           "*de

" Line
nnoremap xl           "*dd
nnoremap x;           "*d$
nnoremap xh           "*d^

" Paragraph
nnoremap xi           "*d{
nnoremap xk           "*d}
nnoremap xp           "*dip

" To char
nnoremap x.           "*dt
nnoremap x,           "*dT


" Change (all changed text is sent to the black hole register)
" ---------------------------------------------------------------------------- "
nnoremap y            <Nop>

" Visual selection
vnoremap y            "_c

" Word
nnoremap yt           "_ciw
nnoremap yu           "_cb
nnoremap yo           "_ce

" Line
nnoremap yh           "_d^i
nnoremap y;           "_C
nnoremap yl           ^"_C

" Paragraph
nnoremap yi           "_c{
nnoremap yk           "_c}
nnoremap yp           "_cip

" To char
nnoremap y.           "_ct
nnoremap y,           "_cT


" Paste
" ---------------------------------------------------------------------------- "
nnoremap v            "*]P'
vnoremap v            "_d"*P'
cnoremap <A-v>        <C-r>*


" Open / join lines
" ---------------------------------------------------------------------------- "
" `<C-o>` in insert mode sends a single normal
" mode cmd then returns back to insert
nnoremap <CR>         o<C-o>mo<Esc>`o
nnoremap <S-CR>       O<C-o>mo<Esc>`o
nnoremap j            J

vnoremap j            J


" Navigate `f` and `/` search results
" ---------------------------------------------------------------------------- "
nnoremap .            ;
nnoremap n            mnn
nnoremap N            mnN
nnoremap *            mn*
nnoremap #            mn#
nnoremap ?            :set hlsearch!<CR>

vnoremap .            ;
vnoremap n            mnn
vnoremap N            mnN
vnoremap *            mn*
vnoremap #            mn#


" Jump to mark `s`
" ---------------------------------------------------------------------------- "
nnoremap b            `s


" Save
" ---------------------------------------------------------------------------- "
nnoremap <A-s>        :w<CR>


" Quit (never quit)
" ---------------------------------------------------------------------------- "
nnoremap <A-q>        :qa<CR>
nnoremap QQ           :qa!<CR>
