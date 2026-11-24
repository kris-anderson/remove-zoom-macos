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

sub_header() {
    printf "\n%s%s...%s\n" "${BOLD}" "$1" "${RESET}"
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

###################
### prompt user ###
###################

loggedInUser=$(stat -f "%Su" /dev/console)
loggedInUserID=$(id -u "$loggedInUser")

# prompt the user for their password if required
printf "\n%sPlease Note:%s This script will prompt for your password if you are not already running as sudo.\n" "${BOLD}" "${RESET}"

sudo -v

####################
### kill process ###
####################

header "Zoom Desktop Application"

sub_header "Checking to see if the Zoom process is running"

if pgrep -i "zoom.us" &>/dev/null; then

    sudo kill "$(pgrep -i zoom.us)"
    terminated
    printf "Zoom process\n"

else

    not_found
    printf " Zoom process\n"

fi

##########################
### remove application ###
##########################

sub_header "Removing the Zoom Application"

declare -a ZOOM_APPLICATION=(
    /Applications/zoom.us.app
    /Users/"$loggedInUser"/Applications/zoom.us.app
)

for ENTRY in "${ZOOM_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

############################
### remove audio devices ###
############################

sub_header "Removing the Zoom Audio Devices"

if [ -f "/System/Library/Extensions/ZoomAudioDevice.kext" ] || [ -d "/System/Library/Extensions/ZoomAudioDevice.kext" ]; then

    sudo kextunload -b zoom.us.ZoomAudioDevice
    sudo rm -rf "/System/Library/Extensions/ZoomAudioDevice.kext"
    deleted
    printf "  /System/Library/Extensions/ZoomAudioDevice.kext file\n"

else

    not_found
    printf "/System/Library/Extensions/ZoomAudioDevice.kext file\n"

fi

declare -a ZOOM_AUDIO_DEVICE=(
    /Library/Audio/Plug-Ins/HAL/ZoomAudioDevice.driver
    /Library/Extensions/ZoomAudioDevice.kext
)

for ENTRY in "${ZOOM_AUDIO_DEVICE[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

######################
### remove plugins ###
######################

sub_header "Removing Zoom Plugins"

declare -a ZOOM_PLUGIN=(
    /Library/Internet\ Plug-Ins/ZoomUsPlugIn.plugin
    /Users/"$loggedInUser"/Library/Internet\ Plug-Ins/ZoomUsPlugIn.plugin
)

for ENTRY in "${ZOOM_PLUGIN[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

###################################
### remove defaults preferences ###
###################################

sub_header "Removing Zoom defaults preferences"

# run defaults as the logged-in user, inside their session, so it reaches their
# preferences (and the cfprefsd that caches them) even when this script runs as root
user_defaults() {
    sudo launchctl asuser "$loggedInUserID" sudo -u "$loggedInUser" defaults "$@"
}

ZOOM_DEFAULTS_DOMAINS=$(user_defaults domains 2>/dev/null | tr ',' '\n' | sed 's/^ *//' | grep -E '^(us\.zoom\..*|ZoomChat)$')

if [ -n "${ZOOM_DEFAULTS_DOMAINS}" ]; then

    while IFS= read -r DOMAIN; do
        user_defaults delete "${DOMAIN}" &>/dev/null
        deleted
        printf "  defaults domain %s\n" "${DOMAIN}"
    done <<<"${ZOOM_DEFAULTS_DOMAINS}"

else

    not_found
    printf "defaults domains us.zoom.* and ZoomChat\n"

fi

##############################
### remove pkgutil history ###
##############################

sub_header "Removing pkgutil history"

# Zoom has shipped both spellings: 4.6.18176.0301 used videomeeting,
# 4.6.19273.0402 used videmeeting, and current releases use videomeeting
declare -a ZOOM_PKG_IDS=(
    us.zoom.pkg.videmeeting
    us.zoom.pkg.videomeeting
)

for PKG_ID in "${ZOOM_PKG_IDS[@]}"; do
    if pkgutil --pkg-info "${PKG_ID}" &>/dev/null; then
        sudo pkgutil --forget "${PKG_ID}" &>/dev/null
        deleted
        printf "  pkgutil history for %s\n" "${PKG_ID}"
    else
        not_found
        printf "pkgutil history for %s\n" "${PKG_ID}"
    fi
done

##########################
### remove extra cruft ###
##########################

sub_header "Removing extra cruft that Zoom leaves behind"

declare -a ZOOM_CRUFT=(
    /Applications/.zoomusUpdateUseOnly
    /Library/Application\ Support/zoom.us/
    /Library/Caches/us.zoom.xos
    /Library/LaunchAgents/us.zoom.updater.delay.plist
    /Library/LaunchAgents/us.zoom.updater.login.check.plist
    /Library/LaunchAgents/us.zoom.updater.plist
    /Library/LaunchDaemons/us.zoom.updater.install.plist
    /Library/LaunchDaemons/us.zoom.ZMSipLocationHelper.plist
    /Library/LaunchDaemons/us.zoom.ZoomDaemon.plist
    /Library/Logs/DiagnosticReports/zoom.us*
    /Library/Logs/LocationInstall.log
    /Library/Logs/us.zoom.ZMSipLocationHelper
    /Library/Logs/zoom.us
    /Library/Logs/ZoomDaemon
    /Library/Logs/zoominstall.log
    /Library/Logs/ZoomUpdater
    /Library/Logs/zoomusinstall.log
    /Library/Managed\ Preferences/"$loggedInUser"/us.zoom.config.plist
    /Library/Managed\ Preferences/"$loggedInUser"/us.zoom.xos.AppInstaller.plist
    /Library/Managed\ Preferences/us.zoom.config.plist
    /Library/Managed\ Preferences/us.zoom.xos.AppInstaller.plist
    /Library/Preferences/us.zoom.config.plist
    /Library/Preferences/us.zoom.xos.plist
    /Library/Preferences/ZoomChat.plist
    /Library/PrivilegedHelperTools/us.zoom.ZMSipLocationHelper
    /Library/PrivilegedHelperTools/us.zoom.ZoomDaemon
    /private/var/folders/*/*/*/us.zoom.aomhost
    /private/var/folders/*/*/*/us.zoom.caphost
    /private/var/folders/*/*/*/us.zoom.CptHost
    /private/var/folders/*/*/*/us.zoom.updater
    /private/var/folders/*/*/*/us.zoom.xos
    /private/var/folders/*/*/*/us.zoom.ZoomAutoUpdater
    /private/var/folders/*/*/*/us.zoom.ZoomClips
    /Users/"$loggedInUser"/.zoomus
    /Users/"$loggedInUser"/Desktop/Zoom
    /Users/"$loggedInUser"/Documents/Zoom
    /Users/"$loggedInUser"/Library/Application\ Scripts/*.ZoomClient3rd
    /Users/"$loggedInUser"/Library/Application\ Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings
    /Users/"$loggedInUser"/Library/Application\ Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings.plist
    /Users/"$loggedInUser"/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/us.zoom*.sfl*
    /Users/"$loggedInUser"/Library/Application\ Support/com.zoom.screenshot
    /Users/"$loggedInUser"/Library/Application\ Support/CrashReporter/zoom.us*
    /Users/"$loggedInUser"/Library/Application\ Support/zCCIMeetingHost
    /Users/"$loggedInUser"/Library/Application\ Support/zoom.us
    /Users/"$loggedInUser"/Library/Application\ Support/ZoomPhone
    /Users/"$loggedInUser"/Library/Application\ Support/ZoomUpdater
    /Users/"$loggedInUser"/Library/Caches/us.zoom.xos
    /Users/"$loggedInUser"/Library/Caches/us.zoom.ZoomMeeting
    /Users/"$loggedInUser"/Library/Cookies/us.zoom.xos.binarycookies
    /Users/"$loggedInUser"/Library/Group\ Containers/*.ZoomClient3rd
    /Users/"$loggedInUser"/Library/HTTPStorages/us.zoom.xos
    /Users/"$loggedInUser"/Library/HTTPStorages/us.zoom.xos.binarycookies
    /Users/"$loggedInUser"/Library/HTTPStorages/us.zoom.ZoomMeeting
    /Users/"$loggedInUser"/Library/HTTPStorages/us.zoom.ZoomMeeting.binarycookies
    /Users/"$loggedInUser"/Library/LaunchAgents/us.zoom.updater*.plist
    /Users/"$loggedInUser"/Library/Logs/us.zoom.ZoomBridge
    /Users/"$loggedInUser"/Library/Logs/us.zoom.ZoomOpener
    /Users/"$loggedInUser"/Library/Logs/us.zoom.ZoomUninstaller
    /Users/"$loggedInUser"/Library/Logs/zoom.us
    /Users/"$loggedInUser"/Library/Logs/zoominstall.log
    /Users/"$loggedInUser"/Library/Logs/ZoomPhone
    /Users/"$loggedInUser"/Library/Logs/ZoomUpdater
    /Users/"$loggedInUser"/Library/Logs/zoomusinstall.log
    /Users/"$loggedInUser"/Library/Logs/zzhost.log
    /Users/"$loggedInUser"/Library/Mobile\ Documents/iCloud~us~zoom~videomeetings
    /Users/"$loggedInUser"/Library/Preferences/us.zoom.*.plist*
    /Users/"$loggedInUser"/Library/Preferences/ZoomChat.plist
    /Users/"$loggedInUser"/Library/Preferences/ZoomChineseChat.plist
    /Users/"$loggedInUser"/Library/Receipts/us.zoom.pkg.videomeeting.bom
    /Users/"$loggedInUser"/Library/Receipts/us.zoom.pkg.videomeeting.plist
    /Users/"$loggedInUser"/Library/Receipts/us.zoom.pkg.videmeeting.bom
    /Users/"$loggedInUser"/Library/Receipts/us.zoom.pkg.videmeeting.plist
    /Users/"$loggedInUser"/Library/Saved\ Application\ State/us.zoom.xos.savedState
    /Users/"$loggedInUser"/Library/WebKit/us.zoom.xos
    /Users/"$loggedInUser"/Library/WebKit/us.zoom.ZoomMeeting
)

for ENTRY in "${ZOOM_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

###############################
### remove package receipts ###
###############################

sub_header "Removing Zoom package receipts"

declare -a ZOOM_CLIENT_RECEIPTS=(
    /private/var/db/receipts/us.zoom.pkg.videmeeting.bom
    /private/var/db/receipts/us.zoom.pkg.videmeeting.plist
    /private/var/db/receipts/us.zoom.pkg.videomeeting.bom
    /private/var/db/receipts/us.zoom.pkg.videomeeting.plist
    /private/var/db/receipts/us.zoom.xos.bom
    /private/var/db/receipts/us.zoom.xos.plist
)

for ENTRY in "${ZOOM_CLIENT_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi

done

######################
### outlook plugin ###
######################

header "Zoom Outlook Plugin"

###################################
### kill outlook plugin process ###
###################################

sub_header "Killing Zoom Outlook Plugin Launcher if running"

if pgrep -i PluginLauncher &>/dev/null; then

    sudo kill "$(pgrep -i PluginLauncher)"
    terminated
    printf "Zoom PluginLauncher process\n"

else

    not_found
    printf " Zoom PluginLauncher process\n"

fi

##########################################
### unload outlook plugin launch agent ###
##########################################

sub_header "Unloading Zoom Outlook Plugin LaunchAgent"

if pgrep -i zOutlookPluginAgent &>/dev/null; then

    sudo su - "$loggedInUser" -c "/bin/launchctl unload -wF /Library/LaunchAgents/us.zoom.pluginagent.plist" &>/dev/null
    terminated
    printf "Zoom OutlookPlugin Agent process\n"

else

    not_found
    printf " Zoom OutlookPlugin Agent process\n"

fi

#####################################
### remove outlook plugin folders ###
#####################################

sub_header "Deleting Zoom Outlook Plugin folders"

declare -a ZOOM_OUTLOOK_APPLICATION=(
    /Applications/ZoomOutlookPlugin
    /Users/"$loggedInUser"/Applications/ZoomOutlookPlugin
)

for ENTRY in "${ZOOM_OUTLOOK_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "%s\n" "  ${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

###################################
### remove outlook plugin cruft ###
###################################

sub_header "Cleaning up Zoom Outlook Plugin cruft"

declare -a ZOOM_OUTLOOK_CRUFT=(
    /Library/Application\ Support/Microsoft/ZoomOutlookPlugin
    /Library/LaunchAgents/us.zoom.pluginagent.plist
    /Library/ScriptingAdditions/zOLPluginInjection.osax
    /Users/"$loggedInUser"/Library/Logs/zoomoutlookplugin.log
    /Users/Shared/ZoomOutlookPlugin
)

for ENTRY in "${ZOOM_OUTLOOK_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

#############################################
### remove outlook plugin pkgutil history ###
#############################################

sub_header "Removing pkgutil history for Zoom Outlook Plugin"

if pkgutil --pkgs | grep -Eq "ZoomMacOutlookPlugin.pkg"; then

    sudo pkgutil --forget ZoomMacOutlookPlugin.pkg &>/dev/null
    deleted
    printf "  pkgutil history for ZoomMacOutlookPlugin.pkg\n"

else

    not_found
    printf "pkgutil history for ZoomMacOutlookPlugin.pkg\n"

fi

##############################################
### remove outlook plugin package receipts ###
##############################################

sub_header "Removing package receipts for Zoom Outlook Plugin"

declare -a ZOOM_OUTLOOK_RECEIPTS=(
    /private/var/db/receipts/ZoomMacOutlookPlugin.pkg.bom
    /private/var/db/receipts/ZoomMacOutlookPlugin.pkg.plist
)

for ENTRY in "${ZOOM_OUTLOOK_RECEIPTS[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        deleted
        printf "  %s\n" "${ENTRY}"
    else
        not_found
        printf "%s\n" "${ENTRY}"
    fi
done

exit 0
