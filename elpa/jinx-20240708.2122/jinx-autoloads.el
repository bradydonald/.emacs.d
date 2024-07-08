;;; jinx-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from jinx.el

(put 'jinx-languages 'safe-local-variable #'stringp)
(put 'jinx-local-words 'safe-local-variable #'stringp)
(put 'jinx-mode 'safe-local-variable #'not)
(autoload 'jinx-languages "jinx" "\
Set languages locally or globally to LANGS.
LANGS should be one or more language codes as a string, separated
by whitespace.  When called interactively, the language codes are
read via `completing-read-multiple'.  If the prefix argument
GLOBAL is non-nil, the languages are changed globally for all
buffers.  See also the variable `jinx-languages'.

(fn LANGS &optional GLOBAL)" t)
(autoload 'jinx-correct-all "jinx" "\
Correct all misspelled words in the buffer.
With prefix argument ONLY-CHECK, only check the buffer and highlight all
misspellings, but do not open the correction UI.

(fn &optional ONLY-CHECK)" t)
(autoload 'jinx-correct-nearest "jinx" "\
Correct nearest misspelled word." t)
(autoload 'jinx-correct-word "jinx" "\
Correct word between START and END, by default the word before point.
Suggest corrections even if the word is not misspelled.
Optionally insert INITIAL input in the minibuffer.

(fn &optional START END INITIAL)" t)
(autoload 'jinx-correct "jinx" "\
Correct word depending on prefix ARG.
This command dispatches to the following commands:
  - `jinx-correct-nearest': If prefix ARG is nil, correct nearest
    misspelled word.
  - `jinx-correct-all': If a region is marked, or if prefix ARG
    is 4, corresponding to \\[universal-argument] pressed once,
    correct all misspelled words.
  - `jinx-correct-word': If prefix ARG is 16, corresponding to
    \\[universal-argument] pressed twice, correct word before point.
  - If prefix ARG is 64, corresponding to \\[universal-argument] pressed
    three times, check the whole buffer, but do not open the correction
    UI.

(fn &optional ARG)" t)
(autoload 'jinx-mode "jinx" "\
Enchanted Spell Checker.

This is a minor mode.  If called interactively, toggle the `Jinx mode'
mode.  If the prefix argument is positive, enable the mode, and if it is
zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable the
mode if ARG is nil, omitted, or is a positive number.  Disable the mode
if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `jinx-mode'.

The mode's hook is called both when the mode is enabled and when it is
disabled.

(fn &optional ARG)" t)
(put 'global-jinx-mode 'globalized-minor-mode t)
(defvar global-jinx-mode nil "\
Non-nil if Global Jinx mode is enabled.
See the `global-jinx-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-jinx-mode'.")
(custom-autoload 'global-jinx-mode "jinx" nil)
(autoload 'global-jinx-mode "jinx" "\
Toggle Jinx mode in all buffers.
With prefix ARG, enable Global Jinx mode if ARG is positive; otherwise, disable
it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Jinx mode is enabled in all buffers where `jinx--on' would do it.

See `jinx-mode' for more information on Jinx mode.

(fn &optional ARG)" t)
(register-definition-prefixes "jinx" '("global-jinx-modes" "jinx-"))

;;; End of scraped data

(provide 'jinx-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; jinx-autoloads.el ends here
