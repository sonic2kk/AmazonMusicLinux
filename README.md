# Amazon Music Installer for Linux
This Bash script installs the Amazon Music Desktop App for Linux running through [Wine-GE](https://github.com/GloriousEggroll/wine-ge-custom) with some extra fonts and a `.desktop` file for system integration by default.

The release of Wine-GE used has been chosen as it works the best in my testing. It may not be the latest release but it should give the most stable. It may be bumped from time to time.

## Features
This script has various convenient features:
- It will download the Amazon Music installer, a compatible Wine-GE, install some extra fonts, and create a `.desktop` file for desktop integration
- An updater script to update the `.desktop` file should Wine ever break it (such as after an Amazon Music client update), or if duplicate entries ever appear
- An uninstallation script
- Aside from the `.desktop` file, **all** files are restricted to the installation folder, allowing for clean manual uninstallation

As this is the native Windows Amazon Music desktop app running through Wine, you can expect almost all of what you'd get on Windows:
- Ultra HD music playback
- Offline playback
- Automatic updates

Unfortunately, there are some missing features due to limitations in Wine:
- Media keys - Wine audio playback does not integrate into the system, so it cannot use media keys right now
- Amazon's Ember WOFF2 font is not used throughout the entire app, though it is used in some places. It may fall back to an ugly font depending on your system!

## Dependencies
The script should run on any major Linux desktop, though there are a few dependencies that must be met for the script to run properly:
- winetricks
- curl

## Installation
To install, download this repository and run `bash install.sh`. This may take a while, especially while installing fonts. Once it's done, Amazon Music may or may not open. After installation, Amazon Music can be launched again from your desktop environment's application launcher. Once installed, you are free to log in and use the Amazon Music app like normal.

More advanced users may wish to know some of the installation paths for manual uninstallation or other reasons:
- Amazon Music installs its executable and other such files to `/path/to/download/folder/pfx/drive_c/users/USER/AppData/Local/Amazon Music/`
- The `.desktop` file installs to `~/.local/share/applications/wine/Programs/Amazon Music/`
  - After running `install.sh`, `update_desktopfile.sh` or `uninstall.sh`, this is the path used for `update-desktop-database` to refresh the application list

Full documentation on script flags coming soon! For now, you can run `./install.sh --help` for more details.

## How It Works
By default, everything is downloaded and created in the folder that the `install.sh` script is located in.

This script downloads the Amazon Music Windows installer file from Amazon, and installs it using Wine-GE 7-6 (downloaded by the script) which is verified using its provided SHA-512 checksum. A new dedicated Wine prefix is created and winetricks is used to install some Chinese, Japanese and Korean fonts that may be missing. Once this is complete, Wine-GE runs the installer, and the `.desktop` file is updated so that Amazon Music can be cleanly launched from your application manager.

The script cleans up after itself, removing the Amazon Music Installer, and the Wine-GE tar and checksum. **Do not remove the `pfx/` folder or the Wine-GE folder**, as this is essentially your installation folder. Currently, there is no way to re-generate the `.desktop` file if you move the parent installation directory without reinstalling.

## Updating
It is safe to update Amazon Music through its installer, but you should run the included `update_desktopfile.sh` script afterwards so that you can continue to launch the Amazon Music app from your application launcher of choice.

If there is ever a duplicate entry in your application launcher for Amazon Music, or one is written to your desktop, this script should get rid of it also.

## Uninstall
The Uninstall executable installed with Amazon Music has not been tested and will likely not be supported. To uninstall, you can simply remove the `pfx/` folder from your installation folder, and remove the `.desktop` file with `rm -rf ~/.local/share/applications/wine/Programs/Amazon\ Music`.

## Planned Features
There are a number of planned features I hope to get around to:
- Add flags for various options, such as using an existing prefix, or an existing Wine version
- Ability to "reinstall" if parent directory changes
- Better checking for existing prefix, existing winetricks font installation, so that a reinstall can go much faster
- Better error handling
- Cleaner Terminal output

## Contributing
Contributions are welcome from anyone! If there are any bugs, dead links, or extra features that could be added (such as more fonts) feel free to open an issue or a pull request. If links or versions need bumped, feel free to open an issue about that too. And of course, any help with the planned features would be appreciated as well.

## License
This script is Free Software under the permissive MIT license. See LICENSE for further information.