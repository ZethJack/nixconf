{pkgs, ...}: {
  home.packages = with pkgs; [
    inkscape-with-extensions
  ];

  myHomeManager.impermanence.cache.directories = [
    ".config/inkscape"
  ];

}
