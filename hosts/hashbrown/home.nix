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

  # Explicitly disable swaylock and prevent it from being enabled elsewhere
  programs.swaylock = {
    enable = lib.mkForce false;
    package = lib.mkForce null;
    settings = lib.mkForce {};
  };

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
              openssl
            ];
        })
    ];
  };
}
