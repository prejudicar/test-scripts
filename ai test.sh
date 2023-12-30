#!/bin/sh

# Install brew if not present
if ! command -v brew &>/dev/null; then
  echo ">>> Installing brew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is set up in the PATH
if [ -z "$(command -v brew)" ]; then
  echo ">>> Executing brew shellenv ..."
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo '---'
echo '---'

echo 'Icon of the admin user:'
dscl . read /Users/Admin Picture
echo '---'
dscl . delete /Users/Admin Picture
dscl . delete /Users/Admin JPEGPhoto
if [ "$(sw_vers -productVersion)" "<" "13" ]; then
  dscl . create /Users/Admin Picture '/Library/User Pictures/Fun/Ying-Yang.png'
else
  dscl . create /Users/Admin Picture '/Library/User Pictures/Fun/Ying-Yang.heic'
fi

dscl . read /Users/Admin Picture
echo '---'
echo '---'
echo 'Appearance:'

echo '---'
echo '---'
echo '---'
echo 'Name of the computer:'
echo -n 'ComputerName: '
scutil --get ComputerName
echo -n 'LocalHostName: '
scutil --get LocalHostName
echo -n 'HostName: '
scutil --get HostName
echo '---'
echo 'Enter a ComputerName (UPPERCASE) ?'
read ComputerName
echo '---'
scutil --set ComputerName "${ComputerName}"
scutil --set LocalHostName "${ComputerName}"

echo -n 'ComputerName: '
scutil --get ComputerName
echo -n 'LocalHostName: '
scutil --get LocalHostName
echo -n 'HostName: '
scutil --get HostName
echo '---'
echo '---'
echo 'Appearance:'

echo '---'
echo '---'
echo 'Software upgrade configuration:'
defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true

defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist
defaults read /Library/Preferences/com.apple.commerce.plist
echo '---'
echo '---'
echo 'Applications:'

echo "Choose an option:"
echo "1. Dev"
echo "2. Sales"
read option

if [ "$option" = "1" ]; then
  echo "Dev selected"

  echo ">>> Running brew install --cask for Dev..."
  brew install rustdesk teamviewer docker

elif [ "$option" = "2" ]; then
  echo "Sales selected"

  echo ">>> Running brew install for Sales..."
  brew install skype teamviewer adobe-acrobat-reader

else
  echo "Invalid option selected"
fi

echo ">>> Done. Enjoy."
