(defun db/print-elements-of-list (list)
  "Print each element of LIST on a line of its own."
  (while list
    (print (car list))
    (setq list (cdr list))))

(defun db/toggle-transparency ()
  "Toggles transparency of the frame for note taking on zoom etc"
  (interactive)
  (setq current-alpha-value (cadr (frame-parameter (selected-frame) 'alpha)))
  (if (equal nil current-alpha-value)
      (setq current-alpha-value 100))
   (if (/= current-alpha-value 100)
       (set-frame-parameter nil 'alpha '(100 100))
     (set-frame-parameter nil 'alpha '(85 50))))
