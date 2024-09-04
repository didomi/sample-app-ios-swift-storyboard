#!/bin/bash

#----------------------------------------------------------
# Get iOS SDK last version (latest from cocoapods)
#----------------------------------------------------------

# Get last version from pod
pod_last_version() {
  version=""
  temp_file=$(mktemp)
  pod trunk info Didomi-XCFramework > "$temp_file"

  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+) ]]; then
      current_version="${BASH_REMATCH[1]}"
      if [[ -z "$version" || $(printf '%s\n' "$version" "$current_version" | sort -V | tail -n1) == "$current_version" ]]; then
        version=$current_version
      fi
    fi
  done < "$temp_file"

  rm "$temp_file"
  echo "$version"
}

lastVersion=$(pod_last_version)

if [[ ! $lastVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting last iOS version ($lastVersion)"
  exit 1
fi

echo "$lastVersion"
