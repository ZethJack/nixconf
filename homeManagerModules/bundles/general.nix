{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    };
  };

  # Explicitly disable swaylock at the bundle level
  programs.swaylock = {
    enable = lib.mkForce false;
    package = lib.mkForce null;
    settings = lib.mkForce {};
  };

  myHomeManager.zsh.enable = lib.mkDefault true;
  myHomeManager.lf.enable = lib.mkDefault true;
  myHomeManager.yazi.enable = lib.mkDefault true;
  myHomeManager.nix-extra.enable = lib.mkDefault true;
  myHomeManager.bottom.enable = lib.mkDefault true;
  myHomeManager.nix-direnv.enable = lib.mkDefault true;
  myHomeManager.hyprlock.enable = lib.mkDefault true;
  myHomeManager.btop.enable = lib.mkDefault true;
  myHomeManager.stylix.enable = lib.mkDefault true;

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
    package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };
  services.syncthing = {
    enable = true;
    tray.enable = false;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-gtk2;
  };

  home.packages = with pkgs; [
    appimage-run
    nil
    nixd
    pistol
    file
    git
    gh
    p7zip
    unzip
    zip
    libqalculate
    imagemagick
    killall
    neovim
    helix
    hblock
    taskspooler
    gparted
    (lib.mkForce pinentry-gtk2)

    fzf
    htop
    lf
    eza
    fd
    zoxide
    obsidian
    bat
    du-dust
    ripgrep
    fastfetch
    lazygit
    localsend

    ffmpeg
    shotcut
    wget

    gnupg
    pinentry-gtk2
    (wofi-pass.override {extensions = exts: [exts.pass-otp];})

    yt-dlp
    tree-sitter
    brave
    syncthing
    wavemon

    nh
  ];

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/.local/src/nixconf";
  };
}
