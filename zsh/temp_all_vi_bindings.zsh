# All modes
################################################################################
.safe
command
emacs
isearch
listscroll
main
menuselect
vicmd
viins
viopp
visual


# .safe
################################################################################
bindkey -R -M .safe "^@"-"^I" .self-insert
bindkey -M .safe "^J" .accept-line
bindkey -R -M .safe "^K"-"^L" .self-insert
bindkey -M .safe "^M" .accept-line
bindkey -R -M .safe "^N"-"\M-^?" .self-insert


# command
################################################################################
bindkey -M command "^G" send-break
bindkey -M command "^J" accept-line
bindkey -M command "^M" accept-line


# emacs
################################################################################
bindkey -M emacs "^@" set-mark-command
bindkey -M emacs "^A" beginning-of-line
bindkey -M emacs "^B" backward-char
bindkey -M emacs "^D" delete-char-or-list
bindkey -M emacs "^E" end-of-line
bindkey -M emacs "^F" forward-char
bindkey -M emacs "^G" send-break
bindkey -M emacs "^H" backward-delete-char
bindkey -M emacs "^I" fzf-tab-complete
bindkey -M emacs "^J" accept-line
bindkey -M emacs "^K" kill-line
bindkey -M emacs "^L" clear-screen
bindkey -M emacs "^M" accept-line
bindkey -M emacs "^N" down-line-or-history
bindkey -M emacs "^O" accept-line-and-down-history
bindkey -M emacs "^P" up-line-or-history
bindkey -M emacs "^Q" push-line
bindkey -M emacs "^R" history-incremental-search-backward
bindkey -M emacs "^S" history-incremental-search-forward
bindkey -M emacs "^T" transpose-chars
bindkey -M emacs "^U" kill-whole-line
bindkey -M emacs "^V" quoted-insert
bindkey -M emacs "^W" backward-kill-word
bindkey -M emacs "^X^B" vi-match-bracket
bindkey -M emacs "^X^F" vi-find-next-char
bindkey -M emacs "^X^J" vi-join
bindkey -M emacs "^X^K" kill-buffer
bindkey -M emacs "^X^N" infer-next-history
bindkey -M emacs "^X^O" overwrite-mode
bindkey -M emacs "^X^U" undo
bindkey -M emacs "^X^V" vi-cmd-mode
bindkey -M emacs "^X^X" exchange-point-and-mark
bindkey -M emacs "^X*" expand-word
bindkey -M emacs "^X." fzf-tab-debug
bindkey -M emacs "^X=" what-cursor-position
bindkey -M emacs "^XG" list-expand
bindkey -M emacs "^Xg" list-expand
bindkey -M emacs "^Xr" history-incremental-search-backward
bindkey -M emacs "^Xs" history-incremental-search-forward
bindkey -M emacs "^Xu" undo
bindkey -M emacs "^Y" yank
bindkey -M emacs "^[^D" list-choices
bindkey -M emacs "^[^G" send-break
bindkey -M emacs "^[^H" backward-kill-word
bindkey -M emacs "^[^I" self-insert-unmeta
bindkey -M emacs "^[^J" self-insert-unmeta
bindkey -M emacs "^[^L" clear-screen
bindkey -M emacs "^[^M" self-insert-unmeta
bindkey -M emacs "^[^_" copy-prev-word
bindkey -M emacs "^[ " expand-history
bindkey -M emacs "^[!" expand-history
bindkey -M emacs "^[\"" quote-region
bindkey -M emacs "^[\$" spell-word
bindkey -M emacs "^['" quote-line
bindkey -M emacs "^[-" neg-argument
bindkey -M emacs "^[." insert-last-word
bindkey -M emacs "^[0" digit-argument
bindkey -M emacs "^[1" digit-argument
bindkey -M emacs "^[2" digit-argument
bindkey -M emacs "^[3" digit-argument
bindkey -M emacs "^[4" digit-argument
bindkey -M emacs "^[5" digit-argument
bindkey -M emacs "^[6" digit-argument
bindkey -M emacs "^[7" digit-argument
bindkey -M emacs "^[8" digit-argument
bindkey -M emacs "^[9" digit-argument
bindkey -M emacs "^[<" beginning-of-buffer-or-history
bindkey -M emacs "^[>" end-of-buffer-or-history
bindkey -M emacs "^[?" which-command
bindkey -M emacs "^[A" accept-and-hold
bindkey -M emacs "^[B" backward-word
bindkey -M emacs "^[C" capitalize-word
bindkey -M emacs "^[D" kill-word
bindkey -M emacs "^[F" forward-word
bindkey -M emacs "^[G" get-line
bindkey -M emacs "^[H" run-help
bindkey -M emacs "^[L" down-case-word
bindkey -M emacs "^[N" history-search-forward
bindkey -M emacs "^[OA" up-line-or-history
bindkey -M emacs "^[OB" down-line-or-history
bindkey -M emacs "^[OC" forward-char
bindkey -M emacs "^[OD" backward-char
bindkey -M emacs "^[P" history-search-backward
bindkey -M emacs "^[Q" push-line
bindkey -M emacs "^[S" spell-word
bindkey -M emacs "^[T" transpose-words
bindkey -M emacs "^[U" up-case-word
bindkey -M emacs "^[W" copy-region-as-kill
bindkey -M emacs "^[[200~" bracketed-paste
bindkey -M emacs "^[[A" up-line-or-history
bindkey -M emacs "^[[B" down-line-or-history
bindkey -M emacs "^[[C" forward-char
bindkey -M emacs "^[[D" backward-char
bindkey -M emacs "^[_" insert-last-word
bindkey -M emacs "^[a" accept-and-hold
bindkey -M emacs "^[b" backward-word
bindkey -M emacs "^[c" capitalize-word
bindkey -M emacs "^[d" kill-word
bindkey -M emacs "^[f" forward-word
bindkey -M emacs "^[g" get-line
bindkey -M emacs "^[h" run-help
bindkey -M emacs "^[l" down-case-word
bindkey -M emacs "^[n" history-search-forward
bindkey -M emacs "^[p" history-search-backward
bindkey -M emacs "^[q" push-line
bindkey -M emacs "^[s" spell-word
bindkey -M emacs "^[t" transpose-words
bindkey -M emacs "^[u" up-case-word
bindkey -M emacs "^[w" copy-region-as-kill
bindkey -M emacs "^[x" execute-named-cmd
bindkey -M emacs "^[y" yank-pop
bindkey -M emacs "^[z" execute-last-named-cmd
bindkey -M emacs "^[|" vi-goto-column
bindkey -M emacs "^[^?" backward-kill-word
bindkey -M emacs "^_" undo
bindkey -R -M emacs " "-"~" self-insert
bindkey -M emacs "^?" backward-delete-char
bindkey -R -M emacs "\M-^@"-"\M-^?" self-insert


