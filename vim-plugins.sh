#!/bin/bash

install_dir=~/.vim/bundle
swap_dir=~/.vim/swapfiles
backup_dir=~/.vim/backups
color_headline="34"
color_default="33"


function print {
  local terminal_width=$(tput cols)
  local string_width=$(($terminal_width - 2))
  local color=${2:-$color_default}
  printf "\n\x1b[%d;7m %-*s\x1b[0m\n" $color $string_width "$1"
}

function clone {
# last argument is the directory name
  local dir=${2:-$(basename $1 .git)}

  if [[ -d "$install_dir/$dir" ]]; then
    printf "\x1b[3;30m$dir\x1b[0m is already installed\n"
    return 1
  fi

  git clone --depth=1 $@
  echo ""

  return 0
}


if [[ ! -d $install_dir ]]; then
  echo "Could not find install directory, creating it at $install_dir"
  mkdir -p $install_dir
  mkdir $swap_dir
  mkdir $backup_dir
fi

cd $install_dir

print "Pathogen plugin handler"
if [[ -f ~/.vim/autoload/pathogen.vim ]]; then
  printf "\x1b[3;30mPathogen\x1b[0m is already installed\n"
else
  mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim git@tpo.pe/pathogen.vim
fi


## SYNTAX
print "S Y N T A X" $color_headline

print "Mustache/Handlebars"
clone git@github.com:mustache/vim-mustache-handlebars.git mustache

print "Stylus"
clone git@github.com:wavded/vim-stylus.git

print "Jinja"
clone git@github.com:lepture/vim-jinja.git

print "JavaScript"
clone git@github.com:jelera/vim-javascript-syntax.git

print "Terraform"
clone git@github.com:hashivim/vim-terraform.git

print "Bash"
clone git@github.com:kovetskiy/vim-bash.git


## PLUGINS
print "P L U G I N S" $color_headline

print "Ranger"
clone git@github.com:francoiscabrol/ranger.vim.git

print "SnipMate"
clone git@github.com:tomtom/tlib_vim.git
clone git@github.com:MarcWeber/vim-addon-mw-utils.git
clone git@github.com:garbas/vim-snipmate.git
clone git@github.com:daghall/vim-snippets.git

print "Commentary"
clone git@github.com:tpope/vim-commentary

print "Git gutter"
clone git@github.com:airblade/vim-gitgutter.git

print "Syntastic"
clone git@github.com:vim-syntastic/syntastic.git

print "FZF.vim"
clone git@github.com:junegunn/fzf.vim.git

print "Fugitive"
clone git@github.com:tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q

print "Markdown preview"
clone git@github.com:iamcco/markdown-preview.nvim.git
if [[ $? -eq 0 ]]; then
  cd "$install_dir/markdown-preview.nvim/app"
  npm install
  cd -
fi

print "Vimspector"
clone git@github.com:puremourning/vimspector.git

print "Language Server"
clone git@github.com:prabirshrestha/vim-lsp.git
clone git@github.com:mattn/vim-lsp-settings.git
clone git@github.com:prabirshrestha/asyncomplete.vim.git
clone git@github.com:prabirshrestha/asyncomplete-lsp.vim.git
clone git@github.com:preservim/vim-markdown.git

print "Vista"
brew list universal-ctags > /dev/null || brew install universal-ctags
clone git@github.com:liuchengxu/vista.vim.git

print "Quick-Scope"
clone git@github.com:unblevable/quick-scope

print "Copilot"
clone git@github.com:github/copilot.vim.git

print "Context"
clone git@github.com:wellle/context.vim.git
