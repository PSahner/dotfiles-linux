" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

" Use the Solarized Dark theme
syntax enable
set background=dark
silent! colorscheme solarized
let g:solarized_termtrans=1
" Enable full-color support.
set t_Co=256
if !has("gui_running")
    let g:solarized_contrast = "high"
    let g:solarized_termcolors = 256
    let g:solarized_termtrans = 1
    let g:solarized_visibility = "high"
endif

" Make Vim more useful => don't make Vim vi-compatibile
set nocompatible
" Use the system clipboard as the default register
set clipboard=unnamed
if has('unnamedplus')
    set clipboard+=unnamedplus
endif  
" Enhance command-line completion
if has('wildmenu')
    set wildmenu
endif 

" Allow cursor keys in insert mode
" set esckeys

" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","

" Don’t add empty newlines at the end of files
" set binary
" set noeol

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

" Don’t create backups when editing files in certain directories
if has('wildignore')
    set backupskip=/tmp/*,/private/tmp/*
endif

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight certain column(s) and current line
if has('syntax')
    set colorcolumn=73
    set cursorline
endif
" Set global <TAB> settings (make tabs as wide as two spaces)
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" Copy indent to the new line.
set autoindent
" Increase the minimal number of columns used for the `line number`.
if has('linebreak')
    set numberwidth=5
endif

" Show “invisible” characters
" Use custom symbols to represent invisible characters."
" set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" set list

if has('extra_search')
    " Highlight searches
    set hlsearch
    " Highlight dynamically as pattern is typed
    set incsearch
endif
" Ignore case of searches
set ignorecase

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse+=a
" Hide mouse pointer while typing.
set mousehide

" Disable beeping and window flashing.
" https://vim.wikia.com/wiki/Disable_beeping"
set noerrorbells
set visualbell
set t_vb=

" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
if has('cmdline_info')
    set ruler
endif
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
if has('cmdline_info')
    set showcmd
endif

" Use relative line numbers
" if exists("&relativenumber")
" 	set relativenumber
"	au BufReadPost * set relativenumber
" endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype plugin indent on
    "           │     │    └──────── Enable file type detection.
    "           │     └───────────── Enable loading of indent file.
    "           └─────────────────── Enable loading of plugin files.
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" When making a change, don't redisplay the line, and instead,
" put a `$` sign at the end of the changed text.
set cpoptions+=$

" Do not redraw the screen while executing macros, registers
" and other commands that have not been typed.
set lazyredraw

" Enable extended regexp.
set magic

" When using the join command, only insert a single space after a `.`, `?`, or `!`.
set nojoinspaces

" Disable for security reasons.
" https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme
set nomodeline

" Report the number of lines changed.
set report=0

" Set the spellchecking language.
if has('syntax')
    set spelllang=en_us
endif

" Override `ignorecase` option if the search pattern contains uppercase characters.
set smartcase

" Limit syntax highlighting (this avoids the very slow redrawing when files contain long lines).
if has('syntax')
    set synmaxcol=2500
endif

" Allow cursor to be anywhere.
if has('virtualedit')
    set virtualedit=all
endif

" Allow windows to be squashed.
if has('windows')
    set winminheight=0
endif

" Prevent `Q` in `normal` mode from entering `Ex` mode.
nmap Q <Nop>

" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! GetGitBranchName()

    let branchName = ""

    if exists("g:loaded_fugitive")
        let branchName = "[" . fugitive#Head() . "]"
    endif

    return branchName

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! PrettyPrint()

    if ( &filetype == 'json' && (has('python3') || has('python')) )
        %!python -m json.tool
        norm! ggVG==
    elseif ( &filetype == 'svg' || &filetype == 'xml' )
        set formatexpr=xmlformat#Format()
        norm! Vgq
    endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! StripBOM()
    if has('multi_byte')
        set nobomb
    endif
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! StripTrailingWhitespaces()

    " Save last search and cursor position.

    let searchHistory = @/
    let cursorLine = line(".")
    let cursorColumn = col(".")

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Strip trailing whitespaces.

    %s/\s\+$//e

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Restore previous search history and cursor position.

    let @/ = searchHistory
    call cursor(cursorLine, cursorColumn)


endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ToggleLimits()

    " [51,73]
    "
    "   * Git commit message
    "     http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
    "
    " [81]
    "
    "   * general use
    "     https://daniel.haxx.se/blog/2020/11/30/i-am-an-80-column-purist/

    if ( &colorcolumn == "73" )
        set colorcolumn+=51,81
    else
        set colorcolumn-=51,81
    endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ToggleRelativeLineNumbers()

    if ( &relativenumber == 1 )
        set number
    else
        set relativenumber
    endif

endfunction

" ----------------------------------------------------------------------
" | Status Line                                                        |
" ----------------------------------------------------------------------

" Terminal types:
"
"   1) term  (normal terminals, e.g.: vt100, xterm)
"   2) cterm (color terminals, e.g.: MS-DOS console, color-xterm)
"   3) gui   (GUIs)

highlight ColorColumn
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLine
    \ term=NONE
    \ cterm=NONE  ctermbg=235  ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLineNr
    \ term=bold
    \ cterm=bold  ctermbg=NONE   ctermfg=178
    \ gui=bold    guibg=#073642  guifg=Orange

highlight LineNr
    \ term=NONE
    \ cterm=NONE  ctermfg=241    ctermbg=NONE
    \ gui=NONE    guifg=#839497  guibg=#073642

highlight User1
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=Grey
    \ gui=NONE    guibg=#073642  guifg=#839496

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set statusline=
set statusline+=%1*            " User1 highlight
set statusline+=\ [%n]         " Buffer number
set statusline+=\ %{GetGitBranchName()}        " Git branch name
set statusline+=\ [%f]         " File path
set statusline+=%m             " Modified flag
set statusline+=%r             " Readonly flag
set statusline+=%h             " Help file flag
set statusline+=%w             " Preview window flag
set statusline+=%y             " File type
set statusline+=[
set statusline+=%{&ff}         " File format
set statusline+=:
set statusline+=%{strlen(&fenc)?&fenc:'none'}  " File encoding
set statusline+=]
set statusline+=%=             " Left/Right separator
set statusline+=%c             " File encoding
set statusline+=,
set statusline+=%l             " Current line number
set statusline+=/
set statusline+=%L             " Total number of lines
set statusline+=\ (%P)\        " Percent through file

" Example result:
"
"  [1] [main] [vim/vimrc][vim][unix:utf-8]            17,238/381 (59%)

" ----------------------------------------------------------------------
" | Local Settings                                                     |
" ----------------------------------------------------------------------

" Load local settings if they exist.
"
" [!] The following needs to remain at the end of this file in
"     order to allow any of the above settings to be overwritten
"     by the local ones.

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
