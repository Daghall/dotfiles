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
set title
set titlestring=%f%m
set ignorecase
set smartcase
set infercase
set tabpagemax=50
set updatetime=100
set showcmd
set virtualedit=block
syntax enable
colorscheme desert
highlight Search ctermbg=Yellow
filetype plugin on


" Colors for vimdiff {{{1
highlight DiffAdd      ctermfg=Green     ctermbg=NONE
highlight DiffChange   ctermfg=None      ctermbg=Black
highlight DiffDelete   ctermfg=Red       ctermbg=NONE
highlight DiffText     ctermfg=Yellow    ctermbg=Black


" Cursor line {{{1
set cursorline
set cursorlineopt=both
highlight CursorLine ctermbg=237 cterm=none
highlight CursorLineNr ctermbg=237 cterm=bold ctermfg=yellow

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
set statusline+=\ %3*%{NearestMethodOrFunction()}
set statusline+=%=          " Separation between left and right alignment
set statusline+=\ %F     " Full path of file in the buffer
set statusline+=\ %4*\ %y   " File type
set statusline+=\ %1*\ %5l: " Row
set statusline+=%-4c        " Column
set statusline+=%2*%4P      " Percentage
set statusline+=\ 

autocmd BufWinEnter,BufReadPost,BufWritePost quickfix setlocal statusline=%2*\ %Y\ %1*%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}%=\%4*%q\ %1*%(%5l/%-4L%)\ %2*%4P\ 


" Follow the leader {{{1
let mapleader = " "


" Swap files and backups {{{1
set directory:~/.vim/swapfiles//
set backupdir:~/.vim/backup//


" White space rendering {{{1
set listchars=tab:▸\ ,trail:·,nbsp:_
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
let g:syntastic_cpp_compiler_options = " -std=c++11 -stdlib=libc++ -Wall"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_stl_format = " ⛔️ :%F (%t)"
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
nnoremap <silent> <Leader>e :SyntasticCheck<CR> :Errors<CR> :lopen<CR> :let w:quickfix_title = "Syntastic check"<CR> :lfirst<CR>


" Jump to next/previous - or first - error {{{1
nmap [e :call Lnext()<CR>
nmap ]e :call Lprev()<CR>

function Lnext()
  try
    lnext
  catch
    lfirst
    endtry
endfunction

function Lprev()
  try
    lprevious
  catch
    lfirst
    endtry
endfunction


