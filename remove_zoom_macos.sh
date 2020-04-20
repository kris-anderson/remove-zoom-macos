#!/usr/bin/env bash

######################
### make it pretty ###
######################

if [ "$TERM" == "dumb" ]; then
    COL_RESET=""
    COL_GREEN=""
    COL_YELLOW=""
    COL_RED=""
    BOLD=""
    NORMAL=""
else
    ESC_SEQ="\x1b["
    COL_RESET=$ESC_SEQ"39;49;00m"
    COL_GREEN=$ESC_SEQ"32;01m"
    COL_YELLOW=$ESC_SEQ"33;01m"
    COL_RED=$ESC_SEQ"31;01m"
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
fi

###############
### helpers ###
###############

function not_found() {
    echo -e "${COL_GREEN}[not found]${COL_RESET} " #$1
}

function deleted() {
    echo -e "${COL_YELLOW}[deleted]${COL_RESET} " #$1
}

function terminated() {
    echo -e "${COL_RED}[terminated]${COL_RESET} " #$1
}

loggedInUser=$(stat -f "%Su" /dev/console)

###################
### remove zoom ###
###################

# prompt the user for their password if required

echo ""
echo -e "${BOLD}Please Note:${NORMAL} This script will prompt for your password if you are not already running as sudo."

sudo -v

# kill the Zoom process if it's running

echo ""
echo -e "${BOLD}Checking to see if the Zoom process is running...${NORMAL}"

if pgrep -i zoom >/dev/null; then

    sudo kill "$(pgrep -i zoom)"
    printf "Zoom process "
    terminated

else

    printf "Zoom process "
    not_found

fi

# remove the Zoom application

echo ""
echo -e "${BOLD}Removing the Zoom Application...${NORMAL}"

declare -a ZOOM_APPLICATION=(
    "/Applications/zoom.us.app"
    "/Users/$loggedInUser/Applications/zoom.us.app"
)

for ENTRY in "${ZOOM_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done

# unload the Zoom Audio Device and remove the kext file

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

# remove the Zoom Plugin

echo ""
echo -e "${BOLD}Removing Zoom Plugins...${NORMAL}"

declare -a ZOOM_PLUGIN=(
    "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
)

for ENTRY in "${ZOOM_PLUGIN[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done

# remove Zoom defaults

echo ""
echo -e "${BOLD}Removing Zoom defaults preferences...${NORMAL}"

if ! sudo defaults read us.zoom.xos 2>&1 | grep -Eq "Domain us.zoom.xos does not exist"; then

    sudo defaults delete us.zoom.xos
    printf "sudo defaults read us.zoom.xos "
    deleted

else

    printf "sudo defaults read us.zoom.xos "
    not_found

fi

echo ""
echo -e "${BOLD}Removing pkgutil history...${NORMAL}"

if pkgutil --pkgs | grep -Eq "us.zoom.pkg.videmeeting"; then

    sudo pkgutil --forget us.zoom.pkg.videmeeting &> /dev/null
    printf "pkgutil history for us.zoom.pkg.videmeeting "
    deleted

else

    printf "pkgutil history for us.zoom.pkg.videmeeting "
    not_found

fi

# remove extra Zoom cruft

echo ""
echo -e "${BOLD}Removing extra cruft that Zoom leaves behind...${NORMAL}"

declare -a ZOOM_CRUFT=(
    "/Users/$loggedInUser/.zoomus"
    "/Users/$loggedInUser/Library/Application Support/zoom.us"
    "/Library/Caches/us.zoom.xos"
    "/Users/$loggedInUser/Library/Caches/us.zoom.xos"
    "/Library/Logs/zoom.us"
    "/Users/$loggedInUser/Library/Logs/zoom.us"
    "/Library/Logs/zoominstall.log"
    "/Users/$loggedInUser/Library/Logs/zoominstall.log"
    "/Library/Preferences/ZoomChat.plist"
    "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist"
    "/Library/Preferences/us.zoom.xos.plist"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist"
    "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState"
    "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies"
)

