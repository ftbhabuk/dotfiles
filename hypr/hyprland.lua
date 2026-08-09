-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

-- ============================================================
-- Ported from the old .conf era (userprefs.conf etc.)
-- ============================================================

hl.env("QT_QPA_PLATFORM", "wayland;xcb")

hl.config({
    input = {
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

-- ============================================================
-- Restored design (from ~/projects/dotfiles/hypr/themes/theme.conf)
-- ============================================================

hl.config({
    animations = { enabled = true },
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        layout = "dwindle",
        resize_on_border = true,
        col = {
            active_border = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
        },
    },
    group = {
        col = {
            border_active = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            border_inactive = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
            border_locked_active = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
        },
    },
    decoration = {
        rounding = 10,
        shadow = { enabled = false },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
    },
})

-- keep the drop-down console on the theme border color even when unfocused
hl.window_rule({
    name = "user_console_border",
    match = { class = "^(console-dropdown)$" },
    border_color = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
})

-- 3-finger horizontal swipe switches workspaces (new Hyprland gesture API)
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- ============================================================
-- Restored animations (from old animations/theme.conf)
-- ============================================================

hl.curve("user_wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("user_winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("user_winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("user_liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "user_wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "user_winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "user_winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "user_wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "user_liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "user_liner", style = "once" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "user_wind" })

hl.on(
    "hyprland.start",
    function()
        hl.exec_cmd("pypr")
    end
)

-- Custom keybinds (ported from keybindings.conf)
hl.bind("SUPER + C", hl.dsp.exec_cmd("cursor"), {
    description = "[Launcher|Apps] text editor",
})
hl.bind("SUPER + h", hl.dsp.exec_cmd("helium-browser"), {
    description = "[Launcher|Apps] helium browser",
})
hl.bind("SUPER + o", hl.dsp.exec_cmd("obsidian"), {
    description = "[Launcher|Apps] obsidian notes",
})
hl.bind("SUPER + m", hl.dsp.exec_cmd("env LD_PRELOAD=/usr/lib/spotify-adblock.so spotify"), {
    description = "[Launcher|Apps] spotify music",
})

-- Custom window rules (deltas not in HyDE's window_rules.lua)
hl.window_rule({
    name = "user_zen_opacity",
    match = { class = "^(zen)$" },
    opacity = "0.9 0.9 1",
})
hl.window_rule({
    name = "user_steam_friends_float",
    match = { title = "^(Friends List)$" },
    float = true,
})
hl.window_rule({
    name = "user_steam_settings_float",
    match = { title = "^(Steam Settings)$" },
    float = true,
})
hl.window_rule({
    name = "user_blender_render",
    match = { initial_title = "^(Image Editor)$", class = "^(blender)$" },
    float = true,
    size = "(monitor_w*0.5) (monitor_h*0.5)",
})

-- idle inhibit (media, spotify, browsers) restored from windowrules.conf
hl.window_rule({ name = "user_idle_inhibit_media", match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ name = "user_idle_inhibit_spotify", match = { class = "^(.*[Ss]potify.*)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({
    name = "user_idle_inhibit_browsers",
    match = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$" },
    idle_inhibit = "fullscreen",
})

-- per-app opacity rules restored from windowrules.conf
local opacity_090_classes = {
    "^(firefox)$", "^(zen)$", "^(brave-browser)$"
}
local opacity_080_classes = {
    "^(code-oss)$", "^([Cc]ode)$", "^(code-url-handler)$", "^(code-insiders-url-handler)$",
    "^(kitty)$", "^(org.kde.dolphin)$", "^(org.kde.ark)$", "^(nwg-look)$",
    "^(qt5ct)$", "^(qt6ct)$", "^(kvantummanager)$",
}
local opacity_080_070_classes = {
    "^(org.pulseaudio.pavucontrol)$", "^(blueman-manager)$", "^(nm-applet)$",
    "^(nm-connection-editor)$", "^(hyprpolkitagent)$",
    "^(org.freedesktop.impl.portal.desktop.gtk)$", "^(org.freedesktop.impl.portal.desktop.hyprland)$",
}
local opacity_070_classes = {
    "^([Ss]team)$", "^(steamwebhelper)$", "^([Ss]potify)$"
}
local opacity_080_flatpak_classes = {
    "^(com.github.tchx84.Flatseal)$", "^(hu.kramo.Cartridges)$", "^(com.obsproject.Studio)$",
    "^(gnome-boxes)$", "^(vesktop)$", "^(discord)$", "^(WebCord)$", "^(ArmCord)$",
    "^(app.drey.Warp)$", "^(net.davidotek.pupgui2)$", "^(yad)$", "^(Signal)$",
    "^(io.github.alainm23.planify)$", "^(io.gitlab.theevilskeleton.Upscaler)$",
    "^(com.github.unrud.VideoDownloader)$", "^(io.gitlab.adhami3310.Impression)$",
    "^(io.missioncenter.MissionCenter)$",
}
for i, cls in ipairs(opacity_090_classes) do
    hl.window_rule({ name = "user_op_c090_" .. i, match = { class = cls }, opacity = "0.90 0.90 1" })
end
for i, cls in ipairs(opacity_080_classes) do
    hl.window_rule({ name = "user_op_c080_" .. i, match = { class = cls }, opacity = "0.80 0.80 1" })
end
for i, cls in ipairs(opacity_080_070_classes) do
    hl.window_rule({ name = "user_op_c08070_" .. i, match = { class = cls }, opacity = "0.80 0.70 1" })
end
for i, cls in ipairs(opacity_070_classes) do
    hl.window_rule({ name = "user_op_c070_" .. i, match = { class = cls }, opacity = "0.70 0.70 1" })
end
for i, cls in ipairs(opacity_080_flatpak_classes) do
    hl.window_rule({ name = "user_op_c080fp_" .. i, match = { class = cls }, opacity = "0.80 0.80" })
end
hl.window_rule({ name = "user_op_clapper", match = { class = "^(com.github.rafostar.Clapper)$" }, opacity = "0.90 0.90" })
hl.window_rule({ name = "user_op_spotify_free", match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ name = "user_op_spotify_premium", match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ name = "user_op_blender", match = { class = "^(blender)$" }, opacity = "1.00 1.00 1" })

-- extra floating rules restored from windowrules.conf (not in new defaults)
local float_classes = {
    "^(Signal)$", "^(com.github.rafostar.Clapper)$", "^(app.drey.Warp)$",
    "^(net.davidotek.pupgui2)$", "^(yad)$", "^(eog)$",
    "^(io.github.alainm23.planify)$", "^(io.gitlab.theevilskeleton.Upscaler)$",
    "^(com.github.unrud.VideoDownloader)$", "^(io.gitlab.adhami3310.Impression)$",
    "^(io.missioncenter.MissionCenter)$",
}
for i, cls in ipairs(float_classes) do
    hl.window_rule({ name = "user_float_" .. i, match = { class = cls }, float = true })
end

-- jetbrains IDE popup flicker workaround restored from windowrules.conf
hl.window_rule({
    name = "user_jetbrains_no_initial_focus",
    match = { class = "^(.*jetbrains.*)$", title = "^(win[0-9]+)$" },
    no_initial_focus = true,
})
