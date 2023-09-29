(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from dired-sidebar.el

(autoload 'dired-sidebar-toggle-sidebar "dired-sidebar" "\
Toggle the project explorer window.
Optional argument DIR Use DIR as sidebar root if available.

With universal argument, use current directory.

(fn &optional DIR)" t)
(autoload 'dired-sidebar-toggle-with-current-directory "dired-sidebar" "\
Like `dired-sidebar-toggle-sidebar' but use current-directory." t)
(autoload 'dired-sidebar-show-sidebar "dired-sidebar" "\
Show sidebar displaying buffer B.

(fn &optional B)" t)
(autoload 'dired-sidebar-hide-sidebar "dired-sidebar" "\
Hide the sidebar in the selected frame." t)
(autoload 'dired-sidebar-jump-to-sidebar "dired-sidebar" "\
Jump to `dired-sidebar' buffer if it is showing.

If it's not showing, act as `dired-sidebar-toggle-sidebar'." t)
(register-definition-prefixes "dired-sidebar" '("dired-sidebar-"))

;;; End of scraped data

