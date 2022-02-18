syntax on
set background=dark

" install vim-plug if not available
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" required by theme
if (has("termguicolors"))
 set termguicolors
endif

" To make the cursor blink and become a line in insert mode
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

" Required by coc
set hidden " TextEdit might fail if hidden is not set.
set encoding=utf-8 " unicode characters in the file autoload/float.vim
set nobackup " Some servers have issues with backup files, see #649.
set nowritebackup " Some servers have issues with backup files, see #649.
set updatetime=300 " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"Space is the leader
let mapleader= "\<Space>"

" UI
set number " show line numbers
set showcmd " show command in bottom bar
set cursorline " highlight current line
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{()}]
set wildmenu " visual autocomplete for command menu
set cmdheight=2 " Give more space for displaying messages
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast
" Spaces and tabs
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set expandtab " tabs are spaces. In other words, tab will just insert 4 spaces

" Search
set incsearch " search as characters are entered
set hlsearch " highlight matches
:set ignorecase
:set smartcase

" Folds
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max
" Misc
set backspace=indent,eol,start " Backspace works normal in Insert mode"

" Plugins
call plug#begin()
Plug 'thoughtbot/vim-rspec'
Plug 'https://github.com/hashivim/vim-terraform.git'
Plug 'tpope/vim-fugitive'
Plug 'arcticicestudio/nord-vim'
Plug 'https://github.com/joshdick/onedark.vim'
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dense-analysis/ale'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vim-which-key'
call plug#end()
" Terraform settings"
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_fmt_on_save=1
" Theme settings
colorscheme nord
" NERDTree settings
let g:NERDTreeWinSize = 40
let NERDTreeShowHidden=1

" ALE settings

" FIXERS
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ 'ruby': ['rubocop'],
      \ 'json': ['jq'],
  	  \ 'bash': ['ShellCheck'],
      \ 'go': ['gofmt'],
			\ 'css': ['csslint'],
			\ 'html': ['htmlhint'],
			\ 'java': ['pmd']
      \}
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_autoimport = 1
nmap <leader>cdp <Plug>(ale_previous_wrap)
nmap <leader>cdn <Plug>(ale_next_wrap)
nnoremap <leader>cl :ALEFix<CR>
set rtp+=~/.fzf

" Lightline settings
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified'], ['absolutepath'] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], ['filetype'] ]
      \ },
      \ 'component_function': {
			\   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" coc settings
" To install the missing language servers upon startup
let g:coc_global_extensions = ['coc-json', 'coc-html', 'coc-solargraph', 'coc-markdownlint', 'coc-sh', 'coc-sql', 'coc-spell-checker', 'coc-xml', 'coc-yaml', 'coc-go']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <C-space> coc#refresh()
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <leader>cgd <Plug>(coc-definition)
nmap <leader>cgy <Plug>(coc-type-definition)
nmap <leader>cgi <Plug>(coc-implementation)
nmap <leader>cgr <Plug>(coc-references)

" show documentation in preview window.
nnoremap <leader>ck :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>crn <Plug>(coc-rename)

" vim-rspec settings

map <F5> :call RunCurrentSpecFile()<CR>
map <F6> :call RunNearestSpec()<CR>
map <F7> :call RunLastSpec()<CR>
map <F8> :call RunAllSpecs()<CR>

" vim which-key
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" After pressing leader the guide buffer will pop up when there are no further keystrokes within timeoutlen
set timeoutlen=100
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
let g:which_key_map =  {}

" Mappings
let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
" SEARCH <leader>f
	" open silver searcher - search for content of files
nnoremap <leader>fa :Ag<CR>
	" open fuzzy finder - search for files
nnoremap <leader>ff :Files<CR>
  " open latest files
nnoremap <leader>fh :History<CR>
  " change colors
nnoremap <leader>fc :Colors<CR>
let g:which_key_map['f'] = {
      \ 'name' : '+fzf' ,
      \ 'a' : ['Ag'  , 'find content']      ,
      \ 'f' : ['Files'  , 'find files']   ,
      \ 'h' : ['History'  , 'history']   ,
      \ 'c' : ['Colors'  , 'colors']   ,
      \ }

" NERDTree <leader>e
	" open/close NERDTree
nnoremap <leader>ee :NERDTreeToggle<CR>
	" find in NERDTree
nnoremap <leader>ef :NERDTreeFind<CR>
	" refresh
nnoremap <leader>er :NERDTreeRefreshRoot<CR>
let g:which_key_map['e'] = {
      \ 'name' : '+explorer' ,
      \ 'e' : ['NERDTreeToggle'  , 'toggle explorer']      ,
      \ 'f' : ['NERDTreeFind'  , 'find file in tree']   ,
      \ 'r' : ['NERDTreeRefreshRoot'  , 'refresh tree']   ,
      \ }
" NAVIGATION <leader>
	" jump left
nnoremap <leader>l 10l
let g:which_key_map['l'] = 'which_key_ignore'
	" jump up
nnoremap <leader>k 10k
let g:which_key_map['k'] = 'which_key_ignore'
	" jump down
nnoremap <leader>j 10j
let g:which_key_map['j'] = 'which_key_ignore'
	" jump left
nnoremap <leader>h 10h
let g:which_key_map['h'] = 'which_key_ignore'
" SEARCH <leader>s
	" search for whatever under cursor
nnoremap <leader>s *N
let g:which_key_map['s'] = 'which_key_ignore'
	" let got of the search
nnoremap <leader>sa :noh<CR>
let g:which_key_map['sa'] = 'which_key_ignore'
" EXIT/SAVE <leader>q
	" exit without save
nnoremap <leader>qqq :qa!<CR>
	" save all
nnoremap <leader>qws :wa<CR>
	" save all and close all
nnoremap <leader>qwq :wa<CR> :qa<CR>
let g:which_key_map['q'] = {
      \ 'name' : '+quiet/save' ,
      \ 'qq' : [':qa!<CR>' , 'exit without save']   ,
      \ 'ws' : [':wa<CR>' , 'save']   ,
      \ 'wq' : [':wa<CR> :qa<CR>' , 'save and quiet']   ,
      \ }
" WINDOW
nnoremap <S-Up> 10<C-W>-
nnoremap <S-Down> 10<C-W>+
nnoremap <S-Right> 10<C-W>>
nnoremap <S-Left> 10<C-W><
nnoremap <S-v> <C-w>v
nnoremap <S-s> <C-w>s
nnoremap <S-c> <C-w>c
nnoremap <S-h> <C-w>h
nnoremap <S-l> <C-w>l
nnoremap <S-j> <C-w>j
nnoremap <S-k> <C-w>k
" TABS <leader>n
nnoremap <leader>tw :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>
let g:which_key_map['t'] = {
      \ 'name' : '+tabs' ,
      \ 'w' : ['tabnew' , 'new tab']   ,
      \ 'c' : ['tabclose' , 'close tab']   ,
      \ 'n' : ['tabnext' , 'next tab']   ,
      \ 'p' : ['tabprevious' , 'previous tab']   ,
      \ }
