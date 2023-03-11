;;; flycheck-inline-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from flycheck-inline.el

(autoload 'flycheck-inline-mode "flycheck-inline" "\
A minor mode to show Flycheck error messages line.

When called interactively, toggle `flycheck-inline-mode'.  With
prefix ARG, enable `flycheck-inline-mode' if ARG is positive,
otherwise disable it.

When called from Lisp, enable `flycheck-inline-mode' if ARG is
omitted, nil or positive.  If ARG is `toggle', toggle
`flycheck-inline-mode'.  Otherwise behave as if called
interactively.

In `flycheck-inline-mode', show Flycheck error messages inline,
directly below the error reported location.

(fn &optional ARG)" t)
(put 'global-flycheck-inline-mode 'globalized-minor-mode t)
(defvar global-flycheck-inline-mode nil "\
Non-nil if Global Flycheck-Inline mode is enabled.
See the `global-flycheck-inline-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-flycheck-inline-mode'.")
(custom-autoload 'global-flycheck-inline-mode "flycheck-inline" nil)
(autoload 'global-flycheck-inline-mode "flycheck-inline" "\
Toggle Flycheck-Inline mode in all buffers.
With prefix ARG, enable Global Flycheck-Inline mode if ARG is positive;
otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Flycheck-Inline mode is enabled in all buffers where `turn-on-flycheck-inline'
would do it.

See `flycheck-inline-mode' for more information on Flycheck-Inline mode.

(fn &optional ARG)" t)
(register-definition-prefixes "flycheck-inline" '("flycheck-inline-" "turn-on-flycheck-inline"))

;;; End of scraped data

(provide 'flycheck-inline-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; flycheck-inline-autoloads.el ends here
