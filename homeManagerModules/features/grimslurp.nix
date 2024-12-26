{pkgs, ...}: let
  grimslurp = pkgs.writeShellScriptBin "grimslurp" ''

    case "$(printf "a selected area\\ncurrent window\\nfull screen\\na selected area (copy)\\ncurrent window (copy)\\nfull screen (copy)" | rofi -dmenu -l 6 -i -p "Screenshot which area?")" in
    	"a selected area")
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot save area $HOME/Pics/Screenshots/pic-selected-"$(date '+%y%m%d-%H%M-%S').png" ;;
    	"current window")
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot save active $HOME/Pics/Screenshots/pic-window-"$(date '+%y%m%d-%H%M-%S').png" ;;
    	"full screen") 
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen $HOME/Pics/Screenshots/pic-full-"$(date '+%y%m%d-%H%M-%S').png" ;;
    	"a selected area (copy)") 
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area;;
    	"current window (copy)") 
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot copy active;;
    	"full screen (copy)") 
        sleep 2 
        ${pkgs.sway-contrib.grimshot}/bin/grimshot copy screen;;
    esac
  '';
in {
  home.packages = with pkgs; [
    grim
    slurp
    sway-contrib.grimshot
    grimslurp
    wl-clipboard
  ];
}
