{
  pkgs,
  config,
  lib,
  inputs,
  osConfig,
  ...
}: {
  imports = [
    ./monitors.nix
    ./modules/keybinds.nix
    ./modules/window-rules.nix
    ./modules/appearance.nix
    ./modules/input.nix
    ./modules/startup.nix
  ];

  options = {
    hyprlandExtra = lib.mkOption {
      default = "";
      description = "extra hyprland config lines";
    };
  };

  config = {
    myHomeManager.waybar.enable = lib.mkDefault true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = map
          (m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},1"
            else "disable"
          }")
          (config.myHomeManager.monitors);

        workspace = map
          (m: "${m.name},${m.workspace}")
          (lib.filter (m: m.enabled && m.workspace != null) config.myHomeManager.monitors);

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        gestures = {
          workspace_swipe = false;
        };
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
