""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" NeoVim configuration:  ~/.config/nvim/init.vim
"
"  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
"      'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Init
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" necesary for lots of cool Vim things
set nocompatible

" replace system's fish shell. run sh cmd with :! or :r!
set shell=/bin/sh

" Sets how many lines of history Vim has to remember
set history=1000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" set the leader
let mapleader = " "
let g:mapleader = " "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
    "" use Lua/Fennel as the config language?  TODO or not todo
    "" better repeater
        Plug 'tpope/vim-repeat'
        Plug 'tpope/vim-surround'
    "" user interface
        Plug 'reedes/vim-colors-pencil'
    "" show | in front of indent line
        Plug 'Yggdroot/indentLine'
    "" a better status line
        Plug 'vim-airline/vim-airline'
    "" session and more
        Plug 'mhinz/vim-startify'
    "" cut copy paste
        Plug 'christoomey/vim-system-copy'
    "" prompter
        Plug 'ervandew/supertab'
    "" auto complete
        " Plug 'ncm2/ncm2'
        " Plug 'ncm2/ncm2-path'
        " Plug 'ncm2/ncm2-jedi'
        " Plug 'ncm2/ncm2-snippet'
        " Plug 'ncm2/ncm2-bufword'
        Plug 'roxma/nvim-yarp'
    "" syatastic
        Plug 'scrooloose/syntastic'
    "" lsp
        Plug 'neovim/nvim-lspconfig'
        Plug 'williamboman/nvim-lsp-installer'
    "" treesitter
        Plug 'nvim-treesitter/nvim-treesitter'
    "" Python
        Plug 'klen/python-mode'
call plug#end()

" SuperTab
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabCrMapping             = 0

" auto complete -- enable ncm2 for all buffers
" autocmd BufEnter * call ncm2#enable_for_buffer()
" 模糊匹配
" let g:ncm2#matcher = 'substrfuzzy'

" syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" pymode
let g:pymode_rope_lookup_project = 0
let g:pymode_rope = 0

" To turn off default keymapping and use your own:
let g:copy_cut_paste_no_mappings = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for cut copy paste
set mousemodel=popup

" Enable syntax highlighting
syntax enable

"set fold
set foldmethod=indent " syntax, indent, marker, manual, expr ...
set foldlevel=10

" set line break
set linebreak
set textwidth=0
set wrapmargin=0

" Turn on the WiLd menu
set wildmenu

" command-line completion
set wildmode=longest:full,full

" to recognize a list header
set formatlistpat=^\\s*\\(\\d\\\|[-*]\\)\\+[\\]:.)}\\t\ ]\\s*
set formatoptions+=n

"show the tabes
set list
set listchars=tab:\|\ ,trail:·,extends:#,nbsp:.

"do not break words joined by the following characters
set iskeyword+=_,@

" make >> and << work better
set shiftround

" Specify the behavior when switching between buffers
set switchbuf=useopen,usetab,newtab
set stal=2

" wrap or not
set wrap
set whichwrap+=<,>,[,],h,l,b,s,~

" A buffer becomes hidden when it is abandoned
set hid

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

"use dialog when file was not saved
set confirm

"inline replace
set gdefault

"set auto-complete (was: longest,menu. revised for: ncm2)
set completeopt=noinsert,menuone,noselect

"share clipboard
set clipboard+=unnamedplus

" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Show matching brackets, and how many tenths of a second to show
set showmatch
set mat=10

" set delay
set timeoutlen=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Screen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=3

" Increase the space between lines
set linespace=10

"show the command typing
set showcmd

" Try to keep the cursor line in the vertically center (27 lines)
set scrolloff=3

"Always show current position
set ruler

"show line number
set number

" hightlight current line/col
set cursorline
set cursorcolumn

" Enable syntax highlighting
syntax enable

" Height of the command bar
set cmdheight=2

" colorscheme and background
let $VIM_TUI_ENABLE_TRUE_COLOR=1
colorscheme pencil
set t_ut=

" stolen from atomic colorscheme
set background=dark
" if (strftime("%H") > 6) && (strftime("%H") < 18)
"     set background=light
" else
"     set background=dark
" endif

" in term mode # atomic
if has("termguicolors")
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" colors
set colorcolumn=+1
hi ColorColumn NONE ctermbg=Cyan

"set font
set guifont=Hack:h18

" add more components to statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" display the status line always
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set dir to the current file's directory.
set autochdir

