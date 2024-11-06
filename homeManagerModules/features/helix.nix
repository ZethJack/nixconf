{pkgs, ...}: let
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
    lf-pick
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      # theme = "catppuccin_mocha";
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection"];
        C-f = [":new" ":insert-output lf-pick" ":theme default" "select_all" "split_selection_on_newline" "goto_file" "goto_last_modified_file" ":buffer-close!" ":theme catppuccin_mocha"];
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
          max-wrap = 25;
        };
      };
    };
    languages = { language-server.nixd = {
      command = "nixd";
      args = [ "--inlay-hints=true" ];
    }; 
    
    language = [{
      name = "nix";
      scope = "source.nix";
      injection-regex = "nix";
      file-types = ["nix"];
      comment-token = "#";
      formatter = { command ="alejandra"; };
      indent = { tab-width = 2; unit = "  "; };
      language-servers = [ "nixd" ];
    }];
    
    };
  };
}
