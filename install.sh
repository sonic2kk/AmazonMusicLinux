#!/bin/bash

# Variables setup
SCRIPTNAME="Amazon Music Installer for Linux"
SCRIPTDESC="Downloads and runs the installer for Amazon Music on Linux using Wine-GE."

downloadURL="https://d2j9xt6n9dg5d3.cloudfront.net/win/2313210_f1997af515fa3be8ced90db43c9341f0/AmazonMusicInstaller.exe"
downloadPath="$(pwd)"
installerName="AmazonMusicLinux.exe"

wineGEVersion="7-6"
wineGEURL="https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton$wineGEVersion/wine-lutris-GE-Proton$wineGEVersion-x86_64.tar.xz"
wineGESumURL="https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton$wineGEVersion/wine-lutris-GE-Proton$wineGEVersion-x86_64.sha512sum"
wineGESumName="wine-lutris-GE-Proton$wineGEVersion-x86_64.sha512sum"
wineGETarname="wine-lutris-GE-Proton$wineGEVersion-x86_64.tar.xz"
wineGEDirname="lutris-GE-Proton$wineGEVersion-x86_64"

winepfx="$downloadPath/pfx/"
wineprog="$downloadPath/$wineGEDirname/bin/wine"

# Check options
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$SCRIPTNAME - $SCRIPTDESC"
      echo " "
      echo "options:"
      echo "-h,  --help                   Show help"
      echo "-u,  --url                    URL of installer, defaults to built-in link"
      echo "-i,  --installer-name         Name given to executable, defaults to 'AmazonMusicLinux.exe"
      exit 0
      ;;
    -u|--url*)
      shift
      if test $# -gt 0; then
        downloadURL=$1
      fi
      shift
      ;;
    -p|--path*)
      shift
      if test $# -gt 0; then
        downloadPath=$1
      fi
      shift
      ;;
    -i|--installer-name*)
      shift
      if test $# -gt 0; then
        installerName=$1

        fullFilename=$(basename -- $installerName)
        extension="${fullFilename##*.}"
        if [ $extension != "exe" ]; then
          echo "WARNING: installer name does not include '.exe', this will be appended."
          installerName="${fullFilename}.exe"
        fi
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Download installer
mkdir -p $downloadPath
if [ -f "$downloadPath/$installerName" ]; then 
  echo "Installer with the same name already exists, skipping..."
else
  echo "Downloading Amazon Music installer ($installerName) to $downloadPath..."
  curl "$downloadURL" --output "$downloadPath/$installerName"
  echo "Successfully downloaded Amazon Music Installer."
fi

# Download and extract Wine
if [ -d "$downloadPath/$wineGEDirname" ]; then 
  echo "Wine-GE already extracted, skipping..."
else
  # Download Wine
  if [ -f "$downloadPath/$wineGETarname" ]; then
    echo "Wine-GE already downloaded, skipping..."
  else
    echo "Downloading Wine-GE ($wineGETarname) from $wineGEURL..."
    curl -LJO "$wineGEURL" --output "$downloadPath/$wineGETarname"
    echo "Successfully downloaded Wine-GE to $downloadPath"
  fi
  
  # Download Sum
  if [ -f "$downloadPath/$wineGESumName" ]; then
    echo "Wine-GE sum already downloaded, skipping..."
  else
    echo "Downloading Wine-GE checksum..."
    curl -LJO "$wineGESumURL" --output "$downloadPath/$wineGESumName"
    echo "Successfully downloaded Wine-GE checksum."
  fi
  
  # Verify sum
  echo "Verifying Wine-GE archive integrity..."
  checksumResult=$(sha512sum -c "$downloadPath/$wineGESumName")
  
  if [ "$checksumResult" == "$wineGETarname: OK" ]; then
    echo "Successfully verified checksums."
  else
    echo "ERROR: Checksums did not match ($checksumResult). Aborting installation..."
    exit 1;
  fi
  
  echo "Extracting Wine-GE to $downloadPath..."
  tar -xf $wineGETarname
  echo "Successfully extracted Wine-GE to $downloadPath"
  
  echo "Removing Wine-GE tar..."
  rm -rf "$downloadPath/$wineGETarname"
  rm -rf "$downloadPath/$wineGESumName"
  echo "Successfully removed Wine-GE tar."
fi

# Create new wine prefix and install using downloaded Wine
echo "Installing fonts to Wine prefix ($winepfx)..."
WINEPREFIX="$winepfx" WINE="$wineprog" winetricks fakechinese fakejapanese fakekorean &>/dev/null  # not totally safe, should reevaluate
echo "Running installer..."
WINEPREFIX="$winepfx" $wineprog "$downloadPath/$installerName" &>/dev/null  # also not totally safe

# Amazon Music will complain if this file is not present in the AppData dir
touch "$winepfx/drive_c/users/$USER/AppData/Local/Amazon Music/update.ini"

# Remove dumb Powershell files, re-create Amazon Music desktop file so it runs with Wine-GE,
# and other misc cleanup
echo "Updating .desktop files..."
rm -rf "$HOME/.local/share/applications/wine/Programs/PowerShell"
rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music/Amazon Music.desktop"
rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music.desktop"
rm -rf "$HOME/Desktop/Amazon Music.lnk"
rm -rf "$HOME/Desktop/Amazon Music.desktop"
echo "[Desktop Entry]
Name=Amazon Music
Exec=env WINEPREFIX=\"$winepfx\" $wineprog C:\\\\\\\\users\\\\\\\\$USER\\\\\\\\AppData\\\\\\\\Roaming\\\\\\\\Microsoft\\\\\\\\Windows\\\\\\\\Start\\\\ Menu\\\\\\\\Programs\\\\\\\\Amazon\\\\ Music\\\\\\\\Amazon\\\\ Music.lnk
Type=Application
StartupNotify=true
Icon=$HOME/.local/share/icons/hicolor/256x256/apps/0068_Amazon Music.0.png
StartupWMClass=amazon music.exe" > "$downloadPath/Amazon Music.desktop"
cp "$downloadPath/Amazon Music.desktop" "$HOME/.local/share/applications/wine/Programs/Amazon Music/"
update-desktop-database "$HOME/.local/share/applications"
echo "Removing installer file..."
rm -rf "$downloadPath/$installerName"
echo "Successfully removed installer file."

echo ""
echo "Installation complete!"
echo ""
echo "Amazon Music installation and configuration files are available at: $winepfx/drive_c/users/$USER/AppData/Local/Amazon Music/"
exit 0
