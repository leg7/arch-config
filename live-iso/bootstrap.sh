#!/bin/sh

if test "$1" = ""; then
	printf "Please provide the hostname of the system you want to install void to as the first and only argument\n"
	exit
fi

my_hostname="$1"

mount --onlyonce -m -L "${my_hostname}R" /mnt
mount --onlyonce -m -L "${my_hostname}H" /mnt/home
mount --onlyonce -m PARTLABEL="${my_hostname}Esp" /mnt/boot

pacstrap -K /mnt \
	base linux linux-firmware \
	xfsprogs exfatprogs fuse2 fuse3 \
   	cryptsetup lvm2 \
	iwd impala \
	mesa \
	neovim git less openssh 7zip bottom inetutils fd fzf which keyd \
	pam stow \
	doas texinfo pkgconf patch make guile gc libtool groff flex fakeroot debugedit xxhash bison automake autoconf m4 # This is base-devel without sudo

mkdir -p /mnt/home/user/code
cp -r /root/arch-config /mnt/home/user/code
arch-chroot /mnt /bin/bash -c "cd /home/user/code/arch-config/live-iso/config-files && ./deploy.sh"

mkswap -U clear --size 4G --file /mnt/swapfile
swapon /mnt/swapfile

genfstab /mnt > /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt hwclock --systohc

arch-chroot /mnt locale-gen

echo "$my_hostname" > /mnt/etc/hostname

arch-chroot /mnt mkinitcpio -P

ln -sf /mnt/usr/bin/doas /mnt/usr/bin/sudo

arch-chroot /mnt passwd
arch-chroot /mnt useradd --groups wheel -U user
arch-chroot /mnt passwd user

arch-chroot /mnt systemctl enable systemd-networkd systemd-resolved iwd keyd
arch-chroot /mnt ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
arch-chroot /mnt ln -sf /usr/lib/systemd/network/89-ethernet.network.example /usr/lib/systemd/network/89-ethernet.network

luks_uuid="$(blkid -o value -s UUID -t PARTLABEL="${my_hostname}Luks")"
mkdir -p /mnt/boot/loader/entries
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions rd.luks.name=%s=%s_system root=/dev/%s_system/root rw quiet" "$luks_uuid" "$my_hostname" "$my_hostname" > /mnt/boot/loader/entries/arch.conf
arch-chroot /mnt bootctl install
