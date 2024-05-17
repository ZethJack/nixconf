{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    };
  };

  myHomeManager.zsh.enable = lib.mkDefault true;
  myHomeManager.lf.enable = lib.mkDefault true;
  myHomeManager.yazi.enable = lib.mkDefault true;
  myHomeManager.nix-extra.enable = lib.mkDefault true;
  myHomeManager.bottom.enable = lib.mkDefault true;
  myHomeManager.nix-direnv.enable = lib.mkDefault true;

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Zeth";
    userEmail = "zeth@zethjack.eu";
  };
  programs.gh = {
    enable = true;
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };
  services.syncthing = {
    enable = true;
    tray.enable = false;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          shadow_passes = 2;
        }
      ];
    };

  };

  home.packages = with pkgs; [
    nil
    nixd
    pistol
    file
    git
    gh
    p7zip
    unzip
    zip
    stow
    libqalculate
    imagemagick
    killall
    neovim
    helix

    fzf
    htop
    lf
    eza
    fd
    zoxide
    bat
    du-dust
    ripgrep
    neofetch
    lazygit

    ffmpeg
    wget

    gnupg
    wofi-pass
    
    yt-dlp
    tree-sitter
    brave
    syncthing

    nh
  ];

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/.local/src/nixconf";
  };

  myHomeManager.impermanence.directories = [
    ".local/share/nvim"
    ".config/nvim"
    ".config/helix"

    ".ssh"
  ];

  myHomeManager.impermanence.files = [
    ".zsh_history"
  ];
}
