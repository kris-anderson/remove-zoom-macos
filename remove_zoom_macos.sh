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

if [ -f "$HOME/Applications/zoom.us.app" ] || [ -d "$HOME/Applications/zoom.us.app" ]; then

    sudo rm -rf "$HOME/Applications/zoom.us.app"
    printf "Zoom app in %s/Applications/ " "$HOME"
    deleted

else

    printf "Zoom app in %s/Applications/ " "$HOME"
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

if [ -f "$HOME/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ] || [ -f "$HOME/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin" ]; then

    sudo rm -rf "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    printf "%s/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin " "$HOME"
    deleted

else

    printf "%s/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin " "$HOME"
    not_found

fi

# ~/.zoomus/
echo ""
echo -e "${BOLD}Removing extra cruft that Zoom leaves behind...${NORMAL}"

if [ -f "$HOME/.zoomus" ] || [ -d "$HOME/.zoomus" ]; then

    sudo rm -rf "$HOME/.zoomus"
    printf "%s/.zoomus " "$HOME"
    deleted

else

    printf "%s/.zoomus " "$HOME"
    not_found

fi

# ~/Library/Application\ Support/zoom.us

if [ -f "$HOME/Library/Application Support/zoom.us" ] || [ -d "$HOME/Library/Application Support/zoom.us" ]; then

    sudo rm -rf "$HOME/Library/Application Support/zoom.us/"
    printf "%s/Library/Application Support/zoom.us/ " "$HOME"
    deleted

else

    printf "%s/Library/Application Support/zoom.us/ " "$HOME"
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

if [ -f "$HOME/Library/Caches/us.zoom.xos" ] || [ -d "$HOME/Library/Caches/us.zoom.xos" ]; then

    sudo rm -rf "$HOME/Library/Caches/us.zoom.xos"
    printf "%s/Library/Caches/us.zoom.xos " "$HOME"
    deleted

else

    printf "%s/Library/Caches/us.zoom.xos " "$HOME"
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

if [ -f "$HOME/Library/Logs/zoom.us" ] || [ -d "$HOME/Library/Logs/zoom.us" ]; then

    sudo rm -rf "$HOME/Library/Logs/zoom.us"
    printf "%s/Library/Logs/zoom.us " "$HOME"
    deleted

else

    printf "%s/Library/Logs/zoom.us " "$HOME"
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

if [ -f "$HOME/Library/Logs/zoominstall.log" ] || [ -d "$HOME/Library/Logs/zoominstall.log" ]; then

    sudo rm -rf "$HOME/Library/Logs/zoominstall.log"
    printf "%s/Library/Logs/zoominstall.log " "$HOME"
    deleted

else

    printf "%s/Library/Logs/zoominstall.log " "$HOME"
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

if [ -f "$HOME/Library/Preferences/ZoomChat.plist" ] || [ -d "$HOME/Library/Preferences/ZoomChat.plist" ]; then

    sudo rm -rf "$HOME/Library/Preferences/ZoomChat.plist"
    printf "%s/Library/Preferences/ZoomChat.plist " "$HOME"
    deleted

else

    printf "%s/Library/Preferences/ZoomChat.plist " "$HOME"
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

if [ -f "$HOME/Library/Preferences/us.zoom.xos.plist" ] || [ -d "$HOME/Library/Preferences/us.zoom.xos.plist" ]; then

    sudo rm -rf "$HOME/Library/Preferences/us.zoom.xos.plist"
    printf "%s/Library/Preferences/us.zoom.xos.plist " "$HOME"
    deleted

else

    printf "%s/Library/Preferences/us.zoom.xos.plist " "$HOME"
    not_found

fi

# ~/Library/Saved Application State/us.zoom.xos.savedState

if [ -f "$HOME/Library/Saved Application State/us.zoom.xos.savedState" ] || [ -d "$HOME/Library/Saved Application State/us.zoom.xos.savedState" ]; then

    sudo rm -rf "$HOME/Library/Saved Application State/us.zoom.xos.savedState"
    printf "%s/Library/Saved Application State/us.zoom.xos.savedState " "$HOME"
    deleted

else

    printf "%s/Library/Saved Application State/us.zoom.xos.savedState " "$HOME"
    not_found

fi
