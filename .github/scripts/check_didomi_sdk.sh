#!/bin/bash

#----------------------------------------------------------
# Check iOS SDK version (latest from cocoapods)
#----------------------------------------------------------

currentVersion=$(sh .github/scripts/extract_current_ios_sdk_version.sh)
if [[ -z $currentVersion ]]; then
  echo "Error while getting ios SDK current version"
  exit 1
fi

lastVersion=$(sh .github/scripts/query_last_ios_sdk_version.sh)
if [[ -z $lastVersion ]]; then
  echo "Error while getting ios SDK version"
  exit 1
fi

if [[ "$currentVersion" == "$lastVersion" ]]; then
  echo "iOS SDK last version is $currentVersion, no change"
  exit 0
fi

# Confirm update
echo "yes"
