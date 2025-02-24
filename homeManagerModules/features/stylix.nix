{
  pkgs,
  inputs,
  lib,
  ...
}: let
  schemeAttr = file:
    (builtins.fromJSON (builtins.readFile
      (pkgs.runCommand "json" {} ''
        ${lib.getExe pkgs.yj} < "${file}" > $out
      '')
      .outPath))
    .palette;
in {
  imports = [inputs.stylix.homeManagerModules.stylix];
  stylix = {
    enable = true; # Explicitly enable for zeth
    base16Scheme = schemeAttr "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ../../nixosModules/features/stylix/gruvbox-mountain-village.png;
    polarity = "dark"; # Force dark theme (optional, per docs)
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
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
    cursor = {
      name = "Bibata-Original-Amber";
      package = pkgs.bibata-cursors;
      size = 12;
    };
    targets = {
      kitty.enable = true;
      gtk.enable = true;
      qt.enable = true;
      # qt.platform = "gtk";
      firefox.enable = true;
      rofi.enable = false;
      kde.enable = false;
    };
    autoEnable = true; # Theme all supported Home Manager targets
  };
}
