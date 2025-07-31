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

  # Override ncmpcpp with proper Boost headers to fix compilation issue
  home.packages = with pkgs; [
    (ncmpcpp.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ boost.dev ];
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkg-config ];
      configureFlags = oldAttrs.configureFlags or [] ++ [
        "--with-boost=${boost.dev}"
        "CPPFLAGS=-I${boost.dev}/include"
        "LDFLAGS=-L${boost.dev}/lib"
      ];
    }))
    ncmpc        # Fallback curses-based MPD client
    mpc          # Minimalist command line interface to MPD
    miniplayer   # Curses-based MPD client with album art support
  ];

  # ncmpcpp configuration files
  home.file = {
    ".config/ncmpcpp/config" = {
      text = ''
        ncmpcpp_directory = "~/.config/ncmpcpp"
        lyrics_directory = "~/.local/share/lyrics"
        mpd_music_dir = "~/Music"
        message_delay_time = "1"
        visualizer_type = "wave"
        song_list_format = {$4%a - }{%t}|{$8%f$9}$R{$3(%l)$9}
        song_status_format = $b{{$8"%t"}} $3by {$4%a{ $3in $7%b{ (%y)}} $3}|{$8%f}
        song_library_format = {%n - }{%t}|{%f}
        alternative_header_first_line_format = $b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b
        alternative_header_second_line_format = {{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}
        current_item_prefix = $(cyan)$r$b
        current_item_suffix = $/r$(end)$/b
        current_item_inactive_column_prefix = $(magenta)$r
        current_item_inactive_column_suffix = $/r$(end)
        playlist_display_mode = columns
        browser_display_mode = columns
        progressbar_look = ->
        media_library_primary_tag = album_artist
        media_library_albums_split_by_date = no
        startup_screen = "browser"
        display_volume_level = no
        ignore_leading_the = yes
        external_editor = nvim
        use_console_editor = yes
        empty_tag_color = magenta
        main_window_color = white
        progressbar_color = black:b
        progressbar_elapsed_color = blue:b
        statusbar_color = red
        statusbar_time_color = cyan:b
      '';
    };

    ".config/ncmpcpp/bindings" = {
      text = ''
        def_key "+"
            show_clock
        def_key "="
            volume_up

        def_key "j"
            scroll_down
        def_key "k"
            scroll_up

        def_key "ctrl-u"
            page_up
        def_key "ctrl-d"
            page_down
        def_key "u"
            page_up
        def_key "d"
            page_down
        def_key "h"
            previous_column
        def_key "l"
            next_column

        def_key "."
            show_lyrics

        def_key "n"
            next_found_item
        def_key "N"
            previous_found_item

        def_key "J"
            move_sort_order_down
        def_key "K"
            move_sort_order_up
        def_key "h"
          jump_to_parent_directory
        def_key "l"
          enter_directory
        def_key "l"
          run_action
        def_key "l"
          play_item
        def_key "m"
          show_media_library
        def_key "m"
          toggle_media_library_columns_mode
        def_key "t"
          show_tag_editor
        def_key "v"
          show_visualizer
        def_key "G"
          move_end
        def_key "g"
          move_home
        def_key "U"
          update_database
        def_key "s"
          reset_search_engine
        def_key "s"
          show_search_engine
        def_key "f"
          show_browser
        def_key "f"
          change_browse_mode
        def_key "x"
          delete_playlist_items
        def_key "P"
          show_playlist

        # Additional standard bindings
        def_key "enter"
          enter_directory
        def_key "enter"
          toggle_output
        def_key "enter"
          run_action
        def_key "enter"
          play_item
        def_key "space"
          add_item_to_playlist
        def_key "space"
          toggle_lyrics_update_on_song_change
        def_key "space"
          toggle_visualization_type
        def_key "delete"
          delete_playlist_items
        def_key "delete"
          delete_browser_items
        def_key "delete"
          delete_stored_playlist
        def_key "right"
          next_column
        def_key "right"
          slave_screen
        def_key "right"
          volume_up
        def_key "left"
          previous_column
        def_key "left"
          master_screen
        def_key "left"
          volume_down
        def_key "-"
          volume_down
        def_key ":"
          execute_command
        def_key "tab"
          next_screen
        def_key "shift-tab"
          previous_screen
        def_key "f1"
          show_help
        def_key "1"
          show_playlist
        def_key "2"
          show_browser
        def_key "2"
          change_browse_mode
        def_key "3"
          show_search_engine
        def_key "3"
          reset_search_engine
        def_key "4"
          show_media_library
        def_key "4"
          toggle_media_library_columns_mode
        def_key "5"
          show_playlist_editor
        def_key "6"
          show_tag_editor
        def_key "7"
          show_outputs
        def_key "8"
          show_visualizer
        def_key "@"
          show_server_info
        def_key "s"
          stop
        def_key "p"
          pause
        def_key ">"
          next
        def_key "<"
          previous
        def_key "ctrl-h"
          jump_to_parent_directory
        def_key "ctrl-h"
          replay_song
        def_key "backspace"
          jump_to_parent_directory
        def_key "backspace"
          replay_song
        def_key "f"
          seek_forward
        def_key "b"
          seek_backward
        def_key "r"
          toggle_repeat
        def_key "z"
          toggle_random
        def_key "y"
          save_tag_changes
        def_key "y"
          start_searching
        def_key "y"
          toggle_single
        def_key "R"
          toggle_consume
        def_key "Y"
          toggle_replay_gain_mode
        def_key "T"
          toggle_add_mode
        def_key "|"
          toggle_mouse
        def_key "#"
          toggle_bitrate_visibility
        def_key "Z"
          shuffle
        def_key "x"
          toggle_crossfade
        def_key "X"
          set_crossfade
        def_key "ctrl-s"
          sort_playlist
        def_key "ctrl-s"
          toggle_browser_sort_mode
        def_key "ctrl-s"
          toggle_media_library_sort_mode
        def_key "ctrl-r"
          reverse_playlist
        def_key "ctrl-f"
          apply_filter
        def_key "ctrl-_"
          select_found_items
        def_key "/"
          find
        def_key "/"
          find_item_forward
        def_key "?"
          find
        def_key "?"
          find_item_backward
        def_key "."
          next_found_item
        def_key ","
          previous_found_item
        def_key "w"
          toggle_find_mode
        def_key "e"
          edit_song
        def_key "e"
          edit_library_tag
        def_key "e"
          edit_library_album
        def_key "e"
          edit_directory_name
        def_key "e"
          edit_playlist_name
        def_key "e"
          edit_lyrics
        def_key "i"
          show_song_info
        def_key "I"
          show_artist_info
        def_key "g"
          jump_to_position_in_song
        def_key "l"
          show_lyrics
        def_key "ctrl-v"
          select_range
        def_key "v"
          reverse_selection
        def_key "V"
          remove_selection
        def_key "B"
          select_album
        def_key "a"
          add_selected_items
        def_key "c"
          clear_playlist
        def_key "c"
          clear_main_playlist
        def_key "C"
          crop_playlist
        def_key "C"
          crop_main_playlist
        def_key "m"
          move_sort_order_up
        def_key "m"
          move_selected_items_up
        def_key "n"
          move_sort_order_down
        def_key "n"
          move_selected_items_down
        def_key "M"
          move_selected_items_to
        def_key "A"
          add
        def_key "S"
          save_playlist
        def_key "o"
          jump_to_playing_song
        def_key "G"
          jump_to_browser
        def_key "G"
          jump_to_playlist_editor
        def_key "~"
          jump_to_media_library
        def_key "E"
          jump_to_tag_editor
        def_key "U"
          toggle_playing_song_centering
        def_key "P"
          toggle_display_mode
        def_key "\\"
          toggle_interface
        def_key "!"
          toggle_separators_between_albums
        def_key "L"
          toggle_lyrics_fetcher
        def_key "F"
          fetch_lyrics_in_background
        def_key "alt-l"
          toggle_fetching_lyrics_in_background
        def_key "ctrl-l"
          toggle_screen_lock
        def_key "`"
          toggle_library_tag_type
        def_key "`"
          refetch_lyrics
        def_key "`"
          add_random_items
        def_key "ctrl-p"
          set_selected_items_priority
        def_key "q"
          quit
      '';
    };
  };
} 