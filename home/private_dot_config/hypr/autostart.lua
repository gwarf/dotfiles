-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Shadow packaged omarchy-* commands with ~/.local/bin/omarchy-overrides
-- (omarchy-agent launches daryl). Hyprland's env is imported into the
-- systemd user manager at login, so the shell and crash-watch inherit it.
-- Strip earlier occurrences first: every reload re-evaluates this against
-- Hyprland's already-modified env, otherwise the entry duplicates.
local overrides_dir = (os.getenv("HOME") or "") .. "/.local/bin/omarchy-overrides"
local path_entries = {}
for entry in (os.getenv("PATH") or "/usr/local/bin:/usr/bin"):gmatch("[^:]+") do
  if entry ~= overrides_dir then table.insert(path_entries, entry) end
end
table.insert(path_entries, 1, overrides_dir)
hl.env("PATH", table.concat(path_entries, ":"))

o.launch_on_start("obsidian")
o.launch_on_start("ghostty")
o.launch_on_start("firefox")
