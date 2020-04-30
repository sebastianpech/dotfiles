" Additional installs needed
" Installing node for iron
"   curl -s https://install-node.now.sh | sh -s -- --prefix=$HOME
"
" Installing neovim remote
"   pip3 install neovim-remote
"
" Install for Mundo
"   pip3 install pynvim
"
" Installing coc-texlab
"   CocInstall coc-texlab
"
" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load and install plugins
call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'
    Plug 'morhetz/gruvbox'
    Plug 'tpope/vim-commentary'
    Plug 'vim-airline/vim-airline'
    Plug 'kien/ctrlp.vim'
    Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'JuliaEditorSupport/julia-vim'
    Plug 'jremmen/vim-ripgrep'
    Plug 'simnalamburt/vim-mundo'
    if has('nvim')
        " Install node
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'Vigemus/iron.nvim'
    else
        Plug 'jpalardy/vim-slime'
    end
    Plug 'lervag/vimtex'
call plug#end()


" Disable bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" tpope/vim-commentary
" Julia
autocmd BufRead,BufNewFile *.jl setlocal commentstring=#\ %s
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_auto = 1

" Mappings
let mapleader = ","
let maplocalleader = ","
inoremap jk <ESC>
nnoremap j gj
" Change directory to current files
nnoremap <leader>cd :cd %:p:h<CR>

" Use sysem clipboard
set clipboard=unnamed

" Colorscheme
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

" Tabs
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" CtrlP config
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>r :CtrlPMRU<CR>

" Nerdtree
" Close if last
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open if folder is commandline arg
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" sync open file with NERDTree
" see https://stackoverflow.com/a/59977029
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction
nmap <C-n> :call ToggleNerdTree()<CR>


" Vim slime
if !has("nvim")
    let g:slime_target = "vimterminal"
end

" Enable mouse
set mouse=a
if !has("nvim")
    set ttymouse=xterm2
end

" Allow hiding of buffers
set hidden

" Activate relative line number
set rnu

" Completion functions for coc-nvim
if has("nvim")
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? coc#_select_confirm() :
                \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    let g:coc_snippet_next = '<tab>'
end

" Fugitive
nnoremap <leader>g :Git<CR>

" Iron
if has("nvim")
    nmap <C-c><C-c> <Plug>(iron-send-line)
    vmap <C-c><C-c> <Plug>(iron-visual-send)
    let g:iron_repl_open_cmd = 'hsplit'
end

" Neovim Terminal
if has("nvim")
    tnoremap <Esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>
end

" vimtex
if has('nvim')
    let g:vimtex_compiler_progname = 'nvr'
end
let g:tex_flavor = 'latex'

" Searching
set ignorecase
set smartcase
if has("nvim") 
  set inccommand=nosplit
endif
nnoremap g* *Ncgn

" Folding
set foldmethod=marker
