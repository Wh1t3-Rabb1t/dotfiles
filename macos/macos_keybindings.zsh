#!/usr/bin/env zsh

# https://apple.stackexchange.com/questions/398561/how-to-set-system-keyboard-shortcuts-via-command-line
# https://stackoverflow.com/questions/11876485/how-to-disable-generating-special-characters-when-pressing-the-alta-optiona
# https://stackoverflow.com/questions/60870113/mac-generating-%E2%88%86%CB%9A%C2%AC-characters-instead-of-executing-vscode-shortcuts-that-involve

# ^ Control (⌃)
# $ Shift (⇧)
# ~ Option (⌥)
# @ Command (⌘)

sudo -v

defaults write com.apple.HIToolbox AppleSelectedInputSources -array-add '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = "-1"; "KeyboardLayout Name" = "Unicode Hex Input"; }'
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.UnicodeHexInput"


defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "org.mozilla.firefox"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Tab" -string "~m"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Window" -string "~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Private Window" -string "$~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Find in Page..." -string "~f"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Close Tab" -string "~w"

killall SystemUIServer


# sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "com.brave.Browser"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Tab" -string "~m"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Reopen Closed Tab" -string "$~m"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Window" -string "~n"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "New Private Window" -string "$~n"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Find..." -string "~f"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Search Tabs..." -string "~p"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Quick Commands" -string "$~p"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Close Tab" -string "~w"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Copy" -string "~c"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Cut" -string "~x"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Paste" -string "~v"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Undo" -string "~y"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Redo" -string "$~y"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Reload This Page" -string "~r"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Open Location..." -string "~'"; \
# defaults write com.brave.Browser NSUserKeyEquivalents -dict-add "Select All" -string "~a"





# defaults write com.apple.HIToolbox AppleSelectedInputSources -array-add '{ \
#     InputSourceKind = "Keyboard Layout"; \
#     "KeyboardLayout ID" = "-1"; \
#     "KeyboardLayout Name" = "Unicode Hex Input"; \
# }'






# SOURCE="${XDG_CONFIG_HOME}/macos/DefaultKeyBinding.dict"
# TARGET="${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"

# if [[ ! -f "$SOURCE" ]]; then
#     echo "Error: Source file does not exist: $SOURCE" >&2
#     exit 1
# fi

# if [[ ! -f "$TARGET" ]]; then
#     echo "Creating required directory"
#     mkdir -p "${HOME}/Library/KeyBindings"
# fi

# cp -f "$SOURCE" "$TARGET" || { echo "Error: Failed to create symlink"; exit 1; }
# killall SystemUIServer || { echo "Error: Failed to restart SystemUIServer"; exit 1; }

# echo "Key bindings updated successfully."




# ```sh
# defaults read com.brave.Browser NSUserKeyEquivalents
# ```
