(defun db/print-elements-of-list (list)
  "Print each element of LIST on a line of its own."
  (while list
    (print (car list))
    (setq list (cdr list))))



(defun db/insert-emoji-reload ()
  "Insert the Unicode character 🔄 (U+1F504) at point."
  (interactive)
  (insert "\U0001F504"))


