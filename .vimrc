set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let Vundle manage Vundle
Plugin 'gmark/Vundle.vim'

" Other plugins
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim'}
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'klen/python-mode'
Plugin 'davidhalter/jedi-vim'
Plugin 'nixon/vim-vmath'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-commentary'
Plugin 'kien/ctrlp.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
Plugin 'petRUShka/vim-opencl'
Plugin 'kshenoy/vim-signature'
Plugin 'Valloric/YouCompleteMe'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'tomasr/molokai'
Plugin 'fmoralesc/molokayo'
Plugin 'wting/rust.vim'

call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of histoy VIM has to remember
set history=200

" Enable filetype plugins
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread

" automatically change window's cwd to file's dir
set autochdir

" more subtle popup colors
if has ('gui_running')
	highlight Pmenu guibg=#cccccc gui=bold
endif

imap jj <ESC>

" Treat all numerals as decimal
set nrformats=

" Automatically remove all trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e

" Make the 121 column stand out
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%121v',100)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on the Wild menu
set wildmenu
set wildmode=full

" Ignore compiled files
set wildignore=*.o,*.exe

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros
set lazyredraw
set ttyfast

" Show matching brackets when text indicator is over them
set showmatch
" How many thenths of a second to blink when matching brackets
set mat=2

" Show line numbers
set nu


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Colodsurscheme
colorscheme molokayo

" Use 256 colours
set t_Co=256

" Hide the default mode text
set noshowmode

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change hightlighting color
hi Visual guifg=#000000 guibg=#000000


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! StatusDir()
    if &buftype != "nofile"
        let d = expand("%:p:~:h")
        if d != fnamemodify(getcwd(), ":~")
            return expand("%:p:.:h").'/'
        else
            return ''
        endif
    else
        return ''
    endif
endfunction

function! OtherBuffers()
    let buffers_txt = ""
    redir => buffers_txt
    silent ls
    redir END
    let lines = []
    for line in split(buffers_txt, "\n")
        let bufnr = split(line)[0]
        if bufnr != bufnr("%")
            call add(lines, split(line)[0])
        endif
    endfor
    return lines
endfunction

function! StatusOtherBuffers()
    return join(map(OtherBuffers(), '"·".v:val'), ' ')
endfunction

function! PWD()
    return fnamemodify(getcwd(), ":~")
endfunction

set laststatus=2
set statusline=%#SLDelim#@:%#SLSpecial#%{PWD()}
set statusline+=%#SLDelim#:%#SLNumber#%n%#SLDelim#: "buffer number
set statusline+=%#SLDirectory#%{expand('%:h')!=''?StatusDir():''} "file path, if buffer is a file
set statusline+=%#SLIdentifier#%{expand('%:h')!=''?expand('%:t'):'[unnamed]'}%#Boolean#%m%r "buffer name and modifiers
set statusline+=%#SLDelim#%{fugitive#head()!=''?':':''}%#SLVCS#%{fugitive#head()}
set statusline+=\ %#SLCharacter#%{StatusOtherBuffers()} "list of other buffers
set statusline+=\ %=\%#SLConstant#%{&fenc}%#SLDelim#:%#SLType#%{&ft}%#SlDelim#:%#SLFunction#%{&fo}%#SLDelim#:%#SLSpellBad#%{&spell?&spl:''}
set statusline+=%#SLNumber#\ %l,%c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Persistent undo buffer
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone"
set undoreload=10000 "maximum number lines to save for undo on a buffer reload"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
map <F2> :NERDTreeToggle<CR>

" => Powerline setup
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
let g:airline_powerline_fonts = 1

" => Python
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator
" modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)

let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Trim unused whitespace on save
let g:pymode_trim_whitespaces = 1

" Setup max line length
let g:pymode_options_max_line_length = 0

" Disable warning about max_line length
let g:pymode_lint_ignore = "E501,W"


" Enable pymode indentation
let g:pynode_indent = 1



" => Vim vmath setup
vmap <expr> ++ VMATH_YankAndAnalyse()
nmap        ++ vip++

" => Gundo
noremap <F5> :GundoToggle<CR>

" => YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/c/ycm/.ycm_extra_conf.py'
