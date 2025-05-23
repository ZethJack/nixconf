{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 2;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = lib.mkForce [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = lib.mkForce [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            shadow_passes = 2;
          }
        ];
        label = [
          {
            # clock
            text = "$TIME";
            color = "rgb(202, 211, 245)";
            font_size = 65;
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };

  # Explicitly disable swaylock
  programs.swaylock = {
    enable = lib.mkForce false;
    settings = lib.mkForce {};
  };
}
