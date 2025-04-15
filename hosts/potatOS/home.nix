{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  myHomeManager = {
    bundles.general.enable = true;
    bundles.desktop.enable = true;
    bundles.gaming.enable = true;
    bundles.desktop-full.enable = true;
    hypridle.enable = true;
    evolution.enable = true;

    hyprland.enable = true;

    monitors = [
      {
        name = "DP-1";
        width = 1366;
        height = 768;
        refreshRate = 60.0;
        x = 0;
        y = 0;
      }
    ];
  };

  home = {
    stateVersion = "24.11";
    homeDirectory = lib.mkDefault "/home/zeth";
    username = "zeth";

    packages = with pkgs; [
      bottles
      libimobiledevice
      ifuse
      (unityhub.override
        {
          extraLibs = pkgs:
            with pkgs; [
              openssl
            ];
        })
    ];
  };
}
