{
  pkgs,
  lib,
  ...
}: {
  # MPD configuration
  services.mpd = {
    enable = true;
    musicDirectory = "/home/zeth/Music";
    extraConfig = ''
      # Prevent playback restoration after restart
      restore_paused "yes"
      
      # Audio output
      audio_output {
        type "pulse"
        name "PulseAudio Output"
      }
      
      # General settings
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

  systemd.user.services.mpd = {
    Unit = {
      After = [ "pipewire.service" "pipewire-pulse.service" ];
      Wants = [ "pipewire.service" "pipewire-pulse.service" ];
    };
  };

  # Add ncmpcpp as a pre-built package to avoid compilation issues
  home.packages = with pkgs; [
    ncmpcpp
  ];
} 