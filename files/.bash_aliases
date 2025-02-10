#!/usr/bin/env bash
alias ccd='cd ~/.local/src/dotfiles'
alias yt='yt-dlp --add-metadata -i --external-downloader aria2c:"-c -j 3 -x 3 -k 1M" --sponsorblock-remove sponsor,selfpromo,interaction -o "%(title)s.%(ext)s"'
alias yta='yt -x -f bestaudio/best --audio-format opus'
alias yta-ogg='yt -x -f bestaudio/best --audio-format ogg'
alias tat='tmux a || tmux'
alias nhhs='nh home switch'
alias mkd='mkdir -pv'
gifenc() {
  local input="$1"
  local output="${input%.*}.gif"
  ffmpeg -i "$input" -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" "$output"
}
