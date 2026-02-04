#!/bin/sh

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Fast path: use FOCUSED_WORKSPACE from the event trigger
  if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on
  else
    sketchybar --set "$NAME" background.drawing=off
  fi
else
  # Initial load (sketchybar --update): query aerospace directly
  FOCUSED=$(aerospace list-workspaces --focused)
  if [ "$1" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" background.drawing=on
  else
    sketchybar --set "$NAME" background.drawing=off
  fi
fi
