#!/bin/bash

# Check if APK list file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <apk_list.txt>"
  exit 1
fi

APK_LIST_FILE="$1"

# Check if file exists
if [ ! -f "$APK_LIST_FILE" ]; then
  echo "Error: File '$APK_LIST_FILE' not found."
  exit 1
fi

# Check if adb is installed
if ! command -v adb &> /dev/null; then
  echo "Error: adb not found. Please install Android Platform Tools."
  exit 1
fi

# Check if a device is connected
if ! adb get-state 1>/dev/null 2>&1; then
  echo "Error: No Android device connected or authorized."
  exit 1
fi

# Read and install each APK from the text file
while IFS= read -r apk_path || [ -n "$apk_path" ]; do
  # Skip empty lines and comments
  if [[ -z "$apk_path" || "$apk_path" =~ ^# ]]; then
    continue
  fi

  # Trim whitespace
  apk_path=$(echo "$apk_path" | xargs)

  # Verify file exists
  if [ ! -f "$apk_path" ]; then
    echo "Warning: APK file '$apk_path' not found. Skipping."
    continue
  fi

  echo "Installing: $apk_path"
  adb install -r "$apk_path"
done < "$APK_LIST_FILE"

echo "Done installing all APKs."
