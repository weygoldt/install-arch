# My arch linux installation helper
**Disclaimer:** This was created for personal documentation of my setup to make my setup more reproducible. Do not use this as a guide.

Three scripts to help me install (1) the arch base system, (2) the kde plasma desktop environment and (3) the software I use on a daily basis. This repository is still work in progress and not fully functional yet. The scripts are modified versions of the arch install helper scripts from [eflinux](https://gitlab.com/eflinux).

The script is written for a thinkpad p52, which boots in uefi mode, has an intel processor and nvidia and intel hybrid graphics. Instead of swap I use zram. The file system will be btrfs for its snapshot capabilities.

Before running the script download the [arch iso](https://archlinux.org/download/), burn usb and boot into live environment.

## 1. Keymap, network, clock

To list available keyboard layouts, use the following commands. Select the appropriate layout. The default is the us layout.
```sh
localectl list-keymaps                          # list keymaps
localectl list-keymaps | grep -i <search_term>  # search 
loadkeys <layout>                               # select layout from list
```
Verify the boot mode to prevent running into errors in later stages of the installation. If there is no error after running `ls /sys/firmware/efi/efivars`, the system booted in uefi mode.

To verify a network connection (using a wired connection is easier) use `ip link` to list available network interfaces and `ping archlinux.org` to test if a connection can be established.

Update the system clock with `timedatectl set-ntp true`

## 2. Disk partitioning

This partition layout will only contain a boot partition, root partition and a home partition with btrfs filesystem. For other file systems or partition layouts refer to the [wiki](https://wiki.archlinux.org/title/Installation_guide). I also use zram so no swap partition will be created. It is best to start this on a fully wiped drive.

```sh
fdisk -l                              # list devices or
lsblk                                 # also lists devices
gdisk /dev/<disk_to_be_partitioned>   # select target
n                                     # create new partition
1                                     # accept default partition number
# accept first sector
+300M                                 # create 300M efi partition
ef00                                  # select efi partition layout 
n                                     # create second partition
# accept all defaults
w                                     # write parition layout
lsblk                                 # check if partitions were created
```

6. Make file systems
```sh
mkfs.fat -F32 /dev/<partition_name_1>

# label the partition archlinux
mkfs.btrfs -L archlinux /dev/<partition_name_2>
```

7. Create subvolumes

Mount root partition to mount directory, create btrfs subvolumes, unmount directory, then remount subvolumes with their own options.
```sh
mount /dev/<partition_name_2> /mnt    # mount btrfs part to /mnt
cd /mnt
btrfs subvol create @               # create root partition
btrfs subvol create @home           # create home partition
cd
umount /mnt
mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/<partition_name_2> /mnt # mount root
mkdir /mnt/{boot/efi,home} # create dir for home and boot
mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/<partition_name_2> /mnt/home # mount home
mount /dev/<partition_name_1> /mnt/boot/efi # mount boot
lsblk # check if worked
```
8. Install base packages

There will be some errors since the locales have not been generated yet. This will be done by the scripts.
```sh
pacstrap /mnt base linux linux-headers linux-firmware nano git
```

9. Generate fstab
```sh 
genfstab -U /mnt >> /mnt/etc/fstab
```

10. Move into installation
```sh
arch-chroot /mnt
```
11.  Use base script
```sh 
git clone https://github.com/weygoldt/arch-install
cd <arch-install>
chmod +x <base.sh>
# move back to root
cd /
./arch-install/base.sh
```

12. Edit mkinitcpio.conf before reboot after installing base script
Add modules for file system
```sh
nano /etc/mkinitcpio.conf
# Then add
MODULES=(btrfs i915)
# Rebuild initramfs by running
mkinitcpio -p linux linux-lts# change if another kernel is installed
```
Some missing firmware warnings are normal

13. Unmount and reboot
```sh
exit
umount -R /mnt
reboot
```
log in with sudo user instead of root

14. Recheck ip after reboot
```sh
ip a
```
15. Copy stuff from the arch install directory to home directory
```sh
cd ~
cp -r /arch-install .
ls -l       # to check if sucessful
cd arch-install   # move to repo
```
16. Run kde install script 
```sh
chmod +x kde.sh
cd /
.home/weygoldt/arch-install/kde.sh
```

17. Reboot - 
Now we should be greeted with sddm and boot into kde. Login as the created user.

18. Optional: enable multilib
Some packages, such as davinci-resolve, require 32bit packages that are found the in the multilib repo.
To enable, uncomment the lines
```sh
[multilib]
Include = /etc/pacman.d/mirrorlist
```
in `/etc/pacman.conf`

19. Install software with the scripts provided in `arch-install/software/`. Be sure to use all scripts since they partially depend on each other. E.g. `cronie` is available in the official repositories and `timeshift` only in the AUR but `timeshit` needs `cronie` for scheduled snapshots.

20. To do list after installation
- Setup btrbk snapshots and backups
- Clone dotfiles
- Check that ufw and zram is enabled
- Change root and user passwords (default: password)
- Add conky startup script to kde startup scripts in system settings
- Get themes
  - Global theme: https://store.kde.org/p/1633675/
  - Icons: https://store.kde.org/p/1686927/
  - Cursors: https://store.kde.org/p/1662218/