#!/usr/bin/env bash

######################
### make it pretty ###
######################

if [ -t 1 ]; then
    BLACK=$(tput setaf 0)
    BLUE=$(tput setaf 4)
    BOLD=$(tput bold)
    CYAN=$(tput setaf 6)
    GREEN=$(tput setaf 2)
    MAGENTA=$(tput setaf 5)
    RED=$(tput setaf 1)
    RESET=$(tput sgr0)
    UNDERLINE=$(tput smul)
    WHITE=$(tput setaf 7)
    YELLOW=$(tput setaf 3)
else
    BLACK=""
    BLUE=""
    BOLD=""
    CYAN=""
    GREEN=""
    MAGENTA=""
    RED=""
    RESET=""
    UNDERLINE=""
    WHITE=""
    YELLOW=""
fi

export BLACK
export BLUE
export BOLD
export CYAN
export GREEN
export MAGENTA
export RED
export RESET
export UNDERLINE
export WHITE
export YELLOW

###############
### helpers ###
###############

header() {
    printf "\n%s%s" "${BOLD}" "${BLUE}"
    printf "===========================================================\n"
    printf " (⌐■_■) %s\n" "$1"
    printf "===========================================================\n"
    printf "%s" "${RESET}"
}

not_found() {
    printf "%s%s[not found]%s " "${BOLD}" "${GREEN}" "${RESET}"
}

deleted() {
    printf "%s%s[deleted]%s " "${BOLD}" "${YELLOW}" "${RESET}"
}

terminated() {
    printf "%s%s[terminated]%s " "${BOLD}" "${RED}" "${RESET}"
}

loggedInUser=$(stat -f "%Su" /dev/console)

###################
### remove zoom ###
###################

# prompt the user for their password if required

echo ""
echo -e "${BOLD}Please Note:${RESET} This script will prompt for your password if you are not already running as sudo."

sudo -v

header "Zoom Desktop Application"

# kill the Zoom process if it's running

echo ""
echo -e "${BOLD}Checking to see if the Zoom process is running...${RESET}"

if pgrep -i zoom &>/dev/null; then

    sudo kill "$(pgrep -i zoom)"
    terminated
    printf "Zoom process\n"

else

    not_found
    printf "Zoom process\n"

fi

# remove the Zoom application

echo ""
echo -e "${BOLD}Removing the Zoom Application...${RESET}"

declare -a ZOOM_APPLICATION=(
    "/Applications/zoom.us.app"
    "/Users/$loggedInUser/Applications/zoom.us.app"
)

for ENTRY in "${ZOOM_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

# unload the Zoom Audio Device and remove the kext file

echo ""
echo -e "${BOLD}Removing the Zoom Audio Device...${RESET}"

if [ -f "/System/Library/Extensions/ZoomAudioDevice.kext" ] || [ -d "/System/Library/Extensions/ZoomAudioDevice.kext" ]; then

    sudo kextunload -b zoom.us.ZoomAudioDevice
    sudo rm -rf "/System/Library/Extensions/ZoomAudioDevice.kext"
    deleted
    printf "/System/Library/Extensions/ZoomAudioDevice.kext file\n"

else

    not_found
    printf "/System/Library/Extensions/ZoomAudioDevice.kext file\n"

fi

declare -a ZOOM_AUDIO_DEVICE=(
    "/Library/Audio/Plug-Ins/HAL/ZoomAudioDevice.driver"
)

for ENTRY in "${ZOOM_AUDIO_DEVICE[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

# remove the Zoom Plugin

echo ""
echo -e "${BOLD}Removing Zoom Plugins...${RESET}"

declare -a ZOOM_PLUGIN=(
    "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
)

for ENTRY in "${ZOOM_PLUGIN[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

# remove Zoom defaults

echo ""
echo -e "${BOLD}Removing Zoom defaults preferences...${RESET}"

if ! sudo defaults read us.zoom.xos 2>&1 | grep -Eq "Domain us.zoom.xos does not exist"; then

    sudo defaults delete us.zoom.xos
    deleted
    printf "sudo defaults read us.zoom.xos\n"

else

    not_found
    printf "sudo defaults read us.zoom.xos\n"

fi

echo ""
echo -e "${BOLD}Removing pkgutil history...${RESET}"

if pkgutil --pkgs | grep -Eq "us.zoom.pkg.videmeeting"; then

    sudo pkgutil --forget us.zoom.pkg.videmeeting &>/dev/null
    deleted
    printf "pkgutil history for us.zoom.pkg.videmeeting\n"

else

    not_found
    printf "pkgutil history for us.zoom.pkg.videmeeting\n"

fi

# remove extra Zoom cruft

