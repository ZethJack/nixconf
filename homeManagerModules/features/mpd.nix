{
  pkgs,
  lib,
  ...
}: {
  # MPD configuration - simplified to avoid build issues
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
    '';
  };

  systemd.user.services.mpd = {
    Unit = {
      After = [ "pipewire.service" "pipewire-pulse.service" ];
      Wants = [ "pipewire.service" "pipewire-pulse.service" ];
    };
  };
} 