" vim-rc
" -> ask@0x61736b.net


set nocompatible
set textwidth=78

"set scrollbind
set noscrollbind
syncbind

" reload help-tags.
helptags ~/.vim/doc

iab __nowdate__ <C-r>=strftime('%c')<CR>


" terminal and gui settings
set term=ansi
set termencoding=utf-8
set encoding=utf-8
set backspace=indent,eol,start
set tabstop=4
set visualbell
set smarttab
set smartcase
set noerrorbells
set showmatch
set showcmd
set wildmode=longest,list
set wildmenu
set completeopt=menuone,longest,preview
set hidden
set complete+=k
set iskeyword=@,48-57,192-255
set iskeyword-=:
set copyindent
set modeline
set showtabline=2

set confirm

hi Search ctermfg=white ctermbg=lightblue

"set foldmethod=indent
"set foldnestmax=1
"set nofoldenable


colorscheme evening

" GUI options (only in effect when running in a GUI).
if has("gui_running")
    set gfn=Inconsolata:h18
    set enc=utf-8
    colorscheme brookstream " macvim
    syntax on

    " Import Python paths
    python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

    if has("gui_macvim")
        " Map Cmd+<n> to move to tab <n>.
        map <D-1> :tabn 1<CR>
        map <D-2> :tabn 2<CR>
        map <D-3> :tabn 3<CR>
        map <D-4> :tabn 4<CR>
        map <D-5> :tabn 5<CR>
        map <D-6> :tabn 6<CR>
        map <D-7> :tabn 7<CR>
        map <D-8> :tabn 8<CR>
        map <D-9> :tabn 9<CR>
        map! <D-1> <C-O>:tabn 1<CR>
        map! <D-2> <C-O>:tabn 2<CR>
        map! <D-3> <C-O>:tabn 3<CR>
        map! <D-4> <C-O>:tabn 4<CR>
        map! <D-5> <C-O>:tabn 5<CR>
        map! <D-6> <C-O>:tabn 6<CR>
        map! <D-7> <C-O>:tabn 7<CR>
        map! <D-8> <C-O>:tabn 8<CR>
        map! <D-9> <C-O>:tabn 9<CR>

        " Add MacVim shift-movement
        let macvim_hig_shift_movement = 1

        " A itzy-bitzy amount of transparency
        set transparency=4
        
        " Anti-aliasing is niiiice
        set antialias

    endif
    
else
    "colorscheme evening
endif

" Terminal Options (only in effect when running from a terminal).
if &t_Co > 2
	"colorscheme evening
	syntax on
    language en_GB.UTF-8
endif	

" display and behaviour settings
set ruler
set showcmd
set foldenable
set expandtab
set history=200
set undolevels=1000

" indentation
"set cindent
"set cino=""
set shiftwidth=4
set shiftround

" searching
if has("gui_running") || &t_Co > 2
	set hlsearch  " - "
endif
set ignorecase
set incsearch 
set showmatch "potentially slow, turn off in big files.
set nowrap
set wrapscan


" from Perl Hacks (O'Reilly 2006)
set iskeyword+=:
map ,j <Esc>:r ~/.vim/js-header.stub<CR>

map ,. <Esc>:!a x<CR>
map ,/ <Esc>:!a err<CR>
map ,m <Esc>:tabedit .<CR>
map ,n <Esc>:tabclose<CR><Esc>:tabedit .<CR>
map ,u <Esc>iλ<Esc>
map ,g <Esc>:w<CR><Esc>:!git commit "%"<CR>
map ,c <Esc>:VCSCommit<CR>
"smoother scrolling
:map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>      
:map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>

let mapleader = "\\"

" autocmd
filetype plugin on
filetype plugin indent on
"filetype indent on
augroup vimrcEx



au!
"autocmd FileType text setlocal textwidth=78
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\ 	exe "normal g`\"" |
	\ endif
augroup END

map _u :call ID_search()<Bar>execute "/\\<" . g:word . "\\>"<CR>
map _n :n<Bar>execute "/\\<" . g:word . "\\>"<CR>

function! ID_search()
    let g:word = expand("<cword>")
    let x = system("lid --key=none ". g:word)
    let x = substitute(x, "\n", " ", "g")
    execute "next " . x
endfun


" taglist config
"
"

let Tlist_Auto_Highlight_Tag = 1
let Tlist_Exit_OnlyWindow    = 1
let Tlist_Use_Right_Window   = 1
let Tlist_WinWidth           = 40
let Tlist_Inc_Winwidth       = 1
let Tlist_Highlight_Tag_On_BufEnter = 1

map ,L <Esc>:TlistToggle<CR><Esc>
map ,l <Esc>:TlistOpen<CR><Esc>

set list
set listchars=tab:>-,extends:#

" Omnicompletion for Python
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType vim set omnifunc=syntaxcomplete#Complete
autocmd FileType c set omnifunc=ccomplete#Complete
inoremap <C-space> <C-x><C-O>

" Window dimensions
set lines=38
set columns=78

" Don't show toolbar
set go-=T

