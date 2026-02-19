#!/bin/sh
# Automate systemd boot update

if ! which yay; then
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin || exit
	if git pull; then
		makepkg --needed -si
	fi
	rm -r yay-bin
fi

yay -Syuq --needed --noconfirm \
	bluez bluez-utils bluetui \
	fish starship brightnessctl \
	cargo go clang make jq odin \
	pipewire pipewire-audio pipewire-alsa pipewire-pulse rtkit wireplumber pipewire-docs mpd mpc \
	picard spek-x-bin coppwr easyeffects lsp-plugins \
	rmpc pulsemixer pamixer playerctl \
	transmission-cli rustmission-bin \
	hyprland foot yambar-hyprland-wses fnott fuzzel swaybg yambar-wayland kanshi flameshot \
	neovide mpv imv brave-bin signal-desktop qalculate-gtk mullvad-vpn-bin \
	zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps \
	lact syncthing \
	wlr-randr yt-dlp wl-clipboard imagemagick ffmpeg slurp grim satty wlsunset \
	noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-nerd-fonts-symbols \
	steam proton-ge-custom-bin mangohud gamescope gamemode heroic-games-launcher-bin prismlauncher \
	stow

go install github.com/sav/mpd-brainz@latest

systemctl --user enable --now pipewire pipewire-pulse wireplumber mpd
systemctl enable --now bluetooth transmission lactd syncthing@user.service
