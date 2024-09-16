{pkgs, ...}: let
  linkhandler = pkgs.writeShellScriptBin "linkhandler" (builtins.readFile ./linkhandler);
  qndl = pkgs.writeShellScriptBin "qndl" (builtins.readFile ./qndl);
in {
  home.packages = with pkgs; [
    linkhandler
    qndl
  ];
}
