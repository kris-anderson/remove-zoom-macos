# remove-zoom-macos

A bash script for macOS that will completely uninstall the Zoom Desktop Client and all of the additional cruft it installs.

## Highlights

* Works on any macOS computer
* Can also be deployed via Jamf within your enterprise
* Provides helpful output letting you know what it found and deleted

## What it does

* Kills the Zoom process if it is running
* Removes the Zoom application from the `/Applications/` or `~/Applications/` folders
* Uninstalls the Zoom Audio Device
* Removes the Zoom Internet Plugin
* Removes the `~/.zoomus/` directory from your home folder
* Removes the cache directories Zoom uses
* Removes the log files Zoom uses
* Removes additional preferences and configuration files

## Why use this instead of the Zoom uninstaller

Do you trust Zoom to uninstall the application completely? Their uninstaller does kill the Zoom process and it removes the application from the default `/Applications/` directory. But it also leaves behind some extra stuff like Internet Plugins that still stay installed.

This script removes everything, and it gives you helpful output to tell you what it found and removed. You can safely run this script multiple times.

## Example Terminal Output

![terminal command screenshot](https://remove-zoom-macos.s3-us-west-2.amazonaws.com/images/terminal_screenshot_light.jpg "Terminal Screenshot Light Theme")

## Instructions

1. Download the `remove_zoom_macos.sh` script.

2. Open your terminal and `cd` into the directory where you downloaded the script. For example:

    ```shell
    cd ~/Downloads
    ```

3. Add execute permissions to the script.

    ```shell
    chmod +x remove_zoom_macos.sh
    ```

4. Run it.

    ```shell
    ./remove_zoom_macos.sh
    ```
