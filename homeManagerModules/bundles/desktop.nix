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
    # myHomeManager.rofi.enable = lib.mkDefault true;
    myHomeManager.alacritty.enable = lib.mkDefault true;
    myHomeManager.kitty.enable = lib.mkDefault true;
    # myHomeManager.xremap.enable = lib.mkDefault true;
    myHomeManager.helix.enable = lib.mkDefault true;
    myHomeManager.sysact.enable = lib.mkDefault true;
    myHomeManager.grimslurp.enable = lib.mkDefault true;
    myHomeManager.linkhandler.enable = lib.mkDefault true;
    myHomeManager.mpv.enable = lib.mkDefault true;
    myHomeManager.ddw.enable = lib.mkDefault true;
    myHomeManager.appinstall.enable = lib.mkDefault true;

    home.file = {
      ".local/share/rofi/rofi-bluetooth".source = "${pkgs.rofi-bluetooth}";
    };

    qt.enable = true;
    # qt.platformTheme.name = "gtk";
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    services.udiskie.enable = true;

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = ["zathura.desktop"];
      "image/*" = ["imv.desktop"];
      "video/png" = ["mpv.desktop"];
      "video/jpg" = ["mpv.desktop"];
      "video/*" = ["mpv.desktop"];
    };

    services.mako = {
      enable = true;
      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 10000;
      layer = "overlay";
    };

    home.packages = with pkgs; [
      adwaita-qt
      bash-language-server
      cargo
      cm_unicode
      easyeffects
      element-desktop
      fd
      feh
      gcc
      gegl
      kitty
      lemminx
      libnotify
      libreoffice-fresh
      libxml2
      lm_sensors
      lxsession
      meld
      mpv
      neovide
      newsboat
      nodePackages.yaml-language-server
      noisetorch
      pavucontrol
      papirus-icon-theme
      pcmanfm
      polkit
      polkit_gnome
      pulsemixer
      pv
      pywal
      qbittorrent
      qpwgraph
      qtox
      libsForQt5.qt5ct
      qutebrowser
      ripdrag
      ripgrep
      rofi-wayland
      rpi-imager
      sxiv
      upower
      virt-manager
      wezterm
      zathura
    ];
  };
}
