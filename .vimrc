set showmode
set hidden
set nocompatible
set ruler
set autoindent
set backspace=indent,eol,start
set incsearch
syntax enable
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

colorscheme desert

" Highlight unwanted spacing
highlight ExtraWhitespace ctermbg=red guibg=red
au BufEnter * match ExtraWhitespace /\(\s\+$\|^ \{1,\}\)/
"au BufEnter * match ExtraWhitespace /\(\s\+$\|^\( \{1,\}\(?![\# ]\)\)\)/
"au BufEnter * match ExtraWhitespace /\(\s\+$\|^\( \{1,\}\(?![\# ]\)\)\)/
au InsertEnter * match ExtraWhitespace /\(\s\+\%#\@<!$\|^ \{1,\}\)/
au InsertLeave * match ExtraWhitespace /\(\s\+$\|^ \{1,\}\)/

" Map ctrl-k to open the file under cursor in a new tab
"set suffixesadd=.tmpl
nmap <C-k> <C-w>gF<CR>
"let root = system("pwd | cut -d \/ -f1-4 | tr '\n' '/'")
"let &path=".,".root."templates,".root."php/common/include/,".root."www/js/site/,".root."regress/final/,".root."scripts/batch/,".root."conf/bconf/campaigns/"

if version >= 700
	set nofsync
endif
set ttym=xterm2
set hlsearch
set viminfo='25,\"50,n~/.viminfo
set ve=block

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

" WIP! DON'T USE!
com Conf exec "tabe " . root ."conf/bconf/bconf.txt." <tab>

" Parenthisis matching
hi MatchParen cterm=none ctermbg=red ctermfg=black


au BufNewFile,BufRead *.tmpl                    let b:match_words='<%:%>' | set mps+=<:>
au BufNewFile,BufRead *.tmpl                    set filetype=templateparse
au BufNewFile,BufRead *.html.tmpl               set filetype=htmltemplateparse
au BufNewFile,BufRead *.sql.tmpl               	set filetype=sqltemplateparse
au BufNewFile,BufRead *.bconf               	set filetype=conf
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

" Match template tags
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = '<%:%>,{:},(:),[:],<:>'
let b:matchpairs = '<:>,{:},(:),[:]'

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

