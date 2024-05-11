{ pkgs,... }:
let
  lf-pick = pkgs.writeShellScriptBin "lf-pick" ''
    function lfp(){
      local TEMP=$(mktemp)
      lf -selection-path=$TEMP
      cat $TEMP
    }
    lfp
  '';

in {
    home.packages = with pkgs; [
      helix
    ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      
    theme = "catppuccin_mocha";
    keys.normal = {
      esc = [ "collapse_selection" "keep_primary_selection" ];
    };
    editor = {
      line-number = "relative";
      bufferline = "multiple";
      cursor-shape = {
        insert = "bar";
      };
      indent-guides = {
        render = true;
        character = "┆";
        skip-levels = 1;
      };

      soft-wrap = {
        enable = true;
        max-wrap= 25;
        };
    };

    };
  };
  environment.systemPackages = [ lf-pick ];
  
}
