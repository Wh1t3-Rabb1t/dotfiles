#!/usr/bin/env zsh

# WARNING!!! Do not attempt to go down this route. There is only misery, madness,
# malaise, and mental decay awaiting any naive enough to consider themselves
# capable of elegantly wrangling Apple's default keybindings across multiple app's.

# The Alt key requires unicode hex input to be enabled so that bindings won't be
# overwritten by Apple's default special character input behaviour. But enabling
# unicode hex input still doesn't enable Alt bindings in Brave, and although they
# work in Firefox, it disables Alt + left / right bindings even if they are
# redeclared in this file, yet other Alt bindings work without issue (wtf?).

# I'm dropping this nonsense entirely and leaning on Karabiner for all
# keystoke repurposing from here on out. You'd be wise to do the same.


# https://apple.stackexchange.com/questions/398561/how-to-set-system-keyboard-shortcuts-via-command-line
# https://stackoverflow.com/questions/11876485/how-to-disable-generating-special-characters-when-pressing-the-alta-optiona
# https://stackoverflow.com/questions/60870113/mac-generating-%E2%88%86%CB%9A%C2%AC-characters-instead-of-executing-vscode-shortcuts-that-involve

# ^ Control (⌃)
# $ Shift (⇧)
# ~ Option (⌥)
# @ Command (⌘)

# sudo -v


# defaults write com.apple.HIToolbox AppleSelectedInputSources -array-add '{ \
#     InputSourceKind = "Keyboard Layout"; \
#     "KeyboardLayout ID" = "-1"; \
#     "KeyboardLayout Name" = "Unicode Hex Input"; \
# }'

# defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.UnicodeHexInput"


defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "org.mozilla.firefox"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Tab" -string "~m"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Window" -string "~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "New Private Window" -string "$~n"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Find in Page..." -string "~f"; \
defaults write org.mozilla.firefox NSUserKeyEquivalents -dict-add "Close Tab" -string "~w"

# killall SystemUIServer


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











# SOURCE="${XDG_CONFIG_HOME}/macos/KeyBindings/DefaultKeyBinding.dict"
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



# /* _deleteBackward:
# _selectNextKeyView:
# _ageDownAndMod ifySelection:
# _insertLineBreak:
# ^insertNewline:
# _ makeBaseWritingDirectionNatural:
# ZinsertTa b:
# _$makeBaseWritingDirectionRightToLeft:
# _$makeBaseWritingDirectionLeftToRight:
# _oveToBegi nningOfParagraph:
# ]moveBackward:
# _cycleToNextInputKeyboardLayout:
# ^deleteForward:
# ^insertBac ktab:
# _moveToEndOfParagraph:
# _deleteWordBackward:
# _selectPreviousKeyView:
# _cancelOperation:
# \ moveForward:
# _deleteWordForward:
# _deleteToEndOfParagraph:
# _!insertNewlineIgnoringFieldEdito r:
# _centerSelectionInVisibleArea:
# WmoveUp:
# YmoveDown:
# WpageUp:
# _,moveToBeginningOfDocumentAnd ModifySelection:
# YmoveLeft:
# ZmoveRight:
# YpageDown:
# _&insertDoubleQuoteIgnoringSubstitution:
# _ &moveToEndOfDocumentAndModifySelection:
# _pageUpAndModifySelection:
# Ycomplete:
# _insertTabI gnoringFieldEditor:
# ]scrollPageUp:
# _scrollPageDown:
# _moveToLeftEndOfLine:
# _&insertSingleQuot eIgnoringSubstitution:
# Ztranspose:
# _moveToRightEndOfLine:
# Uyank:
# _insertRightToLeftSlash:
# _mo veWordBackward:
# _-deleteBackwardByDecomposingPreviousCharacter:
# _scrollToBeginningOfDocume nt:
# _moveWordForward:
# _scrollToEndOfDocument:
# _cycleToNextInputScript:
# _moveToBeginningOfDoc ument:
# _ makeTextWritingDirectionNatural:
# _moveToEndOfDocument:
# _-moveToBeginningOfParag raphAndModifySelection:
# _moveBackwardAndModifySelection:
# Wdelete:
# ]moveWordLeft:
# ^moveWor dRight:
# _$makeTextWritingDirectionRightToLeft:
# _moveUpAndModifySelection:
# _#moveWordBackwar dAndModifySelection:
# _&moveToLeftEndOfLineAndModifySelection:
# _'moveToEndOfParagraphAndMod ifySelection:
# _oveDownAndModifySelection:
# _moveForwardAndModifySelection:
# _oveLeftAndModify Selection:
# _'moveToRightEndOfLineAndModifySelection:
# _moveRightAndModifySelection:
# _$makeTe xtWritingDirectionLeftToRight:
# _(moveParagraphBackwardAndModifySelection:
# _'moveParagraphF orwardAndModifySelection:
# _"moveWordForwardAndModifySelection:
# _moveWordLeftAndModifySelec tion:
# _ moveWordRightAndModifySelection:
# _deleteToBeginningOfLine:
# _togglePlatformInputSyst */

# /* ~/Library/KeyBindings/DefaultKeyBinding.dict */
# {
#     "~a" = "selectAll:";                       /* Alt + a */
#     "~c" = "copy:";                            /* Alt + c */
#     "~x" = "cut:";                             /* Alt + x */
#     "~v" = "paste:";                           /* Alt + v */
#     "~y" = "undo:";                            /* Alt + y */
#     "~\UF702" = "moveWordBackward:";           /* Alt + Left */
#     "~\UF703" = "moveWordForward:";            /* Alt + Right */
#     "~\010" = "deleteWordBackward:";           /* Alt + Backspace */
#     "~\177" = "deleteWordBackward:";           /* Alt + Delete */
#     "$\UF72B" = "moveToBeginningOfDocument:";  /* Shift + PageUp */
#     "$\UF72C" = "moveToEndOfDocument:";        /* Shift + PageDown */
#     "\UF729" = "moveToLeftEndOfLine:";         /* Home */
#     "\UF72B" = "moveToRightEndOfLine:";        /* End */
# }

# "\UF72C"   = "pageUp:";                                      /* PageUp                   */
# "$\UF72C"  = "moveToBeginningOfDocument:";                   /* Shift + PageUp           */
# "@$\UF72C" = "moveToBeginningOfDocumentAndModifySelection:"; /* Cmd + Shift + PageUp     */

# "\UF72D"   = "pageDown:";                                    /* PageDown                 */
# "$\UF72D"  = "moveToEndOfDocument:";                         /* Shift + PageDown         */
# "@$\UF72D" = "moveToEndOfDocumentAndModifySelection:";       /* Cmd + Shift + PageDown   */
