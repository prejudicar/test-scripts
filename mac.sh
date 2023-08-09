#!/bin/bash

# This script should be executed as the user which should have assigned a pre-defined password $SUDO_PASS to install Webroot for each location

SUDO_PASS_POR="Password01"
WEBROOT_SERIAL_POR="AF5C-WRSM-0F8F-2688-4E8A"

SUDO_PASS_DUB="Password02"
WEBROOT_SERIAL_DUB="AF5C-WRSM-0F8F-2688-4E8A"

SUDO_PASS_BCN="Password03"
WEBROOT_SERIAL_BCN="SA68-WRSM-258A-968A-C3A9"

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

# Set up the ID account to manage iCloud settings
echo 'Set up Apple ID:'
/usr/bin/open 'x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane'
/usr/bin/osascript -e "display dialog \"Please add the Apple ID (root@exoclick.com or root@exads.com and the password) please configure all 2sd authentifications here, and then click 'OK'.\" with title \"Apple ID\" with icon file POSIX file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/InternetLocation.icns\"  buttons {\"OK\"} default button {\"OK\"}"
/usr/bin/osascript -e 'quit app "System Preferences"'

echo '---'
echo '---'
echo 'Applications:'

echo ">>> Installing common packages ..."
brew tap benwebber/tunnelblickctl

echo ">>> Running brew install ..."
brew install \
  teamviewer \
  tunnelblickctl \
  tunnelblick \
  tmate \
  google-chrome \
  libreoffice \
  slack \
  wget

while true; do
  echo "Choose an option:"
  echo "1 - Dev"
  echo "2 - Sales"
  read -p "Option: " option

  if [ "$option" = "1" ]; then
   
    echo "Dev selected"
    echo ">>> Running brew install --cask for Dev..."
    brew install --cask rustdesk docker
    break
  
  elif [ "$option" = "2" ]; then
   
    echo "Sales selected"
    echo ">>> Running brew install for Sales..."
    brew install skype adobe-acrobat-reader
    break
  
   else
    echo "Invalid option selected. Please, select 1 or 2."
  fi
done

# Function to set up WiFi and printers for each profile
function set_wifi_and_printers_porto() {
  # Prompt for WiFi setup for Porto
  echo "Enter the password for WiFi EXADS Porto Vodafone-EE3F13: "
  read -s porto_password

  # Set up WiFi network for Porto
  networksetup -setairportnetwork en0 "Vodafone-EE3F13" "$porto_password"

  # Add printers for Porto
  # Printer pending:
  lpadmin -p "EXADS" -E -v "PortoPrinter1URI" -P "/path/to/PortoPrinter1PPD"

 # Webroot installation Dublin
 if [ ! -d "/Applications/Webroot SecureAnywhere.app" ]; then
 echo ">>> Downloading Webroot SecureAnywhere installer ..."
 /usr/bin/curl -Lko "/tmp/WSAMACSME.pkg" "https://mac.webrootmultiplatform.com/production/wsa-mac/versions/latest/WSAMACSME.pkg"
 echo ">>> Installing Webroot SecureAnywhere (sudo password required) ..."
 sudo --stdin <<< "${SUDO_PASS_POR}" /bin/bash -c "
    /usr/bin/defaults write group.com.webroot.wsa language -string 'en';
    /usr/bin/defaults write group.com.webroot.wsa keycode -string "${WEBROOT_SERIAL_POR}";
    /usr/bin/defaults write group.com.webroot.wsa installerTempFile -string /tmp/installMacWSA.sh.ITeeI2.txt;
    /usr/sbin/installer -dumplog -verboseR -pkg /tmp/WSAMACSME.pkg -target /
 "
 rm -f "/tmp/WSAMACSME.pkg" 2>/dev/null
 # Open Webroot SecureAnywhere
    /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
    /usr/bin/osascript -e "display dialog \"Add Full Disk Access to webroot, press 'OK' then ready.\" with title \"Webroot Full Disc Access\" with icon file POSIX file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarAdvanced.icns\"  buttons {\"OK\"} default button {\"OK\"}"
   /usr/bin/open '/Applications/Webroot SecureAnywhere.app'
 else
  echo ">>> Webroot SecureAnywhere is already installed."
 fi
}

