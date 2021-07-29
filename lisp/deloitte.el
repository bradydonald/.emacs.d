;; some useful work related functions

;; Deloitte fiscal years begin on the Sunday before the first Monday of June
;; e.g. FY20 began on 6/2/20
;; e.g. FY21 began on 5/31/21

;; | P1      | P2      | P3      | P4      | P5       |
;; | 5/31/20 | 6/28/20 | 7/26/20 | 8/23/20 | 9/20/20  |
;; | 6/27/20 | 7/25/20 | 8/22/20 | 9/19/20 | 10/17/20 |

(require 'ts)

(defvar current-yy (string-to-number (format-time-string "%y")))
(defvar current-mm (string-to-number (format-time-string "%m")))


(defun deloitte-ts-start-of-current-fiscal-year ()
  "Returns the start date of the current fiscal year as ts"

  ;; adjust the year depening on the month. If we are before June then we are in
  ;; the fiscal year that began the prior year in June
  (setq tmp-yy current-yy)
  (if (< current-mm 6)
      (setq tmp-yy (- current-yy 1)))

  ;; Walk forward from June 1 until we hit a Monday
  (setq june-walk (ts-parse (s-concat "jun 1 " (number-to-string tmp-yy))))
  (while (not (string-equal (ts-day-abbr june-walk) "Mon"))
    (setq june-walk (ts-adjust 'day 1 june-walk)))

  ;; that's our day, now return the day (Sunday) before
  (ts-adjust 'day -1 june-walk))


(defun deloitte-start-of-current-fiscal-year ()
  "Returns the start of the current fiscal year in dd/mm/yy format"
  (ts-format "%m/%d/%y" (deloitte-ts-start-of-current-fiscal-year)))


(defun deloitte-current-fiscal-year-abbrev ()
  "Returns the standard fiscal year abbreviation e.f. FY21"
  (setq yy-string (car (last (s-split "/" (deloitte-start-of-current-fiscal-year)))))
  (s-concat "FY" (number-to-string (+ (string-to-number yy-string) 1))))

(defun deloitte-financial-period ()
  "Returns the deloitte financial period which is divided into 13 four week periods"
  (interactive)
  ;; start at the begining of the year
  (setq period 0)
  (setq period-walker (deloitte-ts-start-of-current-fiscal-year))

  ;; walk forward in 4 week periods until >= today
  (while (ts>= (ts-now) period-walker)
    (setq period-walker (ts-adjust 'day 28 period-walker))
    (setq period (+ period 1)))

  ;; thats our period.
  (setq period-s (s-concat (deloitte-current-fiscal-year-abbrev) "-P"
                           (number-to-string period)))

  (if (called-interactively-p 'any)
      (message period-s))

  period-s)



;; wsl functions
(defun db/dired-wsl-home ()
  (interactive)
  (dired-jump-other-window "/mnt/c/Users/donaldbrady/"))

;; Some work specific key bindings
(global-set-key (kbd "M-<home>") 'db/dired-wsl-home)

;; wsl path conversion
;; TODO
(defun dc/yank-win-path-to-wsl-path ()
  (interactive)
  ;; yank expecting a win path
  ;; convert to wsl equivalent /mnt/c/...
  )

(defun db/convert-win-path-to-wsl-path str
  (replace-regexp-in-string "\\" "\/" str))

