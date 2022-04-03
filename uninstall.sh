#!/bin/bash

#####
# This file will remove the following:
# 1. The Wine prefix where Amazon Music is installed
# 2. The Wine-GE installation used to run Amazon Music
# 3. The "Amazon Music" directory containing the "Amazon Music.desktop"
#    and "Uninstall Amazon Music.desktop" files located at ~/.local/share/applications/wine/Programs
#
# Make sure it is located in the same folder as the Wine prefix and Wine-GE folders!
# Flag to remove custom Wine prefixes and Wine-GE installation directories planned for the future!
#####

echo "Are you sure you want to uninstall [Y/n]"
read uninstall

echo "$uninstall"

if [ "$uninstall" == "Y" ]; then
  echo "Uninstalling..."
  rm -rf "pfx/"
  rm -rf "lutris-GE-Proton*"
  rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music/"
  update-desktop-database "$HOME/.local/share/applications"

  echo "Uninstall finished."
else
  echo "Uninstall cancelled, no files have been changed
fi
