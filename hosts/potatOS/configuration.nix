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
    # GameMode and gaming tools
    gamemode
    mangohud
    goverlay
    # Create GameMode status indicator script
    (pkgs.writeShellScriptBin "gamemode-status" ''
      #!/bin/bash
      # GameMode status indicator
      
      if gamemoded -s | grep -q "gamemode is active"; then
          echo "🎮 GameMode: ACTIVE"
          exit 0
      else
          echo "🎮 GameMode: INACTIVE"
          exit 1
      fi
    '')
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

  # GameMode configuration for improved gaming performance
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        # CPU governor settings
        cpu_governor = "performance";
        # I/O priority settings
        ioprio = "1";
        # Process niceness
        nice = "-10";
        # Kernel scheduler
        kernel_scheduler = "1";
        # Screensaver inhibiting
        inhibit_screensaver = "1";
        # GPU performance mode
        gpu_performance_mode = "1";
        # GPU overclocking (NVIDIA only)
        gpu_overclock = "0";
        # Soft real-time scheduling
        softrealtime = "auto";
        # Renice GPU processes
        renice = "10";
      };
      # GPU-specific settings
      gpu = {
        # NVIDIA GPU settings
        nvidia_drm_modeset = "1";
        nvidia_persistenced = "1";
        nvidia_power_management = "1";
        # AMD GPU settings
        amd_performance_level = "high";
        amd_power_dpm_force_performance_level = "high";
        # Intel GPU settings
        intel_gpu_frequency = "1";
      };
      # Custom environment variables
      custom = {
        # Vulkan settings for better performance
        VK_LAYER_NV_optimus = "NVIDIA_only";
        __GL_SYNC_TO_VBLANK = "0";
        __GL_THREADED_OPTIMIZATIONS = "1";
        __GL_YIELD = "NOTHING";
        # Mesa settings
        MESA_GL_VERSION_OVERRIDE = "4.5";
        MESA_GLSL_VERSION_OVERRIDE = "450";
        MESA_GLTHREAD = "1";
        # Wine/Proton optimizations
        WINEDLLOVERRIDES = "dxgi=n";
        DXVK_HUD = "0";
        DXVK_STATE_CACHE = "1";
        # Steam optimizations
        STEAM_RUNTIME = "1";
        STEAM_GAMEMODE = "1";
        # General gaming optimizations
        SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
        SDL_VIDEO_WINDOW_POS = "0,0";
        SDL_VIDEO_CENTERED = "0";
      };
    };
  };

  # Add GameMode to user groups for proper permissions
  users.users.zeth.extraGroups = ["gamemode"];

  # Configure Steam with GameMode integration
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      gamemode
      mangohud
      goverlay
    ];
  };

  # Configure GameMode for Lutris
  environment.sessionVariables = {
    # Enable GameMode for Lutris games
    LUTRIS_GAMEMODE = "1";
  };

  # Configure GameMode for better performance with specific games
  environment.variables = {
    # Enable GameMode for Steam games
    STEAM_GAMEMODE = "1";
    # Enable GameMode for Wine/Proton games
    WINE_GAMEMODE = "1";
    # Enable GameMode for native Linux games
    GAMEMODE_RUN = "1";
  };

  # MPD is handled by Home Manager, no need for system-level configuration
}
