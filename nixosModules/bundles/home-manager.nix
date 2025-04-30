{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS = {
    userName = lib.mkOption {
      default = "zeth";
      description = ''
        username
      '';
    };

    userConfig = lib.mkOption {
      default = ./../../home-manager/work.nix;
      description = ''
        home-manager config path
      '';
    };

    userNixosSettings = lib.mkOption {
      default = {};
      description = ''
        NixOS user settings
      '';
    };
  };

  config = {
    programs.zsh.enable = true;

    programs.hyprland.enable = cfg.sharedSettings.hyprland.enable;

    services = lib.mkIf cfg.sharedSettings.hyprland.enable {
      displayManager = {
        defaultSession = "hyprland";
      };
    };

    home-manager = {
      backupFileExtension = "bak";
      extraSpecialArgs = {
        inherit inputs;
        inherit myLib;
        outputs = inputs.self.outputs;
      };
      users = {
        ${cfg.userName} = {...}: {
          imports = [
            (import cfg.userConfig)
            outputs.homeManagerModules.default
          ];
        };
      };
    };

    users.users.${cfg.userName} =
      {
        isNormalUser = true;
        initialPassword = "12345";
        description = cfg.userName;
        shell = pkgs.zsh;
        extraGroups = ["libvirtd" "networkmanager" "wheel"];
      }
      // cfg.userNixosSettings;
  };
}
