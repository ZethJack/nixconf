{ config, pkgs,... }:
let
  sysact = pkgs.writeShellScriptBin "sysact" ''
      # A dmenu wrapper script for system functions.
    case "$(readlink -f /sbin/init)" in
    	*systemd*) ctl='systemctl' ;;
    	*) ctl='loginctl' ;;
    esac

    case "$(printf "🔒 lock\n🚪 logout\n♻️ renew hypr\n🐻 hibernate\n🔃 reboot\n🖥️shutdown\n💤 sleep" | dmenu -i -p 'Action: ')" in
    	'🔒 lock') slock ;;
    	'🚪 leave hypr') hyprctl dispatch exit ;;
    	'♻️ renew hypr') hyprctl reload ;;
    	'🐻 hibernate') hyprlock $ctl hibernate ;;
    	'💤 sleep') hyprlock $ctl suspend ;;
    	'🔃 reboot') $ctl reboot -i ;;
    	'🖥️shutdown') $ctl poweroff -i ;;
    	*) exit 1 ;;
    esac
  '';

in {
    home.packages = with pkgs; [
      sysact
    ];
}