" Open dialog defaults to the current file's directory.
set browsedir=buffer

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Turn backup on. Need to build these folders manually.
"set backup
"set backupdir=$HOME/.config/nvim/backup
"set directory=$HOME/.config/nvim/tmp

" Set utf8 as standard encoding, and en_US as the standard language
set encoding=utf8
set termencoding=utf8

"Chinese Vim menus (windows)
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"Chinese Vim messages (windows)
language messages zh_CN.utf-8

" encodeing just opened file.
set fileencodings=utf8,gbk,big5,ucs-bom

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ exec ":call UpdateCopyright()" |
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ exe "normal! zz" |
    \ endif

" Automatically update copyright notice with current year
autocmd BufWritePre *
    \ exec ":call UpdateCopyright()" |
    \ exec ":call DeleteTrailingWS()" |
    \ let &backupext = '.-' . strftime("%Y%m%d-%H%M%S")

" enable omni-completion
set omnifunc=syntaxcomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType perl set omnifunc=perlcomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType node set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType cpp set omnifunc=cppcomplete#Complete
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType d set omnifunc=ccomplete#Complete
autocmd Filetype octave set omnifunc=syntaxcomplete#Complete
autocmd FileType go set omnifunc=gocomplete#Complete

" commenting blocks of code.
autocmd FileType *                   let b:comment_leader = '// '
autocmd FileType c,d,cpp,java,scala  let b:comment_leader = '// '
autocmd FileType sh,ruby,python,text let b:comment_leader = '#  '
autocmd FileType conf,fstab,perl     let b:comment_leader = '#  '
autocmd FileType tex,octave          let b:comment_leader = '%  '
autocmd FileType mail                let b:comment_leader = '>  '
autocmd FileType vim                 let b:comment_leader = '"  '
autocmd FileType lisp                let b:comment_leader = ';; '
autocmd FileType haskell,vhdl,ada    let b:comment_leader = '-- '

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
nnoremap k gk
nnoremap j gj
nnoremap <Down> gj
nnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Map \ to replace
noremap \ :1,$s/%/ic

" Disable highlight when <leader>/ is pressed.
noremap <silent> <leader>/ :noh<CR>

" Del the tailing ^M (to work with MS-DOS files)
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()

" Opens a new tab with the current buffer's path
noremap <leader><CR> :tabedit <c-r>=expand("%:p:h")<CR>/

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Delete trailing white spaces
noremap <leader><BS> :%s/\s\+$//ge<CR>

" F5: run according to filetypes
au FileType python let g:pymode_run_bind = "<F5>"

" F6: toggle and untoggle spell checking
noremap <F6> :setlocal spell!<CR>

" F7: build something
""au FileType markdown nmap <F7> :!pandoc -f markdown+lhs % -o markdown.html -t dzslides -i -s -S --toc<CR>

" F8: open vim file explorer
nnoremap <F8>   :set background=light<CR>
nnoremap <S-F8> :set background=dark<CR>

" F11: add a parting line
noremap <F11> 2o<ESC>k:call AddPartingLine()<CR>j

" F12: attach copyright things
noremap <F12> :call AddCopyright()<CR>:call ProcessEnv()<CR>

" backspace in Visual mode deletes selection
vnoremap <BS> d
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>dw

" Use CTRL-S for saving, also in Insert mode
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" CTRL-F4 is Close window
noremap  <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

" Smart way to move between windows (<ctrl>j etc.)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" emacsish keybindings
noremap  <C-G> <Esc>
vnoremap <C-G> <Esc>
snoremap <C-G> <Esc>
inoremap <C-G> <Esc>
cnoremap <C-G> <Esc>

" run a command
noremap  <C-Z> :
vnoremap <C-Z> :
snoremap <C-Z> :
inoremap <C-Z> <C-O>:

"Change Y to yank to end of line
map Y y$

" paste over without overwriting register
xnoremap p pgvy
xnoremap P Pgvy

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" To avoid the extra 'shift' keypress when typing the colon to go to cmdline mode
noremap ; :
noremap ;; ;

" Quickly insert parenthesis/brackets/etc.
inoremap <space>( ()<esc>i
inoremap <space>[ []<esc>i
inoremap <space>{ {}<esc>i
inoremap <space>' ''<esc>i
inoremap <space>" ""<esc>i
inoremap <space>` ``<esc>i
inoremap <space>$ $$<esc>i
inoremap <space>\| \|\|<esc>i

" Surround the visual selection in parenthesis/brackets/etc.
vnoremap <space>( <esc>`>a)<esc>`<i(<esc>
vnoremap <space>[ <esc>`>a]<esc>`<i[<esc>
vnoremap <space>{ <esc>`>a}<esc>`<i{<esc>
vnoremap <space>" <esc>`>a"<esc>`<i"<esc>
vnoremap <space>' <esc>`>a'<esc>`<i'<esc>
vnoremap <space>` <esc>`>a`<esc>`<i`<esc>
vnoremap <space>$ <esc>`>a$<esc>`<i$<esc>
vnoremap <space>\| <esc>`>a\|<esc>`<i\|<esc>

