" vi: fdm=marker

" General settings {{{1
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
set wildmode=longest:list
set mouse=a
set number
set ic
set title
set titlestring=%f%m
set smartcase
set tabpagemax=50
set updatetime=100
set showcmd
syntax enable
colorscheme desert
highlight Search ctermbg=Yellow


" Colors for vimdiff {{{1
highlight DiffAdd      ctermfg=Green     ctermbg=NONE
highlight DiffChange   ctermfg=None      ctermbg=Black
highlight DiffDelete   ctermfg=Red       ctermbg=NONE
highlight DiffText     ctermfg=Yellow    ctermbg=Black


" Status line {{{1
set laststatus=2
autocmd VimEnter * highlight User1 ctermfg=15 ctermbg=242
autocmd VimEnter * highlight User2 ctermfg=0 ctermbg=248
autocmd VimEnter * highlight User3 ctermfg=11 ctermbg=242
autocmd VimEnter * highlight User4 ctermfg=9 ctermbg=242
set statusline=%2*\ %n      " Buffer number
set statusline+=\ %1*\ %t   " File name
set statusline+=\ %M        " Modified flag
set statusline+=%R          " Read only flag
set statusline+=%H          " Help buffer flag
set statusline+=%W          " Preview window flag
set statusline+=%=          " Separation between left and right alignment
set statusline+=\ %F     " Full path of file in the buffer
set statusline+=\ %4*\ %y   " File type
set statusline+=\ %1*\ %5l: " Row
set statusline+=%-4c        " Column
set statusline+=%2*%4P      " Percentage
set statusline+=\ 


" Follow the leader {{{1
let mapleader = " "


" Swap files and backups {{{1
set directory:~/.vim/swapfiles//
set backupdir:~/.vim/backup//


" White space rendering (tab:▸\ ,trail:·,eol:¬,nbsp:_) {{{1
set lcs=tab:▸\ ,trail:·,nbsp:_
"}}}

" PLUGINS

" Bootstrap plugins {{{1
execute pathogen#infect()


" Force snippet version 1 {{{1
let g:snipMate = { 'snippet_version' : 1 }


" Syntastic {{{1
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_eslint_exec = "eslint_d"
let g:syntastic_javascript_eslint_args = ['--fix']
let g:syntastic_javascriptreact_checkers = ["javascript/eslint"]
let g:syntastic_javascriptreact_eslint_exec = "eslint_d"
let g:syntastic_javascriptreact_eslint_args = ["--fix"]
let g:syntastic_cpp_compiler_options = " -std=c++11 -stdlib=libc++"
autocmd VimEnter *.js autocmd BufWritePost *.js checktime
autocmd CursorHold *.js checktime
autocmd VimEnter *.jsx autocmd BufWritePost *.jsx checktime
autocmd CursorHold *.jsx checktime
autocmd BufWritePre *.js call execute('LspCodeActionSync source.fixAll.ts')
autocmd BufWritePre *.ts call execute('LspCodeActionSync source.fixAll.ts')
nnoremap <silent> <Leader>f :checktime<CR>
set autoread
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let syntastic_mode_map = { 'passive_filetypes': ['html'] }
nmap <silent> <Leader>e :Errors<CR> :lfirst<CR>
nmap <silent> <Leader>en :lnext<CR>
nmap <silent> <Leader>ep :lprevious<CR>


" Comments {{{1
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType conf setlocal commentstring=#\ %s
autocmd FileType gitconfig setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType php setlocal commentstring=#\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
autocmd FileType jinja setlocal commentstring={#\ %s\ #}
autocmd FileType scss setlocal commentstring=//\ %s

" FZF {{{1
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git; echo .env'
nmap <silent> <Leader>t :Files!<CR>
nmap <silent> <Leader>b :Buffers!<CR>
nmap <silent> <Leader>h :HistoryFiles!<CR>
nmap <silent> <Leader><Leader> :b#<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': '--cycle'}, 'right:50%', '?'), <bang>0)
command! -bang -nargs=? -complete=dir Buffers
  \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({'options': '--cycle'}, 'right:50%', '?'), <bang>0)
command! -bang -nargs=* HistoryFiles
  \ call fzf#vim#history(fzf#vim#with_preview({'options': '--cycle'}, 'right:50%', '?'), <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 1 --tac --cycle'}, 'right:50%', '?'), <bang>1)
command! -bang -nargs=* Agi
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4 --tac --cycle'}, 'right:50%', '?'), <bang>1)


" LSP {{{1
nmap <silent> K :LspHover<CR>
nmap <silent> gd :LspDefinition<CR>
nmap <silent> gD :LspPeekDefinition<CR>
nmap <silent> <Leader>R :LspRename<CR>
nmap <silent> <Leader>E :LspDocumentDiagnostics<CR>
nmap <silent> <Leader>w :LspHover<CR>
nmap <silent> <leader>A :LspCodeAction<CR>
xnoremap <silent> <leader>A :LspCodeAction<CR>

