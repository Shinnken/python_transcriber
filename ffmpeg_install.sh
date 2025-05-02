#!/bin/bash

# Script to download FFmpeg and add it to the PATH on Windows (using Git Bash)
#
# This script assumes you are running it in a Git Bash environment.
# It downloads a pre-built FFmpeg binary from gyan.dev, extracts it,
# and adds the bin directory to your user PATH.
#
# IMPORTANT: This script requires 'curl' and 'unzip' to be installed in your Git Bash environment.
#             Git Bash usually comes with curl, but you might need to install unzip separately
#             using pacman (if you have MSYS2 installed) or by other means.
#
# Installation Notes:
# 1.  Open Git Bash.
# 2.  Run this script. You can copy and paste it into your Git Bash terminal.
# 3.  The script will download FFmpeg, extract it to /c/ffmpeg, and add it to your PATH.
# 4.  You may need to restart your terminal or any applications that use FFmpeg for the
#     PATH changes to take effect.
# 5.  The script creates a directory /c/ffmpeg if it does not exist.  You can change this
#     if you want, by modifying the INSTALL_DIR variable.
#
#  Confirmation:
#  1. After the script finishes, open a new Git Bash terminal.
#  2. Type `ffmpeg -version` and press Enter.
#  3. If FFmpeg is correctly installed, you should see the FFmpeg version information.

# Set the installation directory
INSTALL_DIR="/c/ffmpeg"  # Changed to /c/ffmpeg for Windows-like path

# Set the FFmpeg version and download URL.  We'll try to get the latest.
# Note:  This URL structure is common, but it's best to check gyan.dev for the most current download location.
FFMPEG_VERSION="latest" # Set to latest, and then resolve.
BASE_URL="https://www.gyan.dev/ffmpeg/builds"

# Function to display messages
msg() {
  echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Check for required tools
command -v curl >/dev/null 2>&1 || { msg "ERROR: curl is required but not installed.  Please install it and try again."; exit 1; }
command -v unzip >/dev/null 2>&1 || { msg "ERROR: unzip is required but not installed.  Please install it and try again.  You might need to install it via pacman if you are using MSYS2."; exit 1; }

# Create the installation directory if it doesn't exist
msg "Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR" || { msg "ERROR: Failed to create installation directory.  Do you have write permissions?"; exit 1; }

# Determine the correct FFmpeg download URL.  This logic attempts to find the latest release.
# This is fragile, and the website structure can change.  A more robust solution would
# involve scraping the website or using an API if available.  This simple approach
# assumes a naming convention.
msg "Determining latest FFmpeg build URL..."

# Construct a URL.  This is a guess, and might need updating.
FFMPEG_URL=$(curl -s "$BASE_URL" | grep -oP 'href="\Kffmpeg-git-[\w.-]+-essentials\.zip' | head -n 1)

if [[ -z "$FFMPEG_URL" ]]; then
  msg "ERROR: Could not determine the latest FFmpeg download URL.  The download location or naming convention may have changed.  Please visit $BASE_URL to find the correct URL and update the script."
  exit 1
fi
FFMPEG_URL="$BASE_URL/$FFMPEG_URL"

msg "Downloading FFmpeg from: $FFMPEG_URL"
# Download FFmpeg
curl -L "$FFMPEG_URL" -o "$INSTALL_DIR/ffmpeg.zip" || { msg "ERROR: Failed to download FFmpeg.  Check your internet connection and the URL."; exit 1; }

# Extract FFmpeg
msg "Extracting FFmpeg to $INSTALL_DIR"
unzip -q "$INSTALL_DIR/ffmpeg.zip" -d "$INSTALL_DIR" || { msg "ERROR: Failed to extract FFmpeg.  Is the zip file valid?"; exit 1; }

# Add FFmpeg to the PATH.  This is the crucial part for Windows.
msg "Adding FFmpeg to your PATH"
# Get the existing PATH.  Important to not overwrite it.
OLD_PATH=$(reg query HKCU\Environment /v Path | awk '{print $3}')

# Extract the ffmpeg bin directory name.
FFMPEG_BIN_DIR=$(find "$INSTALL_DIR" -maxdepth 1 -type d -name "ffmpeg-*-essentials_build*" | head -n 1)
FFMPEG_BIN_PATH="$FFMPEG_BIN_DIR/bin"

# Add to PATH, avoiding duplicates.  Use a more robust check.
if [[ "$OLD_PATH" != *"$FFMPEG_BIN_PATH"* ]]; then
  NEW_PATH="$FFMPEG_BIN_PATH;$OLD_PATH" # Prepend, which is usually preferred.
  reg add HKCU\Environment /v Path /t REG_SZ /d "$NEW_PATH" /f || { msg "ERROR: Failed to add FFmpeg to the PATH."; exit 1; }
  msg "FFmpeg bin directory added to PATH: $FFMPEG_BIN_PATH"
else
  msg "FFmpeg bin directory is already in PATH."
fi

# Clean up (remove the zip file)
msg "Cleaning up downloaded zip file"
rm -f "$INSTALL_DIR/ffmpeg.zip"

msg "FFmpeg installation complete!"
msg "You may need to restart your terminal or applications for the changes to take effect."
msg "To verify the installation, open a new Git Bash terminal and type 'ffmpeg -version'."
