;;; mastodon-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from mastodon.el

(autoload 'mastodon "mastodon" "\
Connect Mastodon client to `mastodon-instance-url' instance." t)
(autoload 'mastodon-toot "mastodon" "\
Update instance with new toot. Content is captured in a new buffer.
If USER is non-nil, insert after @ symbol to begin new toot.
If REPLY-TO-ID is non-nil, attach new toot to a conversation.
If REPLY-JSON is the json of the toot being replied to.

(fn &optional USER REPLY-TO-ID REPLY-JSON)" t)
(autoload 'mastodon-notifications-get "mastodon" "\
Display NOTIFICATIONS in buffer.
Optionally only print notifications of type TYPE, a string.
BUFFER-NAME is added to \"*mastodon-\" to create the buffer name.
FORCE means do not try to update an existing buffer, but fetch
from the server and load anew.

(fn &optional TYPE BUFFER-NAME FORCE)" t)
(autoload 'mastodon-url-lookup "mastodon" "\
If a URL resembles a mastodon link, try to load in `mastodon.el'.
Does a WebFinger lookup.
URL can be arg QUERY-URL, or URL at point, or provided by the user.
If a status or account is found, load it in `mastodon.el', if
not, just browse the URL in the normal fashion.

(fn &optional QUERY-URL)" t)
(add-hook 'mastodon-mode-hook (lambda nil (when (require 'emojify nil :noerror) (emojify-mode t) (when mastodon-toot--enable-custom-instance-emoji (mastodon-toot--enable-custom-emoji)))))
(add-hook 'mastodon-mode-hook #'mastodon-profile--fetch-server-account-settings)
(register-definition-prefixes "mastodon" '("mastodon-"))


;;; Generated autoloads from mastodon-async.el

(autoload 'mastodon-async-mode "mastodon-async" "\
Async Mastodon.

This is a minor mode.  If called interactively, toggle the
`Mastodon-Async mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `mastodon-async-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(register-definition-prefixes "mastodon-async" '("mastodon-async--"))


;;; Generated autoloads from mastodon-auth.el

(register-definition-prefixes "mastodon-auth" '("mastodon-auth-"))


;;; Generated autoloads from mastodon-client.el

(register-definition-prefixes "mastodon-client" '("mastodon-client"))


;;; Generated autoloads from mastodon-discover.el

(register-definition-prefixes "mastodon-discover" '("mastodon-discover"))


;;; Generated autoloads from mastodon-http.el

(register-definition-prefixes "mastodon-http" '("mastodon-http--"))


;;; Generated autoloads from mastodon-inspect.el

(register-definition-prefixes "mastodon-inspect" '("mastodon-inspect--"))


;;; Generated autoloads from mastodon-iso.el

(register-definition-prefixes "mastodon-iso" '("mastodon-iso-639-"))


;;; Generated autoloads from mastodon-media.el

(register-definition-prefixes "mastodon-media" '("mastodon-media--"))


;;; Generated autoloads from mastodon-notifications.el

(register-definition-prefixes "mastodon-notifications" '("mastodon-notifications--"))


;;; Generated autoloads from mastodon-profile.el

(register-definition-prefixes "mastodon-profile" '("mastodon-profile-"))


;;; Generated autoloads from mastodon-search.el

(register-definition-prefixes "mastodon-search" '("mastodon-search--"))


;;; Generated autoloads from mastodon-tl.el

(register-definition-prefixes "mastodon-tl" '("mastodon-tl-"))


;;; Generated autoloads from mastodon-toot.el

(add-hook 'mastodon-toot-mode-hook #'mastodon-profile--fetch-server-account-settings-maybe)
(register-definition-prefixes "mastodon-toot" '("mastodon-toot-"))


;;; Generated autoloads from mastodon-views.el

(register-definition-prefixes "mastodon-views" '("mastodon-views-"))

;;; End of scraped data

(provide 'mastodon-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; mastodon-autoloads.el ends here