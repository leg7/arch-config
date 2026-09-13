----  Basics

--- Variables

hl.config({
	general = {
		layout = "dwindle",

		gaps_in = 6,
		gaps_out = 12,
		border_size = 5,

		col = {
			active_border   = "#ff5f1f",
			inactive_border = "#101623",
		},

		no_focus_fallback = true,

		resize_on_border = true,
		hover_icon_on_border = true,
	},

	decoration = {
		blur = {
			enabled = false,
			size = 2,
		},

		shadow = {
			enabled = true,
		},
	},

	input = {
		numlock_by_default = true,
		repeat_rate = 50,
		repeat_delay = 300,

		accel_profile = "flat",

		touchpad = {
			natural_scroll = true,
			clickfinger_behavior = true,
		},
	},

	cursor = {
		inactive_timeout = 3,
	},

	misc = {
		vrr = 3, -- Only on for games and videos
		key_press_enables_dpms = true,
	},

	render = {
		direct_scanout = 2,
	},
})

--- Monitors

hl.monitor({
	output = "desc:Shenzhen KTC Technology Group M27T6",
	mode = "2560x1440@180",
	position = "auto",
	scale = 1,
	bitdepth = 10,
	supports_hdr = 1,
	supports_wide_color = 1,
	cm = "hdr",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-right",
	scale = 1,
	mirror = "desc:Shenzhen KTC Technology Group M27T6"
})

hl.monitor({
	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 24130B003814",
	mode = "2560x1440@120",
	position = "auto",
	scale = 1,
	bitdepth = 10,
})

--- Binds

-- Application Launchers
hl.bind("SUPER + CONTROL + B", hl.dsp.exec_cmd("brave")) -- TODO: Use $BROWSER
hl.bind("SUPER + CONTROL + C", hl.dsp.exec_cmd("qalculate-gtk"))
hl.bind("SUPER + CONTROL + E", hl.dsp.exec_cmd("foot -f monospace:pixelsize=20 -T emoji-picker emoji"))
hl.bind("SUPER + CONTROL + F", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + CONTROL + G", hl.dsp.exec_cmd("steam"))
hl.bind("SUPER + CONTROL + L", hl.dsp.exec_cmd("swaylock"))
hl.bind("SUPER + CONTROL + M", hl.dsp.exec_cmd("music"))
hl.bind("SUPER + CONTROL + N", hl.dsp.exec_cmd("neovide"))
hl.bind("SUPER + CONTROL + Q", hl.dsp.exec_cmd("qr"))
hl.bind("SUPER + CONTROL + R", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + CONTROL + T", hl.dsp.exec_cmd("footclient"))
hl.bind("SUPER + CONTROL + V", hl.dsp.exec_cmd("footclient -T pulsemixer pulsemixer"))
hl.bind("SUPER + CONTROL + W", hl.dsp.exec_cmd("wl-color-picker"))
hl.bind("SUPER + CONTROL + ESCAPE", hl.dsp.exec_cmd("pkill hyprland"))
hl.bind("SUPER + CONTROL + X", hl.dsp.window.close())
hl.bind("SUPER + CONTROL + K", hl.dsp.window.kill())

-- Focus & Movement (Normal Mode)
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + Z", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind("SUPER + Period", hl.dsp.focus({ monitor = "+1" }))
hl.bind("SUPER + Comma",  hl.dsp.focus({ monitor = "-1" }))

-- Layout manipulation TODO
-- hl.bind("SUPER + ALT + H") splitratio, -0.05
-- hl.bind("SUPER + ALT + L") splitratio, +0.05

-- Move mode

hl.bind("SUPER + ALT + M", hl.dsp.submap("move"))
hl.define_submap("resize", function ()
    hl.bind("J", hl.dsp.window.swap({direction = "d"}))
    hl.bind("K", hl.dsp.window.swap({direction = "u"}))
    hl.bind("H", hl.dsp.window.swap({direction = "l"}))
    hl.bind("L", hl.dsp.window.swap({direction = "r"}))

    hl.bind("Period", function()
    	hl.dsp.window.move({ monitor = "mon:+1" })
		hl.dsp.focus({ montior = "+1" })
    end)
    hl.bind("Comma", function()
    	hl.dsp.window.move({ monitor = "mon:-1" })
		hl.dsp.focus({ montior = "-1" })
    end)

    hl.bind("ALT + Period", hl.dsp.window.move({ monitor = "mon:+1" }))
    hl.bind("ALT + Comma",  hl.dsp.window.move({ monitor = "mon:-1" }))
    hl.bind("Escape",       hl.dsp.submap("reset"))
end)

-- Float Mode
-- bind = $mainMod ALT, F, submap, floatmode
-- hl.bind("SUPER + ALT + F", hl.dsp.submap("floating"))
-- hl.define_submap("floating", function()
--     bind = , T, togglefloating
--
--     # Move (step 50)
--     binde = , H, moveactive, -50 0
--     binde = , J, moveactive, 0 50
--     binde = , K, moveactive, 0 -50
--     binde = , L, moveactive, 50 0
--
--     # Resize (step 50)
--     binde = CONTROL, H, resizeactive, -50 0
--     binde = CONTROL, J, resizeactive, 0 50
--     binde = CONTROL, K, resizeactive, 0 -50
--     binde = CONTROL, L, resizeactive, 50 0
--
--     # Snapping not native in Hyprland config, mapped to simple moves for now
--     bind = ALT, H, movewindow, l
--     bind = ALT, J, movewindow, d
--     bind = ALT, K, movewindow, u
--     bind = ALT, L, movewindow, r
--
--     bind = , Escape, submap, reset
-- end)

-- Passthrough Mode --
-- bind = $mainMod ALT, F11, submap, passthrough
-- submap = passthrough
--     bind = $mainMod ALT, F11, submap, reset
-- submap = reset

-- Mouse ---
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true }) -- Left Click
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Right Click
hl.bind("SUPER + mouse:274", hl.dsp.window.float(),  { mouse = true }) -- Middle Click

