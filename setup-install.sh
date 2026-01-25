#!/bin/sh

if test "$1" = ""; then
	printf "Please provide the hostname of the system you want to install void to as the first and only argument\n"
	exit
fi

my_hostname="$1"

mount --onlyonce -m -L "${my_hostname}R" /mnt
mount --onlyonce -m -L "${my_hostname}H" /mnt/home
mount --onlyonce -m PARTLABEL="${my_hostname}Esp" /mnt/boot

pacstrap -K /mnt base linux linux-firmware xfsprogs cryptsetup lvm2 iwd impala

mkswap -U clear --size 4G --file /mnt/swapfile
swapon /mnt/swapfile

genfstab /mnt > /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "$my_hostname" > /mnt/etc/hostname

echo "KEYMAP=us" > /mnt/etc/vconsole.conf

sed -i 's/HOOKS=.*/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)/' /mnt/etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -P

arch-chroot /mnt passwd
arch-chroot /mnt useradd --groups wheel --create-home -U user
arch-chroot /mnt passwd user

arch-chroot /mnt systemctl enable systemd-networkd systemd-resolved iwd
mkdir -p /mnt/etc/iwd
printf "[Network]\nNameResolvingService=systemd\n[General]\nEnableNetworkConfiguration=true\n" > /mnt/etc/iwd/main.conf
arch-chroot /mnt ln -sf /usr/lib/systemd/network/89-ethernet.network.example /usr/lib/systemd/network/89-ethernet.network
arch-chroot /mnt ln -sf /usr/lib/systemd/network/80-wifi-adhoc.network /usr/lib/systemd/network/

luks_uuid="$(blkid -o value -s UUID -t PARTLABEL="${my_hostname}Luks")"
mkdir -p /mnt/boot/loader/entries
printf "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions rd.luks.name=%s=%s_system root=/dev/%s_system/root rw quiet" "$luks_uuid" "$my_hostname" "$my_hostname" > /mnt/boot/loader/entries/arch.conf
arch-chroot /mnt bootctl install


