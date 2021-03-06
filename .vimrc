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

set laststatus=2
set statusline=%2*\ %n\ %1*\ %t\ %M%R%H%W%=%3*\ %F\ %4*\ %y\ %1*\ %5l:%-4c%2*%4P\ 

colorscheme desert

let mapleader = " "
highlight Search ctermbg=Yellow

" Swap files and backups
set directory:~/.vim/swapfiles//
set backupdir:~/.vim/backup//

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
autocmd BufWritePre *.js silent! :undojoin | execute "normal mFHmG" | silent execute "%!eslint_d --stdin --fix-to-stdout" | execute "normal 'Gzt`F"

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
autocmd FileType php setlocal commentstring=#\ %s

" FZF
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --exclude node_modules'
nmap <silent> <Leader>t :Files!<CR>
nmap <silent> <Leader>b :Buffers<CR>
"nmap <silent> <Leader>p :HistoryFiles!<CR>
nmap <silent> <Leader>a :Ag!<CR>
nmap <silent> <Leader><Leader> :b#<CR>
nmap <silent> <Leader>l :silent !tig %<CR>:redraw!<CR>

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
command! -bang -nargs=* HistoryFiles
  \ call fzf#vim#history(fzf#vim#with_preview('right:50%', '?'), <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'), <bang>0)

" Ranger
nmap <silent> <Leader>r :Ranger<CR>

" Misc.
nmap <silent> <Leader>q :bd<CR>
nmap <silent> <Leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>

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

" Store folds and other view related stuff
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Spelling
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType vim setlocal spell
autocmd FileType javascript setlocal spell

" Session handling
com Save mksession! ~/.session.vim
com Load source ~/.session.vim
" Default session options but with "curdir" omitted; the BufEnter * lcd command brakes stuff
set sessionoptions-=curdir

" Marko syntax highlighting
autocmd BufNewFile,BufRead *.marko set filetype=html

" Git commands
com Ga !git add %
com Gd !git di % | less -R
com Gr !git resolved %
com Gl !git log % | less

" Fat fingers syndrome
com W w
com Q q
com Wq wq
com WQ wq
com Qa qa
com QA qa
com Wa wa
com WA wa

" Sort in dictionary order, ignoring case
xnoremap <leader>s :!sort -df<CR>

" Copy/paste helper
xnoremap <leader>y "ay
nnoremap <leader>y "ay
nnoremap <leader>yy "ayy
xnoremap <leader>p "ap
nnoremap <leader>p "ap

" Misc
com Ftjs set ft=javascript

hi User1 ctermbg=black ctermfg=white
hi User2 ctermbg=gray ctermfg=black
hi User3 ctermbg=black ctermfg=yellow
hi User4 ctermbg=black ctermfg=red
