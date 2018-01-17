#!/bin/bash

function print {
  echo -e "\n ===> $1"
}

print "Pathogen plugin handler"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle

## SYNTAX

print "Mustache/Handlebars"
git clone git://github.com/mustache/vim-mustache-handlebars.git bundle/mustache

print "Stylus"
git clone git://github.com/wavded/vim-stylus.git


## PLUGINS

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

print "CommandT"
git clone https://github.com/wincent/command-t.git
cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
ruby extconf.rb
make
