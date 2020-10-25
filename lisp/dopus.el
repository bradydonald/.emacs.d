; These functions mimic [[https://www.gpsoft.com.au/][Directory Opus]] by bringing up two dired buffers via
; /db\/dopus-in/, one in the directory you were in, and one in your home
; directory. When exting via /db\/dopus-out/ the window state is restored.

(defun db/dopus-in ()
  "Stores the current buffer state and switches to a splt view with two dired
    mode buffers ala Dopus on windows"
  (interactive)
  (window-configuration-to-register 'a)
  (delete-other-windows)
  (dired default-directory)
  (dired-other-window (expand-file-name "~"))
  (other-window 1))

(defun db/dopus-out ()
  "Returns the stored buffer state after your all done manipulating files Dopus style"
  (interactive)
  (jump-to-register 'a 'DELETE))
