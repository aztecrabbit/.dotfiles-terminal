" Auto Install Vim Plug
"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


" Vim Plug
"

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

Plug 'airblade/vim-gitgutter'                           " git diff
Plug 'vim-airline/vim-airline'                          " status bar
Plug 'tpope/vim-commentary'                             " comment
Plug 'sheerun/vim-polyglot'                             " syntax highlight
Plug 'preservim/nerdtree'                               " nerd tree

Plug 'flazz/vim-colorschemes'
Plug 'joshdick/onedark.vim'

call plug#end()


" Settings
"

filetype on
filetype plugin indent on

set term=xterm-256color
set number
set splitbelow
set splitright
set termguicolors
set colorcolumn=120
set tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab smarttab

set list
set listchars=tab:\|\ ,trail:■

set nowrap


" Interface
"

syntax on
colorscheme onedark


" Shortcut
"

nnoremap <C-t> :NERDTreeToggle<CR>
