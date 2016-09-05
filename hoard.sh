#!/bin/bash
#
# hoard.sh
#
# Basically youtube-dl with hard coded options
# with an optional glorified while loop featuring an interactive countdown.
#
# By default it runs youtube-dl once,
# otherwise specify looping and interval between loops
# e.g "./hoard.sh loop 10"
#
trexit(){ #exit for traps, trexit!
  echo "hoarder terminated at $(date)"
  tput cnorm
  tput sgr0
  exit
}

mexit(){ #exit with message, mexit!
  echo "FATAL: $1" && exit
}

init() {
  trap trexit SIGINT SIGTERM
  if [[ -z "$hoarder_data_dir" ]]; then
    if [[ -f "hoarder.cfg" ]]; then
       source hoarder.cfg
       [[ -z "$hoarder_data_dir" ]] && mexit "hoarder_data_dir is not set in hoarder.cfg"
    fi
    [[ -z "$hoarder_data_dir" ]] && mexit "hoarder_data_dir is not set and hoarder.cfg could not be located."
  fi

  [[ -d "$hoarder_data_dir" ]] || mexit "hoarder_data_dir '$hoarder_data_dir' does not exist."
  [[ -f "$hoarder_data_dir/hoarder_urls.txt" ]] || mexit "$hoarder_data_dir/hoarder_urls.txt does not exist. Please create it and populate it with the URLs you wish to hoard from."
  [[ -f "$hoarder_data_dir/hoarder_archive.txt" ]] || echo "NOTICE: $hoarder_data_dir/hoarder_archive.txt does not exist, a new one will be created."

  if [[ -z "$hoarder_mode" ]]; then
    [[ "$1" == "loop" ]] && hoarder_mode=loop || hoarder_mode=runonce
  fi

  if [[ "$hoarder_mode" == "loop" ]]; then
    if [[ -z "$hoarder_wait" ]]; then
      [[ -z "$2" ]] && hoarder_wait=43200 && echo "hoarder_wait was not set, defaulting to $hoarder_wait." || hoarder_wait="$2"
    fi
  fi
}

hoard(){
  echo "Hoarding started at $(date)"
  youtube-dl \
  --batch-file "$hoarder_data_dir/hoarder_urls.txt" \
  --download-archive "$hoarder_data_dir/hoarder_archive.txt" \
  --embed-subs \
  --restrict-filenames \
  --all-subs \
  --merge-output-format mkv \
  -o "$hoarder_data_dir/%(uploader)s/%(uploader)s-%(title)s.%(ext)s"
  echo "Hoarding ended at $(date)"
}

waitcounter(){
  echo -n "Next hoarding countdown: "
  tput sc
  tput civis
  hoarder_wait_countdown="$hoarder_wait"
  while [[ "$hoarder_wait_countdown" -ne 0 ]]; do
    tput rc
    tput el
    echo -n "$hoarder_wait_countdown"
    sleep 1
    (( hoarder_wait_countdown-- ))
  done
  tput cnorm
  echo
}

hoarder(){
  if [[ "$hoarder_mode" == "loop" ]]; then
      while true; do
        hoard
        waitcounter
      done
  else
      hoard
 fi
}

init "$1" "$2"
hoarder
