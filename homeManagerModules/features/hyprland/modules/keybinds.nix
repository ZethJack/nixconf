{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options = {
    myHomeManager.hyprland.keybinds = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Hyprland keybindings configuration";
    };
  };

  config = {
    wayland.windowManager.hyprland.settings = let
      mainMod = if (config.osConfig.sharedSettings.altIsSuper or false) then "ALT" else "SUPER";
    in {
      "$mainMod" = mainMod;
      
      # Enable cycling through fullscreen windows
      binds = {
        movefocus_cycles_fullscreen = true;
      };
      
      bind = [
        "$mainMod, return, exec, kitty"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, F, fullscreen,1"
        "$mainMod SHIFT, F, fullscreen,0"
        "$mainMod, G, togglegroup,"
        "$mainMod, bracketleft, changegroupactive, b"
        "$mainMod, bracketright, changegroupactive, f"
        "$mainMod SHIFT, D, exec, wofi --show run"
        "$mainMod, D, exec, rofi -show drun -show-icons"
        "$mainMod, W, exec, brave"
        "$mainMod, P, pin, active"
        "CTRL ALT, P, exec, wofi-pass ~/.local/share/password-store"
        "$mainMod, BACKSPACE, exec, sysact"
        " , PRINT, exec, grimshot copy screen"
        "SHIFT, PRINT, exec, grimslurp"
        "$mainMod, N, exec, kitty -e newsboat"
        "$mainMod, R, exec, kitty -e lf"

        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Window movement
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Workspace switching
        "$mainMod, plus, workspace, 1"
        "$mainMod, ecaron, workspace, 2"
        "$mainMod, scaron, workspace, 3"
        "$mainMod, ccaron, workspace, 4"
        "$mainMod, rcaron, workspace, 5"
        "$mainMod, zcaron, workspace, 6"
        "$mainMod, yacute, workspace, 7"
        "$mainMod, aacute, workspace, 8"
        "$mainMod, iacute, workspace, 9"
        "$mainMod, eacute, workspace, 10"

        # Move to workspace
        "$mainMod SHIFT, plus,   movetoworkspace, 1"
        "$mainMod SHIFT, ecaron, movetoworkspace, 2"
        "$mainMod SHIFT, scaron, movetoworkspace, 3"
        "$mainMod SHIFT, ccaron, movetoworkspace, 4"
        "$mainMod SHIFT, rcaron, movetoworkspace, 5"
        "$mainMod SHIFT, zcaron, movetoworkspace, 6"
        "$mainMod SHIFT, yacute, movetoworkspace, 7"
        "$mainMod SHIFT, aacute, movetoworkspace, 8"
        "$mainMod SHIFT, iacute, movetoworkspace, 9"
        "$mainMod SHIFT, eacute, movetoworkspace, 10"

        # MPD Controls
        "$mainMod, p, exec, mpc toggle"
        ", XF86AudioPlay, exec, mpc toggle"
        "$mainMod SHIFT, p, exec, mpc stop"
        ", XF86AudioStop, exec, mpc stop"
        "$mainMod, comma, exec, mpc prev"
        ", XF86AudioPrev, exec, mpc prev"
        "$mainMod, period, exec, mpc next"
        ", XF86AudioNext, exec, mpc next"
        "$mainMod, m, exec, kitty -e ncmpcpp"
        
        # Additional ncmpcpp controls
        "$mainMod SHIFT, m, exec, kitty -e ncmpc"
        "$mainMod, minus, exec, mpc volume -5"
        "$mainMod, equal, exec, mpc volume +5"
        ", XF86AudioRaiseVolume, exec, mpc volume +5"
        ", XF86AudioLowerVolume, exec, mpc volume -5"
      ];

      binde = [
        # Window movement with arrow keys
        "$mainMod SHIFT, h, moveactive, -20 0"
        "$mainMod SHIFT, l, moveactive, 20 0"
        "$mainMod SHIFT, k, moveactive, 0 -20"
        "$mainMod SHIFT, j, moveactive, 0 20"

        # Window resizing
        "$mainMod CTRL, l, resizeactive, 30 0"
        "$mainMod CTRL, h, resizeactive, -30 0"
        "$mainMod CTRL, k, resizeactive, 0 -10"
        "$mainMod CTRL, j, resizeactive, 0 10"
      ];

      bindm = [
        # Mouse bindings
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
} 