#!/bin/sh

print_separator() {
	printf "\n\n----- %s -----\n\n" "$1"
}

# Automate systemd boot update

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

print_separator "Bluetooth"
install bluez bluez-utils bluetui
systemctl enable --now bluetooth

print_separator "Basic utilities"
install fish starship brightnessctl

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
