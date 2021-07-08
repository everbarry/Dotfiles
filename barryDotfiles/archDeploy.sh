#!/bin/bash


## set locale and host config

read -p "Type in your region: " region
read -p "Type in your city: " city
ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

## set root pwd
echo "Setting root password"
echo root:password | chpasswd

## install microcode
echo "1) intel-ucode 	2) amd-ucode 3) Skip"
read -r -p "Choose your microcode: (default 1)(will not re-install): " vid

case $vid in 
[1])
	DRI='intel-ucode'
	;;

[2])
	DRI='amd-ucode'
	;;
[3])
	DRI=""
	;;
[*])
	DRI=''
	;;
esac


## install basic packages 
pacman -S grub $DRI efibootmgr networkmanager dialog wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils alsa-utils reflector ntfs-3g

## install grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

## enable services
systemctl enable NetworkManager
systemctl enable bluetooth

## add user
read -p "Enter your username: " username
useradd -mG $username
echo $username:password | chpasswd

printf "Done! Type exit, umount -a and reboot."
