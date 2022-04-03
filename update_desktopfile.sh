#####
# This file is useful to run after updating the app
# It corrects the Icon and wine path of the .desktop file
#
# Should be run in the folder Amazon Music was downloaded to
#####

echo "Updating .desktop file..."
rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music/Amazon Music.desktop"
rm -rf "$HOME/.local/share/applications/wine/Programs/Amazon Music.desktop"
rm -rf "$HOME/Desktop/Amazon Music.lnk"
rm -rf "$HOME/Desktop/Amazon Music.desktop"
cp "Amazon Music.desktop" "$HOME/.local/share/applications/wine/Programs/Amazon Music/Amazon Music.desktop"
update-desktop-database "$HOME/.local/share/applications" &>/dev/null
echo "Successfully updated .desktop file."

