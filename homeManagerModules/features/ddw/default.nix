{pkgs, ...}: let
  ddw = pkgs.writeShellScriptBin "ddw" (builtins.readFile ./ddw);
in {
  home.packages = with pkgs; [
  dd
  pv
  ddw
  ];
}
