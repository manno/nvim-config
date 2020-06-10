" ----- Colors
set mouse=ivh

"----- Setup tabs, use spaces instead of tabs
set shiftround
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set cf                " Enable error files & error jumping.
set autowrite         " Writes on make/shell commands
set number            " Show line numbers

"----- speed
set synmaxcol=512
"set lazyredraw        " to avoid scrolling problems

"----- Setup document specifics
filetype on                       " Load filetype.vim
set hidden                        " Allow hidden buffers
set noinsertmode                  " Don't don't out in insert mode
set backspace=indent,eol,start    " Allow us to backspace before an insert
set wildignore+=*.o,*.obj,.svn,.git,tags

" Jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| exe "normal g'\"" | endif

"----- Backups & Files
set backup                  " Enable creation of backup file.
if empty(glob('~/.local/share/nvim/backup'))
    call mkdir($HOME . "/.local/share/nvim/backup", "p", 0700)
endif
set backupdir=~/.local/share/nvim/backup " Where backups will go.
set undofile                " So is persistent undo ...
set undolevels=1000         " Maximum number of changes that can be undone
set undoreload=10000        " Maximum number lines to save for undo on a buffer reload

" not working anymore?
" augroup NoSimultaneousEdits
"     autocmd!
"     autocmd  SwapExists  *  :let v:swapchoice = 'o'
" augroup END

"----- Search
set ignorecase
set smartcase
set inccommand=nosplit "split?

"----- Encoding
set nodigraph               " Disable digraphs for uumlauts
set fileencodings=utf-8,iso-8859-15,ucs-bom    " heuristic
set virtualedit=block  " Fix problem with yank in utf8

"----- Diffmode
if &diff
    syntax off
    "set wrap
    set diffopt+=iwhite
endif

"----- Statusline
set ruler
set showcmd                 " show the command in the status line

" ----- Spelling
"
" Rechtschreibung & Word Processing: move cursor in editor lines, not text lines
" change to utf8 umlaut compatible mode with digraphs
" http://vim.wikia.com/wiki/VimTip38
function! WordProcessor(enable)
  if a:enable
    echo "WordProcessor Mode: enabled"
    imap <Up> <C-O>gk
    imap <Down> <C-O>gj
    imap <k> <C-O>gk
    imap <j> <C-O>gj
  else
    echo "WordProcessor Mode: disabled"
    silent! iunmap <Up>
    silent! iunmap <Down>
    silent! iunmap <k>
    silent! iunmap <j>
  endif
endfunction

" disable arrow keys to learn hjkl
" noremap <Up> <Nop>
" noremap <Down> <Nop>
" noremap <Left> <Nop>
" noremap <Right> <Nop>

" German spelling
map <F8>        :setlocal spell spelllang=de_20,de,en<CR>:call WordProcessor(1)<CR>
map <s-F8>      :setlocal spell spelllang=en<CR>:call WordProcessor(1)<CR>
map <esc><F8>   :setlocal nospell<CR>:call WordProcessor(0)<CR>

set thesaurus+=~/.config/nvim/spell/thesaurus.txt

" ----- Keys / Mappings / Commands
"
" Change map leader, default is \
"let mapleader = ","

" Famous paste toggle for xterm vim
set pastetoggle=<F5>

" Buffer next/prev
nnoremap <C-n>   :bn<CR>
nnoremap <C-p>   :bp<CR>

" Tab next
nnoremap <leader>n   :tabnext<CR>
nnoremap <leader>p   :tabprev<CR>

" Quit all buffers - qa/wa
command! Q      :quitall

" Close current buffer
nnoremap <leader>w       :bw<CR>
nnoremap <leader>D       :%bd!<CR>

" Debug
map   <F6>      :command
map   <F7>      :n ~/.config/nvim/init.vim<CR>
" https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
map   <leader><F7>      :CocConfig<CR>

" Make
map !ma       <ESC>:w<CR>:make<CR>

" Search
map <leader>G     :Ggrep <C-R><C-W> ':(exclude)*fake*'<CR>

