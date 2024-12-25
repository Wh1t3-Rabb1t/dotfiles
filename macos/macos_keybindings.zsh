
# @ Command (⌘)
# ~ Option (⌥)
# ^ Control (⌃)
# $ Shift (⇧)

# sudo -v

sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "com.brave.Browser"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Tab" -string "~m"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Reopen Closed Tab" -string "~$m"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Window" -string "~n"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Private Window" -string "~$n"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Find..." -string "~f"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Search Tabs..." -string "~p"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Quick Commands" -string "~$p"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Close Tab" -string "~w"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Copy" -string "~c"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Cut" -string "~x"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Paste" -string "~v"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Undo" -string "~y"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Redo" -string "~$y"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Reload This Page" -string "~r"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Open Location..." -string "~'"; \
defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Select All" -string "~a"; \
