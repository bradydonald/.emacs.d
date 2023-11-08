;;; simple-httpd-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from simple-httpd.el

(autoload 'httpd-start "simple-httpd" "\
Start the web server process. If the server is already
running, this will restart the server. There is only one server
instance per Emacs instance." t)
(autoload 'httpd-stop "simple-httpd" "\
Stop the web server if it is currently running, otherwise do nothing." t)
(autoload 'httpd-running-p "simple-httpd" "\
Return non-nil if the simple-httpd server is running.")
(autoload 'httpd-serve-directory "simple-httpd" "\
Start the web server with given `directory' as `httpd-root'.

(fn DIRECTORY)" t)
(register-definition-prefixes "simple-httpd" '("defservlet" "httpd" "with-httpd-buffer"))


;;; End of scraped data

(provide 'simple-httpd-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; simple-httpd-autoloads.el ends here
