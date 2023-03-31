#!/bin/bash

#----------------------------------------------------------
# Get iOS SDK last version (latest from cocoapods)
#----------------------------------------------------------

lastVersion=""
for line in $(pod trunk info Didomi-XCFramework); do
  if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    lastVersion=$line
  fi
done

if [[ ! $lastVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting last iOS version"
  exit 1
fi

echo "$lastVersion"
