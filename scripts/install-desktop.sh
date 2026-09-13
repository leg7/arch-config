#!/bin/sh

if ! which yay; then
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin || exit
	if git pull; then
		makepkg --needed -si
	fi
	cd .. || exit
	rm -r yay-bin
	yay --sudo /usr/bin/doas --save
fi

yay -Syuq --needed --noconfirm \
	bluez bluez-utils bluetui \
	fish starship brightnessctl \
	cargo go clang make jq odin \
	ripgrep \
	pipewire pipewire-audio pipewire-alsa pipewire-pulse rtkit wireplumber pipewire-docs mpd mpc \
	picard spek shntool coppwr easyeffects lsp-plugins \
	rmpc pulsemixer pamixer playerctl \
	transmission-cli rustmission-bin \
	hyprland xdg-desktop-portal-gtk foot yambar-hyprland-wses fnott fuzzel swaybg yambar-wayland kanshi flameshot \
	neovide mpv imv brave-bin signal-desktop qalculate-gtk mullvad-vpn-bin \
	zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps \
	lact syncthing \
	wlr-randr yt-dlp wl-clipboard imagemagick ffmpeg slurp grim satty wlsunset \
	noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-nerd-fonts-symbols \
	steam proton-ge-custom-bin mangohud gamescope gamemode heroic-games-launcher-bin prismlauncher \
	stow

chsh --shell /usr/bin/fish

go install github.com/sav/mpd-brainz@latest

doas systemctl --user enable --now pipewire pipewire-pulse wireplumber mpd
doas systemctl enable --now bluetooth lactd
systemctl enable --now syncthing@user.service
