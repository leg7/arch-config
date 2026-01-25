#!/bin/sh
# This script is distro agnostic. You can use it to setup your main disk for a new install.
# The disk will have 1 512M unencrypted ESP partition
# and a second LUKS partition with two LVM logical volumes home and root with an XFS filesystems

# Check for root
if test "$(id -u)" -ne 0; then
	printf "This script must be run as root." >&2
	exit 1
fi

# Check dependencies
dependencies="grep cat cryptsetup mkfs.xfs mkfs.vfat parted id vgcreate"
missing_deps=false
for d in $dependencies; do
	if ! command -v "$d" > /dev/null 2>&1; then
		printf "Missing command: %s.\n" "$d" >&2
		missing_deps=true
	fi
done

if $missing_deps; then
	printf '%s\n%s\n' \
		'Please insall the missing commands to use this script' \
		'If you already have them installed under a different name a symlink should suffice' >&2
	exit
fi

# $1 confirmation message to print
confirm()
{
	while true; do
		echo "$1"
		printf "\t[y/N]: "
		read -r confirmation

		if echo "$confirmation" | grep -qiE "^n(o)?$|^$"; then
			return 1
		elif echo "$confirmation" | grep -qiE "^y(e(s)?)?$"; then
			return 0
		else
			printf "I didn't understand your answer.\n"
		fi
	done
}

prompt_result_path="$(mktemp)"

# $1 prompt question to print
prompt()
{
	while true; do
		printf "\n$1"
		printf "\tanswer: "
		read -r answer

		confirm "Please confirm that $answer is your answer." && break
	done

	echo "$answer" > "$prompt_result_path"
}

# Read the disk to format
lsblk
while true; do
	prompt "What block device do you want to setup as a system disk? (example: /dev/sda)\nWARNING: All data on the disk will be erased.\n"
	disk="$(cat $prompt_result_path)"

	if test -b "$disk"; then
		break
	else
		printf "ERROR: %s is not a block device. Please try again\n" "$disk"
	fi
done


# Read the hostname
prompt "What will be the hostname of your machine? This is needed to prefix the partition labels\n"
hostname="$(cat $prompt_result_path)"
# TODO: Make sure it is no more than 15 characters to accomodate xfs label constraints

# Partition disk
parted "$disk" -s \
	mklabel gpt \
	mkpart "${hostname}Esp" fat32 0% 512MiB \
	mkpart "${hostname}Luks" 512MiB 100% \
	set 1 esp on

# Encrypt system partition
system_partition="$(lsblk -nr -o PATH $disk | sed -n '3p')"
cryptsetup luksFormat "$system_partition"
cryptsetup open "$system_partition" "${hostname}_luks"

# Add the lvm layer
vg="${hostname}_system"
vgcreate "$vg" /dev/mapper/${hostname}_luks
lvcreate --name root -L 40G "$vg"
lvcreate --name home -l 100%FREE "$vg"

# make filesystems
esp_partition="$(lsblk -nr -o PATH $disk | sed -n '2p')"
mkfs.vfat -F32 "$esp_partition"
mkfs.xfs -L "${hostname}R" /dev/"$vg"/root
mkfs.xfs -L "${hostname}H" /dev/"$vg"/home