function set_wifi_and_printers_dublin() {
  # Prompt for WiFi setup for Dublin
  echo "Enter the password for WiFi EXADS Dublin: "
  read -s dublin_password

  # Set up WiFi network for Dublin
  networksetup -setairportnetwork en0 "EXADS" "$dublin_password"

  # Add printers for Dublin
  # Printer pending:
  lpadmin -p "EXADS PRINTER" -E -v "socket://192.168.114.10" -P "/tmp/XeroxDrivers_6515.gz"

  # Webroot installation Dublin
 if [ ! -d "/Applications/Webroot SecureAnywhere.app" ]; then
 echo ">>> Downloading Webroot SecureAnywhere installer ..."
 /usr/bin/curl -Lko "/tmp/WSAMACSME.pkg" "https://mac.webrootmultiplatform.com/production/wsa-mac/versions/latest/WSAMACSME.pkg"
 echo ">>> Installing Webroot SecureAnywhere (sudo password required) ..."
 sudo --stdin <<< "${SUDO_PASS_DUB}" /bin/bash -c "
    /usr/bin/defaults write group.com.webroot.wsa language -string 'en';
    /usr/bin/defaults write group.com.webroot.wsa keycode -string "${WEBROOT_SERIAL_DUB}";
    /usr/bin/defaults write group.com.webroot.wsa installerTempFile -string /tmp/installMacWSA.sh.ITeeI2.txt;
    /usr/sbin/installer -dumplog -verboseR -pkg /tmp/WSAMACSME.pkg -target /
 "
 rm -f "/tmp/WSAMACSME.pkg" 2>/dev/null
 # Open Webroot SecureAnywhere
    /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
    /usr/bin/osascript -e "display dialog \"Add Full Disk Access to webroot, press 'OK' then ready.\" with title \"Webroot Full Disc Access\" with icon file POSIX file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarAdvanced.icns\"  buttons {\"OK\"} default button {\"OK\"}"
   /usr/bin/open '/Applications/Webroot SecureAnywhere.app'
 else
  echo ">>> Webroot SecureAnywhere is already installed."
 fi
}

function set_wifi_and_printers_bcn() {
  # Prompt for WiFi setup for Barcelona
  echo "Enter the password for WiFi WLAN_40: "
  read -s bcn_password

  # Set up WiFi network for Bcn
  networksetup -setairportnetwork en0 "WLAN_40" "$bcn_password"

# Add printers for Bcn
 lpadmin -p "RICOH_IM_C2000" -E -v "socket://lacasadepapel.es1.hop6.lan" -P "/tmp/RICOH_IM_C2000.gz"
# Set up as defeault
 lpoptions -d "RICOH_IM_C2000"

# Webroot installation Bcn
 if [ ! -d "/Applications/Webroot SecureAnywhere.app" ]; then
 echo ">>> Downloading Webroot SecureAnywhere installer ..."
 /usr/bin/curl -Lko "/tmp/WSAMACSME.pkg" "https://mac.webrootmultiplatform.com/production/wsa-mac/versions/latest/WSAMACSME.pkg"
 echo ">>> Installing Webroot SecureAnywhere (sudo password required) ..."
 sudo --stdin <<< "${SUDO_PASS_BCN}" /bin/bash -c "
    /usr/bin/defaults write group.com.webroot.wsa language -string 'en';
    /usr/bin/defaults write group.com.webroot.wsa keycode -string "${WEBROOT_SERIAL_BCN}";
    /usr/bin/defaults write group.com.webroot.wsa installerTempFile -string /tmp/installMacWSA.sh.ITeeI2.txt;
    /usr/sbin/installer -dumplog -verboseR -pkg /tmp/WSAMACSME.pkg -target /
 "
 rm -f "/tmp/WSAMACSME.pkg" 2>/dev/null
 # Open Webroot SecureAnywhere
    /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
    /usr/bin/osascript -e "display dialog \"Add Full Disk Access to webroot, press 'OK' then ready.\" with title \"Webroot Full Disc Access\" with icon file POSIX file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarAdvanced.icns\"  buttons {\"OK\"} default button {\"OK\"}"
   /usr/bin/open '/Applications/Webroot SecureAnywhere.app'
 else
  echo ">>> Webroot SecureAnywhere is already installed."
 fi
}

while true; do
  echo "Choose a profile:"
  echo "1 - Porto"
  echo "2 - Dublin"
  echo "3 - Barcelona"
  read -p "Profile: " profile

  if [ "$profile" = "1" ]; then
    echo "Porto profile selected"
    set_wifi_and_printers_porto
    break

  elif [ "$profile" = "2" ]; then
    echo "Dublin profile selected"
    set_wifi_and_printers_dublin
    break

  elif [ "$profile" = "3" ]; then
    echo "Barcelona profile selected"
    set_wifi_and_printers_bcn
    break

  else
    echo "Invalid profile selected. Please, select 1, 2, or 3."
  fi
done

echo '---'
echo '---'

#Configure FileVault to encrypt the data
echo 'FileVault:'
/usr/bin/fdesetup status
/usr/bin/fdesetup list
/usr/bin/open 'x-apple.systempreferences:com.apple.preference.security'
/usr/bin/osascript -e "display dialog \"Scroll down inside 'Privacy & Security' and press 'Turn On FileVault'. Select 'Allow my iCloud account to unlock my disk'.\" with title \"FileVault\" with icon file POSIX file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/LockedIcon.icns\"  buttons {\"OK\"} default button {\"OK\"}"
/usr/bin/osascript -e 'quit app "System Preferences"'

echo ">>> Done. Enjoy."
