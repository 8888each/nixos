#!/usr/bin/env bash
# ~/.dotfiles/home-manager/modules/waybar/scripts/language-updater.sh
FLAG_FILE="/tmp/waybar_language_flag"

# Switch to the next layout
hyprctl dispatch keyboard next_layout

# Allow a brief moment for the layout change to register
sleep 0.1

# Get the current layout; adjust this command as needed for your Hyprland config
layout=$(hyprctl getinputs -j | jq -r '.[0].xkb_active_layout_name')

# Map the layout to a flag; customize as needed
case "$layout" in
  us|en)
    flag="🇺🇸"
    ;;
  ru)
    flag="🇷🇺"
    ;;
  *)
    flag=""
    ;;
esac

# Write the flag to the file
echo "$flag" > "$FLAG_FILE"

# After 5 seconds, clear the flag
(sleep 5 && echo "" > "$FLAG_FILE") &