" Settings: https://github.com/prabirshrestha/vim-lsp/blob/master/doc/vim-lsp.txt
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_hover_conceal = 1
let g:markdown_syntax_conceal = 1
let g:markdown_fenced_languages = ["javascript"]
set conceallevel=2
let g:lsp_settings = {
\   "typescript-language-server": {
\     "workspace_config": {
\       "diagnostics": {
\         "ignoredCodes": [80001, 7016]
\       }
\     }
\   }
\ }

" Logging
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

" vim-markdown {{{1
let g:vim_markdown_folding_disabled = 1

" markdown-preview {{{1
nmap <silent> <Leader>m :MarkdownPreview<CR>

" Completion: Cycling {{{1
inoremap <expr> <C-j>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" Completion: force refres (<C-@> is ctrl-space in Vim 8) {{{1
imap <C-@> <Plug>(asyncomplete_force_refresh)
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview


" vimspector {{{1
nmap <Leader>dd <Plug>VimspectorLaunch
nmap <Leader>dc <Plug>VimspectorContinue
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver
nmap <Leader>dk <Plug>VimspectorStepOut
nmap <Leader>dr <Plug>VimspectorRestart
nmap <silent> <Leader>de :call vimspector#Reset()<CR>
nmap <Leader>db <Plug>VimspectorToggleBreakpoint :echom "Toggle breakpoint"<CR>
nmap <Leader>dq <Plug>VimspectorToggleConditionalBreakpoint<CR>
nmap <silent> <Leader>dB :call vimspector#ListBreakpoints()<CR>
nmap <silent> <Leader>dC :call vimspector#ClearBreakpoints()<CR>
nmap <silent> <Leader>di <Plug>VimspectorBalloonEval
source ~/git/dotfiles/vimspector-bindings.vim

let g:vimspector_sign_priority = {
  \    'vimspectorBP':         13,
  \    'vimspectorBPCond':     12,
  \    'vimspectorBPLog':      12,
  \    'vimspectorBPDisabled': 11,
  \    'vimspectorPC':         999,
  \ }


" git-gutter {{{1
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#00ff00 ctermfg=2
highlight GitGutterChange guifg=#ffff00 ctermfg=3
highlight GitGutterDelete guifg=#ff0000 ctermfg=1
nmap <silent> <Leader>gq :GitGutterQuickFix<CR>:copen<CR>
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_sign_priority = 9


" Ranger {{{1
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
let g:ranger_map_keys = 0       " Do not map default keys
let g:ranger_replace_netrw = 1  " Use Ranger when opening directories
command! -bang Bclose :bd       " Required to use as netrw replacement
nnoremap <silent> <Leader>r :Ranger<CR>


" MISCELLANEOUS

" Git jump {{{1
command! -bar -nargs=+ -complete=custom,Complete_git_jump GitJump cexpr system("git jump --stdout " . expand(<q-args>)) | :copen | :let w:quickfix_title = "[git jump " .. expand(<q-args>) .. "]"
abbreviate gj GitJump

function Complete_git_jump(ArgLead, CmdLine, CursorPos)
  let words = split(a:CmdLine, " ")
  if len(words) == 2 && len(a:ArgLead) > 0
    return system("compgen -W 'diff merge grep ws' -- " .. a:ArgLead)
  endif

  return ""
endfunction

" Folding {{{1
set foldcolumn=3
let foldinglevelstart=99
set fillchars+=fold:\ ,foldsep:│,foldclose:>,foldopen:v
set foldtext=Folding()

function Folding()
  let line = getline(v:foldstart)
  if line =~# "\\v\s(Scenario|describe|context|it|Given|When|Then|And|But)[.(]"
    let line = substitute(line, "([\"'`]", ": ", "")
    let line = substitute(line, "[\"'`],.*", "", "")
    return line
  endif

  let line = substitute(line, "{$", "{…}", "")
  let line = substitute(line, "[$", "[…]", "")
  let line = substitute(line, "[0-9]$", "", "")
  return line
endfunction

nnoremap <silent> <Leader>ff :call FoldFunctions()<CR>
nnoremap <silent> <Leader>fs :call FoldScenarios()<CR>
nnoremap <silent> <Leader>fc :call FoldClass()<CR>

function FoldFunctions()
  execute "normal zE"
  g/\<function\>/ :normal $zf%za
endfunction

