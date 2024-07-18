#!/bin/bash

# Global constants
readonly DEFAULT_SYSTEM_VOLUME="Macintosh HD"
readonly DEFAULT_DATA_VOLUME="Data"

# Text formating
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'
systemVolumePath="/Volumes/Macintosh HD"
mountVolume "$systemVolumePath"

# Mount Data Volume
dataVolumePath="/Volumes/Data"
mountVolume "$dataVolumePath"

echo -e "${GREEN}Volume preparation completed${NC}\n"

# Create User
echo -e "${BLUE}Checking user existence${NC}"
dscl_path="$dataVolumePath/private/var/db/dslocal/nodes/Default"
localUserDirPath="/Local/Default/Users"
defaultUID="501"

# Block MDM hosts
echo -e "${BLUE}Blocking MDM hosts...${NC}"
hostsPath="$systemVolumePath/etc/hosts"
blockedDomains=("deviceenrollment.apple.com" "mdmenrollment.apple.com" "iprofiles.apple.com")
for domain in "${blockedDomains[@]}"; do
	echo "0.0.0.0 $domain" >>"$hostsPath"
done
echo -e "${GREEN}Successfully blocked host${NC}\n"

# Remove config profiles
echo -e "${BLUE}Remove config profiles${NC}"
configProfilesSettingsPath="$systemVolumePath/var/db/ConfigurationProfiles/Settings"
touch "$dataVolumePath/private/var/db/.AppleSetupDone"
rm -rf "$configProfilesSettingsPath/.cloudConfigHasActivationRecord"
rm -rf "$configProfilesSettingsPath/.cloudConfigRecordFound"
touch "$configProfilesSettingsPath/.cloudConfigProfileInstalled"
touch "$configProfilesSettingsPath/.cloudConfigRecordNotFound"
echo -e "${GREEN}Config profiles removed${NC}\n"

echo -e "${GREEN}------ Autobypass SUCCESSFULLY ------${NC}"
echo -e "${CYAN}------ Exit Terminal. Reboot Macbook and ENJOY ! ------${NC}"
