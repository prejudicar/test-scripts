#!/bin/bash

# Install brew if not present
if ! command -v brew &>/dev/null; then
  echo ">>> Installing brew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is set up in the PATH
if [ -z "$(command -v brew)" ]; then
  echo ">>> Executing brew shellenv ..."
  eval "$(/usr/local/bin/brew shellenv)"
fi

cecho '---'
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
sudo scutil --set ComputerName "${ComputerName}"
sudo scutil --set LocalHostName "${ComputerName}"

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
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true

defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist
defaults read /Library/Preferences/com.apple.commerce.plist
echo '---'
echo '---'
echo 'Applications:'

echo ">>> Installing common packages ..."
brew tap benwebber/tunnelblickctl

echo ">>> Running brew install ..."
brew install \
  tunnelblickctl \
  tunnelblick \
  tmate \
  google-chrome \
  libreoffice \
  wget

echo "Choose an option:"
echo "1. Dev"
echo "2. Sales"
read option

if [ "$option" = "1" ]; then
  echo "Dev selected"

  echo ">>> Running brew install --cask for Dev..."
  brew install --cask rustdesk teamviewer docker

elif [ "$option" = "2" ]; then
  echo "Sales selected"

  echo ">>> Running brew install for Sales..."
  brew install skype teamviewer adobe-acrobat-reader

else
  echo "Invalid option selected"
fi

echo ">>> Done. Enjoy."
