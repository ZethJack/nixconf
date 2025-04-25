{
  pkgs,
  config,
  lib,
  ...
}: {
  # Enable Trezor daemon and udev rules
  services.trezord.enable = true;

  # Add udev rules for hardware wallets
  services.udev.packages = with pkgs; [
    trezor-udev-rules
    ledger-udev-rules  # Adding Ledger support as well for completeness
  ];

  # Install Trezor Suite
  environment.systemPackages = with pkgs; [
    trezor-suite
  ];
} 