
# @ Command (⌘)
# ~ Option (⌥)
# ^ Control (⌃)
# $ Shift (⇧)

# sudo -v

sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "com.brave.Browser"; defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Tab" -string "^v"