for ENTRY in "${ZOOM_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi

done

echo ""
echo -e "${BOLD}Removing package receipts for Zoom...${NORMAL}"

declare -a ZOOM_CLIENT_RECEIPTS=(
    "/private/var/db/receipts/us.zoom.pkg.videmeeting.bom"
    "/private/var/db/receipts/us.zoom.pkg.videmeeting.plist"
)

for ENTRY in "${ZOOM_CLIENT_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi

done

#############################
### remove outlook plugin ###
#############################

echo ""
echo -e "${BOLD}Killing Zoom OL Plugin Launcher if running...${NORMAL}"

# kill PluginLauncher if running

if pgrep -i PluginLauncher >/dev/null; then

    sudo kill "$(pgrep -i PluginLauncher)"
    printf "Zoom PluginLauncher process "
    terminated

else

    printf "Zoom PluginLauncher process "
    not_found

fi

echo ""
echo -e "${BOLD}Unloading Zoom OL Plugin LaunchAgent...${NORMAL}"

# Unload pluginagent LaunchAgent if zOutlookPluginAgent running

if pgrep -i zOutlookPluginAgent >/dev/null; then
    if [ $(whoami) == root ]; then
        echo -e "I am root"
        su - "$loggedInUser" -c "/bin/launchctl unload -wF /Library/LaunchAgents/us.zoom.pluginagent.plist"
        printf "Zoom OutlookPlugin Agent process "
        terminated
    else
        echo "I am user"
        /bin/launchctl unload -wF /Library/LaunchAgents/us.zoom.pluginagent.plist
        printf "Zoom OutlookPlugin Agent process "
        terminated
    fi
else

    printf "Zoom OutlookPlugin Agent process "
    not_found

fi

echo ""
echo -e "${BOLD}Deleting Zoom OL Plugin folders...${NORMAL}"

# delete ZoomOutlook plugin folder

declare -a ZOOM_OUTLOOK_APPLICATION=(
    "/Applications/ZoomOutlookPlugin"
    "/Users/$loggedInUser/Applications/ZoomOutlookPlugin"
)

for ENTRY in "${ZOOM_OUTLOOK_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done


echo ""
echo -e "${BOLD}Cleaning up Zoom OL Plugin cruft...${NORMAL}"
# cleanup Zoom Outlook plugin cruft

declare -a ZOOM_OUTLOOK_CRUFT=(
    "/Library/LaunchAgents/us.zoom.pluginagent.plist"
    "/Library/ScriptingAdditions/zOLPluginInjection.osax"
    "/Users/Shared/ZoomOutlookPlugin"
    "/Library/Application Support/Microsoft/ZoomOutlookPlugin"
    "/Users/$loggedInUser/Library/Logs/zoomoutlookplugin.log"

)

for ENTRY in "${ZOOM_OUTLOOK_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi

done

echo ""
echo -e "${BOLD}Removing pkgutil history for Zoom OL Plugin...${NORMAL}"

if pkgutil --pkgs | grep -Eq "ZoomMacOutlookPlugin.pkg"; then

    sudo pkgutil --forget ZoomMacOutlookPlugin.pkg &> /dev/null
    printf "pkgutil history for ZoomMacOutlookPlugin.pkg "
    deleted

else

    printf "pkgutil history for ZoomMacOutlookPlugin.pkg "
    not_found

fi

echo ""
echo -e "${BOLD}Removing package receipts for Zoom OL Plugin...${NORMAL}"

declare -a ZOOM_OL_RECEIPTS=(
    "/private/var/db/receipts/ZoomMacOutlookPlugin.pkg.bom"
    "/private/var/db/receipts/ZoomMacOutlookPlugin.pkg.plist"
)

for ENTRY in "${ZOOM_OL_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi

done

exit 0
