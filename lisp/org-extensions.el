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


;; should not need this but can't remember function
(defun db/counsel-org-agenda-insert-link-to-headlines ()
  "Insert a link to headers of `org-mode' files in the agenda."
  (interactive)
  (require 'org)
  (let ((minibuffer-allow-text-properties t))
    (ivy-read "Org headline: "
              (counsel-org-agenda-headlines--candidates)
              :action #'link/counsel-org-agenda-headlines-action-insert-link
              :history 'counsel-org-agenda-headlines-history
              :caller 'link/counsel-org-agenda-insert-link-to-headlines)))
(defun link/counsel-org-agenda-headlines-action-insert-link (headline)
  "Insert a link to the `org-mode' agenda HEADLINE."
  (let ((link (save-window-excursion
                (save-excursion
                  (save-restriction
		    (find-file (nth 1 headline))
		    (goto-char (nth 2 headline))
                    (org-store-link nil))))))
    (insert link)))
(ivy-set-actions
 'counsel-org-agenda-headlines
 '(("i" link/counsel-org-agenda-headlines-action-insert-link "insert link to headline")
   ("g" counsel-org-agenda-headlines-action-goto "goto headline")))
(ivy-set-actions
 'link/counsel-org-agenda-insert-link-to-headlines
 '(("i" link/counsel-org-agenda-headlines-action-insert-link "insert link to headline")
   ("g" counsel-org-agenda-headlines-action-goto "goto headline")))
