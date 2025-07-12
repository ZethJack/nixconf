{pkgs}: {
  battery = pkgs.writeShellScriptBin "script" ''
    cat /sys/class/power_supply/BAT0/capacity
  '';

  mpd = pkgs.writeShellScriptBin "script" ''
    #!/bin/bash
    
    # Get MPD status using full path to mpc
    status=$(${pkgs.mpc}/bin/mpc status 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        exit 0
    fi
    
    # Extract current song info
    current_song=$(echo "$status" | head -1)
    player_status=$(echo "$status" | grep -o "\[playing\]\|\[paused\]\|\[stopped\]")
    
    # Get progress info
    progress=$(echo "$status" | grep -o "#[0-9]*/[0-9]*" | head -1)
    time_info=$(echo "$status" | grep -o "[0-9]*:[0-9]*/[0-9]*:[0-9]*" | head -1)
    
    # Don't show anything if stopped
    if [ "$player_status" = "[stopped]" ]; then
        exit 0
    fi
    
    # Set icon based on status
    case "$player_status" in
        "[playing]")
            icon="󰐊"
            ;;
        "[paused]")
            icon="󰏤"
            ;;
        *)
            exit 0
            ;;
    esac
    
    # Truncate song name if too long
    song_length=$(echo "$current_song" | wc -c)
    if [ "$song_length" -gt 30 ]; then
        current_song="$(echo "$current_song" | cut -c1-27)..."
    fi
    
    # Output format: icon song_name
    echo "$icon $current_song"
    
    # For tooltip, include more details
    if [ -n "$time_info" ]; then
        echo "$current_song - $time_info" >&2
    else
        echo "$current_song" >&2
    fi
  '';
}
