#!/bin/bash

# clone dotfiles 
cd
echo 'alias dfs="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.zshrc
source ~/.zshrc
echo ".dotfiles.git" >> .gitignore
git clone --bare https://www.github.com/weygoldt/repo.git $HOME/.dotfiles
dfs checkout
dfs config --local status.showUntrackedFiles no