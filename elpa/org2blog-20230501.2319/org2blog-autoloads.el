;;; org2blog-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from org2blog.el

(autoload 'org2blog-user-interface "org2blog" "\
Invoke the graphical user interface." t)
(autoload 'org2blog-on-new-entry-kill "org2blog" "\
Handler for a new KIND of entry buffer closing.

  KIND must be either ’buffer or ’subtree.

  Use like this:

  (add-hook 'kill-buffer-hook
            (apply-partially #'org2blog-on-new-entry-kill ’buffer)
            nil 'local)
  .

(fn KIND)")
(autoload 'org2blog-maybe-start "org2blog" "\
Enable function `org2blog/wp-mode' when `#+ORG2BLOG:' is present.

  Use it like this:

  (add-hook 'org-mode-hook #'org2blog-maybe-start)")
(autoload 'org2blog-user-report "org2blog" "\
Report library actions if ON is non-nil.

  Call with a prefix-argument to enable, and without one
  to disable debugging.

  org2blog/wp operates using the following APIs in the order
  listed below, followed by details about their debug output:

  - org2blog: Application Layer
  - ox-wp: WordPress API
  - Display export in a text buffer: *Org WordPress Export*
  - xml-rpc: Message processing layer
  - The XML message content sent to the server over HTTPS.
  Useful for testing with cURL and comparing the results
  to xml-rpc.
  - View call request data in buffer: request-data
  - The internal data structure used to make the
  post call. Useful for a quick view of the call details
  as an Elisp list.
  - View xml-rpc method call data in buffer: func-call
  - url-util: Message transfer layer
  - Debug messages output in buffer: *URL-DEBUG*
  - gnutls: Secure communications layer
  - Debug messages output in buffer: *Messages*

  Investigate by going through layer's messages from top to bottom.
  Call function ‘org2blog-version-info’ to display runtime version numbers

  You usually only need to keep track of what is happening between
  two of them because if it is doing what you expect then you
  can move on.

  Consider print messages where you need them and also using Edebug.
  With virtually no setup Edebug lets you walk through a function
  and evaluate local variables to see precisely what is happening.

  If after studying the request body, messages, and control flow
  things still don't work then the best thing to do is to test the
  call using another tool. Paste the request-data into a file named
  `test.txt' and make the request using cURL like this:

  curl --data @test.txt https://www.yourblog.com/xmlrpc.php

  By this point you'll have a better sense of where things are
  happening, or not, and now might be the time to move on to the
  transfer layer.

  If you are investigating at the GnuTLS layer it helps to study
  the debug messages side by side with the output of an analysis
  tool like tcpdump or Wireshark. Viewing them side-by-side helps
  to make better sense of the flow and interactions between what
  you expected, the APIs tried to do, and what really happened
  over the wire. If the time comes to dig deeper into the
  communications layer then start by reading more in the variable
  ‘gnutls-algorithm-priority’ and it's referenced GnuTLS
  documentation. GnuTLS doesn’t expose a version number as a
  variable, but you will see it in the detailed logging
  messages.

  This is beyond the domains of Emacs and into GnuTLS. However,
  it will let you do things like selectively enable and disable
  protocols to help narrow down what works and what doesn't, helping
  you further investigate the issue. The contents of the debug
  buffer include things like certificate version and issuer, public
  key algorithm, and protocol. The protocol information is particularly
  important because when clients connect to a server the protocol
  is often negotiated and it might not be what you expect. For
  example this is why your XML request might work using cURL
  but not using gnutls: the negotiated protocol version might not quite work
  right between your client and the server! A solution here then is to
  force a different method by customizing ‘gnutls-algorithm-priority’.
  If you get this far, then give yourself a pat on the back for digging
  deeper. It is actually pretty fun to look behind the curtain and what
  is happening on the socket layer. Of course that is only looking
  back at it—at the time it is pretty unpleasant!

  Tracking down the unexpected behavior requires no magic–just
  patience and persistence and definitely talking it through
  with others. Before getting overwhelmed, take a break and
  consider reaching out using email or an Issue Request.

  Remember: Org2Blog is trying to keep the fun in blogging. So
  enjoy working through your debugging session, it is one step
  closer to doing more blogging!

(fn ON)" t)
(autoload 'org2blog-user-report-on "org2blog" "\
Enable ‘org2blog-user-report’ ’ing." t)
(autoload 'org2blog-user-report-off "org2blog" "\
Disable ‘org2blog-user-report’ ’ing." t)
(autoload 'org2blog-version-info "org2blog" "\
Display critical library information or return as a VALUE if non-nil.

  Hydra doesn't provide a version number.

(fn &optional VALUE)" t)
(autoload 'org2blog-user-set-password "org2blog" "\
Set password “in memory”.

  This does not change your password on the blog.

  This does not change your password in your configuration file.

  It does change your password in memory during this session.

  See messages below for details." t)
(autoload 'org2blog-user-login "org2blog" "\
Log in to BLOG-NAME if non-nil, otherwise choose from a list.

  Please note that this login is only from the User's perspective.
  Org2Blog uses the XML-RPC API to interact with WordPress.
  Org2Blog has to send the Users password with every API call.
  The API is stateless: there is no concept of logging in. Every
  API call is a new one requiring the password each time. Despite
  that Org2Blog has to provide some concept of being logged in
  for the User. Given that goal Org2Blog must know some basics
  about the User's blog. Using that information it must make some
  decisions about how to configure itself for the most common
  usage scenario.

  The most common usage scenario here is defined by imagined usage
  and lack of Issue Requests stating otherwise. It looks like this:

  - You must tell me about at least one blog available for use
  now. Unless you defined a blog in `org2blog/wp-blog-alist' I'm
  stopping.
  - You must choose a blog to use for this session. Unless you
  choose one I'm stopping.
  - Thus far Org2Blog hasn't made any API calls. Therefore we
  still don't know if User's password works or not. This is OK
  because the User can still use Org2Blog without logging
  successfully. The only limitation is that the User won't have
  completion data.
  - `org2blog-complete' needs completion data to work. Therefore
  categories, tags, and pages are loaded here. If any of the
  loads fail then I'll notify the user. It is an error because
  we don't know why it didn't work. It could be network
  connectivity or a problem with Org2Blog itself. However the
  User can still continue moving forward to edit an Org2Blog file
  without that data. Consequently the function proceeds instead
  of failing here.
  

(fn &optional BLOG-NAME)" t)
(autoload 'org2blog-user-logout "org2blog" "\
Log out of blog." t)
(autoload 'org2blog-buffer-new "org2blog" "\
Create new post entry." t)
(autoload 'org2blog-subtree-new "org2blog" "\
Create new subtree entry." t)
(autoload 'org2blog-buffer-post-save "org2blog" "\
Save new or existing post. Publish if PUBLISH is non-nil.

(fn &optional PUBLISH)" t)
(autoload 'org2blog-buffer-post-publish "org2blog" "\
Publish post." t)
(autoload 'org2blog-buffer-page-save "org2blog" "\
Save new page to the blog or edits an existing page. Publish if PUBLISH is non-nil. Do as subtree if SUBTREE-P is non-nil.

(fn &optional PUBLISH)" t)
(autoload 'org2blog-buffer-page-publish "org2blog" "\
Publish page." t)
(autoload 'org2blog-subtree-post-save "org2blog" "\
Save the current subtree entry as a draft. Publish if PUBLISH is non-nil.

(fn &optional PUBLISH)" t)
(autoload 'org2blog-subtree-post-publish "org2blog" "\
Publish subtree post." t)
(autoload 'org2blog-subtree-page-save "org2blog" "\
Save new subtree page to the blog or edits an existing page. If PUBLISH is non-nil then save and publish it.

(fn &optional PUBLISH)" t)
(autoload 'org2blog-subtree-page-publish "org2blog" "\
Publish page." t)
(autoload 'org2blog-entry-save "org2blog" "\
Save new or existing entry of TYPE from SOURCE. In non-nil PUBLISH, do. If non-nil SUBTREE-P, do.

(fn SOURCE TYPE &optional PUBLISH)" t)
(autoload 'org2blog-entry-trash-prompt "org2blog" "\
Prompt for an entry ID then trash it.

(fn ID)" t)
(autoload 'org2blog-buffer-post-trash "org2blog" "\
Trash buffer post. If POST-ID is non-nil trash that.

(fn &optional POST-ID)" t)
(autoload 'org2blog-subtree-post-trash "org2blog" "\
Trash subtree post. If POST-ID is non-nil trash that.

(fn &optional POST-ID)" t)
(autoload 'org2blog-buffer-page-trash "org2blog" "\
Trash page. If PAGE-ID is non-nil trash that.

(fn &optional PAGE-ID)" t)
(autoload 'org2blog-subtree-page-trash "org2blog" "\
Trash page. If PAGE-ID is non-nil trash that.

(fn &optional PAGE-ID)" t)
(autoload 'org2blog-entry-trash "org2blog" "\
Trash entry of TYPE. If ENTRY-ID is non-nil trash that one.

(fn TYPE &optional ENTRY-ID)" t)
(autoload 'org2blog-complete "org2blog" "\
Complete categories, tags, or pages." t)
(autoload 'org2blog-insert-more "org2blog" "\
Insert WordPress “More” tag.

  “More” tags only work in posts, not Pages." t)
(autoload 'org2blog-structure-template-add "org2blog" "\
Enable `BEGIN_EXPORT wp' blocks.

  Add them to `snippet-key org-structure-template-alist' unless
  already present." t)
(autoload 'org2blog-insert-mathjax "org2blog" "\
Insert the WordPress ‘MathJax’ shortcode." t)
(autoload 'org2blog-insert-latex "org2blog" "\
Insert WordPress ‘LaTeX’ string." t)
(autoload 'org2blog-buffer-track "org2blog" "\
Track buffer." t)
(autoload 'org2blog-subtree-track "org2blog" "\
Track subtree." t)
(autoload 'org2blog-entry-track "org2blog" "\
Track entry from SOURCE. Was it already PUBLISHED?

(fn SOURCE &optional PUBLISHED?)" t)
(autoload 'org2blog-buffer-post-or-page-view "org2blog" "\
Use either `org2blog-buffer-post-view' or `org2blog-buffer-page-view'.

  WordPress 6 differentiates between viewing a Page and a Post.
  Therefore this function must be retired. It is not a bug:
  WordPress just doesn't work that way with the API now.
  " t)
(autoload 'org2blog-buffer-post-view "org2blog" "\
View buffer post." t)
(autoload 'org2blog-buffer-page-view "org2blog" "\
View buffer page." t)
(autoload 'org2blog-subtree-post-or-page-view "org2blog" "\
Use either `org2blog-subtree-post-view' or `org2blog-subtree-page-view'.

  WordPress 6 differentiates between viewing a Page and a Post.
  Therefore this function must be retired. It is not a bug:
  WordPress just doesn't work that way with the API now.
  " t)
(autoload 'org2blog-subtree-post-view "org2blog" "\
View subtree post." t)
(autoload 'org2blog-subtree-page-view "org2blog" "\
View subtree page." t)
(autoload 'org2blog-subtree-view "org2blog" "\
View subtree post or page.

  DEST is either ’post or ’page.

(fn DEST)" t)
(autoload 'org2blog-entry-view "org2blog" "\
View SOURCE's entry published to DEST.

  SOURCE is either ’buffer or ’subtree.

  DEST is either ’post or ’page.
  

(fn SOURCE DEST)" t)
(autoload 'org2blog-insert-link-to-post "org2blog" "\
Insert link to post." t)
(autoload 'org2blog-insert-link-to-page "org2blog" "\
Insert link to page." t)
(autoload 'org2blog-insert-link "org2blog" "\
Choose and insert link to entry using IS-PAGE if non-nil.

  When IS-PAGE is nil then chose from page IDs
  instead of posts.

(fn IS-PAGE)" t)
(autoload 'org2blog-reload-entry-mode-map "org2blog" "\
Re-initialize `org2blog-mode-map'.

  Use the prefix key sequence defined by
  `org2blog/wp-keymap-prefix' and update `minor-mode-map-alist'
  accordingly." t)
(autoload 'org2blog-about "org2blog" "\
Display brief about page." t)
(autoload 'org2blog-org2blog-keyword-check "org2blog" "\
Insert the ORG2BLOG keyword unless it exists.

  Inserts ‘#+ORG2BLOG’ on the first empty lines that it finds.

  If it doesn’t find one then it doesn’t insert it." t)
(autoload 'org2blog/wp-mode "org2blog" "\
Toggle org2blog/wp minor mode.

  With no argument, the mode is toggled on/off.

  Non-nil argument turns mode on.

  Nil argument turns mode off.

  Commands:
  \\{org2blog-mode-map}

  Entry to this mode calls the value of `org2blog-mode-hook'.

This is a minor mode.  If called interactively, toggle the
`Org2blog/Wp mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `org2blog/wp-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(register-definition-prefixes "org2blog" '("org2blog"))


;;; Generated autoloads from org2blog-test-system.el

(register-definition-prefixes "org2blog-test-system" '("org2blog--"))


;;; Generated autoloads from ox-wp.el

(autoload 'ox-wp-export-as-wordpress "ox-wp" "\
Export current buffer to a text buffer by delegation.

Delegating: ASYNC, SUTREEP, and EXT-PLIST.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When `org-export-show-temporary-export-buffer' is non-nil
display a buffer with the export value.

(fn &optional ASYNC SUBTREEP EXT-PLIST)" t)
(register-definition-prefixes "ox-wp" '("org-html-underline" "ox-wp-"))


;;; End of scraped data

(provide 'org2blog-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; org2blog-autoloads.el ends here
