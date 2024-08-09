{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    # base16Scheme = {
    #  base00 = "272822"; # ----
    #  base01 = "f92672"; # ---
    #  base02 = "a6e22e"; # --
    #  base03 = "f4bf75"; # -
    #  base04 = "66d9ef"; # +
    #  base05 = "d5c4a1"; # ++
    #  base06 = "ebdbb2"; # +++
    #  base07 = "fbf1c7"; # ++++
    #  base08 = "fb4934"; # red
    #  base09 = "fe8019"; # orange
    #  base0A = "fabd2f"; # yellow
    #  base0B = "b8bb26"; # green
    #  base0C = "8ec07c"; # aqua/cyan
    #  base0D = "7daea3"; # blue
    #  base0E = "e089a1"; # purple
    #  base0F = "f28534"; # brown
    # };
    base16Scheme = {
      base00 = "1e1e2e"; # base
      base01 = "181825"; # mantle
      base02 = "313244"; # surface0
      base03 = "45475a"; # surface1
      base04 = "585b70"; # surface2
      base05 = "cdd6f4"; # text
      base06 = "f5e0dc"; # rosewater
      base07 = "b4befe"; # lavender
      base08 = "f38ba8"; # red
      base09 = "fab387"; # peach
      base0A = "f9e2af"; # yellow
      base0B = "a6e3a1"; # green
      base0C = "94e2d5"; # teal
      base0D = "89b4fa"; # blue
      base0E = "cba6f7"; # mauve
      base0F = "f2cdcd"; # flamingo
    };


    image = ./gruvbox-mountain-village.png;

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sizes = {
        applications = 12;
        terminal = 10;
        desktop = 10;
        popups = 10;
      };
    };

    cursor.name = "Bibata-Original-Amber";
    cursor.package = pkgs.bibata-cursors;
    cursor.size = 12;

    targets.chromium.enable = true;
    targets.grub.enable = true;
    targets.grub.useImage = true;
    targets.plymouth.enable = true;
  

    # opacity.terminal = 1;
    # stylix.targets.nixos-icons.enable = true;

    autoEnable = false;
  };
}
