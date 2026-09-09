-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- 1 because the compositor now does the scaling. Omarchy defaults this to 2 for
-- HiDPI panels where auto-scale also lands on 2; on a 1x output the two
-- multiply instead of matching, and GTK apps come out twice too big.
local omarchy_gdk_scale = 1
-- 3440x1440 only divides cleanly by 1.25, 1.6 and 2. Anything else leaves a
-- fractional remainder and Hyprland rejects or snaps it.
local omarchy_monitor_scale = 1.25

-- Omarchy scales GTK but leaves Qt at 96 DPI, so Qt apps render smaller than
-- everything else. 120 is 1.25x text without touching layout or icon sizes.
local qt_font_dpi = 120

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.env("QT_FONT_DPI", tostring(qt_font_dpi))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
