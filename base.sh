#!/bin/bash

# set time zone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime 

# run hwclock to generate /etc/adjtime
hwclock --systohc

# generate locales
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf

# create hostname file
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# set root pw
echo root:password | chpasswd

# install low level software
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset sof-firmware nss-mdns acpid os-prober ntfs-3g intel-ucode

# Install gpu driver
pacman -S --noconfirm nvidia nvidia-lts nvidia-utils nvidia-settings

# Installs grub on efi parition. Change the directory to /boot/efi if you mounted the EFI partition at /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB 

# Regenerate grub config to enaible microcode updates
grub-mkconfig -o /boot/grub/grub.cfg

# enable startup processes
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable acpid

# add regular sudo user
useradd -m weygoldt
echo weygoldt:password | chpasswd
usermod -aG libvirt weygoldt

# add user to sudoers
echo "weygoldt ALL=(ALL) ALL" >> /etc/sudoers.d/weygoldt

# print finishing instructions
printf "\e[1;32mDone! If applicable, edit mkinitcpio.conf, type exit, umount -R and reboot.\e[0m"




