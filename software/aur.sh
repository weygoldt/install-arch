#!/bin/bash
cd

paru -S zsh-autosuggestions-git zsh-completions-git zsh-syntax-highlighting-git rstudio-desktop visual-studio-code-bin espanso-git 1password timeshift timeshift-autosnap optimus-manager optimus-manager-qt zramd

# enable zramd service
sudo systemctl enable --now zramd.service