#!/usr/bin/env zsh

# https://git.herrbischoff.com/awesome-macos-command-line/about/
# https://gist.github.com/trusktr/1e5e516df4e8032cbc3d

# Quit System Preferences so it doesn't override settings
osascript -e 'tell application "System Preferences" to quit'

# KEYBOARD
# ---------------------------------------------------------------------------- #
# Fastest key repeat settings
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable Apple's insane default alt key behaviour <3 <3 <3
# defaults write NSGlobalDomain NSMnemonicsWorkInText -bool YES


mkdir -p "${HOME}/Library/KeyBindings"
cp -f "${XDG_CONFIG_HOME}/macos/DefaultKeyBinding.dict" "${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"


sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "org.mozilla.firefox"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Copy" -string "~c"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Cut" -string "~x"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Paste" -string "~v"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Undo" -string "~y"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Select All" -string "~a"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Tab" -string "~m"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Window" -string "~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Private Window" -string "$~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Find in Page..." -string "~f"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Close Tab" -string "~w"



# FINDER
# ---------------------------------------------------------------------------- #
# Display hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles True

# Show the full path at the bottom of Finder
defaults write com.apple.finder ShowPathbar True

# Default to the list view in Finder
defaults write com.apple.finder FXPreferredViewStyle Nlsv


# DOCK
# ---------------------------------------------------------------------------- #
# Show Dock instantly on mouse-over
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0

# Only show active apps in the Dock
# defaults write com.apple.dock static-only -bool true

# Don't show recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Hide the Dock
defaults write com.apple.dock autohide -bool true


# MISC
# ---------------------------------------------------------------------------- #
# Hide the "Now Playing" menu bar item
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" False

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
