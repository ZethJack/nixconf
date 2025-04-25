{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    monero-gui
    monero-cli
  ];

  # Create Monero configuration directory
  home.file.".bitmonero/monero-wallet-cli.conf".text = ''
    # Log file
    log-file=${config.home.homeDirectory}/.bitmonero/monero-wallet-cli.log

    # Connect to a remote full node (you can change this to your preferred node)
    daemon-address=node.community.rino.io:18081
    untrusted-daemon=1

    # Prevent unsafe RPC calls
    restricted-rpc=1
  '';
} 