{
  pkgs,
  config,
  lib,
  ...
}: {
  options.myHomeManager.features.archive-manager.enable = lib.mkEnableOption "enable archive manager configuration";

  config = lib.mkIf config.myHomeManager.features.archive-manager.enable {
    home.packages = with pkgs; [
      # GUI Archive Manager
      engrampa
      
      # Additional archive tools
      atool        # Archive manipulation tool
      unrar        # RAR archive support
      unzip        # ZIP archive support
      zip          # ZIP archive creation
      p7zip        # 7z archive support
      xarchiver    # Alternative GUI archive manager
      ark          # KDE's archive manager (alternative)
    ];

    # Configure default applications for archive types
    xdg.mimeApps.defaultApplications = {
      "application/x-7z-compressed" = ["org.gnome.Engrampa.desktop"];
      "application/x-rar" = ["org.gnome.Engrampa.desktop"];
      "application/x-tar" = ["org.gnome.Engrampa.desktop"];
      "application/zip" = ["org.gnome.Engrampa.desktop"];
      "application/x-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-bzip-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-xz-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-lzma-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-lzip-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-lzop-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-lrzip-compressed-tar" = ["org.gnome.Engrampa.desktop"];
      "application/x-zstd-compressed-tar" = ["org.gnome.Engrampa.desktop"];
    };
  };
} 