echo ""
echo -e "${BOLD}Removing extra cruft that Zoom leaves behind...${RESET}"

declare -a ZOOM_CRUFT=(
    "/Library/Caches/us.zoom.xos"
    "/Library/Logs/DiagnosticReports/zoom.us*"
    "/Library/Logs/zoom.us"
    "/Library/Logs/zoominstall.log"
    "/Library/Preferences/us.zoom.xos.plist"
    "/Library/Preferences/ZoomChat.plist"
    "/Users/$loggedInUser/.zoomus"
    "/Users/$loggedInUser/Desktop/Zoom"
    "/Users/$loggedInUser/Documents/Zoom"
    "/Users/$loggedInUser/Library/Application Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings.plist"
    "/Users/$loggedInUser/Library/Application Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings"
    "/Users/$loggedInUser/Library/Application Support/CrashReporter/zoom.us*"
    "/Users/$loggedInUser/Library/Application Support/zoom.us"
    "/Users/$loggedInUser/Library/Caches/us.zoom.xos"
    "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies"
    "/Users/$loggedInUser/Library/Logs/zoom.us"
    "/Users/$loggedInUser/Library/Logs/zoominstall.log"
    "/Users/$loggedInUser/Library/Logs/ZoomPhone"
    "/Users/$loggedInUser/Library/Mobile Documents/iCloud~us~zoom~videomeetings"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.airhost.plist"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.Hotkey.plist"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist"
    "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist"
    "/Users/$loggedInUser/Library/Safari/PerSiteZoomPreferences.plist"
    "/Users/$loggedInUser/Library/SafariTechnologyPreview/PerSiteZoomPreferences.plist"
    "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState"
)

for ENTRY in "${ZOOM_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

echo ""
echo -e "${BOLD}Removing package receipts for Zoom...${RESET}"

declare -a ZOOM_CLIENT_RECEIPTS=(
    "/private/var/db/receipts/us.zoom.pkg.videmeeting.bom"
    "/private/var/db/receipts/us.zoom.pkg.videmeeting.plist"
)

for ENTRY in "${ZOOM_CLIENT_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

#############################
### remove outlook plugin ###
#############################

header "Zoom Outlook Plugin"

echo ""
echo -e "${BOLD}Killing Zoom Outlook Plugin Launcher if running...${RESET}"

# kill PluginLauncher if running

if pgrep -i PluginLauncher &>/dev/null; then

    sudo kill "$(pgrep -i PluginLauncher)"
    terminated
    printf "Zoom PluginLauncher process\n"

else

    not_found
    printf "Zoom PluginLauncher process\n"

fi

echo ""
echo -e "${BOLD}Unloading Zoom Outlook Plugin LaunchAgent...${RESET}"

# Unload pluginagent LaunchAgent if zOutlookPluginAgent running

if pgrep -i zOutlookPluginAgent &>/dev/null; then

    sudo su - "$loggedInUser" -c "/bin/launchctl unload -wF /Library/LaunchAgents/us.zoom.pluginagent.plist" &>/dev/null
    terminated
    printf "Zoom OutlookPlugin Agent process\n"

else

    not_found
    printf "Zoom OutlookPlugin Agent process\n"

fi

echo ""
echo -e "${BOLD}Deleting Zoom Outlook Plugin folders...${RESET}"

# delete ZoomOutlook plugin folder

declare -a ZOOM_OUTLOOK_APPLICATION=(
    "/Applications/ZoomOutlookPlugin"
    "/Users/$loggedInUser/Applications/ZoomOutlookPlugin"
)

for ENTRY in "${ZOOM_OUTLOOK_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

echo ""
echo -e "${BOLD}Cleaning up Zoom Outlook Plugin cruft...${RESET}"
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
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

echo ""
echo -e "${BOLD}Removing pkgutil history for Zoom Outlook Plugin...${RESET}"

if pkgutil --pkgs | grep -Eq "ZoomMacOutlookPlugin.pkg"; then

    sudo pkgutil --forget ZoomMacOutlookPlugin.pkg &>/dev/null
    deleted
    printf "pkgutil history for ZoomMacOutlookPlugin.pkg\n"

else

    not_found
    printf "pkgutil history for ZoomMacOutlookPlugin.pkg\n"

fi

echo ""
echo -e "${BOLD}Removing package receipts for Zoom Outlook Plugin...${RESET}"

declare -a ZOOM_OUTLOOK_RECEIPTS=(
    "/private/var/db/receipts/ZoomMacOutlookPlugin.pkg.bom"
    "/private/var/db/receipts/ZoomMacOutlookPlugin.pkg.plist"
)

for ENTRY in "${ZOOM_OUTLOOK_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

exit 0
