{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      mpd = prev.mpd.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or []) ++ [ prev.pkg-config ];
        mesonFlags = (oldAttrs.mesonFlags or []) ++ [ "-Dio_uring=disabled" ];
      });
    })
  ];
  myHomeManager = {
    bundles.general.enable = true;
    bundles.desktop.enable = true;
    bundles.gaming.enable = true;
    bundles.desktop-full.enable = true;
    hypridle.enable = true;
    evolution.enable = true;
    monero.enable = true;

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
      # Temporarily disabled due to gconf/2to3 build issue
      # (unityhub.override
      #   {
      #     extraLibs = pkgs:
      #       with pkgs; [
      #         openssl
      #       ];
      #   })
    ];
  };
}
