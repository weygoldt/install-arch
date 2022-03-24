#!/bin/bash
cd # change dir to home

PACKAGES=(
    zsh-autosuggestions-git         # for autosuggestions (as in manjaro)
    zsh-completions-git             # not working yet
    zsh-syntax-highlighting-git     # for syntax highlighting
    rstudio-desktop                 # IDE for R
    visual-studio-code-bin          # text editor for the lazy
    espanso-git                     # espanso unstable from git
    1password                       # password manager for web
    timeshift                       # for snapshots
    timeshift-autosnap              # for autosnaps before system upgrades
    optimus-manager                 # to manage hybrid graphics
    optimus-manager-qt              # a frontend for qt based desktop environments
    zramd                           # to enable zram
)

paru -S ${PACKAGES[@]}

# enable zramd service
sudo systemctl enable --now zramd.service