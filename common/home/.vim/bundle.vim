" Initialize with:
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" vim :BundleInstall

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle.
Bundle 'gmarik/vundle'

" Commenter.
let g:NERDSpaceDelims = 1
Bundle 'scrooloose/nerdcommenter'

" vim-bufferline.
let g:bufferline_echo = 0
let g:bufferline_active_buffer_left = '['
let g:bufferline_active_buffer_right = ']'
let g:bufferline_inactive_highlight = 'airline_c'
let g:bufferline_active_highlight = 'airline_c'
Bundle 'bling/vim-bufferline'

" vim-airline.
let g:airline_powerline_fonts = 1
let g:airline_theme = 'wombat'
let g:airline#extensions#bufferline#overwrite_variables = 0
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'

filetype plugin indent on