function FoldScenarios()
  execute "normal zE"
  g/\s\(Scenario\|^describe\)[.(]/ :normal zf%
endfunction

function FoldClass()
  execute "normal zE"
  g/\v^\s+[a-z0-9#_]+\([^)]*\) \{/ :normal $zf%
  silent g/ static.*{$/ :normal $zf%
endfunction

" Toggle relative row numbers {{{1
nnoremap <Leader>n :set relativenumber!<CR>

" Remember English keyboard layout {{{1
nnoremap Ö :echo "⚠️  Keyboard layout ⚠️"<CR>

" Reset filetype (hack to reactivate syntax highlighting) {{{1
com Ftreset :let &ft=&ft
autocmd VimResized * :Ftreset

" Toggle booleans {{{1
nnoremap <silent> <Leader>a :call ToggleBoolean()<CR>

function ToggleBoolean()
  let l:toggleHash = {
  \  "no": "yes",
  \  "yes": "no",
  \  "on": "off",
  \  "off": "on",
  \  "true": "false",
  \  "false": "true",
  \}
  let cursor_pos = getpos(".")
  let under_cursor = expand("<cword>")
  let cursor_char = nr2char(strgetchar(getline("."), col(".") - 1))

  " Set 'curswant' to make vertical movement after toggling work
  call add(cursor_pos, col("."))

  if !has_key(l:toggleHash, under_cursor)
      echo "Cannot toggle '" .. under_cursor .. "'"
    return
  endif

  " Jump to first character in matching toggle string
  if cursor_char !~? "[a-z]"
    let jump_to = nr2char(strgetchar(under_cursor, 0))
    keepjumps execute ":normal f" .. jump_to
  endif

  " Toggle!
  let substitution = l:toggleHash[under_cursor]
  keepjumps execute ":normal ciw" .. substitution

  " Jump back to previous cursor position
  call setpos(".", cursor_pos)
endfunction

" Center search hits on screen {{{1
nnoremap n nzzzv
nnoremap N Nzzzv

" Surround {{{1
nnoremap S( lbi(<ESC>ea)<ESC>
nnoremap S) lbi(<ESC>ea)<ESC>
nnoremap S{ lbi{<ESC>ea}<ESC>
nnoremap S} lbi{<ESC>ea}<ESC>
nnoremap S[ lbi[<ESC>ea]<ESC>
nnoremap S] lbi[<ESC>ea]<ESC>
nnoremap S" lbi"<ESC>ea"<ESC>
vnoremap S( :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap S) :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap S{ :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap S} :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap S" :s/\%V.*\%V./"&"/<CR>`< :noh<CR>

" Un-surround {{{1
nnoremap SD( lF(xf)x
nnoremap SD) hF(xf)x
nnoremap SD{ lF{xf}x
nnoremap SD} hF{xf}x
nnoremap SD" hf"xF"x
vnoremap SD :s/\%V.\(.*\)\%V./\1/<CR>`< :noh<CR>

" camelCase <-> SNAKE_CASE {{{1
nnoremap <leader>CC :normal viw<CR> :s/\%V./\l&/g<CR> `< :s/\%V_\(.\)/\u\1/g<CR>`< :noh<CR>
nnoremap <leader>CS :normal viw<CR> :s/\%V[A-Z]/_&/g<CR> `< :s//\U&/g<CR> `< :noh<CR>

" Open all TODOs in the quickfix window {{{1
set grepprg=ag\ --nogroup\ --nocolor
com TODO silent! grep TODO | cw | redraw!

" Format JS/JSON with jq {{{1
com -range JSON '<,'>!tr -d '\n' | xargs -0 printf "'\%s'" | xargs jq -n

" Highlight unwanted spacing {{{1
highlight ExtraWhitespace ctermbg=red guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace //

" Help "Open file under cursor" understand file names without suffix {{{1
set suffixesadd=.js,.json,.hbs,.ts

" Add common paths to help locating files {{{1
let project = system("pwd | cut -d \/ -f1-5 | tr '\n' '/'")
let &path=".,".project."app/views/,".project."views/"

" Fuzzy find relative path from current file to another, and print {{{1
nmap <silent> <Leader>i :silent :execute "!realpath --relative-to " . shellescape(expand("%:h")) ." $(fd '.js$' \| fzf) \| sed -E -e 's/\.js$//' -e 's,^([^.]),./\\1,' \| xargs printf \| pbcopy"<CR> :normal "*P<CR> :redraw!<CR>

" Open tig log and blame, respectively {{{1
nmap <silent> <Leader>L :silent !tig %<CR>:redraw!<CR>
nmap <silent> <Leader>l :silent :execute "!tig blame " . shellescape(expand("%")) . " +" . line(".") <CR>:redraw!<CR>

" Delete buffer. Quit if no more open buffers {{{1
nnoremap <silent> <Leader>q :call CloseOrQuit()<CR>
function CloseOrQuit()
  " let first_buffer = 1
  " let last_buffer = bufnr('$')
  " let unnamed_and_listed_buffers = filter(range(first_buffer, last_buffer), 'empty(bufname(v:val)) && buflisted(v:val)')
  let current_buffer = bufnr()

  " if len(unnamed_and_listed_buffers) == 1
  try
    if empty(bufname(current_buffer))
      :q
    else
      :bd
    endif
  catch
    echohl WarningMsg | echo "Unable to close, unsaved buffer? Try :cq" | echohl none
  endtry
endfunction

nnoremap <silent> <Leader>w :w<CR>

" Insert blank line below cursor {{{1
nmap <Leader> o

" Open a terminal {{{1
nnoremap <silent> <Leader>TT :terminal ++close<CR>
nnoremap <silent> <Leader>Tn :terminal ++close node<CR>

" Search for the visually selected string {{{1
vmap * "oy/\V<C-R>o<CR>
vmap # "oy?\V<C-R>o<CR>


" F-KEYS BINDINGS {{{1

" Prev/next tab
map <F1> gT
map <F2> gt

" Toggle line-wrapping
map <silent><F3> :set wrap!<CR>

" Toggle case-sensitivity
map <F4> :set ic!<CR>

" Toggle conceal level
map <silent><F5> :call ToggleConcealLevel()<CR>

function ToggleConcealLevel()
  if (&conceallevel == 2)
    set conceallevel=0
  else
    set conceallevel=2
  endif
endfunction

" Toggle "list mode"
map <silent><F6> :set list!<CR>

" Toggle spelling
map <F7> :set spell!<CR>

" Turn of highlighting
map <F8> :noh<CR>

" Prev/next diff
map <F9> [c
map <F10> ]c

" Make k/j traverse wrapped lines
map j gj
map k gk

" Speedy quick/location list handling {{{1
nmap <silent><leader>j :call NextListItem()<CR>
function NextListItem()
  try
    if IsQuickFixOpen()
      cn
    else
      lnext
    endif
    norm zz
  catch
    echom "No more items (Bot)"
  endtry
endfunction

nmap <silent><leader>k :call PrevListItem()<CR>
function PrevListItem()
  try
    if IsQuickFixOpen()
      cp
    else
      lprev
    endif
    norm zz
  catch
    echom "No more items (Top)"
  endtry
endfunction

nmap <silent><leader>c :call CloseList()<CR>
function CloseList()
  if IsQuickFixOpen()
    ccl
  else
    lcl
  endif
endfunction

function IsQuickFixOpen()
  return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) != 0
endfunction

" Make ctrl-x/ctrl-a work with selection {{{1
vmap <C-X> :g/./exe "norm \<C-X>"<CR>gv
vmap <C-A> :g/./exe "norm \<C-A>"<CR>gv

" Easy tab moving {{{1
map <silent><C-L> :tabm +<CR>
map <silent><C-H> :tabm -<CR>

" Parenthesis matching {{{1
hi MatchParen cterm=none ctermbg=red ctermfg=black

" Store folds and other view related stuff {{{1
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Function to remove automagically created views {{{1
function! DeleteFileView()
    let path = fnamemodify(bufname("%"), ":p")
    let path = substitute(path, "=", "==", "g")
    if !empty($HOME)
        let path = substitute(path, "^".$HOME, "\~", "")
    endif
    let path = substitute(path, "/", "=+", "g") . "="
    let path = &viewdir . "/" . path
    call delete(path)
    echo "Deleted" path
endfunction

command Delview call DeleteFileView()
command Noq :noautocmd cq

" Spelling {{{1
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType vim setlocal spell
autocmd FileType javascript setlocal spell
set spelllang=en,sv
set spellsuggest=fast,20

" Session handling {{{1
com Save mksession! ~/.session.vim
com Load source ~/.session.vim

" Marko syntax highlighting {{{1
autocmd BufNewFile,BufRead *.marko set filetype=html

" Fat fingers syndrome {{{1
com W w
com Q q
com Wq wq
com WQ wq
com Qa qa
com QA qa
com Wa wa
com WA wa
com Cq cq

" Quickly reset filetype when lost due to swap file collision {{{1
com Ftjs set ft=javascript

" Sort in dictionary order, ignoring case {{{1
xnoremap <leader>s :!sed 's/{ /{/' \| sort -df<CR>

" Copy/paste helper {{{1
xnoremap <leader>y "*y
nnoremap <leader>y "*y
nnoremap <leader>yy "*yy
xnoremap <leader>p "*p
nnoremap <leader>p "*p

" Pretty colors {{{1
hi User1 ctermbg=black ctermfg=white
hi User2 ctermbg=gray ctermfg=black
hi User3 ctermbg=black ctermfg=yellow
hi User4 ctermbg=black ctermfg=red
hi Pmenu ctermbg=darkgray ctermfg=white
hi PmenuSel ctermbg=Gray

" No idea... {{{1
if version >= 700
	set nofsync
endif
set ttym=xterm2
set viminfo='25,\"50,n~/.viminfo
set ve=block
