{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.evolution = {
    enable = true;
    plugins = with pkgs; [
      evolution-ews  # For Exchange support
      evolution-data-server
    ];
  };

  # Enable GNOME keyring for password management
  services.gnome-keyring.enable = true;
} 