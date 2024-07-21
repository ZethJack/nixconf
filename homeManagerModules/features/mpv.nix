{...}:

{
  programs.mpv = {
    enable = true;
    config = {
      vo="gpu-next";
      hwdec="vaapi";
      gpu-context="wayland";
      cache-secs = 10;
      cache-pause = "yes";
      dither-depth = "auto";
      correct-downscaling = "yes";
      sigmoid-upscaling = "yes";
      deband = "no";
      volume-max = 100;
      ytdl-format = "bestvideo[height<=?480]+bestaudio/best";
      ytdl-raw-options = "prefer-free-formats=";
    };
  };
}
