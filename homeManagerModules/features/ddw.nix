{pkgs, ...}: let

ddw = pkgs.writeShellScriptBin "ddw" ''
  #!/usr/bin/env bash
  if [ $# -ne 2 ]; then
      echo "Usage: $0 <input_file> <output_file>"
      exit 1
  fi

  input_file="$1"
  output_file="$2"

  # Get the size of the input file
  size=$(stat -c %s "$input_file")

  # Function to display progress
  progress_bar() {
      local current=$1
      local total=$2
      local width=50
      local percent=$((current * 100 / total))
      local complete=$((width * current / total))
      local incomplete=$((width - complete))
      
      printf "\r["
      printf "%0.s=" $(seq 1 $complete)
      printf "%0.s " $(seq 1 $incomplete)
      printf "] %d%%" $percent
  }

  # Use dd with status=none to avoid clutter, and use pv for progress
  dd if="$input_file" bs=4M status=none | pv -s $size | dd of="$output_file" bs=4M status=none

  echo -e "\nCopy completed."
'';

in {
  home.packages = with pkgs; [
    ddw
    pv
  ];
}
