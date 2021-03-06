" Additional installs needed
" Installing neovim remote
"   pip3 install neovim-remote
"
" Install for Mundo
"   pip3 install pynvim
"
" Auto install vim-plug
"
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
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'JuliaEditorSupport/julia-vim'
    Plug 'simnalamburt/vim-mundo'
    if has('nvim') || has('patch-8.0.902')
      Plug 'mhinz/vim-signify'
    else
      Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    if has('nvim')
        Plug 'neovim/nvim-lsp'
        Plug 'neovim/nvim-lspconfig'
        Plug 'nvim-lua/completion-nvim'
        Plug 'sebastianpech/term-repl'
        Plug 'hrsh7th/vim-vsnip'
        Plug 'hrsh7th/vim-vsnip-integ'
    else
        Plug 'jpalardy/vim-slime'
    end
    Plug 'lervag/vimtex'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    Plug 'voldikss/vim-floaterm'
    Plug 'tpope/vim-obsession'
    Plug 'nathangrigg/vim-beancount'
    Plug 'stefandtw/quickfix-reflector.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'szw/vim-g'
    Plug 'Raimondi/delimitMate'
    Plug 'sheerun/vim-polyglot'
    Plug 'ledger/vim-ledger'
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
nnoremap k gk
" Change directory to current files
nnoremap <localleader>wd :cd %:p:h<CR>:pwd<CR>

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

" Nerdtree
" Close if last
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open if folder is commandline arg
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

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
    autocmd BufEnter * lua require'completion'.on_attach()

lua << EOF
    local nvim_lsp = require'lspconfig'
    nvim_lsp.vimls.setup({on_attach=on_attach_vim})
    nvim_lsp.bashls.setup({on_attach=on_attach_vim})
    nvim_lsp.julials.setup({on_attach=on_attach_vim})
    nvim_lsp.pyls.setup{
          settings = {
              pyls = {
                  configurationSources = {
                      pycodestyle,
                      flake8
                  },
                  plugins = {
                      mccabe = { enabled = false },
                      preload = { enabled = true },
                      pycodestyle = {
                          enabled = true,
                          ignore = { "E501" },
                      },
                      pydocstyle = {
                          enabled = false,
                      },
                      pyflakes = { enabled = true },
                      pylint = { enabled = false },
                      rope_completion = { enabled = true },
                      black = { enabled = false },
                  }
              }
          }
       }
EOF

    let g:diagnostic_auto_popup_while_jump = 0
    let g:diagnostic_enable_virtual_text = 0
    let g:diagnostic_enable_underline = 0
    let g:completion_timer_cycle = 200 "default value is 80
    let g:completion_matching_ignore_case = 1
    let g:completion_enable_auto_hover = 1
    let g:completion_enable_auto_signature = 1
    let g:completion_enable_auto_popup = 1
    let g:completion_matching_ignore_case = 1

    nnoremap <silent> <leader>ld :lua vim.lsp.util.show_line_diagnostics()<CR>

    " Set completeopt to have a better completion experience
    set completeopt=menuone,noinsert,noselect

    " Avoid showing message extra message when using completion
    set shortmess+=c
    autocmd Filetype julia setlocal omnifunc=v:lua.vim.lsp.omnifunc

    nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>

    call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
    call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
    call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
    call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

end

" Fugitive
nnoremap <leader>g :Git<CR>

" Iron
if has("nvim")
    nmap <C-c><C-c> :call SendLine()<CR>
    vmap <C-c><C-c> :call SendLines()<CR>
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

" zotero
function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'citep' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>z "=ZoteroCite()<CR>p

" Searching
set ignorecase
set smartcase
if has("nvim") 
  set inccommand=nosplit
endif
nnoremap g* *Ncg

" Folding
set foldmethod=marker

" Markdown

"fzf

nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

"image paste
autocmd FileType pandoc nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
autocmd FileType pandoc nmap <buffer><silent> <leader>ll :Pandoc #default<CR>
" let g:pandoc#biblio#bibs = ['~/m/Literatur/Literatur.bib']
let g:pandoc#biblio#bibs = ['/Users/spech/m/Literatur/Literatur.bib']
au! BufNewFile,BufFilePre,BufRead *.jmd set filetype=Pandoc
" let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
" let g:pandoc#filetypes#pandoc_markdown = 0

" Floaterm
if has('nvim-0.4.0')
    let g:floaterm_keymap_toggle = '<Leader>t'
else
    let s:term_buf = 0
    let s:term_win = 0

    function! TermToggle(height)
        if win_gotoid(s:term_win)
            hide
        else
            new terminal
            exec "resize ".a:height
            try
                exec "buffer ".s:term_buf
                exec "bd terminal"
            catch
                call termopen($SHELL, {"detach": 0})
                let s:term_buf = bufnr("")
                setlocal nonu nornu scl=no nocul
            endtry
            startinsert!
            let s:term_win = win_getid()
        endif
    endfunction

    nnoremap <silent><Leader>t :call TermToggle(12)<CR>
    tnoremap <silent><Leader>t <C-\><C-n>:call TermToggle(12)<CR>
end

" Indent guid lines
let g:diagnostic_auto_popup_while_jump = 0
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_enable_underline = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_color_change_percent = 1
let g:indent_guides_exclude_filetypes = ['help', 'fzf', 'openterm', 'neoterm', 'calendar']

set signcolumn=yes

nnoremap go :Google<CR>

" Persisten undo
"" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo
nnoremap <leader>u :MundoToggle<CR>

" Python 
"
autocmd Filetype python let b:REPL = 'python3'
