{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  system,
  myLib,
  hm,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../../nixosModules/features/greetd/default.nix
    ]
    ++ (myLib.filesIn ./included);

  myNixOS = {
    bundles = {
      base-system.enable = true;
      general-desktop.enable = true;
      users.enable = true;
    };

    sharedSettings.hyprland.enable = true;
    home-users = {
      "zeth" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = ["libvirtd" "networkmanager" "wheel" "adbusers"];
        };
      };
    };
    cachix.enable = true;
  };

  # System-specific settings
  system = {
    name = "hashbrown-nixos";
    nixos.label = "hashbrown";
    stateVersion = "23.05";
  };

  # hashbrown-specific boot configuration
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = false;
        gfxmodeBios = "1920x1080";
      };
    };
    # hashbrown-specific kernel parameters for NVIDIA
    kernelParams = ["quiet" "udev.log_level=3" "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1"];
  };

  # Host-specific settings
  networking = {
    hostName = "hashbrown";
    hostFiles = [../hblock];
  };

  # hashbrown-specific video drivers and settings
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;

  # hashbrown-specific nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # hashbrown-specific packages
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable # Additional wine package specific to hashbrown
  ];

  security.sudo.wheelNeedsPassword = false;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = ["coretemp" "cpuid" "v4l2loopback"];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  console.keyMap = "cz-qwertz";

  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "cz";
      variant = "";
    };
  };

  services.libinput.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10";
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    # bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-tools
        vulkan-headers
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools-lunarg
      ];
    };
  };

  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  services.printing.enable = true;
  services.ratbagd.enable = true;
  services.usbmuxd.enable = true;
  services.avahi.enable = true;

  environment.sessionVariables = {
    FLAKE = "$HOME/.local/src/nixconf";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
  };

  networking.firewall.allowedTCPPorts = [50000 53962 51319 32771 40668 54156 8080 80 50922 5000 3000];
  networking.firewall.allowedUDPPorts = [50000 56787 51319 32771 40668 38396 46223 8080 80 50922 5000 3000];
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  networking.firewall.enable = false;
  services.samba-wsdd.enable = true;

  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  # xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  programs.adb.enable = true;

  virtualisation = {
    # podman = {
    #   enable = true;
    #
    #   # `docker` alias
    #   dockerCompat = true;
    #   defaultNetwork.settings.dns_enabled = true;
    # };
  };
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.docker.enableNvidia = true;

  services.gvfs.enable = true;
  services.flatpak.enable = true;

  services.samba = {
    enable = true;
  };
}
