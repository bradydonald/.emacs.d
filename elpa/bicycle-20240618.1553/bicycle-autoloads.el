(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from bicycle.el

(autoload 'bicycle-cycle "bicycle" "\
Cycle local or global visibility.

With a prefix argument call `bicycle-cycle-global'.
Without a prefix argument call `bicycle-cycle-local'.

(fn &optional GLOBAL)" t)
(autoload 'bicycle-cycle-global "bicycle" "\
Cycle visibility of all sections.

1. OVERVIEW: Show only top-level heading.
2. TOC:      Show all headings, without treating top-level
             code blocks as sections.
3. TREES:    Show all headings, treaing top-level code blocks
             as sections (i.e., their first line is treated as
             a heading).
4. ALL:      Show everything, except code blocks that have been
             collapsed individually (using a `hideshow' command
             or function)." t)
(register-definition-prefixes "bicycle" '("bicycle-" "outline-code-level"))

;;; End of scraped data

