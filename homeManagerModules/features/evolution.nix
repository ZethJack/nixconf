{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    evolution
    evolution-ews  # For Exchange support
    evolution-data-server
  ];

  # Enable GNOME keyring for password management
  services.gnome-keyring.enable = true;
} 