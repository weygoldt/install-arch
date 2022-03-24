#!/bin/bash
cd

# software
sudo pacman -S --noconfirm torbrowser-launcher torsocks keepassxc veracrypt libreoffice texlive-most biber pandoc firefox inkscape qbittorrent vlc ufw zsh neofetch tk r youtube-dl conky filelight cronie python-pip

# Enable firewall (did not execute last time?)
sudo ufw enable

# Change default shell to zsh (also did not execute for some reason)
sudo chsh -s /usr/bin/zsh

# Enable cronie so that scheduled timeshift snapshots are actually executed
systemctl enable cronie.service 
systemctl start cronie.service 