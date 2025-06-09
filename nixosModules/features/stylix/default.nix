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
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    enable = true;
    base16Scheme = schemeAttr "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./gruvbox-mountain-village.png;
    polarity = "dark";
    homeManagerIntegration.autoImport = false;
    homeManagerIntegration.followSystem = false;
  };
}
