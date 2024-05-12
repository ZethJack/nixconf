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
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
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
