#!/usr/bin/env zsh

# Quit System Preferences so it doesn't override settings
osascript -e 'tell application "System Preferences" to quit'

# Fastest key repeat settings
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "I am invincible!"

# Display hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles True

# Default to the list view in Finder
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# Show the full path at the bottom of Finder
defaults write com.apple.finder ShowPathbar True

# Show Dock instantly on mouse-over
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0

# Only show active apps in the Dock
defaults write com.apple.dock static-only -bool true

# Don't show recent apps in the Dock
defaults write com.apple.dock show-recents -bool true

# Hide the Dock
defaults write com.apple.dock autohide -bool true

# Hide the "Now Playing" menu bar item
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" False

# Save screenshots in the "screenshots" folder
defaults write com.apple.screencapture location ~/Documents/screenshots

# See the changes
killall Dock
killall Finder
killall SystemUIServer
