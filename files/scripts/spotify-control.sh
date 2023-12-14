#!/usr/bin/env bash
# Usage: spotify_control <command>

run() {
  local readonly sendToSpotify="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player"

  case "$1" in
  "playpause" )
    ${sendToSpotify}.PlayPause
    exit $?
  ;;
  "next" )
    ${sendToSpotify}.Next
    exit $?
  ;;
  "previous" )
    ${sendToSpotify}.Previous
    exit $?
  ;;
  "stop" )
    ${sendToSpotify}.Stop
    exit $?
  ;;
  "play" )
    ${sendToSpotify}.Play
    exit $?
  ;;
  *)
    echo "Usage: $0 [command]"
    echo "Commands: playpause, next, previous, stop, play"
    exit 1
  ;;
esac
}

run $1