" Comments {{{1
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType javascriptreact setlocal commentstring={/*\ %s\ */}
autocmd FileType conf setlocal commentstring=#\ %s
autocmd FileType gitconfig setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType php setlocal commentstring=#\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
autocmd FileType jinja setlocal commentstring={#\ %s\ #}
autocmd FileType scss setlocal commentstring=//\ %s

" FZF {{{1
set runtimepath+=/opt/homebrew/opt/fzf
let $FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git; echo .env'
let $FZF_DEFAULT_OPTS='--bind ctrl-a:select-all,ctrl-d:deselect-all'
nnoremap <silent> <Leader>t :Files!<CR>
nnoremap <silent> <Leader>. :Files! %:h<CR>
nnoremap <silent> <Leader>b :Buffers!<CR>
nnoremap <silent> <Leader>g :GFiles!?<CR>
nnoremap <silent> <Leader>h :HistoryFiles!<CR>
nnoremap <silent> <Leader><Leader> :b#<CR>
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
nnoremap <silent> K :LspHover<CR>
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gD :LspPeekDefinition<CR>
nnoremap <silent> <Leader>R :LspRename<CR>
nnoremap <silent> <Leader>E :LspDocumentDiagnostics<CR> :lopen<CR> :let w:quickfix_title = "LSP Diagnostics"<CR> :lfirst<CR>
nnoremap <silent> <Leader>W :LspHover<CR>
nnoremap <silent> <leader>A :LspCodeAction<CR>
xnoremap <silent> <leader>A :LspCodeAction<CR>

" Settings: https://github.com/prabirshrestha/vim-lsp/blob/master/doc/vim-lsp.txt
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 150
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_highlights_delay = 0
highlight lspReference ctermbg=242 ctermfg=yellow
let g:lsp_diagnostics_signs_delay = 0
let g:lsp_hover_conceal = 1
let g:markdown_syntax_conceal = 1
let g:markdown_fenced_languages = ["javascript"]
let g:lsp_diagnostics_virtual_text_enabled = 0
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
nnoremap <silent> <Leader>mp :MarkdownPreview<CR>

" Completion: Cycling {{{1
inoremap <expr> <C-j>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" Completion: force refresh {{{1
imap <C-Space> <Plug>(asyncomplete_force_refresh)


" vimspector {{{1
nmap <Leader>dd <Plug>VimspectorLaunch
nmap <Leader>dc <Plug>VimspectorContinue
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver
nmap <Leader>dk <Plug>VimspectorStepOut
nmap <Leader>dr <Plug>VimspectorRestart
nnoremap <silent> <Leader>de :call vimspector#Reset()<CR>
nmap <Leader>db <Plug>VimspectorToggleBreakpoint :echo "Toggle breakpoint"<CR>
nmap <Leader>db <Plug>VimspectorToggleBreakpoint :echo "Toggle breakpoint"<CR>
nmap <Leader>dq <Plug>VimspectorToggleConditionalBreakpoint<CR>
nnoremap <silent> <Leader>dB :call vimspector#ListBreakpoints()<CR>
nnoremap <silent> <Leader>dC :call vimspector#ClearBreakpoints()<CR>
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
nnoremap <silent> <Leader>gq :GitGutterQuickFix<CR>:copen<CR>
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_sign_priority = 9

" Terraform {{{1
let g:terraform_fmt_on_save = 1


" Ranger {{{1
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
let g:ranger_map_keys = 0       " Do not map default keys
let g:ranger_replace_netrw = 1  " Use Ranger when opening directories
command! -bang Bclose :bd       " Required to use as netrw replacement
nnoremap <silent> <Leader>r :Ranger<CR>

" Vista – outline {{{1
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
autocmd FileType vista,vista_kind nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<CR>

let g:vista#renderer#enable_icon = 1
let g:vista_keep_fzf_colors = 1

nnoremap <silent> <Leader>/ :call vista#finder#fzf#Run()<CR>
nnoremap <silent> <Leader>o :Vista!!<CR>

function! NearestMethodOrFunction() abort
  let name = get(b:, "vista_nearest_method_or_function", "")
  if name != ""
    return " ƒ " .. name
  endif
  return ""
endfunction

" Quick-Scope {{{1
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" GitHub Copilot {{{1
imap <silent><script><expr> <S-Tab> copilot#Accept()
imap <C-L> <Plug>(copilot-accept-word)
let g:copilot_no_tab_map = v:true
let g:copilot_node_command = "~/.nvm/versions/node/v20.8.0/bin/node"
let g:copilot_workspace_folders = ["~/git/"]

"}}}

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
  let line = substitute(line, "{[{]{[0-9]$", "", "") " Weird hack because three { folds here, otherwise…
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
  g/\v\s(Scenario|describe)[.(]/ :normal zf%
endfunction

function FoldClass()
  execute "normal zE"
  g/\v^\s+(async )?[a-z0-9#_]+\([^)]*\) \{/ :normal $zf%
  silent g/ static.*{$/ :normal $zf%
  :nohlsearch
endfunction

" Toggle relative row numbers {{{1
nnoremap <C-n> :set relativenumber!<CR>
vnoremap <C-n> <ESC> :set relativenumber!<CR> :norm gv<CR>

" Remember English keyboard layout {{{1
nnoremap Ö :echo "⚠️  Keyboard layout ⚠️"<CR>

" Reset filetype (hack to reactivate syntax highlighting) {{{1
command Ftreset :let &ft=&ft
autocmd VimResized * :Ftreset

" Toggle booleans {{{1
nnoremap <silent> <Leader>a :call ToggleBoolean()<CR>

command Only :norm wi.onlyO// eslint-disable-next-line no-only-tests/no-only-tests

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
nnoremap gs( lbi(<ESC>ea)<ESC>
nnoremap gs) lbi(<ESC>ea)<ESC>
nnoremap gs{ lbi{<ESC>ea}<ESC>
nnoremap gs} lbi{<ESC>ea}<ESC>
nnoremap gs[ lbi[<ESC>ea]<ESC>
nnoremap gs] lbi[<ESC>ea]<ESC>
nnoremap gs" lbi"<ESC>ea"<ESC>
nnoremap gs' lbi'<ESC>ea'<ESC>
nnoremap gs/ lbi/<ESC>ea/<ESC>
nnoremap gs_ lbi_<ESC>ea_<ESC>
nnoremap gs* lbi*<ESC>ea*<ESC>
nnoremap gs` lbi`<ESC>ea`<ESC>
vnoremap gs( :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap gs) :s/\%V.*\%V./(&)/<CR>`< :noh<CR>
vnoremap gs{ :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap gs} :s/\%V.*\%V./{&}/<CR>`< :noh<CR>
vnoremap gs[ :s/\%V.*\%V./[&]/<CR>`< :noh<CR>
vnoremap gs] :s/\%V.*\%V./[&]/<CR>`< :noh<CR>
vnoremap gs" :s/\%V.*\%V./"&"/<CR>`< :noh<CR>
vnoremap gs' :s/\%V.*\%V./'&'/<CR>`< :noh<CR>
vnoremap gs/ :s/\%V.*\%V.//&//<CR>`< :noh<CR>
vnoremap gs_ :s/\%V.*\%V./_&_/<CR>`< :noh<CR>
vnoremap gs* :s/\%V.*\%V./*&*/<CR>`< :noh<CR>
vnoremap gs` :s/\%V.*\%V./`&`/<CR>`< :noh<CR>

" Un-surround {{{1
nnoremap gsd( lF(xf)x
nnoremap gsd) hF(xf)x
nnoremap gsd{ lF{xf}x
nnoremap gsd} hF{xf}x
nnoremap gsd[ lF[xf]x
nnoremap gsd] hF[xf]x
nnoremap gsd" hf"xF"x
nnoremap gsd' hf'xF'x
nnoremap gsd/ hf/xF/x
nnoremap gsd_ hf_xF_x
nnoremap gsd* hf*xF*x
nnoremap gsd` hf`xF`x

vnoremap gsd :s/\%V.\(.*\)\%V./\1/<CR>`< :noh<CR>

" camelCase <-> SNAKE_CASE {{{1
nnoremap <leader>CC :normal viw<CR> :s/\%V./\l&/g<CR> `< :s/\%V_\(.\)/\u\1/g<CR>`< :noh<CR>
nnoremap <leader>CS :normal viw<CR> :s/\%V[A-Z]/_&/g<CR> `< :s//\U&/g<CR> `< :noh<CR>

" Split JavaScript object to multiple lines {{{1
command SplitJS s/[{,]/&\r/g | execute "normal V$F}%<ESC>" | '<,'>s/}/\r}/g | noh

" Open all TODOs in the quickfix window {{{1
set grepprg=ag\ --nogroup\ --nocolor
command! TODO silent! grep TODO | cw | :let w:quickfix_title = "TODO list" | redraw!

" Format JS/JSON with jq {{{1
command -range JSON '<,'>!tr -d '\n' | xargs -0 printf "'\%s'" | xargs jq -n

" Highlight unwanted spacing {{{1
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace //

" Matching helper {{{1
function Match(number, visual_mode)

  " Visual mode? (`mode()` is always 'n', so this is ugly, but works...)
  if (a:visual_mode)
    let [ line_number, start_column ] = getpos("'<")[1:2]
    let end_column = getpos("'>")[2]
    let line = getline(line_number)
    let highlight_string = line[start_column - 1:end_column - 1]
  else
    " Default to word under cursor
    let highlight_string = expand("<cword>")
  endif

  execute ":" .. a:number .. "match User" .. (a:number ? a:number : "1") .. " /" .. highlight_string .. "/"
  echomsg "Highlighting \"" .. highlight_string .. "\" (" .. (a:number ? a:number : "1") .. ")"
endfunction

noremap <Leader>mm :call Match("", v:false)<CR>
noremap <Leader>m1 :call Match("", v:false)<CR>
noremap <Leader>m2 :call Match(2, v:false)<CR>
noremap <Leader>m3 :call Match(3, v:false)<CR>
xnoremap <Leader>mm :call Match("", v:true)<CR>
xnoremap <Leader>m1 :call Match("", v:true)<CR>
xnoremap <Leader>m2 :call Match(2, v:true)<CR>
xnoremap <Leader>m3 :call Match(3, v:true)<CR>

command Matchoff :match | :2match | :3match

" Help "Open file under cursor" understand file names without suffix {{{1
set suffixesadd=.js,.json,.hbs,.ts

" Add common paths to help locating files {{{1
let project = system("pwd | cut -d \/ -f1-5 | tr '\n' '/'")
let &path=".,".project."app/views/,".project."views/"

" Fuzzy find relative path from current file to another, and print {{{1
nnoremap <silent> <Leader>i :silent :execute "!grealpath --relative-to " . shellescape(expand("%:h")) ." $(fd '.jsx?$' \| fzf) \| sed -E  -e 's,^([^.]),./\\1,' \| xargs printf \| pbcopy"<CR> :normal "*P<CR> :redraw!<CR>

" Fuzzy find config node from `exp-config {{{1
nnoremap <silent> <Leader>I :silent :execute "!node ~/scripts/exp-config.js " . getcwd() . " \| fzf \| xargs printf \| pbcopy"<CR> :normal "*P<CR> :redraw!<CR>

" Open tig log and blame, respectively {{{1
nnoremap <silent> <Leader>L :silent !tig %<CR>:redraw!<CR>
nnoremap <silent> <Leader>l :silent :execute "!tig blame " . shellescape(expand("%")) . " +" . line(".") <CR>:redraw!<CR>

" Delete buffer. Quit if no more open buffers {{{1
nnoremap <silent> <Leader>q :call CloseOrQuit()<CR>
function CloseOrQuit()
  let current_buffer = bufnr()

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
nnoremap <Leader> o

" Open a terminal {{{1
nnoremap <silent> <Leader>TT :terminal ++close<CR>
nnoremap <silent> <Leader>Tn :terminal ++close node<CR>

" Search for the visually selected string {{{1
vnoremap * "oy/\V<C-R>o<CR>
vnoremap # "oy?\V<C-R>o<CR>


" F-KEYS BINDINGS {{{1

" Prev/next tab
noremap <F1> gT
noremap <F2> gt

" Toggle line-wrapping
noremap <silent><F3> :set wrap!<CR>:echo (&wrap == 0 ? "No wrap" : "Wrapping")<CR>

" Toggle case-sensitivity
noremap <silent><F4> :call ToggleCase()<CR>

function ToggleCase()
  let ignore_case = &ignorecase
  let smart_case = &smartcase
  set noignorecase " Needed for the regex match to work

  if (getreg("/") =~ '[A-Z]')
    set ignorecase
    if (smart_case == 0)
      set smartcase
    else
      set nosmartcase
    endif
  else
    set smartcase
    if (ignore_case == 0)
      set ignorecase
    else
      set noignorecase " Redundant, kept for clarity
    endif
  endif
endfunction

" Toggle conceal level
noremap <silent><F5> :call ToggleConcealLevel()<CR>

function ToggleConcealLevel()
  if (&conceallevel == 2)
    set conceallevel=0
  else
    set conceallevel=2
  endif
  echo "Conceal level: " . &conceallevel
endfunction

" Toggle "list mode"
noremap <silent><F6> :set list!<CR>

" Toggle spelling
noremap <F7> :set spell!<CR>

" Turn of highlighting
noremap <F8> :noh<CR>

" Prev/next diff
nmap <F9> [c
nmap <F10> ]c

" Make k/j traverse wrapped lines
noremap j gj
noremap k gk

" Speedy quick/location list handling {{{1
nnoremap <silent><leader>j :call NextListItem()<CR>
function NextListItem()
  try
    if IsQuickFixOpen()
      cnext
    else
      lnext
    endif
    norm zz
  catch
    echom "No more items (Bot)"
  endtry
endfunction

nnoremap <silent><leader>k :call PrevListItem()<CR>
function PrevListItem()
  try
    if IsQuickFixOpen()
      cprev
    else
      lprev
    endif
    norm zz
  catch
    echom "No more items (Top)"
  endtry
endfunction

nnoremap <silent><leader>c :call CloseList()<CR>
function CloseList()
  if IsQuickFixOpen()
    cclose
  else
    lclose
  endif
endfunction

function IsQuickFixOpen()
  return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) != 0
endfunction

" Make ctrl-x/ctrl-a work with selection {{{1
vnoremap <C-X> :g/./exe "norm \<C-X>"<CR>gv
vnoremap <C-A> :g/./exe "norm \<C-A>"<CR>gv


" Parenthesis matching {{{1
highlight MatchParen cterm=none ctermbg=red ctermfg=black

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
set spelloptions=camel

" Session handling {{{1
command Save mksession! ~/.session.vim
command Load source ~/.session.vim

" Marko syntax highlighting {{{1
autocmd BufNewFile,BufRead *.marko set filetype=html

" Fat fingers syndrome {{{1
command W w
command Q q
command Wq wq
command WQ wq
command Qa qa
command QA qa
command Wa wa
command WA wa
command Cq cq

" Quickly reset filetype when lost due to swap file collision {{{1
command Ftjs set ft=javascript

" Sort in dictionary order, ignoring case {{{1
xnoremap <leader>s :!sed 's/{ /{/' \| sort -df<CR>

" Copy/paste helper {{{1
xnoremap <leader>y "*y
nnoremap <leader>y "*y
nnoremap <leader>yy "*yy
xnoremap <leader>p "*p
nnoremap <leader>p "*p

" Pretty colors {{{1
highlight User1 ctermbg=black ctermfg=white
highlight User2 ctermbg=gray ctermfg=black
highlight User3 ctermbg=black ctermfg=yellow
highlight User4 ctermbg=black ctermfg=red
highlight Pmenu ctermbg=darkgray ctermfg=white
highlight PmenuSel ctermbg=Gray

" No idea... {{{1
if version >= 700
  set nofsync
endif
set viminfo='25,\"50,n~/.viminfo
