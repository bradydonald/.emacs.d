;; extensions to dired mode

;;
(defun db/dopus-in ()
  "Stores the current buffer state and switches to a splt view with two dired
mode buffers ala Dopus on windows"
  (interactive)
  (window-configuration-to-register 'a)
  (delete-other-windows)
  (ivy-switch-buffer))


(defun db/dopus-out ()
  "Returns the stored buffer state after your all done manipulating files Dopus style"
  (interactive)
  (jump-to-register 'a 'DELETE))

