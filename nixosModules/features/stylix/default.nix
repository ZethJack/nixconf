{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    homeManagerIntegration.autoImport = false;
    homeManagerIntegration.followSystem = false;
  };
}
