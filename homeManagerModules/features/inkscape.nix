{pkgs, ...}: {
  home.packages = with pkgs; [
    inkscape-with-extensions
  ];

  myHomeManager.impermanence.directories = [
    ".config/inkscape"
  ];

}
