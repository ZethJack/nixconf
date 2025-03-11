{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.myNixOS.bundles.base-system.enable {
    # Common system configuration
    security.sudo.wheelNeedsPassword = false;

    # Common boot configuration
    boot = {
      kernelModules = ["coretemp" "cpuid" "v4l2loopback"];
      kernelParams = ["quiet" "udev.log_level=3"];
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
      '';
    };

    # Common keyboard configuration
    console.keyMap = "cz-qwertz";

    # Common networking configuration
    networking = {
      networkmanager.enable = true;
      firewall = {
        allowedTCPPorts = [50000 53962 51319 32771 40668 54156 8080 80 50922 5000 3000];
        allowedUDPPorts = [50000 56787 51319 32771 40668 38396 46223 8080 80 50922 5000 3000];
        extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
        enable = false;
      };
    };

    # Common X server configuration
    services.xserver = {
      enable = true;
      xkb = {
        layout = "cz";
        variant = "";
      };
    };

    # Common hardware configuration
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

    # Common services
    services = {
      libinput.enable = true;
      printing.enable = true;
      ratbagd.enable = true;
      usbmuxd.enable = true;
      avahi.enable = true;
      gvfs.enable = true;
      flatpak.enable = true;
      samba.enable = true;
      samba-wsdd.enable = true;
    };

    # Common programs
    programs = {
      gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gtk2;
        enableSSHSupport = true;
      };
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 10";
      };
      adb.enable = true;
    };

    # Common virtualization
    virtualisation = {
      libvirtd.enable = true;
      docker.enable = true;
    };

    # Common environment configuration
    environment = {
      variables.WLR_NO_HARDWARE_CURSORS = "1";
      systemPackages = with pkgs; [
        hyprlock
        pciutils
        cifs-utils
        vulkan-tools
        wineWowPackages.waylandFull
        winetricks
      ];
      sessionVariables = {
        FLAKE = "$HOME/.local/src/nixconf";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
      };
    };

    # Common XDG portal configuration
    xdg.portal.wlr.enable = true;
  };
}
