syntax on
colorscheme jim

set mouse=a
set clipboard=unnamedplus " 7.3 only. Yank to the X clipboard.

set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

set backspace=2
set vb t_vb=

set showmode     " Show mode.
set showmatch    " Show matching braces/brackets/etc.
set ruler        " Show ruler in bottom-right corner (file position).
set showcmd      " Show (partial) command in the last line of the screen.
set incsearch    " Incremental search.
set hlsearch     " Highlight search results.
set title        " Set terminal title (including filename).
set autoread     " If an unmodified file gets updated externally, read it.

set formatoptions+=j  " Make J deal with comments.

" set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
set nolist

" Tab-complete filenames to longest unambiguous match and present menu:
"set wildmenu wildmode=longest:full
set wildmenu
set wildmode=list:longest,full

function NextBuffer()
  if tabpagenr('$') > 1
    tabnext
  else
    bnext
  endif
endfunction

function PrevBuffer()
  if tabpagenr('$') > 1
    tabprev
  else
    bprev
  endif
endfunction

function CloseBuffer()
  if tabpagenr('$') > 1
    tabclose
  else
    bdelete
  endif
endfunction

" Close/Next/Prev buffer / tab.
nmap <Leader>w :call CloseBuffer()<CR>
nmap <Leader><LEFT> :call PrevBuffer()<CR>
nmap <Leader><RIGHT> :call NextBuffer()<CR>
nmap <M-LEFT> :call PrevBuffer()<CR>
nmap <M-RIGHT> :call NextBuffer()<CR>
nmap <Leader><Leader> :b#<CR>

" Quit.
nmap <Leader>q :bdelete<CR>:q<CR>

" Make paste in visual mode keep the current register value
vnoremap p "_xP

" Search backward/forward for opening brace of a function, namespace, etc.
map [[ ?{<CR>?^[^ ]<CR>/{<CR>
ounmap [[
map ]] /^[^ }]<CR>/{<CR>
ounmap ]]

" Autoload commands:
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
endif

" Switch between .h / -inl.h / .cc / .py / .js / _test.* / _unittest.* with ,h ,i ,c ,p ,j ,t ,u
" let pattern = '\(\(_\(unit\)\?test\)\?\.\(cc\|js\|py\)\|\(-inl\)\?\.h\)$'
" nmap ,c :e <C-R>=substitute(expand("%"), pattern, ".cc", "")<CR><CR>
" nmap ,h :e <C-R>=substitute(expand("%"), pattern, ".h", "")<CR><CR>
" nmap ,i :e <C-R>=substitute(expand("%"), pattern, "-inl.h", "")<CR><CR>
" nmap ,t :e <C-R>=substitute(expand("%"), pattern, "_test.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
" nmap ,u :e <C-R>=substitute(expand("%"), pattern, "_unittest.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
" nmap ,p :e <C-R>=substitute(expand("%"), pattern, ".py", "")<CR><CR>
" nmap ,j :e <C-R>=substitute(expand("%"), pattern, ".js", "")<CR><CR>
" nmap ,b :e <C-R>=substitute(expand("%"), '[^/]*$', "BUILD", "")<CR><CR>

"Turn off auto text wrapping. (Format manually with gq)
set fo-=t

" Case-insenstive commands.
command! Qa :qa
command! QA :qa
command! Q :q
command! Wa :wa
command! WA :wa
command! Wn :wn
command! WN :wn
command! Wp :wp
command! WP :wp
command! Wqa :wqa
command! WqA :wqa
command! WQa :wqa
command! WQA :wqa
command! Wq :wq
command! WQ :wq
command! W :w

" Undo vim-autoformatting after a clipboard paste.
imap <C-z> <ESC>u:set paste<CR>.:set nopaste<CR>i

" Make * keep cursor position without jumping to next match.
nmap * :let @/='<C-R><C-W>'<CR>:set hls<CR>

" Keep visual selection after indent/outdent.
vnoremap < <gv
vnoremap > >gv

set hidden

" Trigger vimbuild.
nmap <Leader>. :!touch /tmp/vimbuild<CR><CR>

" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = substitute(system("find . | dmenu -i -p " . a:cmd), '\n$', '', '')
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

map <Leader>d :call DmenuOpen("e")<cr>

" Show first quickfix error.
nmap <Leader>e1 :cc1<CR>
" Show next/prev quickfix error.
nmap <Leader>ee :cn<CR>
nmap <Leader>er :cp<CR>
" Hide quickfix window.
nmap <Leader>eq :ccl<CR>

" Make CR split lines in normal mode.
nmap  i<CR><ESC>
