(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from git-gutter.el

(autoload 'git-gutter:linum-setup "git-gutter" "\
Setup for linum-mode.")
(autoload 'git-gutter-mode "git-gutter" "\
Git-Gutter mode

This is a minor mode.  If called interactively, toggle the
`Git-Gutter mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `git-gutter-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(put 'global-git-gutter-mode 'globalized-minor-mode t)
(defvar global-git-gutter-mode nil "\
Non-nil if Global Git-Gutter mode is enabled.
See the `global-git-gutter-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-git-gutter-mode'.")
(custom-autoload 'global-git-gutter-mode "git-gutter" nil)
(autoload 'global-git-gutter-mode "git-gutter" "\
Toggle Git-Gutter mode in all buffers.
With prefix ARG, enable Global Git-Gutter mode if ARG is positive; otherwise,
disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Git-Gutter mode is enabled in all buffers where `git-gutter--turn-on' would do
it.

See `git-gutter-mode' for more information on Git-Gutter mode.

(fn &optional ARG)" t)
(autoload 'git-gutter "git-gutter" "\
Show diff information in gutter" t)
(autoload 'git-gutter:toggle "git-gutter" "\
Toggle to show diff information." t)
(register-definition-prefixes "git-gutter" '("git-gutter"))

;;; End of scraped data