-- Workspaces
workspaces = { 'coding', 'testing', 'documentation', 'internet', 'media', 'games', 'notes', 'other' }
for id, w in ipairs(workspaces) do
	workspace_letter = w:sub(1,1)
	hl.bind("SUPER + "       .. workspace_letter, hl.dsp.focus({ workspace = id }))
	hl.bind("SUPER + ALT + " .. workspace_letter, hl.dsp.window.move({  workspace = id }))
end

-- # "All Tags" -> Special Workspace (Scratchpad)
-- bind = $mainMod, A, togglespecialworkspace
-- bind = $mainMod SHIFT, A, movetoworkspace, special
--
-- # --- Media & Hardware Keys ---
-- bindl = , XF86AudioRaiseVolume, exec, pamixer -i 2
-- bindl = , XF86AudioLowerVolume, exec, pamixer -d 2
-- bindl = , XF86AudioMute, exec, pamixer -t
-- bindl = , XF86AudioMedia, exec, playerctl play-pause
-- bindl = , XF86AudioPlay, exec, playerctl play-pause
-- bindl = , XF86AudioPrev, exec, playerctl previous
-- bindl = , XF86AudioNext, exec, playerctl next
-- bind = , Print, exec, flameshot gui
-- bindl = , XF86MonBrightnessUp, exec, brightnessctl set +2%
-- bindl = , XF86MonBrightnessDown, exec, brightnessctl set 2%-

---- Advanced and Cool

--- Animations

hl.curve( "ease_out_expo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

hl.animation({ leaf = 'workspaces', enabled = false, speed = 2, bezier = "ease_out_expo" , style = "slide" })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "ease_out_expo", style = "slide"})

--- Devices

hl.device({
	name = "logitech-pro-x-1",
	accel_profile = "flat",
	sensitivity = -0.3,
})

-- Generic vertical mouse at work
hl.device({
	name = "wireless-dongle",
	accel_profile = "flat",
	sensitivity = -0.5,
})

-- University laptop touchpad
hl.device({
	name = "elan0773:00-04f3:3244-touchpad",
	accel_profile = "adaptive",
	sensitivity = 0.3,
})

-- t480 touchpad
hl.device({
	name = "synaptics-tm3276-022",
	accel_profile = "adaptive",
	sensitivity = 0.3,
})

--- Expanding Functionality

hl.on("hyprland.start", function()
	-- One time
	hl.exec_cmd("setbg -i")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("kanshi")
	-- Daemons
	hl.exec_cmd("yambar-reload")
	hl.exec_cmd("foot --server")
	hl.exec_cmd("fnott")
	hl.exec_cmd("transmission-daemon")
	hl.exec_cmd("syncthing --no-browser")
	hl.exec_cmd("wlsunset -S 6:00 -s 21:00 -t 4000 -d 900")
	hl.exec_cmd("easyeffects --gapplication-service")
	hl.exec_cmd("mpd")
	hl.exec_cmd("mpd-brainz")
end)

--- Env vars

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Toolkits
hl.env("GDK_BACKEND",     "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- Theming
hl.env("GTK_THEME", "Adwaita")
hl.env("XCURSOR_THEME", "Banana")
hl.env("XCURSOR_SIZE", "34")

--- Monitor added/removed events (for docking)

if os.getenv("HOSTNAME") == "fac" then
	-- I assume the laptop screen is always the first screen (i.e 0)
end

-- hl.on("monitor.added", function(_)
-- 	local monitors = hl.get_monitors()
-- 	-- if #monitors == 2 then
-- 		-- hl.monitor({
-- 		-- 	output = "eDP-1",
-- 		-- 	disabled = true,
-- 		-- })
-- 		os.execute("notify-send Added")
-- 	-- end
-- end)
--
-- hl.on("monitor.removed", function(_)
-- 	local monitors = hl.get_monitors()
-- 	-- if #monitors == 1 then
-- 		-- hl.monitor({
-- 		-- 	output = "eDP-1",
-- 		-- 	disabled = false,
-- 		-- 	mode = "preferred", position = "auto", scale = 1
-- 		-- })
-- 		os.execute("notify-send Removed")
-- 	-- end
-- end)
