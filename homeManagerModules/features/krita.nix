{pkgs, ...}: {
  home.packages = with pkgs; [
    krita
  ];

  # Configure Krita as default for supported image formats
  xdg.mimeApps.defaultApplications = {
    # Krita's native format
    "application/x-krita" = ["org.kde.krita.desktop"];
    
    # Common image formats that Krita handles well
    "image/x-krita" = ["org.kde.krita.desktop"];
    "image/x-portable-bitmap" = ["org.kde.krita.desktop"];
    "image/x-portable-graymap" = ["org.kde.krita.desktop"];
    "image/x-portable-pixmap" = ["org.kde.krita.desktop"];
  };
} 