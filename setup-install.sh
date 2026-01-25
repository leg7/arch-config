#!/bin/sh

if test "$1" = ""; then
	printf "Please provide the hostname of the system you want to install void to as the first and only argument\n"
	exit
fi

my_hostname="$1"

mount -m -L "${my_hostname}R" /mnt
mount -m -L "${my_hostname}H" /mnt/home
mount -m PARTLABEL="${my_hostname}Esp" /mnt/boot

mkswap -U clear --size 4G --file /mnt/swapfile
swapon /mnt/swapfile

genfstab /mnt > /mnt/etc/fstab

pacstrap -K /mnt base linux linux-firmware

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "$my_hostname" > /mnt/etc/hostname

arch-chroot /mnt mkinitcpio -P
arch-chroot /mnt passwd

luks_uuid="$(blkid -o value -s UUID -t PARTLABEL="${my_hostname}Luks")"
mkdir -p /mnt/boot/loader/entries
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions rd.luks.name=%s=dan_system root=/dev/dan_system/root rw quiet" "$luks_uuid" > /mnt/boot/loader/entries/arch.conf
arch-chroot /mnt bootctl install
