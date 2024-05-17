{ config, pkgs,... }:
let
  sysact = pkgs.writeShellScriptBin "sysact" ''
      # A dmenu wrapper script for system functions.

    case "$(printf "🔒 lock\n🚪 logout\n♻️ renew hypr\n🐻 hibernate\n🔃 reboot\n🖥️shutdown\n💤 sleep" | rofi -dmenu -i -p 'Action: ')" in
    	'🔒 lock') ${pkgs.hyprlock}/bin/hyprlock ;;
    	'🚪 logout') ${pkgs.hyprland}/bin/hyprctl dispatch exit ;;
    	'♻️ renew hypr')  ${pkgs.hyprland}/bin/hyprctl reload ;;
    	'🔃 reboot') systemctl reboot -i ;;
    	'🖥️shutdown') systemctl poweroff -i ;;
    	*) exit 1 ;;
    esac
  '';

in {
    home.packages = with pkgs; [
      sysact
    ];
}
