-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1200 monitors, with the right monitor as primary
Config {
    font = "xft:Inconsolata-12",
    bgColor = "#000000",
    fgColor = "grey",
    position = Static { xpos = 1920, ypos = 0, width = 1200, height = 16 },
    lowerOnStart = True,
    commands = [
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
      , Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
      , Run Network "enp2s0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
      , Run Date "%a %b %_d %l:%M" "date" 10
      , Run MPD ["-t", "<state>: <artist> - <title>"] 10
      , Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %mpd% %memory%   %swap%   %enp2s0%  <fc=#FFFFCC>%date%</fc>"
}
