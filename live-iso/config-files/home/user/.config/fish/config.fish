if status is-login
	set -U fish_greeting

	set -gx PATH "$BIN_HOME:$PATH"

	set -gx LESS "Ri" # Less default options (inhibits git from calling less with -F and -R)
	set -gx BROWSER "brave"
	set -gx EDITOR "nvim"
	set -gx MAKEFLAGS "-j$(nproc)"

	set -gx ASAN_OPTIONS "halt_on_error=0"
	set -gx FZF_DEFAULT_OPTS "--ansi --layout reverse --color fg:-1,fg+:-1,bg:-1,bg+:-1,hl:-1,hl+:-1,query:-1,gutter:-1"

	set -gx LS_COLORS 'di=1;35:fi=0:ln=1;31:pi=5:so=5:bd=5:cd=5:or=4:ex=1;36'

	set -gx XDG_DESKTOP_DIR     "$HOME"
	set -gx XDG_DOCUMENTS_DIR   "$HOME/documents"
	set -gx XDG_DOWNLOAD_DIR    "$HOME"
	set -gx XDG_MUSIC_DIR       "$HOME/audio"
	set -gx XDG_PICTURES_DIR    "$HOME/pics"
	set -gx XDG_TEMPLATES_DIR   "$HOME"
	set -gx XDG_VIDEOS_DIR      "$HOME/vids"
	mkdir -p "$XDG_DESKTOP_DIR" \
		"$XDG_DOCUMENTS_DIR" \
		"$XDG_DOWNLOAD_DIR" \
		"$XDG_MUSIC_DIR" \
		"$XDG_PICTURES_DIR" \
		"$XDG_TEMPLATES_DIR" \
		"$XDG_VIDEOS_DIR"

	# Don't care about this dir
	set -gx XDG_PUBLICSHARE_DIR ""

	if test (tty) = "/dev/tty1"
		dbus-run-session start-hyprland
	end
end

function fzf-cd
	cd (fd -t d | fzf)
end

function fzf-path
	readlink -f (fd | fzf) | tr -d '\n\r'
end

function fzf-copy-path
	fzf-path | wl-copy
end

function fzf-xdg-open
	setsid -f xdg-open (fzf-path)
end

function fzf-history
	history search | fzf | wl-copy
end

if status is-interactive
	fish_vi_key_bindings

	for mode in default normal insert
		bind -M $mode \cg "setsid -f xdg-open ." # g for gui

		bind -M $mode 'ctrl-w' "fzf-cd; commandline -f repaint" # w for working dir
		bind -M $mode 'ctrl-h' "fzf-history; commandline -f repaint"
		bind -M $mode 'ctrl-p' "fzf-copy-path; commandline -f repaint"
		bind -M $mode 'ctrl-f' "fzf-xdg-open; commandline -f repaint"
		bind -M $mode 'ctrl-t' "setsid -f footclient"
		bind -M $mode 'alt-l' "ls -lahv --group-directories-first; fish_prompt"
		bind -M $mode 'alt-t' "tree -L 3; fish_prompt"
	end

	bind -M insert \ca "accept-autosuggestion" # a for accept

	starship init fish | source
end
