{pkgs, ...}: let
  appinstall = pkgs.writeShellScriptBin "appinstall" ''
        #!/usr/bin/env bash

        # Directory for AppImage files
        APPDIR="$HOME/.local/bin/appimages"
        DESKTOP_DIR="$HOME/.local/share/applications"

        # Create directories if they don't exist
        mkdir -p "$APPDIR"
        mkdir -p "$DESKTOP_DIR"

        # Check if file is provided
        if [ $# -lt 1 ]; then
            echo "Usage: appinstall <path-to-appimage> [name]"
            exit 1
        fi

        APPIMAGE="$1"

        # Check if file exists and is an AppImage
        if [ ! -f "$APPIMAGE" ] || [[ "$APPIMAGE" != *.AppImage ]]; then
            echo "Error: File does not exist or is not an AppImage"
            exit 1
        fi

        # Get name from second argument or from filename
        NAME=''${2:-$(basename "$APPIMAGE" .AppImage)}
        DEST="$APPDIR/$NAME.AppImage"

        # Copy AppImage to destination
        cp "$APPIMAGE" "$DEST"
        chmod +x "$DEST"

        # Create desktop entry
        cat > "$DESKTOP_DIR/$NAME.desktop" << EOF
    [Desktop Entry]
    Name=$NAME
    Exec=appimage-run $DEST
    Type=Application
    Categories=Application;
    Terminal=false
    EOF

        echo "Installation completed successfully:"
        echo "- AppImage installed at: $DEST"
        echo "- Desktop entry: $DESKTOP_DIR/$NAME.desktop"
  '';
in {
  home.packages = with pkgs; [
    appinstall
  ];
}
