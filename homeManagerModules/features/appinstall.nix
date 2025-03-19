{pkgs, ...}: let
  appinstall = pkgs.writeShellScriptBin "appinstall" ''
        #!/usr/bin/env bash

        # Directory for AppImage files
        APPDIR="$HOME/.local/bin/appimages"
        DESKTOP_DIR="$HOME/.local/share/applications"

        # Create directories if they don't exist
        mkdir -p "$APPDIR"
        mkdir -p "$DESKTOP_DIR"

        # Function to show usage
        show_usage() {
            echo "Usage:"
            echo "  appinstall <path-to-appimage> [name]     - Install an AppImage"
            exit 1
        }

        # Function to update desktop entry
        update_desktop_entry() {
            local name="$1"
            local dest="$2"
            cat > "$DESKTOP_DIR/$name.desktop" << EOF
    [Desktop Entry]
    Name=$name
    Exec=appimage-run $dest
    Type=Application
    Categories=Application;
    Terminal=false
    EOF
        }

        # Function to validate AppImage
        validate_appimage() {
            local file="$1"
            if [ ! -f "$file" ] || [[ "$file" != *.AppImage ]]; then
                echo "Error: File '$file' does not exist or is not an AppImage"
                exit 1
            fi
        }

        # Check if any arguments provided
        [ $# -lt 1 ] && show_usage

        # Validate input file
        validate_appimage "$1"
        
        # Get name from second argument or from filename
        NAME=''${2:-$(basename "$1" .AppImage)}
        DEST="$APPDIR/$NAME.AppImage"

        # Copy AppImage to destination
        cp "$1" "$DEST"
        chmod +x "$DEST"

        # Create/update desktop entry
        update_desktop_entry "$NAME" "$DEST"

        echo "Installation completed successfully:"
        echo "- AppImage installed at: $DEST"
        echo "- Desktop entry: $DESKTOP_DIR/$NAME.desktop"
  '';
in {
  home.packages = with pkgs; [
    appinstall
  ];
}
