#!/bin/bash

function print {
  echo -e "\n ===> $1"
}

print "Pathogen plugin handler"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle

## SYNTAX

print "SYNTAX:"

print "Mustache/Handlebars"
git clone git://github.com/mustache/vim-mustache-handlebars.git mustache

print "Stylus"
git clone git://github.com/wavded/vim-stylus.git

print "Jinja"
git clone git://github.com/lepture/vim-jinja.git

print "JavaScript"
git clone https://github.com/jelera/vim-javascript-syntax.git

print "Terraform"
git clone git@github.com:hashivim/vim-terraform.git

print "Bash"
git clone git@github.com:kovetskiy/vim-bash.git


## PLUGINS

print "PLUGINS"

print "Ranger"
git clone git@github.com:francoiscabrol/ranger.vim.git

print "SnipMate"
git clone https://github.com/tomtom/tlib_vim.git
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
git clone https://github.com/garbas/vim-snipmate.git
git clone https://github.com/honza/vim-snippets.git

print "Commentary"
git clone https://github.com/tpope/vim-commentary

print "Git gutter"
git clone git://github.com/airblade/vim-gitgutter.git

print "Syntastic"
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git

print "FZF.vim"
git clone git@github.com:junegunn/fzf.vim.git

print "Fugitive"
git clone https://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q

print "Markdown preview"
git clone git@github.com:iamcco/markdown-preview.vim.git

print "Vimspector"
git clone git@github.com:puremourning/vimspector.git

print "Language Server"
git clone git@github.com:prabirshrestha/vim-lsp.git
git clone git@github.com:mattn/vim-lsp-settings.git
git clone git@github.com:prabirshrestha/asyncomplete.vim.git
git clone git@github.com:prabirshrestha/asyncomplete-lsp.vim.git
git clone git@github.com:preservim/vim-markdown.git

print "Vista"
brew install universal-ctags
git clone git@github.com:liuchengxu/vista.vim.git

print "Quick-Scope"
git clone https://github.com/unblevable/quick-scope

print "Copilot"
git clone git@github.com:github/copilot.vim.git
