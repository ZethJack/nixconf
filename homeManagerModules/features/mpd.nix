{
  pkgs,
  lib,
  ...
}: {
  # ncmpcpp configuration
  programs.ncmpcpp = {
    enable = true;
    settings = {
      # Directories
      ncmpcpp_directory = "~/.config/ncmpcpp";
      lyrics_directory = "~/.local/share/lyrics";
      mpd_music_dir = "~/Music";
      
      # Display settings
      message_delay_time = "1";
      visualizer_type = "wave";
      song_list_format = "{$4%a - }{%t}|{$8%f$9}$R{$3(%l)$9}";
      song_status_format = "$b{{$8\"%t\"}} $3by {$4%a{ $3in $7%b{ (%y)}} $3}|{$8%f}";
      song_library_format = "{%n - }{%t}|{%f}";
      alternative_header_first_line_format = "$b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b";
      alternative_header_second_line_format = "{{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}";
      current_item_prefix = "$(cyan)$r$b";
      current_item_suffix = "$/r$(end)$/b";
      current_item_inactive_column_prefix = "$(magenta)$r";
      current_item_inactive_column_suffix = "$/r$(end)";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      progressbar_look = "->";
      media_library_primary_tag = "album_artist";
      media_library_albums_split_by_date = "no";
      startup_screen = "browser";
      display_volume_level = "no";
      ignore_leading_the = "yes";
      external_editor = "nvim";
      use_console_editor = "yes";
      empty_tag_color = "magenta";
      main_window_color = "white";
      progressbar_color = "black:b";
      progressbar_elapsed_color = "blue:b";
      statusbar_color = "red";
      statusbar_time_color = "cyan:b";
    };
    
    bindings = [
      # Volume controls
      { key = "+"; command = "volume_up"; }
      { key = "="; command = "volume_up"; }
      { key = "-"; command = "volume_down"; }
      
      # Navigation (vim-style)
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "h"; command = "previous_column"; }
      { key = "l"; command = "next_column"; }
      
      # Page navigation
      { key = "ctrl-u"; command = "page_up"; }
      { key = "ctrl-d"; command = "page_down"; }
      { key = "u"; command = "page_up"; }
      { key = "d"; command = "page_down"; }
      
      # File navigation
      { key = "h"; command = "jump_to_parent_directory"; }
      { key = "l"; command = "enter_directory"; }
      { key = "l"; command = "run_action"; }
      { key = "l"; command = "play_item"; }
      
      # Search and navigation
      { key = "n"; command = "next_found_item"; }
      { key = "N"; command = "previous_found_item"; }
      { key = "/"; command = "find"; }
      { key = "/"; command = "find_item_forward"; }
      { key = "?"; command = "find"; }
      { key = "?"; command = "find_item_backward"; }
      
      # Screen navigation
      { key = "1"; command = "show_playlist"; }
      { key = "2"; command = "show_browser"; }
      { key = "2"; command = "change_browse_mode"; }
      { key = "3"; command = "show_search_engine"; }
      { key = "3"; command = "reset_search_engine"; }
      { key = "4"; command = "show_media_library"; }
      { key = "4"; command = "toggle_media_library_columns_mode"; }
      { key = "5"; command = "show_playlist_editor"; }
      { key = "6"; command = "show_tag_editor"; }
      { key = "7"; command = "show_outputs"; }
      { key = "8"; command = "show_visualizer"; }
      { key = "="; command = "show_clock"; }
      { key = "@"; command = "show_server_info"; }
      
      # Playback controls
      { key = "s"; command = "stop"; }
      { key = "p"; command = "pause"; }
      { key = ">"; command = "next"; }
      { key = "<"; command = "previous"; }
      { key = "f"; command = "seek_forward"; }
      { key = "b"; command = "seek_backward"; }
      
      # Playlist management
      { key = "space"; command = "add_item_to_playlist"; }
      { key = "a"; command = "add_selected_items"; }
      { key = "c"; command = "clear_playlist"; }
      { key = "c"; command = "clear_main_playlist"; }
      { key = "C"; command = "crop_playlist"; }
      { key = "C"; command = "crop_main_playlist"; }
      { key = "S"; command = "save_playlist"; }
      { key = "x"; command = "delete_playlist_items"; }
      
      # Selection and movement
      { key = "v"; command = "reverse_selection"; }
      { key = "V"; command = "remove_selection"; }
      { key = "B"; command = "select_album"; }
      { key = "m"; command = "move_selected_items_up"; }
      { key = "n"; command = "move_selected_items_down"; }
      { key = "M"; command = "move_selected_items_to"; }
      
      # Playback modes
      { key = "r"; command = "toggle_repeat"; }
      { key = "z"; command = "toggle_random"; }
      { key = "R"; command = "toggle_consume"; }
      { key = "Y"; command = "toggle_replay_gain_mode"; }
      { key = "T"; command = "toggle_add_mode"; }
      { key = "y"; command = "toggle_single"; }
      
      # Other features
      { key = "."; command = "show_lyrics"; }
      { key = "i"; command = "show_song_info"; }
      { key = "I"; command = "show_artist_info"; }
      { key = "g"; command = "jump_to_position_in_song"; }
      { key = "o"; command = "jump_to_playing_song"; }
      { key = "G"; command = "move_end"; }
      { key = "g"; command = "move_home"; }
      { key = "U"; command = "update_database"; }
      
      # Quit
      { key = "q"; command = "quit"; }
    ];
  };

  # Add to home packages
  home.packages = with pkgs; [
    ncmpcpp
  ];

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