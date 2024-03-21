## Zeth's fork of Goxore's nixconf

This is an attempt to adapt vimjoyer's (aka Goxore, aka Yurii) to my current existing hardware while introducing some changes to fit my personal preferences. It serves me both as a way to learn new approach to managing nixOS configuration but also, should probably serve as an example of how not to do things.

# DISCLAIMER!

It is very much a work in progress experiment and might or might not get deleted or replaced without notice.
Changes that were introduced so far are very opinionated and might break the currently established processes.


## Changes I've introduced so far
  - Introduced new host configuration - **hasbrown** for my desktop and **potatOS** for my lenovo thinkpad X220 - the laptop hadn't been migrated to nixOS yet so that folder is empty.
  - adjusted locales to cs_CZ-UTF-8 and modified keyboard layout accordingly
  - replaced SDDM display manager with TUI-based greetd as SDDM has tendency to break in some occasions. This however introduced new issues - namely when trying to "logout" out of hyprland session
  - added and removed some programs
  - tried to implement PASS as password manager - while it works within terminal, trying to call wofi-pass from wayland doesn't work yet.

