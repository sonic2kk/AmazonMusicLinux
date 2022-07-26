#!/bin/bash

### This file will eventually actually run Amazon Music inside Wine
### The Amazon Music .desktop file will call out to this script, which will manage checking the Wine-GE version and updating accordingly on each run
### This also means each time the app is quit, the .desktop file will be re-created, which is useful if the application updates, so the user won't have to manually update the .desktop file 

source ./install.sh

function updateWineGE {
  # if WineGE folder exists then
  #   get WineGE version
  #   if WineGE version < version listed in install.sh then
  #     remove existing WineGE
  #     call downloadWineGE
  #   else
  #     WineGE version up to date
  #   end
  # else
  #   WineGE wasn't installed, something went wrong. Error out.
  # end
}

function updateDesktopFile {
  # Updates desktop file
  echo "Updating .desktop file..."
  rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music/Amazon Music.desktop"
  rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music.desktop"
  rm -rf "$HOME/Desktop/Amazon Music.lnk"
  rm -rf "$HOME/Desktop/Amazon Music.desktop"
  cp "Amazon Music.desktop" "$HOME/.local/share/applications/wine/Programs/Amazon Music/Amazon Music.desktop"
  update-desktop-database "$HOME/.local/share/applications" &>/dev/null
  echo "Successfully updated .desktop file."
}

updateWineGE
## Not sure if this even works... will need to test
# WINEPREFIX="$winepfx" $wineprog "C:\\\\\\\\users\\\\\\\\emma\\\\\\\\AppData\\\\\\\\Roaming\\\\\\\\Microsoft\\\\\\\\Windows\\\\\\\\Start\\\\ Menu\\\\\\\\Programs\\\\\\\\Amazon\\\\ Music\\\\\\\\Amazon\\\\ Music.lnk"
updateDesktopFile