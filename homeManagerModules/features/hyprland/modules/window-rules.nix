{
  lib,
  config,
  pkgs,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = {
    # First define workspace 3 to be always fullscreen
    workspace = [
      "3,rounding:false,bordersize:0"
    ];

    windowrulev2 = [
      # Workspace assignments with verified class names
      "workspace 2 silent,class:^(Brave-browser)$"
      "workspace 3 silent,class:^(vesktop)$"
      "workspace 3 silent,class:^(io.github.qtox.qTox)$"
      "workspace 3 silent,class:^(Element)$"
      
      # Force fullscreen for any window on workspace 3
      "fullscreenstate 2 2,workspace:3"
    ];
  };
} 