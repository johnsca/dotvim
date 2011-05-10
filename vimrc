set mouse=a
syntax enable
set shiftwidth=4
set sts=4
set et
set ts=8
set ai
set si
set ruler
set rulerformat=%30(%t\ \ %c,%l\ %L\ (%p%%)%)
set is
set ignorecase
set smartcase
set backspace=eol,start,indent

set undodir=~/.vim/undodir
set undofile
set showcmd

set foldmethod=indent
set foldlevel=-2

map <leader>td <Plug>TaskList

filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

filetype on
filetype plugin indent on

"let g:miniBufExplorerMoreThanOne=1

set clipboard=unnamed
vnoremap <LeftRelease> "+y<LeftRelease>
vnoremap <2-LeftRelease> "+y<LeftRelease>

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

let mapleader=","

" vimgrep selected text or none
vnoremap <silent> gv :call VisualSearch('gv')<CR>
vnoremap <silent> gn :call VisualSearch('gn')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
nmap <silent> <leader>* viwgn

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy`>"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "\<CR>"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . "/". l:pattern . "/" . " **/*.")
    elseif a:direction == 'gn'
        execute "vimgrep " . "/". l:pattern . "/" . " **/*.py **/*.html **/*.txt\<CR>"
        cope
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "\<CR>"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <C-o> :botright cope<cr>
map <C-n> :cn<cr>
map <C-p> :cp<cr>

" Make <visual>-s work like normal
vnoremap <C-s> <Plug>Vsurround

nohls " remove any previous search
set hls " highlight searches
set hl+=i:IncSearch " highlight incremental searches
set hl-=l:Search " don't (semi)permanently highlight normal searches
set hl+=ln " no, seriously, don't highlight them

" Execute 'lnoremap x X' and 'lnoremap X x' for each letter a-z.
for c in range(char2nr('A'), char2nr('Z'))
  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
  execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
endfor

" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0

autocmd FileType cucumber set sw=2 sts=2

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:pyflakes_use_quickfix = 0

set nu

let Tlist_Ctags_Cmd="/opt/local/bin/ctags"
let Tlist_WinWidth=50
map <F4> :TlistToggle<CR>
map <F8> :!/opt/local/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

if &term=="xterm" || &term=="xterm-color" || &term=="xterm-256color"
    set t_Co=256
    set background=dark
    colorscheme coldgreen
    hi comment ctermfg=242
    hi linenr ctermfg=242
    hi search ctermbg=None cterm=inverse
    hi directory ctermfg=12
    hi specialkey ctermfg=12
endif

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
