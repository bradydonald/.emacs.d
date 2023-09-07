(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from elfeed-webkit.el

(autoload 'elfeed-webkit-toggle "elfeed-webkit" "\
Toggle rendering of elfeed entries with webkit on/off." t)
(define-obsolete-function-alias 'elfeed-webkit-auto-enable-by-tag 'elfeed-webkit-auto-toggle-by-tag "0.2")
(autoload 'elfeed-webkit-auto-toggle-by-tag "elfeed-webkit" "\
Automatically toggle rendering of elfeed entries with webkit on/off.

If an entry has a tag listed in `elfeed-webkit-auto-enable-tags',
render it with webkit when it is shown.  Likewise, if an entry
has a tag listed in `elfeed-webkit-auto-disable-tags', render it
with the original/default method.

Rendering with webkit can still be toggled on or off manually in
the entry's buffer." t)
(register-definition-prefixes "elfeed-webkit" '("elfeed-webkit-"))

;;; End of scraped data
