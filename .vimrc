if has('gui_running')
	set guicursor=a:blinkon0 " Disable blinking cursor
else
    set term=xterm
endif

:syntax enable
:set background=dark
colorscheme herald

filetype on
filetype plugin on

" General
set cursorline          	" underline current line
set shm=atI                 " Disable intro screen
set lazyredraw              " Don't redraw screen during macros
set ttyfast                 " Improves redrawing for newer computers
set history=50              " Only store past 50 commands
set undolevels=200          " Only undo up to 150 times
set titlestring=%f title    " Display filename in terminal window
set rulerformat=%l:%c ruler " Display current column/line in bottom right
set showcmd                 " Show incomplete command at bottom right
set splitbelow              " Open new split windows below current
set wrap linebreak          " Automatically break lines
set pastetoggle=<f2>        " Use <f2> to paste in text from other apps
set wildmode=full wildmenu  " Enable command-line tab completion
set wildignore+=*.o,*.obj,*.pyc,*.DS_Store,*.db,*.hi " Hide irrelevent matches
set hidden                  " Allow hidden buffers
set mouse=a                 " Enable mouse support
set enc=utf-8
set nobackup        " do not keep a backup file
set number          " show line numbers
set numberwidth=4   " line numbering takes up to 4 spaces
set ignorecase smartcase
set ruler               " show cursor position in status line


"" Backup Files
set backup              " make backups
set backupdir=~/tmp     " but don't clutter $PWD with them
if !isdirectory(&backupdir)
    " create the backup directory if it doesn't already exist
    exec "silent !mkdir -p " . &backupdir
endif


"" Sane whitespace and tab
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set textwidth=79
set softtabstop=4
set autoindent

" Auto Indent
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Remove Trailing whitespace
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

" Correct some spelling mistakes
ia teh the
ia htis this
ia tihs this
ia eariler earlier
ia funciton function
ia funtion function
ia fucntion function
ia retunr return
ia reutrn return
ia foreahc foreach
ia !+ !=
ca eariler earlier
ca !+ !=
ca ~? ~/


"NERDTree settings
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks=1

"Mini buffer Explorer
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1
hi MBENormal guifg=#254307 ctermfg=darkblue
hi MBEChanged guifg=#254307 ctermfg=darkblue gui=bold cterm=bold
hi MBEVisibleNormal guifg=#62c600 ctermfg=darkblue
hi MBEVisibleChanged guifg=#62c600 ctermfg=darkblue gui=bold cterm = bold


"" Detect django models file
if getline(1) =~ 'from django.db import models'
    runtime! ftplugin/django_model_snippets.vim
endif

let mapleader = ','

" Keep traditional <c-o> functionality
nn ,o <c-o>
" Easier way to navigate windows
nm , <c-w>
nn ,, <c-w>p
nn ,W <c-w>w
nn ,n :vnew<cr>
nn ,w :w<cr>
nn ,x :x<cr>
" Switch to alternate window (mnemonic: ,alternate)
nn ,a <c-^>

map <F3> :NERDTreeToggle<CR>
map <F4> :TlistToggle<CR>
map <F7> :!/usr/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"Try some minibufexplorer mapping
nm <silent> <D-[> :MBEbp<CR>
nm <silent> <D-]> :MBEbn<CR>
im <silent> <D-[> <esc>:MBEbp<CR>i
im <silent> <D-]> <esc>:MBEbn<CR>i


" Autocompletion
autocmd FileType python set omnifunc=pysmell#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"


imap <C-c>i <C-R>=RopeCodeAssistInsertMode()<CR>

let ropevim_codeassist_maxfixes=10
let ropevim_guess_project=1
let ropevim_vim_completion=1
let ropevim_enable_autoimport=1
let ropevim_extended_complete=1


function! CustomCodeAssistInsertMode()
    call RopeCodeAssistInsertMode()
    if pumvisible()
        return "\<C-L>\<Down>"
    else
        return ''
    endif
endfunction

function! TabWrapperComplete()
    let cursyn = synID(line('.'), col('.') - 1, 1)
    if pumvisible()
        return "\<C-Y>"
    endif
    if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$' || cursyn != 0
        return "\<Tab>"
    else
        return "\<C-R>=CustomCodeAssistInsertMode()\<CR>"
    endif
endfunction

inoremap <buffer><silent><expr> <Tab> TabWrapperComplete()


"" Rope refactoring tool
nnoremap <silent> <S-z> :RopeShowDoc<CR>


"" Sane Folding
set foldlevel=9999        " initially open all folds
" Space folds and unfolds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
inoremap <Nul> @=(foldlevel('.')?'zM':'l')<CR>


inoremap <c-space> <c-n>

set tags=tags;$HOME/.vim/tags/ "recursively searches directory for 'tags' file

" TagList Plugin Configuration
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"" point taglist to ctags
let Tlist_GainFocus_On_ToggleOpen = 1      " Focus on the taglist when its toggled
let Tlist_Close_On_Select = 1              " Close when something's selected
let Tlist_Use_Right_Window = 1             " Project uses the left window
let Tlist_File_Fold_Auto_Close = 1         " Close folds for inactive files
let Tlist_Auto_Highlight_Tag = 1 " Automatically highlight the current tag
let Tlist_Auto_Open = 1 " Auto open taglist
let Tlist_Auto_Update = 1
let Tlist_Display_Tag_Scope = 1
let Tlist_Enable_Fold_Column = 1
let Tlist_Highlight_Tag_On_BufEnter = 0 " Don't highlight on buffer enter
let Tlist_GainFocus_On_ToggleOpen = 0 " Focus on the taglist when its toggled
let Tlist_Show_Menu = 1 " Show menu for taglist

"" Show recent files when opening vim
" autocmd BufWinEnter * :MRU
argdo let file_specified=1
if !exists('file_specified')
    autocmd VimEnter * :MRU
endif

" Textmate Quick open mapping
noremap ,t :FuzzyFinderTextMate<CR>

"deliMate mappings
inoremap <Space> <C-R>=delimitMate#ExpandSpace()<CR>
inoremap <expr> <CR> pumvisible() ? "\<c-y>" : "\<C-R>=delimitMate#ExpandReturn()\<CR>"

"" Add workpath to python
python << EOF
import os
import sys
import vim
sys.path.append("/Library/Python/2.6/site-packages")
EOF