" Forgot to open as root?
command! Wsudo  :w !sudo tee > /dev/null %

command! Tidy :%!/opt/tidy-html5/bin/tidy -w -i -q -f /dev/null

" Format json
com! -range FormatJSON <line1>,<line2>!python -m json.tool

" ----- Converter Mappings
"
" Convert to html
map  _th     :source $VIMRUNTIME/syntax/2html.vim
" convert to colored tex, use TMiniBufExplorer first
map  _tt     :source $VIMRUNTIME/syntax/2tex.vim
" convert to colored ansi
vmap _ta     :TOansi

" ----- Plug
" Auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/plugged')

" Nerd
Plug 'scrooloose/nerdcommenter'

" Grep
"Plug 'vim-scripts/grep.vim'
"Plug 'manno/grep'

" Search with ag?
"Plug 'rking/ag.vim'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Open files
"Plug 'Shougo/unite.vim'
"Plug 'Shougo/vimproc.vim', { 'do': 'make' }
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" run CocConfig to add language servers, e.g.
"   go get -u golang.org/x/tools/...
"   https://github.com/saibing/tools
"   https://github.com/josa42/coc-go#example-configuration
"   https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-go'}
" CocInstall coc-diagnostic
let g:coc_global_extensions=['coc-json',
                           \ 'coc-diagnostic',
                           \ 'coc-tsserver',
                           \ 'coc-go',
                           \ 'coc-clangd',
                           \ 'coc-yaml' ]

" Syntax errors
"Plug 'scrooloose/syntastic'
"Plug 'benekastah/neomake'
Plug 'w0rp/ale'

" Colorschemes
Plug 'jonathanfilip/vim-lucius'
"Plug 'tomasr/molokai'
"Plug 'noahfrederick/vim-hemisu'
Plug 'endel/vim-github-colorscheme'
"Plug 'chriskempson/vim-tomorrow-theme'
"Plug 'iCyMind/NeoSolarized'
Plug 'TroyFletcher/vim-colors-synthwave'
Plug 'drewtempelmeyer/palenight.vim'

" Ctags support
"Plug 'manno/vim-tags'
"Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" Tmux integration
Plug 'edkolev/tmuxline.vim'

" Readline style insertion
Plug 'tpope/vim-rsi'

" Format SQL
Plug 'vim-scripts/SQLUtilities'
Plug 'vim-scripts/Align'

" Surround - sa$' srb" sd"
Plug 'machakann/vim-sandwich'

" Vim ruby
" gem install gem-ctags
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': 'ruby' }
"Plug 'fatih/vim-go', { 'for': 'go', 'do': ':silent GoInstallBinaries' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'janko-m/vim-test'

" Open files at line
Plug 'manno/file-line'

" Gvim related - change project root
"Plug 'airblade/vim-rooter'

