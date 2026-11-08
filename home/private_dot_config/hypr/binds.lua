-- The single bind table: each row is keys, description, a Lua dispatcher
-- expression, optional bind options. The rows also land in a TSV that the
-- SUPER+K menu reads and replays with `hyprctl dispatch <expression>`.

local function run(cmd) return string.format("hl.dsp.exec_cmd(%q)", cmd) end
local function app(cmd) return run("uwsm app -- " .. cmd) end

local binds = {
    { "SUPER + RETURN", "Terminal", app("ghostty") },
    { "SUPER + SHIFT + RETURN", "Browser", app("firefox") },
    { "SUPER + SHIFT + F", "File manager", app("nautilus") },
    { "SUPER + SPACE", "Launcher", run("rofi -show drun") },
    { "SUPER + K", "Keybindings", run("hypr-keybindings-menu") },
    { "SUPER + ESCAPE", "Power menu", run("hypr-power-menu") },
    { "SUPER + SHIFT + CTRL + A", "Daryl", app("ghostty -e daryl") },

    { "SUPER + W", "Close window", "hl.dsp.window.close()" },
    { "SUPER + F", "Fullscreen", 'hl.dsp.window.fullscreen({ mode = "fullscreen" })' },
    { "SUPER + T", "Toggle floating", 'hl.dsp.window.float({ action = "toggle" })' },
    { "SUPER + J", "Toggle split", 'hl.dsp.layout("togglesplit")' },
    { "SUPER + P", "Pseudo tile", "hl.dsp.window.pseudo()" },
    { "SUPER + G", "Toggle group", "hl.dsp.group.toggle()" },
    { "ALT + TAB", "Next window", 'hl.dsp.window.cycle_next()' },
    { "SUPER + MINUS", "Shrink width", 'hl.dsp.window.resize({ x = -100, y = 0, relative = true })' },
    { "SUPER + EQUAL", "Grow width", 'hl.dsp.window.resize({ x = 100, y = 0, relative = true })' },
    { "SUPER + mouse:272", "Drag window", "hl.dsp.window.drag()", { mouse = true } },
    { "SUPER + mouse:273", "Resize window", "hl.dsp.window.resize()", { mouse = true } },

    { "SUPER + TAB", "Next workspace", 'hl.dsp.focus({ workspace = "e+1" })' },
    { "SUPER + SHIFT + TAB", "Previous workspace", 'hl.dsp.focus({ workspace = "e-1" })' },
    { "SUPER + mouse_down", "Next workspace", 'hl.dsp.focus({ workspace = "e+1" })' },
    { "SUPER + mouse_up", "Previous workspace", 'hl.dsp.focus({ workspace = "e-1" })' },
    { "SUPER + S", "Scratchpad", 'hl.dsp.workspace.toggle_special("magic")' },
    { "SUPER + SHIFT + S", "Send to scratchpad", 'hl.dsp.window.move({ workspace = "special:magic" })' },

    { "Print", "Screenshot region", run([[grim -g "$(slurp)" - | satty --filename -]]) },
    { "SHIFT + Print", "Screenshot screen", run("grim - | satty --filename -") },
    { "SUPER + Print", "Colour picker", run("hyprpicker -a") },
    { "SUPER + CTRL + V", "Clipboard history", run("cliphist list | rofi -dmenu -p clipboard | cliphist decode | wl-copy") },
    { "SUPER + CTRL + L", "Lock", run("loginctl lock-session") },
    { "SUPER + COMMA", "Dismiss notification", run("swaync-client --hide-latest") },
    { "SUPER + SHIFT + COMMA", "Notification centre", run("swaync-client -t") },
    { "SUPER + SHIFT + R", "Reload Hyprland", run("hyprctl reload") },

    { "XF86AudioRaiseVolume", "Volume up", run("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true } },
    { "XF86AudioLowerVolume", "Volume down", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true } },
    { "XF86AudioMute", "Mute", run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") },
    { "XF86AudioMicMute", "Mute microphone", run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") },
    { "XF86AudioPlay", "Play/pause", run("playerctl play-pause") },
    { "XF86AudioPause", "Play/pause", run("playerctl play-pause") },
    { "XF86AudioNext", "Next track", run("playerctl next") },
    { "XF86AudioPrev", "Previous track", run("playerctl previous") },

    -- Kinesis Adv360 inner key next to G.
    { "CTRL + ALT + SHIFT + Home", "Toggle Shield music", run("shield-music-toggle") },
}

for _, a in ipairs({ { "left", "l" }, { "right", "r" }, { "up", "u" }, { "down", "d" } }) do
    table.insert(binds, { "SUPER + " .. a[1], "Focus " .. a[1], string.format("hl.dsp.focus({ direction = %q })", a[2]) })
    table.insert(binds, { "SUPER + SHIFT + " .. a[1], "Swap " .. a[1], string.format("hl.dsp.window.swap({ direction = %q })", a[2]) })
end
for i = 1, 10 do
    local key = tostring(i % 10)
    table.insert(binds, { "SUPER + " .. key, "Workspace " .. i, string.format("hl.dsp.focus({ workspace = %d })", i) })
    table.insert(binds, { "SUPER + SHIFT + " .. key, "Move to workspace " .. i, string.format("hl.dsp.window.move({ workspace = %d })", i) })
end

local menu = {}
for _, b in ipairs(binds) do
    local dispatcher = assert(load("return " .. b[3]))()
    local opts = b[4] or {}
    opts.description = b[2]
    hl.bind(b[1], dispatcher, opts)
    if not opts.mouse then
        table.insert(menu, b[1] .. "\t" .. b[2] .. "\t" .. b[3])
    end
end

-- Push-to-talk on the Kinesis left-thumb inner key. The release half ignores
-- modifiers and passes the key through, so it still fires after typing mid-hold.
local held = false
hl.bind("CTRL + ALT + SHIFT + End", function() held = true; hl.exec_cmd("voxtype record start") end,
    { description = "Start dictation (push-to-talk)" })
hl.bind("CTRL + ALT + SHIFT + End", function() if held then held = false; hl.exec_cmd("voxtype record stop") end end,
    { description = "Stop dictation (push-to-talk)", release = true, transparent = true, ignore_mods = true, non_consuming = true })

local dir = os.getenv("XDG_RUNTIME_DIR")
if dir then
    local f = io.open(dir .. "/hypr-binds.tsv", "w")
    if f then
        f:write(table.concat(menu, "\n"), "\n")
        f:close()
    end
end
