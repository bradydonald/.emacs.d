;;
;; Credit to Xah
;; http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html
;;
(defun db/wsl-open-in-external-app (&optional @fname)
  "Open the current file or dired marked files in external app.
When called in emacs lisp, if @fname is given, open that."
  (interactive)
  (let* (
         ($file-list
          (if @fname
              (progn (list @fname))
            (if (string-equal major-mode "dired-mode")
                (dired-get-marked-files)
              (list (buffer-file-name)))))
         ($do-it-p (if (<= (length $file-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (cond
       ((string-equal (getenv "WSL_DISTRO_NAME") "Fedora") ;; detect wsl2
        (mapc
         (lambda ($fpath)
           ;; changed here
           ;; uses wslview to open the file
           (shell-command (concat "wslview " (shell-quote-argument (file-name-nondirectory $fpath )) )))
         $file-list))
       ((string-equal system-type "darwin")
        (mapc
         (lambda ($fpath)
           (shell-command
            (concat "open " (shell-quote-argument $fpath))))  $file-list))
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda ($fpath) (let ((process-connection-type nil))
                            (start-process "" nil "xdg-open" $fpath))) $file-list))))))