" brackets
inoremap <expr> <silent> ( MayCloseParentheses('(')
inoremap <expr> <silent> [ MayCloseParentheses('[')
inoremap <expr> <silent> { MayCloseParentheses('{')

" Insert the current date and time (useful for timestamps)
iab xdate <c-r>=strftime("%Y/%m/%d %H:%M:%S")<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")
    if buflisted(l:alternateBufNum)
      buffer #
    else
      bnext
    endif
    if bufnr("%") == l:currentBufNum
      new
    endif
    if buflisted(l:currentBufNum)
      execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunction

function! MayCloseParentheses(cmd)
    if col('.') == col('$')
        if a:cmd == '('
            return "()\<Left>"
        elseif a:cmd == '{'
            return "{}\<Left>"
        elseif a:cmd == '['
            return "[]\<Left>"
        endif
    else
        if a:cmd == '('
            return "("
        elseif a:cmd == '['
            return "["
        elseif a:cmd == '{'
            return "{"
        endif
    endif
endfunction

function! AddPartingLine()
    call append(line('.'), b:comment_leader . "· <=>---<=> · <=>---<=> · <=>---<=> · <=>---<=> · <=>---<=> · <=>---<=>")
endfunction

function! AddCopyright()
    call append(0, b:comment_leader . "==============================================")
    call append(1, b:comment_leader . "·")
    call append(2, b:comment_leader . "· Author: truth-set-one-free")
    call append(3, b:comment_leader . "·")
    call append(4, b:comment_leader . "· truthset@one.free")
    call append(5, b:comment_leader . "·")
    call append(6, b:comment_leader . "· Filename: ".expand("%:t"))
    call append(7, b:comment_leader . "·")
    call append(8, b:comment_leader . "· COPYRIGHT ".strftime("%Y"))
    call append(9, b:comment_leader . "·")
    call append(10, b:comment_leader . "· This is the description.")
    call append(11, b:comment_leader . "·")
    call append(12, b:comment_leader . "==============================================")
    call append(13, "")
    echohl WarningMsg | echo "copyright information added." | echohl None
endfunction

function! UpdateCopyright()
    let n=1
    while n < 20
        let line = getline(n)
        if line =~ '\s*\S*COPYRIGHT\S*.*$'
            if line !~ strftime("%Y")
                exe "g#\\cCOPYRIGHT \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y")
            endif
            echohl WarningMsg | echo "copyright information updated." | echohl None
            return
        endif
        let n = n + 1
    endwhile
    echohl WarningMsg | echo "no copyright information found." | echohl None
endfunction

function! ProcessEnv()
    let n=1
    while n < 3
        let line = getline(n)
        if line =~ '\s*\S*env\S*.*$'
            echohl WarningMsg | echo "env information exists." | echohl None
            return
        endif
        let n = n + 1
    endwhile
    if     &filetype == 'sh'
        call append(0, b:comment_leader . "!/usr/bin/env fish")
    elseif &filetype == 'python' || &filetype == 'py'
        call append(0, b:comment_leader . "!/usr/bin/env python")
    else
        call append(0, b:comment_leader . "!/usr/bin/env " . &filetype)
    endif
    call append(1, b:comment_leader . "-*- coding:utf-8 -*-")
    call append(2, "")
    echohl WarningMsg | echo "env information added(press `gg` to check it)!" | echohl None
endfunction

augroup LargeFile
        " Set options:
        "   eventignore+=FileType (no syntax highlighting etc
        "   assumes FileType always on)
        "   noswapfile (save copy of file)
        "   bufhidden=unload (save memory when other file is viewed)
        "   buftype=nowritefile (is read-only)
        "   undolevels=-1 (no undo possible)
        let g:large_file = 10000000 " ~10MB

        au BufReadPre *
                \ let f=expand("<afile>") |
                \ if getfsize(f) > g:large_file |
                        \ set eventignore+=FileType |
                        \ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
                \ else |
                        \ set eventignore-=FileType |
                \ endif
augroup END
