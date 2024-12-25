
# @ Command (⌘)
# ~ Option (⌥)
# ^ Control (⌃)
# $ Shift (⇧)

# sudo -v

sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "com.knollsoft.Rectangle"; \
defaults com.knollsoft.Rectangle NSUserKeyEquivalents -dict-add "Left Half" -string "^v"

# sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "com.brave.Browser"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Tab" -string "^v"
