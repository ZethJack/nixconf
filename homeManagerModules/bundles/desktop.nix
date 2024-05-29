{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {

  options = {
    myHomeManager.startupScript = lib.mkOption {
      default = "";
      description = ''
        Startup script
      '';
    };
  };

  config = {
    myHomeManager.zathura.enable = lib.mkDefault true;
    myHomeManager.rofi.enable = lib.mkDefault true;
    myHomeManager.alacritty.enable = lib.mkDefault true;
    myHomeManager.kitty.enable = lib.mkDefault true;
    myHomeManager.xremap.enable = lib.mkDefault true;
    myHomeManager.helix.enable = lib.mkDefault true;
    myHomeManager.sysact.enable = lib.mkDefault true;
    myHomeManager.grimslurp.enable = lib.mkDefault true;

    myHomeManager.gtk.enable = lib.mkDefault true;

    home.file = {
      ".local/share/rofi/rofi-bluetooth".source = "${pkgs.rofi-bluetooth}";

      ".local/share/wal-telegram".source = builtins.fetchGit {
        url = "https://github.com/guillaumeboehm/wal-telegram";
        rev = "47e1a18f6d60d08ebaabbbac4b133a6158bacadd";
      };
    };

    qt.enable = true;
    qt.platformTheme = "gtk";
    qt.style.name = "adwaita-dark";

    home.sessionVariables = {
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

    services.udiskie.enable = true;

    xdg.mimeApps.defaultApplications = {
      "text/plain" = ["neovide.desktop"];
      "application/pdf" = ["zathura.desktop"];
      "image/*" = ["imv.desktop"];
      "video/png" = ["mpv.desktop"];
      "video/jpg" = ["mpv.desktop"];
      "video/*" = ["mpv.desktop"];
    };

    programs.imv = {
      enable = true;
      settings = {
        options.background = "${config.colorScheme.palette.base00}";
      };
    };

    services.mako = {
      enable = true;
      backgroundColor = "#${config.colorScheme.palette.base01}";
      borderColor = "#${config.colorScheme.palette.base0E}";
      borderRadius = 5;
      borderSize = 2;
      textColor = "#${config.colorScheme.palette.base04}";
      defaultTimeout = 10000;
      layer = "overlay";
    };

    home.packages = with pkgs; [
      feh
      noisetorch
      polkit
      polkit_gnome
      lxsession
      pulsemixer
      pavucontrol
      adwaita-qt
      pcmanfm
      element-desktop
      libnotify
      qtox

      pywal
      neovide
      ripdrag
      mpv
      sxiv
      zathura

      lm_sensors
      upower

      cm_unicode

      virt-manager

      wezterm
      kitty

      libreoffice-fresh
      easyeffects
      gegl
    ];

    myHomeManager.impermanence.directories = [
      ".local/state/wireplumber"
    ];
  };
}
