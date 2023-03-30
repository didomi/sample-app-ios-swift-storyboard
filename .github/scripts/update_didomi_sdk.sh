#!/bin/bash

#----------------------------------------------------------
# Update iOS SDK version (latest from cocoapods)
#----------------------------------------------------------

lastVersion=$(sh .github/scripts/query_last_ios_sdk_version.sh)
if [[ -z $lastVersion ]]; then
  echo "Error while getting ios SDK version"
  exit 1
fi

echo "iOS SDK last version is $lastVersion"

sed -i~ -e "s|pod 'Didomi-XCFramework', '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|pod 'Didomi-XCFramework', '$lastVersion'|g" Podfile || exit 1

# Cleanup backup files
find . -type f -name '*~' -delete

pod update || exit 1
