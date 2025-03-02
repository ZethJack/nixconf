{
  pkgs,
  config,
  lib,
  inputs,
  osConfig,
  ...
}: let
  startScript = pkgs.writeShellScriptBin "start" ''
     ${pkgs.swww}/bin/swww-daemon --format xrgb &

     ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

     # hyprctl setcursor Bibata-Original-Amber 12 &

     systemctl --user import-environment PATH &
     systemctl --user restart xdg-desktop-portal.service &

     # wait a tiny bit for wallpaper
     sleep 2

    ${pkgs.swww}/bin/swww img ${config.stylix.image} &

    ${config.myHomeManager.startupScript}
  '';
in {
  imports = [
    ./monitors.nix
  ];

  options = {
    hyprlandExtra = lib.mkOption {
      default = "";
      description = ''
        extra hyprland config lines
      '';
    };
  };

  config = {
    myHomeManager.waybar.enable = lib.mkDefault true;
    myHomeManager.xremap.enable = lib.mkDefault true;

    wayland.windowManager.hyprland = {
      # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      enable = true;
      # enableNvidiaPatches = true;
      settings = {
        general = {
          gaps_in = 1;
          gaps_out = 2;
          border_size = 2;
          # "col.active_border" = "rgba(${config.stylix.base16Scheme.base0E}ff) rgba(${config.stylix.base16Scheme.base09}ff) 60deg";
          # "col.inactive_border" = "rgba(${config.stylix.base16Scheme.base00}ff)";

          layout = "master";
        };

        monitor =
          map
          (
            m: let
              resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = "${toString m.x}x${toString m.y}";
            in "${m.name},${
              if m.enabled
              then "${resolution},${position},1"
              else "disable"
            }"
          )
          (config.myHomeManager.monitors);

        workspace =
          map
          (
            m: "${m.name},${m.workspace}"
          )
          (lib.filter (m: m.enabled && m.workspace != null) config.myHomeManager.monitors);

        env = [
          "XCURSOR_SIZE,12"
          "XCURSOR_THEME,Bibata-Original-Amber"
          "HYPRCURSOR_THEME,Bibata-Original-Amber"
          "HYPRCURSOR_SIZE,12"
          # "GDK_BACKEND,wayland,x11"
          # "SDL_VIDEODRIVER,wayland"
          # "CLUTTER_BACKEND,wayland"
          # "MOZ_ENABLE_WAYLAND,1"
          # "MOZ_DISABLE_RDD_SANDBOX,1"
          # "_JAVA_AWT_WM_NONREPARENTING=1"
          # "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          # "QT_QPA_PLATFORM,wayland"
          # "LIBVA_DRIVER_NAME,nvidia"
          # "GBM_BACKEND,nvidia-drm"
          # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          # "WLR_NO_HARDWARE_CURSORS,1"
          # "__NV_PRIME_RENDER_OFFLOAD,1"
          # "__VK_LAYER_NV_optimus,NVIDIA_only"
          # "PROTON_ENABLE_NGX_UPDATER,1"
          # "NVD_BACKEND,direct"
          # "__GL_GSYNC_ALLOWED,1"
          # "__GL_VRR_ALLOWED,1"
          # "WLR_DRM_NO_ATOMIC,1"
          # "WLR_USE_LIBINPUT,1"
          # "XWAYLAND_NO_GLAMOR,1"
          # "__GL_MaxFramesAllowed,1"
          # "WLR_RENDERER_ALLOW_SOFTWARE,1"
        ];

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

          sensitivity = 1.2; # -1.0 - 1.0, 0 means no modification.
        };

        misc = {
          enable_swallow = true;
          force_default_wallpaper = 0;

          # swallow_regex = "^(Alacritty|wezterm)$";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 0;
          shadow = {
            enabled = false;
            range = 30;
            render_power = 3;
          };
        };

        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            # "workspaces, 1, 3, default, slidevert"
            # "workspaces, 1, 3, myBezier, slidefadevert"
            "workspaces, 1, 3, myBezier, fade"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
          # soon :)
          # orientation = "center";
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false;
        };

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        # "device:logitech-g102-lightsync-gaming-mouse" = {
        # sensitivity = 0;
        # };

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        "$mainMod" =
          if (osConfig.sharedSettings.altIsSuper or false)
          then "ALT"
          else "SUPER";

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
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

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"

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

          # Scroll through existing workspaces with mainMod + scroll
          "bind = $mainMod, mouse_down, workspace, e+1"
          "bind = $mainMod, mouse_up, workspace, e-1"
        ];
        # ++ map (n: "$mainMod SHIFT, ${toString n}, movetoworkspace, ${toString (
        #   if n == 0
        #   then 10
        #   else n
        # )}") [1 2 3 4 5 6 7 8 9 0]
        # ++ map (n: "$mainMod, ${toString n}, workspace, ${toString (
        #   if n == 0
        #   then 10
        #   else n
        # )}") [1 2 3 4 5 6 7 8 9 0];

        binde = [
          "$mainMod SHIFT, h, moveactive, -20 0"
          "$mainMod SHIFT, l, moveactive, 20 0"
          "$mainMod SHIFT, k, moveactive, 0 -20"
          "$mainMod SHIFT, j, moveactive, 0 20"

          "$mainMod CTRL, l, resizeactive, 30 0"
          "$mainMod CTRL, h, resizeactive, -30 0"
          "$mainMod CTRL, k, resizeactive, 0 -10"
          "$mainMod CTRL, j, resizeactive, 0 10"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # league of legends fixes
        windowrulev2 = [
          "float,class:^(leagueclientux.exe)$,title:^(League of Legends)$"
          "tile,class:^(league of legends.exe)$,title:^(League of Legends (TM) Client)$ windowrule = size 1920 1080,^(league of legends.exe)$"
        ];

        windowrule = [
          "size 1600 900,^(leagueclientux.exe)$"
          "center,^(leagueclientux.exe)$"
          "center,^(league of legends.exe)$"
          "allowsinput,^(league of legends.exe)$"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "${pkgs.bash}/bin/bash ${startScript}/bin/start"
          "waybar"
        ];
      };
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard

      eww
      swww

      networkmanagerapplet

      rofi-wayland
      wofi

      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
    ];
  };
}
