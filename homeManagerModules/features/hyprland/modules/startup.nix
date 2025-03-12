{
  pkgs,
  config,
  lib,
  ...
}: let
  startScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww-daemon --format xrgb &

    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

    systemctl --user import-environment PATH &
    systemctl --user restart xdg-desktop-portal.service &

    # wait a tiny bit for wallpaper
    sleep 2

    ${pkgs.swww}/bin/swww img ${config.stylix.image} &

    ${config.myHomeManager.startupScript}
  '';
in {
  config.wayland.windowManager.hyprland.settings = {
    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "${pkgs.bash}/bin/bash ${startScript}/bin/start"
      "waybar"
    ];
  };

  config.home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    eww
    swww
    networkmanagerapplet
    rofi-wayland
    wofi
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
  ];
} 