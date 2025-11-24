#!/bin/bash


source /post/config


#HOSTNAME
echo "biblios" > /etc/hostname &&


## LOCALTIME 
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &&
hwclock --systohc &&
timedatectl set-ntp true &&
timedatectl set-timezone $TIMEZONE &&


## CONFIG
cp -fr /post/base/* / &&


## LOCALE
locale-gen &&


##
## BOOTUPS
mkdir -p /boot/{efi,kernel,loader} &&
mkdir -p /boot/efi/{boot,linux,systemd,rescue} &&
mv /boot/*-ucode.img /boot/kernel/ &&
rm /etc/mkinitcpio.conf &&
rm -fr /etc/mkinitcpio.conf.d/ &&


##
## SERVICE
systemctl enable gdm &&
systemctl enable dnsmasq &&
systemctl enable sshd &&
systemctl enable update.timer &&
systemctl enable firewalld &&
systemctl enable NetworkManager &&
systemctl enable --global pipewire-pulse &&
systemctl enable systemd-timesyncd.service &&
systemctl enable --global gcr-ssh-agent.socket &&

## EXECUTE
chmod +x /usr/xbin/* &&
chmod +x /usr/rbin/* &&


## CLEARED
rm /usr/share/wayland-sessions/weston.desktop &&


## BOOTING
echo "root=$DISKPROC" > /etc/cmdline.d/01-boot.conf &&
bootctl --path=/boot install &&
mkinitcpio -P &&


## USERADD
useradd -m $USERNAME &&
usermod -aG wheel $USERNAME &&
echo "add user passworrd" &&
passwd $USERNAME
