#!/bin/bash
cd

# software
sudo pacman -S --noconfirm torbrowser-launcher torsocks keepassxc veracrypt libreoffice texlive-most biber pandoc firefox inkscape qbittorrent vlc ufw zsh neofetch tk r youtube-dl conky filelight

# software configuration
sudo ufw enable
sudo chsh -s /usr/bin/zsh