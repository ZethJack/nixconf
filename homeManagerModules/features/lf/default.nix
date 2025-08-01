{
  pkgs,
  config,
  lib,
  osConfig ? null,
  ...
}: {
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;
    commands = {
      # for f in $fx; do
      #     xdg-open "$f" > /dev/null 2>&1 &
      # done ;;
      open = ''
        &{{
            case $(file --mime-type -bL -- "$f") in
                text/*|application/json)
                    lf -remote "send $id ${lib.getExe pkgs.helix} \$fx" ;;
                image/*)
                    ${lib.getExe pkgs.imv} "$fx" ;;
                audio/*)
                    ${lib.getExe pkgs.mpv} "$fx" ;;
                video/*)
                    ${lib.getExe pkgs.mpv} --no-terminal "$f" ;;
                application/pdf|application/epub+zip)
                    ${lib.getExe pkgs.zathura} "$f" ;;
                *)
                    lf -remote "send $id ${lib.getExe pkgs.helix} \$fx" ;;
            esac
        }}
      '';
      drag-out = ''%${pkgs.ripdrag}/bin/ripdrag -a -x "$fx"'';
      editor-open = ''${lib.getExe pkgs.helix} "$f"'';
      edit-dir = ''${lib.getExe pkgs.helix} .'';
      mkdirfile = ''
        ''${{
            printf "File: "
            read DIR
            mkdir -p $DIR
        }}
      '';

      #on-cd = ''
      #  ''${{ }}
      #'';
    };
    keybindings = {
      "\\\"" = "";
      o = "";
      d = "";
      e = "";
      f = "";
      c = "mkdirfile";
      "." = "set hidden!";
      D = "delete";
      p = "paste";
      dd = "cut";
      y = "copy";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";
      a = "rename";
      r = "reload";
      C = "clear";
      U = "unselect";

      do = "drag-out";

      "g~" = "cd";
      gh = "cd";
      "g/" = "/";
      gd = "cd ~/Downloads";
      gt = "cd /tmp";
      gv = "cd ~/Videos";
      go = "cd ~/Documents";
      gc = "cd ~/.config";
      gn = "cd ~/nixconf";
      gp = "cd ~/Projects";
      gs = "cd ~/.local/share";
      gm = "cd /run/media";

      # go to impermanence dir
      gH = "cd /persist/users/${config.home.homeDirectory}";

      ee = "editor-open";
      "e." = "edit-dir";
      V = ''''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';

      "<C-d>" = "5j";
      "<C-u>" = "5k";
    };

    settings = {
      reverse = true;
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.ctpv}/bin/ctpvclear
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      # set cleaner ''${pkgs.ctpv}/bin/ctpvclear
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${pkgs.ctpv}/bin/ctpv
      cmd stripspace %stripspace "$f"
      setlocal ~/Projects sortby time
      setlocal ~/Projects/* sortby time
      setlocal ~/Downloads/ sortby time
    '';
  };

  programs.zsh.initContent = let
    lfColors = [
      "~/Projects=04;33"
      "~/Downloads=04;33"
      "~/Documents=04;33"
      "~/Videos=04;33"
      "~/.config=04;33"
      "~/nixconf=04;33"
      "~/.local/share=04;33"
      "/run/media=04;33"
    ];
    lfExport = ''
      export LF_COLORS="${lib.concatStringsSep ":" lfColors}"
    '';
  in
    lib.mkAfter ''
      lfcd () {
          ${lfExport}
          tmp="$(mktemp)"
          lf -last-dir-path="$tmp" "$@"
          #./lfrun
          if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp"
              if [ -d "$dir" ]; then
                  if [ "$dir" != "$(pwd)" ]; then
                      cd "$dir"
                  fi
              fi
          fi
      }
      alias lf="lfcd"
    '';
}
