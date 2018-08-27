set showmode
set hidden
set nocompatible
set ruler
set autoindent
set backspace=indent,eol,start
set smartindent
set incsearch
set background=dark
set nomore
set title
set wildmode=longest:list
set mouse=a
set number
set ic
set titlestring=%f%m\ %y\ b%n%a
set smartcase
set tabpagemax=50
syntax enable

colorscheme desert

let mapleader = " "
highlight Search ctermbg=Yellow

" Whitespace rendering (tab:▸\ ,trail:·,eol:¬,nbsp:_)
set lcs=tab:▸\ ,trail:·,nbsp:_

" Plugins
execute pathogen#infect()

" Syntastic
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_eslint_exec = "eslint_d"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Autofix on write
autocmd BufWritePre *.js execute "normal mFHmG" | silent execute "%!eslint_d --stdin --fix-to-stdout" | execute "normal 'Gzt`F"

" Autofix entire buffer with eslint_d:
nnoremap <leader>e mF:%!eslint_d --stdin --fix-to-stdout<CR>`F
" Autofix visual selection with eslint_d:
vnoremap <leader>e :!eslint_d --stdin --fix-to-stdout<CR>gv

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }

" Comments
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType conf setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring="\ %s

" CommandT
nmap <silent> <Leader>t <Plug>(CommandT)
nmap <silent> <Leader>b <Plug>(CommandTMRU)
nmap <silent> <Leader>j <Plug>(CommandTJump)
set wildignore+=node_modules,public,logs
" TODO: Make this smarter
let g:CommandTAcceptSelectionCommand="CommandTOpen tabe"
set switchbuf=usetab

" Highlight unwanted spacing
highlight ExtraWhitespace ctermbg=red guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace //

" Help "Open file under cursor" understand file names without suffix
set suffixesadd=.js,.json,.hbs

" Add common paths to help locating files
let project = system("pwd | cut -d \/ -f1-5 | tr '\n' '/'")
let &path=".,".project."app/views/,".project."views/"

" Map ctrl-k to open the file under cursor in a new tab
nmap <C-k> <C-w>gF<CR>

if version >= 700
	set nofsync
endif
set ttym=xterm2
set hlsearch
set viminfo='25,\"50,n~/.viminfo
set ve=block

" Editing
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Search for the visually selected string
vmap * "oy/\V<C-R>o<CR>
vmap # "oy?\V<C-R>o<CR>

" Prev/next tab
map <F1> gT
map <F2> gt

" Toggle line-wrapping
map <silent><F3> :set wrap!<CR>

" Toggle case-sensetivity
map <F4> :set ic!<CR>

" Toggle line numbers
map <silent><F5> :set number!<CR>

" Toggle "list mode"
map <silent><F6> :set list!<CR>

" Toggle paste mode
map <F7> :set paste!<CR>

" Turn of highlighting
map <F8> :noh<CR>

" Prev/next diff (vimdiff)
map <F9> [c
map <F10> ]c

" Make k/j, up/down traverse wrapped lines
map j gj
map k gk
map <Up> gk
map <Down> gj
imap <Up> <C-O>gk
imap <Down> <C-O>gj

" Make ctrl-x/ctrl-a work with selection
vmap <C-X> :g/./exe "norm \<C-X>"<CR>gv
vmap <C-A> :g/./exe "norm \<C-A>"<CR>gv

" Easy tab moving
map <silent><C-L> :tabm +<CR>
map <silent><C-H> :tabm -<CR>

" Parenthisis matching
hi MatchParen cterm=none ctermbg=red ctermfg=black

au BufNewFile,BufRead *.less               	set filetype=less

autocmd BufEnter * lcd %:p:h

" Store folds and other view related stuff
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Session handling
com Save mksession! ~/.session.vim
com Load source ~/.session.vim
" Default session options but with "curdir" omitted; the BufEnter * lcd command brakes stuff
set sessionoptions-=curdir


" Git commands
com Ga !git add %
com Gd !git di % | less -R
com Gdiff !git diff --color % | less -R
com Gr !git resolved %
com Gl !git log % | less
com Gb !git blame % | less

" Fat fingers syndrome
com W w
com Q q
com Wq wq
com WQ wq
com Qa qa
com QA qa
com Wa wa
com WA wa

" Clean bogus whitespaces
com Cend %s/\s\+$//
com Ccurl %s/\t{/ {/

" Clean CSS
com CSS call CSS_cleanup()

function! CSS_cleanup()
	try
		%s/:\([^ ].*\);/: \1;/
		%s/\([^ ]\){$/\1 {/
		%s/^ \+/\t/
		%s/{\n\n/{\r/
	catch
	endtry
endfunction
