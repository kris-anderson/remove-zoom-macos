#!/usr/bin/env bash

# pretty colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_RED=$ESC_SEQ"31;01m"
if [[ $- == *i* ]]; then
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
fi

# helpers
function not_found() {
    echo -e "${COL_GREEN}[not found]${COL_RESET} " #"$1"
}

function deleted() {
    echo -e "${COL_YELLOW}[deleted]${COL_RESET} " #$1
}

function terminated() {
    echo -e "${COL_RED}[terminated]${COL_RESET} " #$1
}

loggedInUser=$(stat -f "%Su" /dev/console)

echo ""
echo -e "${BOLD}Please Note:${NORMAL} This script may prompt you for your password if it finds anything that needs to be removed."

# kill the Zoom process if it's running
echo ""
echo -e "${BOLD}Checking to see if the Zoom process is running...${NORMAL}"

if pgrep -i zoom >/dev/null; then

    sudo kill $(pgrep -i zoom)
    printf "Zoom process " 
    terminated

else

    printf "Zoom process " 
    not_found

fi

# remove the Zoom application from /Applications/ and ~/Applications/
echo ""
echo -e "${BOLD}Removing the Zoom Application...${NORMAL}"

if [ -f "/Applications/zoom.us.app" ] || [ -d "/Applications/zoom.us.app" ]; then

    sudo rm -rf "/Applications/zoom.us.app"
    printf "Zoom app in /Applications/ " 
    deleted

else

    printf "Zoom app in /Applications/ " 
    not_found

fi

if [ -f "/Users/$loggedInUser/Applications/zoom.us.app" ] || [ -d "/Users/$loggedInUser/Applications/zoom.us.app" ]; then

    sudo rm -rf "/Users/$loggedInUser/Applications/zoom.us.app"
    printf "Zoom app in /Users/%s/Applications/ " "$loggedInUser"
    deleted

else

    printf "Zoom app in /Users/%s/Applications/ " "$loggedInUser"
    not_found

fi

# /System/Library/Extensions/ZoomAudioDevice.kext
echo ""
echo -e "${BOLD}Removing the Zoom Audio Device...${NORMAL}"

if [ -f "/System/Library/Extensions/ZoomAudioDevice.kext" ] || [ -d "/System/Library/Extensions/ZoomAudioDevice.kext" ]; then

    sudo kextunload -b zoom.us.ZoomAudioDevice
    sudo rm -rf "/System/Library/Extensions/ZoomAudioDevice.kext"
    printf "/System/Library/Extensions/ZoomAudioDevice.kext file "
    deleted

else

    printf "/System/Library/Extensions/ZoomAudioDevice.kext file "
    not_found

fi

# /Library/Internet\ Plug-Ins/ZoomUsPlugIn.plugin
# ~/Library/Internet\ Plug-Ins/ZoomUsPlugIn.plugin
echo ""
echo -e "${BOLD}Removing Zoom Plugins...${NORMAL}"

if [ -f "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ] || [ -d "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ]; then

    sudo rm -rf "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    printf "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin "
    deleted

else

    printf "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ] || [ -f "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    printf "/Users/%s/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin " "$loggedInUser"
    not_found

fi

# ~/.zoomus/
echo ""
echo -e "${BOLD}Removing extra cruft that Zoom leaves behind...${NORMAL}"

if [ -f "/Users/$loggedInUser/.zoomus" ] || [ -d "/Users/$loggedInUser/.zoomus" ]; then

    sudo rm -rf "/Users/$loggedInUser/.zoomus"
    printf "/Users/%s/.zoomus " "$loggedInUser"
    deleted

else

    printf "/Users/%s/.zoomus " "$loggedInUser"
    not_found

fi

# ~/Library/Application\ Support/zoom.us

