#!/bin/bash
cd # change dir to home

# message
printf "\e[1;32mInstalling miniconda requires user input!\e[0m"

# package list
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
    #grub-btrfs                     # adds btrfs snapshots to grub (read doc first)
)

# install package list
paru -S ${PACKAGES[@]}

# enable zramd service
sudo systemctl enable --now zramd.service

# check if zramd is active
echo # to make a new line
printf "\e[1;32mIs zramd.service active?\e[0m"
echo # to make a new line
sudo systemctl status zramd.service

# check if listed as block device
echo # to make a new line
printf "\e[1;32mIs zram listed as a block device?\e[0m"
echo # to make a new line
lsblk | grep zram