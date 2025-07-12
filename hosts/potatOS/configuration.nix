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
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules/features/greetd/default.nix
  ];

  myNixOS = {
    bundles = {
      base-system.enable = true;
      general-desktop.enable = true;
      users.enable = true;
    };

    hardware-wallets.enable = true;
    sharedSettings.hyprland.enable = true;
    home-users = {
      "zeth" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = ["libvirtd" "networkmanager" "wheel" "adbusers" "plugdev"];
        };
      };
    };
    cachix.enable = true;
  };

  # System-specific settings
  system = {
    name = "potatOS-nixos";
    nixos.label = "potatOS";
    stateVersion = "24.11";
  };

  # potatOS-specific boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-f094d3af-0ead-4064-aa5d-4b80a24d970c".device = "/dev/disk/by-uuid/f094d3af-0ead-4064-aa5d-4b80a24d970c";
  };

  # Host-specific settings
  networking = {
    hostName = "potatOS";
    hostFiles = [../hblock];
  };

  # potatOS-specific video drivers
  services.xserver.videoDrivers = ["intel"];

  # potatOS-specific nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  security.sudo.wheelNeedsPassword = false;

  boot.kernelParams = ["quiet" "udev.log_level=3"];
  boot.kernelModules = ["coretemp" "cpuid" "v4l2loopback"];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  console.keyMap = "cz-qwertz";

  networking.networkmanager.enable = true;

  services.xserver = {
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

  environment.systemPackages = with pkgs; [
    hyprlock
    pciutils
    cifs-utils
    vulkan-tools
    wineWowPackages.waylandFull
    winetricks
    mpc
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

  xdg.portal.wlr.enable = true;

  programs.adb.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  services.gvfs.enable = true;
  services.flatpak.enable = true;

  services.samba = {
    enable = true;
  };

  # Custom MPD package without io_uring to resolve build issues
  nixpkgs.overlays = [
    (final: prev: {
      mpd = prev.mpd.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or []) ++ [ prev.pkg-config ];
        mesonFlags = (oldAttrs.mesonFlags or []) ++ [ "-Dio_uring=disabled" ];
      });
    })
  ];

  services.mpd = {
    enable = false;
    musicDirectory = "/home/zeth/Music";
    user = "zeth";
    extraConfig = ''
      audio_output {
        type "null"
        name "Null Output"
      }
      auto_update "yes"
      follow_inside_symlinks "yes"
      follow_outside_symlinks "no"
      max_output_buffer_size "16384"
      max_playlist_length "16384"
      metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc"
      replaygain "auto"
      replaygain_preamp "0"
      replaygain_missing_preamp "0"
      replaygain_limit "yes"
    '';
  };
}
