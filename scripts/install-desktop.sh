#!/bin/sh

# Install packages

doas pacman -Suq --needed --noconfirm \
	bluez bluez-utils bluetui \
	fish dash starship brightnessctl \
	cargo go gopls clang make jq odin \
	ripgrep \
	pipewire pipewire-audio pipewire-alsa pipewire-pulse rtkit wireplumber pipewire-docs mpd mpc \
	picard spek easyeffects lsp-plugins \
	rmpc pulsemixer pamixer playerctl \
	transmission-cli \
	hyprland xdg-desktop-portal-gtk xdg-desktop-portal-hyprland hyprsunset hyprpaper hyprlock hypridle hyprpolkitagent hyprpicker \
	foot fnott fuzzel kanshi flameshot \
	neovide mpv imv signal-desktop qalculate-gtk \
	zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps \
	lact syncthing \
	wlr-randr yt-dlp wl-clipboard imagemagick ffmpeg \
	noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-nerd-fonts-symbols \
	steam mangohud gamescope gamemode prismlauncher \
	mullvad-vpn-daemon mullvad-vpn \
	tlp \
	stow

# Change shells

fish_path="$(which fish)"
if test "$SHELL" != "$fish_path"; then
	chsh --shell /usr/bin/fish
fi

# Use dash as /bin/sh

dash_path="$(which dash)"
doas ln -sf "$dash_path" /bin/sh

# Create directories and files needed for MPD

mkdir -p "$HOME"/audio/playlists "$HOME"/audio/music/flac "$XDG_CACHE_HOME"/mpd
touch "$XDG_CACHE_HOME"/mpd/mpd.db

# Enable system services

doas systemctl --machine user@.host --user enable --now pipewire pipewire-pulse wireplumber
doas systemctl enable --now bluetooth lactd mullvad-daemon

if test "$(hostname)" = "t480"; then
	doas systemctl enable --now tlp
fi

# Install programs not available with pacman

test "$XDG_CACHE_HOME" != "" || exit
build_dir="$XDG_CACHE_HOME"/arch-config_builds
mkdir -p "$build_dir"

## Install yambar

test "$XDG_CACHE_HOME" != "" || exit

build_dir="$XDG_CACHE_HOME"/arch-config_builds
mkdir -p "$build_dir"

if ! test -d "$build_dir"/yambar; then
	git clone https://codeberg.org/dnkl/yambar.git "$build_dir"/yambar
	sed -i '/Werror/d' "$build_dir"/yambar/meson.build
fi

yambar_build_dir="$build_dir"/yambar/bld/relases
if ! test -d "$yambar_build_dir"; then
	mkdir -p "$yambar_build_dir" && cd "$yambar_build_dir"
	meson setup --buildtype=release -Dbackend-x11=disabled -Dbackend-wayland=enabled ../..
	cd -
fi

cd "$yambar_build_dir"
ninja
if ! cmp yambar ~/.local/bin/yambar; then
	cp -v yambar ~/.local/bin
fi

## Install other programs with cargo

cargo install \
	rustmission \
	yambar-hyprland-wses

## Install other programs with go

go install github.com/sav/mpd-brainz@latest

## install other AUR programs

if ! which yay > /dev/null; then
	git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
	cd /tmp/yay-bin || exit
	if git pull; then
		makepkg --needed -si
	fi
	cd .. || exit
	yay --sudo /usr/bin/doas --save
fi

yay -Suq --needed --noconfirm \
	shntool \
	coppwr \
	brave-bin \
	heroic-games-launcher-bin