" Polyglot bundles csv.vim and an old version too
" Instead install separately https://github.com/sheerun/vim-polyglot
" Plug 'vim-polyglot'
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'tpope/vim-haml', { 'for': 'haml' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'sheerun/yajs.vim', { 'for': 'javascript' }
Plug 'honza/dockerfile.vim', { 'for': 'docker' }
Plug 'JulesWang/css.vim', { 'for': 'css' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'mitsuhiko/vim-python-combined', { 'for': 'python' }
Plug 'vim-scripts/R.vim', { 'for': 'r' }
Plug 'davinche/godown-vim', { 'for': 'markdown' }
Plug 'vim-latex/vim-latex', { 'for': 'tex' }

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

call plug#end()

" ----- Plugin Configurations
"

" fzf
map <leader>t :GitFiles<CR>
map <leader>b :Buffers<CR>
map <leader>F :Rg<CR>
"let g:fzf_layout = { 'up': '~50%' }

" vim-go
"map <leader>f :GoDecls<CR>

" vim-test
nmap <F3> :TestFile<CR>
let test#strategy = "neovim"

" fugitive git grep
autocmd QuickFixCmdPost *grep* cwindow
set diffopt+=vertical

" gutentags
let g:gutentags_cache_dir = $HOME . '/.cache/gutentags'
" let g:gutentags_file_list_command = {
"     \ 'markers': {
"         \ '.git': 'git ls-files',
"         \ },
"     \ }

" airline
"let g:airline_powerline_fonts = 1
"let g:airline_theme='lucius'
let g:airline_theme='kolor'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ":t"
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux.airline.conf"

" Language Support
"let g:neomake_warning_sign={'text': '!', 'texthl': 'NeomakeErrorMsg'}
" test highlights:
" :so $VIMRUNTIME/syntax/hitest.vim
highlight link ALEErrorSign Number
highlight link ALEWarningSign Number
let g:ale_sign_warning = '!'
let g:ale_sign_error = '✖'
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_cursor_detail = 0
let g:ale_go_golangci_lint_package = 1
" don't enable all: golangci-lint linters
let g:ale_go_golangci_lint_options = ''
"let g:ale_linters = {'go': []}
let g:ale_linters = {'go': ['golangci-lint']}
"let g:ale_linters = {'go': ['gometalinter']}
"let g:ale_linters = {'go': ['golint', 'gopls']}
" need to share gopls with ale?
"g:go_gopls_options=

" vim-go
"map <leader>f :GoDecls<CR>
"let g:go_code_completion_enabled = 0
"let g:go_fmt_command = 'goimports'

" coc
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> ]n :ALENext<CR>
nmap <silent> K  :call CocAction('doHover')<CR>

" don't show quickfix in buffer list
augroup QFix
    autocmd!
    autocmd FileType qf setlocal nobuflisted
augroup END

" Vim Rooter
"let g:rooter_patterns = [ 'Gemfile', 'package.json', 'README.md', 'Rakefile', '.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/' ]

" ----- Filetype Specific Settings
"
"autocmd FileType csv          set nofoldenable
"autocmd FileType xml          let g:xml_syntax_folding = 1
autocmd FileType c            set cindent
autocmd FileType eruby        map _rw i<%= %>
autocmd FileType eruby        set number
"autocmd FileType go           map <F4> :GoImports<CR>
autocmd FileType go           setlocal noet ts=8 sw=8 sts=8 number
"autocmd FileType go           set completeopt-=preview
autocmd FileType java         set foldmethod=manual
autocmd FileType lua          set ts=4 sw=4 et smartindent foldmethod=syntax
autocmd FileType nfo          edit ++enc=cp437
autocmd FileType ruby         set number foldmethod=manual
autocmd FileType vim          set ts=4 sw=4
autocmd FileType xml          set ts=4 sw=4
autocmd FileType xwt          set foldmethod=syntax
autocmd FileType zsh          set ts=4 sw=4 et
autocmd filetype crontab setlocal nobackup nowritebackup

" strip trailing whitespace
autocmd FileType c,vim,ruby,yaml,haml,css,html,eruby,coffee,javascript,markdown,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

" ----- Colorschemes
" colorscheme github
colorscheme synthwave

" ----- NERDCommenter
let NERDSpaceDelims = 1

" ----- Terminal
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" fzf grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
map <leader>g     :GGrep <C-R><C-W><CR>

" floating fzf (https://github.com/junegunn/fzf.vim/issues/664)
let $FZF_DEFAULT_OPTS .= ' --layout=reverse'

function! FloatingFZF()
	let height = &lines
	let width = float2nr(&columns - (&columns * 2 / 10))
	let col = float2nr((&columns - width) / 2)
	let col_offset = &columns / 10
	let opts = {
				\ 'relative': 'editor',
				\ 'row': 1,
				\ 'col': col + col_offset,
				\ 'width': width * 2 / 1,
				\ 'height': height / 2,
				\ 'style': 'minimal'
				\ }
	let buf = nvim_create_buf(v:false, v:true)
	let win = nvim_open_win(buf, v:true, opts)
	call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
endfunction

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

highlight TabLine ctermbg=black
