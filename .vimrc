set showmode
set hidden
set nocompatible
set ruler
set autoindent
set backspace=indent,eol,start
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set incsearch
set hlsearch
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
highlight Search ctermbg=Yellow


" Status line
set laststatus=2
set statusline=%2*\ %n\ %1*\ %t\ %M%R%H%W%=%3*\ %F\ %4*\ %y\ %1*\ %5l:%-4c%2*%4P\ 


" Follow the leader
let mapleader = " "


" Swap files and backups
set directory:~/.vim/swapfiles//
set backupdir:~/.vim/backup//


" White space rendering (tab:▸\ ,trail:·,eol:¬,nbsp:_)
set lcs=tab:▸\ ,trail:·,nbsp:_


" PLUGINS

" Bootstrap plugins
execute pathogen#infect()


" Force snippet version 1
let g:snipMate = { 'snippet_version' : 1 }


" Syntastic
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_eslint_exec = "eslint_d"
let g:syntastic_javascript_eslint_args = ['--fix']
au VimEnter *.js au BufWritePost *.js checktime
au CursorHold *.js checktime
nnoremap <silent> <Leader>f :checktime<CR>
set autoread
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
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
nmap <silent> <Leader>b :Buffers!<CR>
nmap <silent> <Leader>h :HistoryFiles!<CR>
nmap <silent> <Leader><Leader> :b#<CR>
nmap <silent> <Leader>l :silent :execute "!tig blame " . shellescape(expand("%")) . " +" . line(".") <CR>:redraw!<CR>

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
command! -bang -nargs=* HistoryFiles
  \ call fzf#vim#history(fzf#vim#with_preview('right:50%', '?'), <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'), <bang>0)


" LSP
nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>R :LspRename<CR>
nmap <silent> <Leader>e :LspDocumentDiagnostics<CR>
nmap <silent> <Leader>w :LspHover<CR>

" Autocomplete (C-j/C-K is bound to Down/up in BetterTouchTool
inoremap <expr> <C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" <C-@> is ctrl-space in Vim8
imap <C-@> <Plug>(asyncomplete_force_refresh)
"let g:asyncomplete_auto_popup = 0
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview


" vimspector
nmap <Leader>dd <Plug>VimspectorLaunch
nmap <Leader>dc <Plug>VimspectorContinue
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver
nmap <Leader>dk <Plug>VimspectorStepOut
nmap <Leader>dr <Plug>VimspectorRestart
nmap <silent> <Leader>de :call vimspector#Reset()<CR>
nmap <Leader>db <Plug>VimspectorToggleBreakpoint :echom "Toggle breakpoint"<CR>
nmap <silent> <Leader>dbb :call vimspector#ListBreakpoints()<CR>
nmap <silent> <Leader>dbc :call vimspector#ClearBreakpoints()<CR>
nmap <silent> <Leader>di <Plug>VimspectorBalloonEval

let g:vimspector_sign_priority = {
  \    'vimspectorBP':         13,
  \    'vimspectorBPCond':     12,
  \    'vimspectorBPLog':      12,
  \    'vimspectorBPDisabled': 11,
  \    'vimspectorPC':         999,
  \ }


" git-gutter
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#00ff00 ctermfg=2
highlight GitGutterChange guifg=#ffff00 ctermfg=3
highlight GitGutterDelete guifg=#ff0000 ctermfg=1


" Ranger
let g:ranger_map_keys = 0       " Do not map keys
let g:ranger_replace_netrw = 1  " Use Ranger when opening directories
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
nmap <silent> <Leader>r :Ranger<CR>


" MISCELLANEOUS


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

" Fuzzy find relative path from current file to another, and print
nmap <silent> <Leader>i :silent :execute "!realpath --relative-to " . shellescape(expand("%:h")) ." $(fd '.js$' \| fzf) \| sed 's/\.js$//' \| xargs printf \| pbcopy"<CR> :normal "*P<CR> :redraw!<CR>

" Open tig blame
nmap <silent> <Leader>L :silent !tig %<CR>:redraw!<CR>

" Quickly delete buffer
nmap <silent> <Leader>q :bd<CR>

" Insert blank line bellow cursor
nmap <Leader> o

" Search for the visually selected string
vmap * "oy/\V<C-R>o<CR>
vmap # "oy?\V<C-R>o<CR>

" Prev/next tab
map <F1> gT
map <F2> gt

" Toggle line-wrapping
map <silent><F3> :set wrap!<CR>

" Toggle case-sensitivity
map <F4> :set ic!<CR>

" Toggle line numbers
map <silent><F5> :set number!<CR>

" Toggle "list mode"
map <silent><F6> :set list!<CR>

" Toggle spelling
map <F7> :set spell!<CR>

" Turn of highlighting
map <F8> :noh<CR>

" Prev/next diff
map <F9> [c
map <F10> ]c

" Make k/j, up/down traverse wrapped lines
map j gj
map k gk

" Make ctrl-x/ctrl-a work with selection
vmap <C-X> :g/./exe "norm \<C-X>"<CR>gv
vmap <C-A> :g/./exe "norm \<C-A>"<CR>gv

" Easy tab moving
map <silent><C-L> :tabm +<CR>
map <silent><C-H> :tabm -<CR>

" Parenthesis matching
hi MatchParen cterm=none ctermbg=red ctermfg=black

" Store folds and other view related stuff
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Spelling
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType vim setlocal spell
autocmd FileType javascript setlocal spell
set spelllang=en,sv
set spellsuggest=fast,20

" Session handling
com Save mksession! ~/.session.vim
com Load source ~/.session.vim
" Default session options but with "curdir" omitted; the BufEnter * lcd command brakes stuff
set sessionoptions-=curdir

" Marko syntax highlighting
autocmd BufNewFile,BufRead *.marko set filetype=html

" Fat fingers syndrome
com W w
com Q q
com Wq wq
com WQ wq
com Qa qa
com QA qa
com Wa wa
com WA wa
com Cq cq

" Quickly reset filetype when lost due to swap file collision
com Ftjs set ft=javascript

" Sort in dictionary order, ignoring case
xnoremap <leader>s :!sed 's/{ /{/' \| sort -df<CR>

" Copy/paste helper
xnoremap <leader>y "ay
nnoremap <leader>y "ay
nnoremap <leader>yy "ayy
xnoremap <leader>p "ap
nnoremap <leader>p "ap

" Pretty colors
hi User1 ctermbg=black ctermfg=white
hi User2 ctermbg=gray ctermfg=black
hi User3 ctermbg=black ctermfg=yellow
hi User4 ctermbg=black ctermfg=red

" No idea...
if version >= 700
	set nofsync
endif
set ttym=xterm2
set viminfo='25,\"50,n~/.viminfo
set ve=block
