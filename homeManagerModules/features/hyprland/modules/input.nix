{
  lib,
  config,
  pkgs,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "cz";
      kb_variant = "";
      kb_model = "";
      kb_options = "menu:super";
      kb_rules = "";
      numlock_by_default = true;

      follow_mouse = 1;

      touchpad = {
        natural_scroll = false;
        scroll_factor = 0.1;
      };

      repeat_rate = 40;
      repeat_delay = 250;
      force_no_accel = true;
      sensitivity = 1.2;
    };

    env = [
      "XCURSOR_SIZE,12"
      "XCURSOR_THEME,Bibata-Original-Amber"
      "HYPRCURSOR_THEME,Bibata-Original-Amber"
      "HYPRCURSOR_SIZE,12"
    ];
  };
} 