if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
call plug#end()

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

autocmd FileType apache setlocal commentstring=#\ %s

" tpope/vim-commentary
" Julia
autocmd BufRead,BufNewFile *.jl setlocal commentstring=#\ %s




inoremap jk <ESC>
vnoremap jk <ESC>


