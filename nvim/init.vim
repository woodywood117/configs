"----- Plugins
call plug#begin('~/.local/share/nvim/plugged')
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vimwiki/vimwiki'
" Plug 'vifm/vifm'
" Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
" Plug 'vim-utils/vim-man'
" Plug 'mbbill/undotree'
" Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
" Plug 'andymass/vim-matchup'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim' " gc comments
" Plug 'tpope/vim-surround'
" Plug 'neomake/neomake', { 'for': ['rust', 'go'] }
Plug 'woodywood117/sonokai'
" Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
" Plug 'rhysd/vim-clang-format'
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'junegunn/fzf', {'dir': '~/.local/src/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'cohama/lexima.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'unblevable/quick-scope'
Plug 'christoomey/vim-tmux-navigator'
Plug 'posva/vim-vue'
call plug#end()


"----- Completion
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$/ containedin=ALL
" Undefined Marks
highlight UndefinedMarks ctermfg=yellow
autocmd Syntax * syn match UndefinedMarks /???/ containedin=ALL


"----- NERDTree
" Open NERDTree in the directory of the current file (or /home if no file is open)
function! NERDTreeToggleFind()
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    execute ":NERDTreeClose"
  else
    execute ":NERDTreeFind"
  endif
endfunction
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"----- FZF
let g:fzf_command_prefix = 'Fzf'
if executable('rg')
    let g:rg_derive_root='true'
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-messages "" .'
    set grepprg=rg\ --vimgrep
    " :Find <term> runs `rg <term>` and passes it to fzf
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif


"----- Racer
set hidden
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'
let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"
let g:racer_cmd = "/home/jwood/.cargo/bin/racer"
" let g:racer_experimental_completer = 1
au FileType rust nmap <leader>rx <Plug>(rust-doc)
au FileType rust nmap <leader>rd <Plug>(rust-def)
au FileType rust nmap <leader>rs <Plug>(rust-def-split)


"----- Neomake
" Gross hack to stop Neomake running when exitting because it creates a zombie cargo check process
" which holds the lock and never exits. But then, if you only have QuitPre, closing one pane will
" disable neomake, so BufEnter reenables when you enter another buffer.
" let s:quitting = 0
" au QuitPre *.rs let s:quitting = 1
" au BufEnter *.rs let s:quitting = 0
" au BufWritePost *.rs if ! s:quitting | Neomake | else | echom "Neomake disabled"| endif
" au QuitPre *.ts let s:quitting = 1
" au BufEnter *.ts let s:quitting = 0
" au BufWritePost *.ts if ! s:quitting | Neomake | else | echom "Neomake disabled"| endif
" let g:neomake_warning_sign = {'text': '?'}


"----- Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'sonokai'
let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


"----- General Settings
set termguicolors
colorscheme sonokai
let g:sonokai_style = 'atlantis'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
let transparency=10
let mapleader=" "
set nocompatible
filetype plugin on
syntax on
set colorcolumn=80
set cursorline
set cursorcolumn
" autocmd BufRead *.rs set filetype=rust
" autocmd BufRead *.go set filetype=go
autocmd BufRead,BufNewFile *.rs setfiletype rust
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd BufRead,BufNewFile *.vue setfiletype vue,html,css
set number
" set relativenumber
set title
set mouse=a
set noerrorbells
set smartindent
set autoindent
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set splitbelow splitright
set signcolumn=yes
set clipboard=unnamedplus
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_doc_keywordprg_enabled = 0 " Disables keybinding for K in go files
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_metalinter_autosave = 0
set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
set listchars=tab:│\ 
set list
let g:vimwiki_list = [{'path': '~/.config/nvim/vimwiki'}]
au FileType c,cpp,go,rust call rainbow#load()
set foldmethod=syntax
set foldlevel=99
set foldnestmax=1
set wildmode=longest,list,full
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Set tab for vue files
autocmd BufRead,BufNewFile *.vue set expandtab
autocmd BufRead,BufNewFile *.vue set shiftwidth=2
autocmd BufRead,BufNewFile *.vue set softtabstop=2
autocmd BufRead,BufNewFile *.vue set tabstop=2
let g:vue_pre_processors = 'detect_on_enter'

autocmd VimLeave * call system("xsel -ib", getreg('+')) " prevent vim from clearing clipboard on close

" utf-8 ftw
" nvim sets utf8 by default, wrap in if because prevents reloading vimrc
if !has('nvim')
  set encoding=utf-8
endif


"----- Key Remaps
nmap <C-w> :wa<CR> " Quicksave
nmap <C-q> :qa!<CR> " Quick quit, no save
nmap <C-x> :xa<CR> " Quicksave and quit
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Use <c-.> to trigger completion.
inoremap <silent><expr> <C-.> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" nmap <silent> gi <Plug>(coc-diagnostic-info)
nnoremap <silent> K :call CocAction('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename) " Symbol renaming.

nnoremap <leader>c :call NERDTreeToggleFind()<cr> " toggle nerdtree

nnoremap <leader>v :FzfGFiles<cr>
nnoremap <leader>b :FzfFiles<cr>
" nnoremap <leader>u :FzfTags<cr>
" nnoremap <leader>j :call fzf#vim#tags("'".expand('<cword>'))<cr>
nnoremap <leader>/ :Find 
nnoremap <leader>' :execute "Find " . expand("<cword>")<cr>
noremap <silent> <c-_> :let @/ = ""<CR>

noremap <leader>v+ :resize +5<CR>
noremap <leader>v- :resize -5<CR>
noremap <leader>h+ :vertical resize +5<CR>
noremap <leader>h- :vertical resize -5<CR>
noremap <C-S-Up> :resize -5<CR>
noremap <C-S-Down> :resize +5<CR>
noremap <C-S-Right> :vertical resize -5<CR>
noremap <C-S-Left> :vertical resize +5<CR>

" Copy
noremap <Leader>y "+y
noremap <Leader>p "+p
autocmd FileType go nmap <leader>d :GoDecls<CR>

nnoremap <leader>f za
nnoremap <expr> <leader>F &foldlevel ? 'zM' :'zR'

nmap <silent> sv :vs<CR>
nmap <silent> ss :sp<CR>

map <C-t> :tabnew<cr>
nmap <C-Left> :tabprev<Return>
nmap <C-Right> :tabnext<Return>
