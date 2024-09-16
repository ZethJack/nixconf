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
    # ++ (myLib.filesIn ./included);
    ;

  myNixOS = {
    bundles.general-desktop.enable = true;
    bundles.users.enable = true;

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

  system.name = "potatOS-nixos";
  system.nixos.label = "test1";
  system.activationScripts.createPersistentStorageDirs.text = ''
    mkdir -p /persist
  '';

  security.sudo.wheelNeedsPassword = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-f094d3af-0ead-4064-aa5d-4b80a24d970c".device = "/dev/disk/by-uuid/f094d3af-0ead-4064-aa5d-4b80a24d970c";
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  boot.kernelParams = ["quiet" "udev.log_level=3"];
  boot.kernelModules = ["coretemp" "cpuid" "v4l2loopback"];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  console.keyMap = "cz-qwertz";
  networking.hostName = "potatOS";

  networking.hostFiles = [../hblock];

  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["intel"];
    xkb = {
      layout = "cz";
      variant = "";
    };
  };

  services.libinput.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSSHSupport = true;
  };

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

  # hardware.nvidia.modesetting.enable = true;
  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  services.printing.enable = true;
  services.ratbagd.enable = true;
  services.usbmuxd.enable = true;
  services.avahi.enable = true;

  environment.systemPackages = with pkgs; [
    hyprlock
    pciutils
    cifs-utils
    vulkan-tools
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
  ];

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

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  xdg.portal.enable = true;

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

  # services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.flatpak.enable = true;

  services.samba = {
    enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #

  system.stateVersion = "23.05";
}
