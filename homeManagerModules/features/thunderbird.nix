{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  programs.thunderbird = {
    enable = true;
    profiles.zeth = {
      isDefault = true;
    };
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };
  };
}
