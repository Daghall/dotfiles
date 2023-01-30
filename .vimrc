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


" Colors for vimdiff
highlight DiffAdd      ctermfg=Green     ctermbg=NONE
highlight DiffChange   ctermfg=None      ctermbg=Black
highlight DiffDelete   ctermfg=Red       ctermbg=NONE
highlight DiffText     ctermfg=Yellow    ctermbg=Black


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


" Comments
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType conf setlocal commentstring=#\ %s
autocmd FileType gitconfig setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType php setlocal commentstring=#\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
autocmd FileType jinja setlocal commentstring={#\ %s\ #}


" FZF
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --exclude node_modules'
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


" LSP
nmap <silent> K :LspHover<CR>
nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>D :LspPeekDefinition<CR>
nmap <silent> <Leader>R :LspRename<CR>
nmap <silent> <Leader>E :LspDocumentDiagnostics<CR>
nmap <silent> <Leader>w :LspHover<CR>
nmap <silent> <leader>A :LspCodeAction<CR>

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

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" markdown-preview
nmap <silent> <Leader>m :MarkdownPreview<CR>

" Completion: Cycling
inoremap <expr> <C-j>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" Completion: force refres (<C-@> is ctrl-space in Vim 8)
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


" git-gutter
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#00ff00 ctermfg=2
highlight GitGutterChange guifg=#ffff00 ctermfg=3
highlight GitGutterDelete guifg=#ff0000 ctermfg=1
nmap <silent> <Leader>gq :GitGutterQuickFix<CR>:copen<CR>
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_sign_priority = 9


" Ranger
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
let g:ranger_map_keys = 0       " Do not map default keys
let g:ranger_replace_netrw = 1  " Use Ranger when opening directories
command! -bang Bclose :bd       " Required to use as netrw replacement
nnoremap <silent> <Leader>r :Ranger<CR>


" FOLDING

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

  return substitute(line, "{$", "{…}", "")
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


" MISCELLANEOUS

" Toggle relative row numbers
nnoremap <Leader>n :set relativenumber!<CR>

" Remember English keyboard layout
nnoremap Ö :echo "⚠️  Keyboard layout ⚠️"<CR>

" Reset filetype (hack to reactivate syntax highlighting)
com Ftreset :let &ft=&ft

" Toggle booleans
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

" Center search hits on screen
nnoremap n nzzzv
nnoremap N Nzzzv

" Surround
nnoremap S( lbi(<ESC>ea)<ESC>
nnoremap S) lbi(<ESC>ea)<ESC>
nnoremap S{ lbi{<ESC>ea}<ESC>
nnoremap S} lbi{<ESC>ea}<ESC>
nnoremap S" lbi"<ESC>ea"<ESC>
vnoremap S( :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap S) :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap S{ :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap S} :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap S" :s/\%V.*\%V./"&"/<CR>`< :noh<CR>

" Un-surround
nnoremap SD( lF(xf)x
nnoremap SD) hF(xf)x
nnoremap SD{ lF{xf}x
nnoremap SD} hF{xf}x
nnoremap SD" hf"xF"x
vnoremap SD :s/\%V.\(.*\)\%V./\1/<CR>`< :noh<CR>

" Open all TODOs in the quickfix window
set grepprg=ag\ --nogroup\ --nocolor
com TODO silent! grep TODO | cw | redraw!

" Format JS/JSON with jq
com -range JSON '<,'>!tr -d '\n' | xargs -0 printf "'\%s'" | xargs jq -n

" Highlight unwanted spacing
highlight ExtraWhitespace ctermbg=red guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace //

" Help "Open file under cursor" understand file names without suffix
set suffixesadd=.js,.json,.hbs,.ts

" Add common paths to help locating files
let project = system("pwd | cut -d \/ -f1-5 | tr '\n' '/'")
let &path=".,".project."app/views/,".project."views/"

" Fuzzy find relative path from current file to another, and print
nmap <silent> <Leader>i :silent :execute "!realpath --relative-to " . shellescape(expand("%:h")) ." $(fd '.js$' \| fzf) \| sed -E -e 's/\.js$//' -e 's,^([^.]),./\\1,' \| xargs printf \| pbcopy"<CR> :normal "*P<CR> :redraw!<CR>

" Open tig log and blame, respectively
nmap <silent> <Leader>L :silent !tig %<CR>:redraw!<CR>
nmap <silent> <Leader>l :silent :execute "!tig blame " . shellescape(expand("%")) . " +" . line(".") <CR>:redraw!<CR>

" Quickly delete buffer
nmap <silent> <Leader>q :bd<CR>

" Insert blank line bellow cursor
nmap <Leader> o

" Open a terminal
nnoremap <Leader>T :terminal ++close<CR>
nnoremap <Leader>Tn :terminal ++close node<CR>

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

" Speedy quick/location list handling
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

" Function to remove automagically created views
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
xnoremap <leader>y "*y
nnoremap <leader>y "*y
nnoremap <leader>yy "*yy
xnoremap <leader>p "*p
nnoremap <leader>p "*p

" Pretty colors
hi User1 ctermbg=black ctermfg=white
hi User2 ctermbg=gray ctermfg=black
hi User3 ctermbg=black ctermfg=yellow
hi User4 ctermbg=black ctermfg=red
hi Pmenu ctermbg=darkgray ctermfg=white
hi PmenuSel ctermbg=Gray

" No idea...
if version >= 700
	set nofsync
endif
set ttym=xterm2
set viminfo='25,\"50,n~/.viminfo
set ve=block