# isearch
################################################################################
bindkey -M isearch "^H" backward-delete-char
bindkey -M isearch "^W" backward-delete-word
bindkey -M isearch " " self-insert
bindkey -M isearch "\"" self-insert
bindkey -R -M isearch "'"-")" self-insert
bindkey -M isearch "[" self-insert
bindkey -M isearch "]" self-insert
bindkey -M isearch "\`" self-insert
bindkey -M isearch "{" self-insert
bindkey -M isearch "}" self-insert
bindkey -M isearch "^?" backward-delete-char


# listscroll
################################################################################
bindkey -M listscroll "^I" complete-word
bindkey -M listscroll "^J" accept-line
bindkey -M listscroll "^M" accept-line
bindkey -M listscroll "^[OB" down-line-or-history
bindkey -M listscroll "^[[B" down-line-or-history
bindkey -M listscroll " " complete-word


# main
################################################################################
bindkey -R "^A"-"^C" self-insert
bindkey "^D" list-choices
bindkey -R "^E"-"^F" self-insert
bindkey "^G" list-expand
bindkey "^H" autopair-delete
bindkey "^I" _tab_wrapper
bindkey "^J" accept-line
bindkey "^K" self-insert
bindkey "^L" clear-screen
bindkey "^M" _enter_wrapper
bindkey -R "^N"-"^P" self-insert
bindkey "^Q" vi-quoted-insert
bindkey "^R" redisplay
bindkey -R "^S"-"^T" self-insert
bindkey "^U" vi-kill-line
bindkey "^V" vi-quoted-insert
bindkey "^W" autopair-delete-word
bindkey "^X^R" _read_comp
bindkey "^X." fzf-tab-debug
bindkey "^X?" _complete_debug
bindkey "^XC" _correct_filename
bindkey "^Xa" _expand_alias
bindkey "^Xc" _correct_word
bindkey "^Xd" _list_expansions
bindkey "^Xe" _expand_word
bindkey "^Xh" _complete_help
bindkey "^Xm" _most_recent_file
bindkey "^Xn" _next_tags
bindkey "^Xt" _complete_tag
bindkey "^X~" _bash_list-choices
bindkey -R "^Y"-"^Z" self-insert
bindkey "^[" vi-cmd-mode
bindkey "^[," _history-complete-newer
bindkey "^[/" _history-complete-older
bindkey "^[OA" up-line-or-history
bindkey "^[OB" down-line-or-history
bindkey "^[OC" vi-forward-char
bindkey "^[OD" vi-backward-char
bindkey "^[Y" redo
bindkey "^[[1;3C" _jump_forward_word
bindkey "^[[1;3D" vi-backward-word
bindkey "^[[200~" bracketed-paste
bindkey "^[[3;2~" kill-whole-line
bindkey "^[[3;3~" kill-word
bindkey "^[[3;5~" kill-line
bindkey "^[[3~" delete-char
bindkey "^[[A" _up_key_wrapper
bindkey "^[[B" history-substring-search-up
bindkey "^[[C" _right_arrow_wrapper
bindkey "^[[D" _left_arrow_wrapper
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[f" _find_files
bindkey "^[g" _grep_into_nvim
bindkey "^[r" _rename_fzf
bindkey "^[v" _paste_from_clipboard
bindkey "^[y" undo
bindkey "^[~" _bash_complete-word
bindkey "^[^?" backward-kill-word
bindkey -R "^\\\\"-"^_" self-insert
bindkey " " _space_wrapper
bindkey "!" self-insert
bindkey "\"" autopair-insert
bindkey -R "#"-"&" self-insert
bindkey "'" _quote_wrapper
bindkey "(" autopair-insert
bindkey ")" autopair-close
bindkey -R "*"-"," self-insert
bindkey -- "-" _hyphen_wrapper
bindkey -R "."-":" self-insert
bindkey ";" _semicolon_wrapper
bindkey -R "<"-">" self-insert
bindkey "?" _question_mark_wrapper
bindkey -R "@"-"Z" self-insert
bindkey "[" autopair-insert
bindkey "\\\\" self-insert
bindkey "]" autopair-close
bindkey -R "\^"-"_" self-insert
bindkey "\`" autopair-insert
bindkey -R "a"-"z" self-insert
bindkey "{" autopair-insert
bindkey "|" self-insert
bindkey "}" autopair-close
bindkey "~" self-insert
bindkey "^?" autopair-delete
bindkey -R "\M-^@"-"\M-^?" self-insert


# menuselect
################################################################################
bindkey -M menuselect "^I" complete-word
bindkey -M menuselect "^J" accept-line
bindkey -M menuselect "^M" accept-line
bindkey -M menuselect "^[OA" up-line-or-history
bindkey -M menuselect "^[OB" down-line-or-history
bindkey -M menuselect "^[OC" forward-char
bindkey -M menuselect "^[OD" backward-char
bindkey -M menuselect "^[[A" up-line-or-history
bindkey -M menuselect "^[[B" down-line-or-history
bindkey -M menuselect "^[[C" forward-char
bindkey -M menuselect "^[[D" backward-char


# Vicmd
################################################################################
bindkey -a "^D" list-choices
bindkey -a "^G" list-expand
bindkey -a "^H" backward-kill-line
bindkey -a "^J" accept-line
bindkey -a "^L" clear-screen
bindkey -a "^M" accept-line
bindkey -a "^N" down-history
bindkey -a "^P" up-history
bindkey -a "^R" redo
bindkey -a "^[" vi-insert
bindkey -a "^[OA" up-line-or-history
bindkey -a "^[OB" down-line-or-history
bindkey -a "^[OC" vi-forward-char
bindkey -a "^[OD" vi-backward-char
bindkey -a "^[Y" redo
bindkey -a "^[[1;3C" _select_in_word
bindkey -a "^[[200~" bracketed-paste
bindkey -a "^[[3;2~" kill-whole-line
bindkey -a "^[[3;3~" kill-word
bindkey -a "^[[3;5~" kill-line
bindkey -a "^[[3~" delete-char
bindkey -a "^[[A" up-line-or-history
bindkey -a "^[[B" down-line-or-history
bindkey -a "^[[C" vi-forward-char
bindkey -a "^[[D" vi-backward-char
bindkey -a "^[c" _increment_integers
bindkey -a "^[x" _decrement_integers
bindkey -a "^[y" undo
bindkey -a "^[^?" backward-kill-word
bindkey -a " " _manipulate_surrounding
bindkey -a "\"" _select_in_surrounding
bindkey -a "%" vi-match-bracket
bindkey -R -a "'"-"(" _select_in_surrounding
bindkey -a "," vi-rev-repeat-find
bindkey -a -- "-" vi-repeat-change
bindkey -a "." vi-repeat-find
bindkey -a "/" vi-history-search-backward
bindkey -a "0" vi-digit-or-beginning-of-line
bindkey -R -a "1"-"9" digit-argument
bindkey -a ";" end-of-line
bindkey -a "<" _select_in_surrounding
bindkey -a "=" list-choices
bindkey -a ">" vi-indent
bindkey -a "A" vi-add-eol
bindkey -a "CS" change-surround
bindkey -a "DS" delete-surround
bindkey -a "F" vi-find-prev-char
bindkey -a "NU" incarg
bindkey -a "O" vi-forward-word-end
bindkey -a "R" vi-replace
bindkey -a "S" visual-line-mode
bindkey -a "TN" vi-find-next-char-skip
bindkey -a "TP" vi-find-prev-char-skip
bindkey -a "U" vi-backward-word-end
bindkey -a "ZB" _zap_backwards
bindkey -a "ZF" zap-to-char
bindkey -a "[" _select_in_surrounding
bindkey -a "_" vi-swap-case
bindkey -a "\`" _select_in_surrounding
bindkey -a "a" vi-add-next
bindkey -a "c" _copy_motions
bindkey -a "f" vi-find-next-char
bindkey -a "gE" vi-backward-blank-word-end
bindkey -a "gU" vi-up-case
bindkey -s -a "gUU" "gUgU"
bindkey -a "ga" what-cursor-position
bindkey -a "ge" vi-backward-word-end
bindkey -a "gg" beginning-of-buffer-or-history
bindkey -a "gu" vi-down-case
bindkey -s -a "guu" "gugu"
bindkey -a "g~" vi-oper-swap-case
bindkey -s -a "g~~" "g~g~"
bindkey -a "h" beginning-of-line
bindkey -a "i" history-substring-search-down
bindkey -a "k" history-substring-search-up
bindkey -a "l" vi-forward-char
bindkey -a "o" vi-forward-word
bindkey -a "r" vi-replace-chars
bindkey -a "s" visual-mode
bindkey -a "t" vi-backward-char
bindkey -a "u" vi-backward-word
bindkey -a "v" _paste_from_clipboard
bindkey -a "w" _delete_motions
bindkey -a "x" _cut_motions
bindkey -a "y" _change_motions
bindkey -a "{" _select_in_surrounding
bindkey -a "^?" backward-delete-char


# Viins
################################################################################
bindkey -R -M viins "^A"-"^C" self-insert
bindkey -M viins "^D" list-choices
bindkey -R -M viins "^E"-"^F" self-insert
bindkey -M viins "^G" list-expand
bindkey -M viins "^H" autopair-delete
bindkey -M viins "^I" _tab_wrapper
bindkey -M viins "^J" accept-line
bindkey -M viins "^K" self-insert
bindkey -M viins "^L" clear-screen
bindkey -M viins "^M" _enter_wrapper
bindkey -R -M viins "^N"-"^P" self-insert
bindkey -M viins "^Q" vi-quoted-insert
bindkey -M viins "^R" redisplay
bindkey -R -M viins "^S"-"^T" self-insert
bindkey -M viins "^U" vi-kill-line
bindkey -M viins "^V" vi-quoted-insert
bindkey -M viins "^W" autopair-delete-word
bindkey -M viins "^X^R" _read_comp
bindkey -M viins "^X." fzf-tab-debug
bindkey -M viins "^X?" _complete_debug
bindkey -M viins "^XC" _correct_filename
bindkey -M viins "^Xa" _expand_alias
bindkey -M viins "^Xc" _correct_word
bindkey -M viins "^Xd" _list_expansions
bindkey -M viins "^Xe" _expand_word
bindkey -M viins "^Xh" _complete_help
bindkey -M viins "^Xm" _most_recent_file
bindkey -M viins "^Xn" _next_tags
bindkey -M viins "^Xt" _complete_tag
bindkey -M viins "^X~" _bash_list-choices
bindkey -R -M viins "^Y"-"^Z" self-insert
bindkey -M viins "^[" vi-cmd-mode
bindkey -M viins "^[," _history-complete-newer
bindkey -M viins "^[/" _history-complete-older
bindkey -M viins "^[OA" up-line-or-history
bindkey -M viins "^[OB" down-line-or-history
bindkey -M viins "^[OC" vi-forward-char
bindkey -M viins "^[OD" vi-backward-char
bindkey -M viins "^[Y" redo
bindkey -M viins "^[[1;3C" _jump_forward_word
bindkey -M viins "^[[1;3D" vi-backward-word
bindkey -M viins "^[[200~" bracketed-paste
bindkey -M viins "^[[3;2~" kill-whole-line
bindkey -M viins "^[[3;3~" kill-word
bindkey -M viins "^[[3;5~" kill-line
bindkey -M viins "^[[3~" delete-char
bindkey -M viins "^[[A" _up_key_wrapper
bindkey -M viins "^[[B" history-substring-search-up
bindkey -M viins "^[[C" _right_arrow_wrapper
bindkey -M viins "^[[D" _left_arrow_wrapper
bindkey -M viins "^[[F" end-of-line
bindkey -M viins "^[[H" beginning-of-line
bindkey -M viins "^[f" _find_files
bindkey -M viins "^[g" _grep_into_nvim
bindkey -M viins "^[r" _rename_fzf
bindkey -M viins "^[v" _paste_from_clipboard
bindkey -M viins "^[y" undo
bindkey -M viins "^[~" _bash_complete-word
bindkey -M viins "^[^?" backward-kill-word
bindkey -R -M viins "^\\\\"-"^_" self-insert
bindkey -M viins " " _space_wrapper
bindkey -M viins "!" self-insert
bindkey -M viins "\"" autopair-insert
bindkey -R -M viins "#"-"&" self-insert
bindkey -M viins "'" _quote_wrapper
bindkey -M viins "(" autopair-insert
bindkey -M viins ")" autopair-close
bindkey -R -M viins "*"-"," self-insert
bindkey -M viins "-" _hyphen_wrapper
bindkey -R -M viins "."-":" self-insert
bindkey -M viins ";" _semicolon_wrapper
bindkey -R -M viins "<"-">" self-insert
bindkey -M viins "?" _question_mark_wrapper
bindkey -R -M viins "@"-"Z" self-insert
bindkey -M viins "[" autopair-insert
bindkey -M viins "\\\\" self-insert
bindkey -M viins "]" autopair-close
bindkey -R -M viins "\^"-"_" self-insert
bindkey -M viins "\`" autopair-insert
bindkey -R -M viins "a"-"z" self-insert
bindkey -M viins "{" autopair-insert
bindkey -M viins "|" self-insert
bindkey -M viins "}" autopair-close
bindkey -M viins "~" self-insert
bindkey -M viins "^?" autopair-delete
bindkey -R -M viins "\M-^@"-"\M-^?" self-insert


# Viopp
################################################################################
bindkey -M viopp "^[" vi-cmd-mode
bindkey -M viopp "^[OA" up-line
bindkey -M viopp "^[OB" down-line
bindkey -M viopp "^[[A" up-line
bindkey -M viopp "^[[B" down-line
bindkey -M viopp "aW" select-a-blank-word
bindkey -M viopp "aa" select-a-shell-word
bindkey -M viopp "aw" select-a-word
bindkey -M viopp "iW" select-in-blank-word
bindkey -M viopp "ia" select-in-shell-word
bindkey -M viopp "iw" select-in-word


# Visual
################################################################################
bindkey -M visual "^[" deactivate-region
bindkey -M visual "^[OA" up-line
bindkey -M visual "^[OB" down-line
bindkey -M visual "^[[1;3C" visual-line-mode
bindkey -M visual "^[[3~" kill-region
bindkey -M visual "^[[A" up-line
bindkey -M visual "^[[B" down-line
bindkey -M visual "\"" _add_surrounding
bindkey -R -M visual "'"-"(" _add_surrounding
bindkey -M visual "-" vi-down-case
bindkey -M visual "<" _add_surrounding
bindkey -M visual "M\"" add-surround
bindkey -M visual "M'" add-surround
bindkey -M visual "M(" add-surround
bindkey -M visual "M<" add-surround
bindkey -M visual "M[" add-surround
bindkey -M visual "M\`" add-surround
bindkey -M visual "M{" add-surround
bindkey -M visual "O" vi-forward-word-end
bindkey -M visual "Q\"" select-quoted
bindkey -M visual "Q'" select-quoted
bindkey -M visual "Q(" select-bracketed
bindkey -M visual "Q<" select-bracketed
bindkey -M visual "Q[" select-bracketed
bindkey -M visual "Q\`" select-quoted
bindkey -M visual "Q{" select-bracketed
bindkey -M visual "U" vi-backward-word-end
bindkey -M visual "[" _add_surrounding
bindkey -M visual "_" vi-up-case
bindkey -M visual "\`" _add_surrounding
bindkey -M visual "a" exchange-point-and-mark
bindkey -M visual "aW" select-a-blank-word
bindkey -M visual "aa" select-a-shell-word
bindkey -M visual "aw" select-a-word
bindkey -M visual "c" _copy_to_clipboard
bindkey -M visual "iW" select-in-blank-word
bindkey -M visual "ia" select-in-shell-word
bindkey -M visual "iw" select-in-word
bindkey -M visual "o" vi-forward-word
bindkey -M visual "u" vi-backward-word
bindkey -M visual "v" _paste_from_clipboard_visual
bindkey -M visual "w" kill-region
bindkey -M visual "x" _cut_to_clipboard
bindkey -M visual "y" vi-change
bindkey -M visual "{" _add_surrounding
bindkey -M visual "^?" kill-region