if [ -f "/Users/$loggedInUser/Library/Application Support/zoom.us" ] || [ -d "/Users/$loggedInUser/Library/Application Support/zoom.us" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Application Support/zoom.us/"
    printf "/Users/%s/Library/Application Support/zoom.us/ " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Application Support/zoom.us/ " "$loggedInUser"
    not_found

fi

# /Library/Caches/us.zoom.xos
# ~/Library/Caches/us.zoom.xos

if [ -f "/Library/Caches/us.zoom.xos" ] || [ -d "/Library/Caches/us.zoom.xos" ]; then

    sudo rm -rf "/Library/Caches/us.zoom.xos"
    printf "/Library/Caches/us.zoom.xos "
    deleted

else

    printf "/Library/Caches/us.zoom.xos "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Caches/us.zoom.xos" ] || [ -d "/Users/$loggedInUser/Library/Caches/us.zoom.xos" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Caches/us.zoom.xos"
    printf "/Users/%s/Library/Caches/us.zoom.xos " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Caches/us.zoom.xos " "$loggedInUser"
    not_found

fi

# /Library/Logs/zoom.us
# ~/Library/Logs/zoom.us

if [ -f "/Library/Logs/zoom.us" ] || [ -d "/Library/Logs/zoom.us" ]; then

    sudo rm -rf "/Library/Logs/zoom.us"
    printf "/Library/Logs/zoom.us "
    deleted

else

    printf "/Library/Logs/zoom.us "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Logs/zoom.us" ] || [ -d "/Users/$loggedInUser/Library/Logs/zoom.us" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Logs/zoom.us"
    printf "/Users/%s/Library/Logs/zoom.us " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Logs/zoom.us " "$loggedInUser"
    not_found

fi

# /Library/Logs/zoominstall.log
# ~/Library/Logs/zoominstall.log

if [ -f "/Library/Logs/zoominstall.log" ] || [ -d "/Library/Logs/zoominstall.log" ]; then

    sudo rm -rf "/Library/Logs/zoominstall.log"
    printf "/Library/Logs/zoominstall.log "
    deleted

else

    printf "/Library/Logs/zoominstall.log "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Logs/zoominstall.log" ] || [ -d "/Users/$loggedInUser/Library/Logs/zoominstall.log" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Logs/zoominstall.log"
    printf "/Users/%s/Library/Logs/zoominstall.log " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Logs/zoominstall.log " "$loggedInUser"
    not_found

fi

# /Library/Preferences/ZoomChat.plist
# ~/Library/Preferences/ZoomChat.plist

if [ -f "/Library/Preferences/ZoomChat.plist" ] || [ -f "/Library/Preferences/ZoomChat.plist" ]; then

    sudo rm -rf "/Library/Preferences/ZoomChat.plist"
    printf "/Library/Preferences/ZoomChat.plist "
    deleted

else

    printf "/Library/Preferences/ZoomChat.plist "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist" ] || [ -d "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist"
    printf "/Users/%s/Library/Preferences/ZoomChat.plist " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Preferences/ZoomChat.plist " "$loggedInUser"
    not_found

fi

# /Library/Preferences/us.zoom.xos.plist
# ~/Library/Preferences/us.zoom.xos.plist

if [ -f "/Library/Preferences/us.zoom.xos.plist" ] || [ -d "/Library/Preferences/us.zoom.xos.plist" ]; then

    sudo rm -rf "/Library/Preferences/us.zoom.xos.plist"
    printf "/Library/Preferences/us.zoom.xos.plist "
    deleted

else

    printf "/Library/Preferences/us.zoom.xos.plist "
    not_found

fi

if [ -f "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist" ] || [ -d "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist"
    printf "/Users/%s/Library/Preferences/us.zoom.xos.plist " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Preferences/us.zoom.xos.plist " "$loggedInUser"
    not_found

fi

# ~/Library/Saved Application State/us.zoom.xos.savedState

if [ -f "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState" ] || [ -d "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState"
    printf "/Users/%s/Library/Saved Application State/us.zoom.xos.savedState " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Saved Application State/us.zoom.xos.savedState " "$loggedInUser"
    not_found

fi

# ~/Library/Cookies/us.zoom.xos.binarycookies

if [ -f "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies" ] || [ -d "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies" ]; then

    sudo rm -rf "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies"
    printf "/Users/%s/Library/Cookies/us.zoom.xos.binarycookies " "$loggedInUser"
    deleted

else

    printf "/Users/%s/Library/Cookies/us.zoom.xos.binarycookies " "$loggedInUser"
    not_found

fi
