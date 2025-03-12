{
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    lutris
    steam
    steam-run
    protonup-ng
    gamemode
    dxvk
    gamescope
    mangohud
    r2modman
    heroic
    er-patcher
    bottles
    steamtinkerlaunch
    protonup-qt
    goverlay
  ];
}
