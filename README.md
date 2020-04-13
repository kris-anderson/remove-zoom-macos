# remove-zoom-macos

A bash script for macOS that will completely uninstall the Zoom Desktop Client and all of the additional cruft it installs.

![shellcheck](https://img.shields.io/badge/shellcheck-pass-brightgreen "ShellCheck") ![issues](https://img.shields.io/github/issues/kris-anderson/remove-zoom-macos "Issues") ![script size](https://img.shields.io/github/size/kris-anderson/remove-zoom-macos/remove_zoom_macos.sh "Script Size") ![license type](https://img.shields.io/github/license/kris-anderson/remove-zoom-macos "License Type")

## Highlights

* Works on any macOS computer
* Can also be deployed via Jamf within your enterprise environment
* Provides helpful output letting you know what it found and deleted

## What it does

* Kills the Zoom process if it is running
* Removes the Zoom application from the `/Applications/` or `~/Applications/` directories
* Uninstalls the Zoom Audio Device
* Removes the Zoom Internet Plugin
* Removes a defaults value
* Removes the `~/.zoomus/` directory from your home directory
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
