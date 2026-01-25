#!/bin/sh

print_separator() {
	printf "\n\n----- %s -----\n\n" "$1"
}

print_separator "Enable crucial services"

# Automate systemd boot update
systemctl enable --now systemd-networkd
systemctl enable --now systemd-resolved

print_separator "Install base-devel without sudo "
doas pacman -Sq --needed texinfo pkgconf patch make guile gc libtool groff flex fakeroot debugedit xxhash bison automake autoconf m4

print_separator "Installing an AUR helper (yay)"
if ! which yay; then
	git clone https://aur.archlinux.org/yay.git
	cd yay || exit
	if git pull; then
		makepkg --needed si
	fi
	rm -r yay
fi

print_separator "Update the system"
yay -Syu --needed

install() {
	yay -Sq --needed --noconfirm "$@"
}

printf_separator "Use doas instead of sudo"
install opendoas
doas ln -sf /usr/bin/doas /usr/bin/sudo

print_separator "Drivers"
install mesa xfsprogs exfatprogs fuse2 fuse3

print_separator "Bluetooth"
install bluez bluez-utils bluetui
systemctl enable --now bluetooth

print_separator "Basic utilities"
install neovim git fzf fd fish starship inetutils less bottom brightnessctl 7zip

print_separator "Dev utilities"
install cargo go clang make jq odin

print_separator "Audio systems"
install pipewire pipewire-audio pipewire-alsa pipewire-pulse rtkit wireplumber pipewire-docs mpd mpc \
	picard spek-x-bin coppwr easyeffects lsp-plugins \
	rmpc pulsemixer pamixer playerctl
systemctl --user enable --now pipewire pipewire-pulse wireplumber mpd

print_separator "Torrenting"
install transmission-cli rustmission-bin
systemctl enable --now transmission

print_separator "Graphical environment"
install hyprland foot yambar-wayland yambar-hyprland-wses fnott fuzzel swaybg

install neovide mpv imv brave-bin signal-desktop qalculate-gtk \
	zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps \
	lact syncthing
doas systemctl enable --now lactd syncthing@user.service

install wlr-randr yt-dlp wl-clipboard imagemagick ffmpeg slurp grim satty wlsunset

print_separator "Install fonts"
install noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-nerd-fonts-symbols

print_separator "Gaming stuff"
install steam proton-ge-custom-bin mangohud gamescope gamemode heroic-games-launcher-bin prismlauncher

print_separator "VPN"
install mullvad-vpn

print_separator "Symlink config files"
install stow
stow -R --no-folding --dir ./config-files -t ~ home
doas stow -R --no-folding --dir ./config-files -t / root
