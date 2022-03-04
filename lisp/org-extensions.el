;;
;; file for any handy org related code.
;;

(defun db/org-reverse-headers ()
  "Reverse headers of current org file"
  (interactive)
  (let (str
    (content (nthcdr 2 (org-element-parse-buffer 'headline)))) ;; `org-element-parse-buffer' returns (ORG-DATA PROPERTIES CONTENT), CONTENT contains the headlines
    (setq content (nreverse content)) ;; reversal of sections
    (insert
     (with-output-to-string
       (dolist (header content)
     (princ (buffer-substring (plist-get (cadr header) :begin) (plist-get (cadr header) :end))))
       (delete-region (point-min) (point-max))))))


(defun db/org-list-all-tags ()
  "Returns a list of all tags"
  (interactive)
  (mapcar (lambda (tag) 
          (substring-no-properties (car tag))) 
          (org-global-tags-completion-table)))

(defun db/refresh-org-files-list ()
  (interactive)
  (setq org-agenda-files (directory-files-recursively org-directory "org$")))



