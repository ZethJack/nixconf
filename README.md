## Zeth's fork of Goxore's nixconf

This is an attempt to adapt vimjoyer's (aka Goxore, aka Yurii) to my current existing hardware while introducing some changes to fit my personal preferences. It serves me both as a way to learn new approach to managing nixOS configuration but also, should probably serve as an example of how not to do things.

# DISCLAIMER!

It is very much a work in progress experiment and might or might not get deleted or replaced without notice.
Changes that were introduced so far are very opinionated and might break the currently established processes.


## Changes I've introduced so far
  - Introduced new host configuration - **potatOS** for my lenovo thinkpad X220.
  - adjusted locales to cs_CZ-UTF-8 and modified keyboard layout accordingly
  - replaced SDDM display manager with TUI-based greetd as SDDM has tendency to break in some occasions. This however introduced new issues - namely when trying to "logout" out of hyprland session
  - added and removed some programs to suit personal preferences
  - tried to implement PASS as password manager - ~while it works within terminal, trying to call wofi-pass from wayland doesn't work yet.~ seems to work thanks to environment.sessionVariavbles

## TODO
 - [ ] replace nix-colors with stylix - refer to upstream fork
 - [ ] add configs for newsboat - needs yt-dlp, ffmpeg and mpv so I can download vids, convert to audio and store as podcasts 
 - [ ] add email client - preferably neomutt, but I am open to alternatives depending on how annoying it will be to configure

   - [ ] look into niceboy microphone support, maybe try different distro to verify - for some reason I get no input what so ever
 - [ ] add music player - mpv and ncmpcpp

## DONE
 - [x] add script for handling screenshots
 - [x] implement sysact script - a dmenu-based utility to manage logout, screenlocking, shutdown and reboot and bind it on hyprland
 - [x] add lockscreen and automatic "idle" routine that locks screen on laptop (hyprlock and hypridle)
