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

    myHomeManager.gtk.enable = lib.mkDefault true;

    home.file = {
      ".local/share/rofi/rofi-bluetooth".source = "${pkgs.rofi-bluetooth}";

      ".local/share/wal-telegram".source = builtins.fetchGit {
        url = "https://github.com/guillaumeboehm/wal-telegram";
        rev = "47e1a18f6d60d08ebaabbbac4b133a6158bacadd";
      };
    };

    qt.enable = true;
    qt.platformTheme.name = "gtk";
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
        options.background = "${config.stylix.base16Scheme.base00}";
      };
    };

    services.mako = {
      enable = true;
      # backgroundColor = "#${config.stylix.base16Scheme.base01}";
      # borderColor = "#${config.stylix.base16Scheme.base0E}";
      borderRadius = 5;
      borderSize = 2;
      # textColor = "#${config.stylix.base16Scheme.base04}";
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
      qpwgraph
      qutebrowser
      rpi-imager
      rofi-wayland

      pywal
      neovide
      ripdrag
      mpv
      sxiv
      zathura
      newsboat
      pv

      lm_sensors
      upower

      cm_unicode

      virt-manager

      wezterm
      kitty

      libreoffice-fresh
      easyeffects
      gegl
      gcc
      ripgrep
      fd
      cargo
    ];

    myHomeManager.impermanence.cache.directories = [
      ".local/state/wireplumber"
    ];
  };
}
