# remove-zoom-macos

![CI](https://github.com/kris-anderson/remove-zoom-macos/workflows/CI/badge.svg?branch=master&event=push) ![license type](https://img.shields.io/github/license/kris-anderson/remove-zoom-macos)

## Highlights

* Easy for anyone to run on macOS
* Provides helpful output letting you know what it found and deleted
* Can also be deployed via Jamf within your enterprise environment

## What it does

* Kills the Zoom process if it is running
* Removes the Zoom application from the `/Applications/` or `~/Applications/` directories
* Uninstalls the Zoom Audio Device
* Removes the Zoom Internet Plugin
* Removes a defaults value
* Removes the pkgutil history for Zoom
* Removes the `~/.zoomus/` directory from your home directory
* Removes the cache directories Zoom uses
* Removes the log files Zoom uses
* Removes additional preferences and configuration files

## Instructions

### Easy Method

1. Open your terminal and run this single command

   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kris-anderson/remove-zoom-macos/master/remove_zoom_macos.sh)"
   ```

### Manual Method

1. Open your terminal

2. Download the `remove_zoom_macos.sh` script

   ```shell
   wget https://raw.githubusercontent.com/kris-anderson/remove-zoom-macos/master/remove_zoom_macos.sh
   ```

3. Add execute permissions to the script

    ```shell
    chmod +x remove_zoom_macos.sh
    ```

4. Run the script

    ```shell
    ./remove_zoom_macos.sh
    ```

## Example Terminal Output

![remove zoom macos command screenshot 1](https://remove-zoom-macos.s3-us-west-2.amazonaws.com/images/remove_zoom_macos_terminal_output_1.jpg)

![remove zoom macos command screenshot 2](https://remove-zoom-macos.s3-us-west-2.amazonaws.com/images/remove_zoom_macos_terminal_output_2.jpg)

## Why this script exists

Zoom has not had a good track record with security and privacy. All software will have vulnerabilities at some point, so it's not fair to avoid a company for this reason alone. That being said, the way Zoom designs and develops their software is around ease of use over security, and their poor software design decisions, are the cause of their security vulnerabilities and privacy issues.

In 2019 Zoom installed a web server on macOS computers when you installed Zoom, and that server persisted even after you uninstalled the application. They did this to make re-installing Zoom easier for users, but it allowed any website to execute javascript to silently re-install zoom and enable your microphone and camera without your permission. This was such a serious vulnerability that Apple themselves pushed a silent fix for this using their MRT (Malware Removal Tool) to uninstall the Zoom web server from all macOS computers. Source: [2019 Zoom Vulnerability](https://www.schneier.com/blog/archives/2019/07/zoom_vulnerabil.html)

In 2020 two more vulnerabilities appeared, also due to Zoom making things easier for users at the expense of security. One of them allowed any person with access to the computer (or a piece of malware on the computer) to become the root user without a password. The other vulnerability allows for other applications on your mac to use code injection in order to piggyback on the permissions you granted to Zoom previously, allowing for those malicious applications to enable your camera and microphone without your permission. Source: [The 'S' in Zoom, Stands for Security](https://objective-see.com/blog/blog_0x56.html)

In 2022 a security researcher found a way that an attacker could leverage the macOS version of Zoom to gain access over the entire operating system. Source: [The Zoom installer let a researcher hack his way to root access on macOS](https://www.theverge.com/2022/8/12/23303411/zoom-defcon-root-access-privilege-escalation-hack-patrick-wardle)

Because of how Zoom develops their software, some people do not trust them, and would prefer not to run their software. I am one of those people, and this script was created for to aid in the complete removal of everything Zoom installs.

## Why use this instead of the Zoom uninstaller

### Normal user

If you're a normal user, you should be fine using the uninstaller built into Zoom. It doesn't uninstall everything, but it does kill the Zoom process and remove the application. Most applications leave behind some extra config and preferences files, and Zoom is no different. These files are usually harmless.

### Paranoid user

If you're paranoid and you want to ensure that everything Zoom installs is fully removed. It will uninstall everything the Zoom uninstaller would uninstall, plus the additional cruft like Internet Plugins, Audio Devices, preferences, and configs.

### MDM Administrator

If you manage a suite of macOS devices using an MDM provider like Jamf within your enterprise and you want to remove Zoom from those devices. You can also make it available in Jamf Self Service to allow your users to remove Zoom themselves.
