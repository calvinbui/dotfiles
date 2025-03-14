call plug#begin('~/.vim/bundle')
Plug 'joshdick/onedark.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'vim-autoformat/vim-autoformat'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Put your non-Plugin stuff after this line


"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

:set nu
:set termguicolors

" theme
syntax on
colorscheme onedark

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start
set history=200 " keep 200 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set wildmenu " display completion matches in a status line

set ttimeout " time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
" Show @@@ in the last line if it is truncated.
set display=truncate
" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5
" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif
" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal
" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>
" set indent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Cursor shape
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" enable mouse
set mouse=a

lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
EOF
