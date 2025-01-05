#!/usr/bin/env zsh
#                                   _   _   _
#   _ __ ___   __ _  ___   ___  ___| |_| |_(_)_ __   __ _ ___
#  | '_ ` _ \ / _` |/ __| / __|/ _ \ __| __| | '_ \ / _` / __|
#  | | | | | | (_| | (__  \__ \  __/ |_| |_| | | | | (_| \__ \
#  |_| |_| |_|\__,_|\___| |___/\___|\__|\__|_|_| |_|\__, |___/
# ==================================================|___/===================== #

# https://git.herrbischoff.com/awesome-macos-command-line/about/
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos

# Quit System Preferences so it doesn't override settings
osascript -e 'tell application "System Preferences" to quit'


# KEYBOARD
# ---------------------------------------------------------------------------- #
# Faster key repeat settings
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable spelling corrections
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic capitalization
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Disable automatic period
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false


# FINDER
# ---------------------------------------------------------------------------- #
# Default to the list view in Finder
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Display hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles True

# Show the full path at the bottom of Finder
defaults write com.apple.finder ShowPathbar True

# Allow quitting via cmd + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Set Desktop as the default location for new Finder windows. For
# other paths, use `PfLo` and `file:///full/path/here/`.
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"


# DOCK
# ---------------------------------------------------------------------------- #
# Faster Dock popup on mouse-over
defaults write com.apple.dock autohide-time-modifier -float 0.1
defaults write com.apple.dock autohide-delay -float 0

# Only show active apps in the Dock
defaults write com.apple.dock static-only -bool true

# Don't show recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Autohide the Dock when unfocused
defaults write com.apple.dock autohide -bool true

# Set the icon size of Dock items to 70 pixels
defaults write com.apple.dock tilesize -int 70


# MISSION CONTROL
# ---------------------------------------------------------------------------- #
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.01

# Disable Ctrl + left / right default bindings (Mission Control: Switch Desktops)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 0;}"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 0;}"


# MISC
# ---------------------------------------------------------------------------- #
# Hammerspoon XDG compliance
defaults write org.hammerspoon.Hammerspoon MJConfigFile "${HOME}/.config/hammerspoon/init.lua"

# Set sidebar icon size to medium
defaults write -g NSTableViewDefaultSizeMode -int 2

# Disable the over-the-top focus ring animation
defaults write -g NSUseAnimatedFocusRing -bool false

# Increase window resize speed for Cocoa applications
defaults write -g NSWindowResizeTime -float 0.001

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save screenshots in the "screenshots" folder
defaults write com.apple.screencapture location ~/Pictures/

# Save screenshots in png format
defaults write com.apple.screencapture type -string "png"

# Hide apple folders
chflags hidden ~/{Movies,Music,Pictures,Public}

# See the changes
killall Dock
killall Finder
killall SystemUIServer



# Set lock screen message
# sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "I AM INVINCIBLE!!!"

# Controls whether certain bindings can be triggered from within text input fields
# defaults write -g NSMnemonicsWorkInText -bool YES

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false

# Hide the "Now Playing" menu bar item
# defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" False
