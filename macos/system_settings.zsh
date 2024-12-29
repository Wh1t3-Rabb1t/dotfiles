#!/usr/bin/env zsh

# https://git.herrbischoff.com/awesome-macos-command-line/about/
# https://gist.github.com/trusktr/1e5e516df4e8032cbc3d

# Quit System Preferences so it doesn't override settings
osascript -e 'tell application "System Preferences" to quit'




# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false





# KEYBOARD
# ---------------------------------------------------------------------------- #
# Fastest key repeat settings
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Controls whether certain bindings can be triggered from within text input fields
# defaults write NSGlobalDomain NSMnemonicsWorkInText -bool YES

# Disable spelling corrections
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false


# FINDER
# ---------------------------------------------------------------------------- #
# Display hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles True

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show the full path at the bottom of Finder
defaults write com.apple.finder ShowPathbar True

# Default to the list view in Finder
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"


# DOCK
# ---------------------------------------------------------------------------- #
# Show Dock instantly on mouse-over
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0

# Only show active apps in the Dock
defaults write com.apple.dock static-only -bool true

# Don't show recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Autohide the Dock when unfocused
defaults write com.apple.dock autohide -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36


# MISSION CONTROL
# ---------------------------------------------------------------------------- #
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false



# MISC
# ---------------------------------------------------------------------------- #
# Hide the "Now Playing" menu bar item
# defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" False

# Save screenshots in the "screenshots" folder
defaults write com.apple.screencapture location ~/Documents/screenshots
defaults write com.apple.screencapture type -string "png"

# Set lock screen message
# sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "I AM INVINCIBLE!!!"

# Hammerspoon XDG compliance
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

# Hide apple folders
chflags hidden ~/{Movies,Music,Pictures,Public}

# See the changes
killall Dock
killall Finder
killall SystemUIServer
