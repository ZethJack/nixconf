{
  pkgs,
  lib,
  ...
}: {
  myHomeManager.bundles.desktop.enable = lib.mkDefault true;

  myHomeManager.chromium.enable = lib.mkDefault true;
  myHomeManager.gimp.enable = lib.mkDefault true;
  myHomeManager.krita.enable = lib.mkDefault true;
  myHomeManager.vesktop.enable = lib.mkDefault true;
  myHomeManager.telegram.enable = lib.mkDefault true;
  myHomeManager.inkscape.enable = lib.mkDefault true;
  myHomeManager.features.archive-manager.enable = lib.mkDefault true;

  home.packages = with pkgs; [
    youtube-music
    tdesktop
  ];
}
