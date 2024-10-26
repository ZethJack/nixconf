{
  pkgs,
  inputs,
  lib,
  ...
}: 
let schemeAttr = file:
      (builtins.fromJSON (builtins.readFile (pkgs.runCommand "json" { } ''
      ${lib.getExe pkgs.yj} < "${file}" > $out
      '').outPath)).palette;
in
{

  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    base16Scheme = schemeAttr "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = {
    #   base00 = "1e1e2e"; # base
    #   base01 = "181825"; # mantle
    #   base02 = "313244"; # surface0
    #   base03 = "45475a"; # surface1
    #   base04 = "585b70"; # surface2
    #   base05 = "cdd6f4"; # text
    #   base06 = "f5e0dc"; # rosewater
    #   base07 = "b4befe"; # lavender
    #   base08 = "f38ba8"; # red
    #   base09 = "fab387"; # peach
    #   base0A = "f9e2af"; # yellow
    #   base0B = "a6e3a1"; # green
    #   base0C = "94e2d5"; # teal
    #   base0D = "89b4fa"; # blue
    #   base0E = "cba6f7"; # mauve
    #   base0F = "f2cdcd"; # flamingo
    # };

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
