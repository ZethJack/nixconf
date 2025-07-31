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
    myHomeManager.mpd.enable = lib.mkDefault true;  # Re-enabled with alternative clients (ncmpc, mpc, miniplayer)
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

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Documents
        "application/pdf" = ["zathura.desktop"];
        "application/postscript" = ["zathura.desktop"];
        "application/x-dvi" = ["zathura.desktop"];
        
        # Images - use dedicated viewers
        "image/*" = ["imv.desktop"];
        "image/png" = ["imv.desktop"];
        "image/jpeg" = ["imv.desktop"];
        "image/jpg" = ["imv.desktop"];
        "image/gif" = ["imv.desktop"];
        "image/bmp" = ["imv.desktop"];
        "image/tiff" = ["imv.desktop"];
        "image/webp" = ["imv.desktop"];
        "image/svg+xml" = ["imv.desktop"];
        
        # Videos
        "video/*" = ["mpv.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "video/avi" = ["mpv.desktop"];
        "video/mkv" = ["mpv.desktop"];
        "video/webm" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "video/x-msvideo" = ["mpv.desktop"];
        "video/quicktime" = ["mpv.desktop"];
        
        # Audio
        "audio/*" = ["ncmpc.desktop"];
        "audio/mpeg" = ["ncmpc.desktop"];
        "audio/mp3" = ["ncmpc.desktop"];
        "audio/ogg" = ["ncmpc.desktop"];
        "audio/wav" = ["ncmpc.desktop"];
        "audio/flac" = ["ncmpc.desktop"];
        
        # Text files
        "text/plain" = ["helix.desktop"];
        "text/markdown" = ["helix.desktop"];
        "text/x-markdown" = ["helix.desktop"];
        "text/xml" = ["helix.desktop"];
        "text/html" = ["helix.desktop"];
        "text/css" = ["helix.desktop"];
        "text/javascript" = ["helix.desktop"];
        "application/json" = ["helix.desktop"];
        
        # Archives
        "application/zip" = ["org.gnome.Engrampa.desktop"];
        "application/x-rar" = ["org.gnome.Engrampa.desktop"];
        "application/x-7z-compressed" = ["org.gnome.Engrampa.desktop"];
        "application/x-tar" = ["org.gnome.Engrampa.desktop"];
        "application/gzip" = ["org.gnome.Engrampa.desktop"];
        "application/x-bzip2" = ["org.gnome.Engrampa.desktop"];
        "application/x-xz" = ["org.gnome.Engrampa.desktop"];
        
        # Office documents
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["libreoffice-writer.desktop"];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["libreoffice-calc.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["libreoffice-impress.desktop"];
        "application/vnd.oasis.opendocument.text" = ["libreoffice-writer.desktop"];
        "application/vnd.oasis.opendocument.spreadsheet" = ["libreoffice-calc.desktop"];
        "application/vnd.oasis.opendocument.presentation" = ["libreoffice-impress.desktop"];
        "application/msword" = ["libreoffice-writer.desktop"];
        "application/vnd.ms-excel" = ["libreoffice-calc.desktop"];
        "application/vnd.ms-powerpoint" = ["libreoffice-impress.desktop"];
        
        # URLs - keep browser for these
        "x-scheme-handler/http" = ["chromium.desktop"];
        "x-scheme-handler/https" = ["chromium.desktop"];
        "x-scheme-handler/ftp" = ["chromium.desktop"];
        "x-scheme-handler/mailto" = ["evolution.desktop"];
      };
      
      # Remove browser associations for file types that should use dedicated apps
      associations.removed = {
        # Remove browser from image types
        "image/*" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/png" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/jpeg" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/jpg" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/gif" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/bmp" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/tiff" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/webp" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "image/svg+xml" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        
        # Remove browser from video types
        "video/*" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/mp4" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/avi" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/mkv" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/webm" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/x-matroska" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/x-msvideo" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "video/quicktime" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        
        # Remove browser from audio types
        "audio/*" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "audio/mpeg" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "audio/mp3" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "audio/ogg" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "audio/wav" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "audio/flac" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        
        # Remove browser from document types
        "application/pdf" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/postscript" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-dvi" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        
        # Remove browser from text types (except HTML)
        "text/plain" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "text/markdown" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "text/x-markdown" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "text/xml" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "text/css" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "text/javascript" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/json" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        
        # Remove browser from archive types
        "application/zip" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-rar" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-7z-compressed" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-tar" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/gzip" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-bzip2" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
        "application/x-xz" = ["chromium.desktop" "firefox.desktop" "google-chrome.desktop"];
      };
    };

    services.mako = {
      enable = true;
      settings = {
        border-radius = 5;
        border-size = 2;
        default-timeout = 10000;
        layer = "overlay";
      };
    };

    home.packages = with pkgs; [
      adwaita-qt
      bash-language-server
      cargo
      clang-tools
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
      libsForQt5.qt5ct
      libxml2
      lm_sensors
      lxsession
      meld
      mpv
      ncdu
      neovide
      newsboat
      nodePackages.yaml-language-server
      noisetorch
      papirus-icon-theme
      pavucontrol
      pcmanfm
      polkit
      polkit_gnome
      pulsemixer
      pv
      pywal
      qbittorrent
      qpwgraph
      qtox
      ripdrag
      ripgrep
      rofi-wayland
      rpi-imager
      shellharden
      sxiv
      upower
      virt-manager
      wezterm
      zathura
    ];
  };
}
