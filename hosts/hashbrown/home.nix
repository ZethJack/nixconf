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

    firefox.enable = true;
    hyprland.enable = true;

    monitors = [
      {
        name = "DP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60.0;
        x = 0;
        y = 0;
      }
    ];
  };

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    stateVersion = "22.11";
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
              openssl_1_1
            ];
        })
    ];
  };
}
