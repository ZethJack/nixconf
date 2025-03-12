{
  lib,
  config,
  pkgs,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 1;
      gaps_out = 2;
      border_size = 2;
      layout = "master";
    };

    decoration = {
      rounding = 0;
      shadow = {
        enabled = false;
        range = 30;
        render_power = 3;
      };
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 3, myBezier, fade"
      ];
    };

    misc = {
      enable_swallow = true;
      force_default_wallpaper = 0;
    };
  };
} 