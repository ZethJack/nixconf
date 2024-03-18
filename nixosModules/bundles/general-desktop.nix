{
  pkgs,
  lib,
  ...
}: {
  # myNixOS.sddm.enable = lib.mkDefault true;
  myNixOS.xremap-user.enable = lib.mkDefault true;
  myNixOS.system-controller.enable = lib.mkDefault false;
  myNixOS.virtualisation.enable = lib.mkDefault true;

  # Central European time zone
  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  fonts.packages = with pkgs; [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
    cm_unicode
    corefonts
  ];

  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
      sansSerif = ["JetBrainsMono Nerd Font"];
      serif = ["JetBrainsMono Nerd Font"];
    };
  };

  # battery
  services.upower.enable = true;
}
