;; some useful work related functions

;; Deloitte fiscal years begin on the first Monday of June
;; e.g. FY20 began on 6/3/19
;; e.g. FY21 began on 6/1/20

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

  ;; that's our day
  june-walk)


(defun deloitte-start-of-current-fiscal-year ()
  "Returns the start of the current fiscal year in dd/mm/yy format"
  (ts-format "%m/%d/%y" (deloitte-ts-start-of-current-fiscal-year)))


(defun deloitte-current-fiscal-year-abbrev ()
  "Returns the standard fiscal year abbreviation e.f. FY21"
  (s-concat "FY" (car (last (s-split "/" (deloitte-start-of-current-fiscal-year))))))


(defun deloitte-financial-period ()
  "Returns the deloitte financial period which is divided into 13 four week periods"
  (interactive)
  ;; start at the begining of the year
  (setq period 1)
  (setq period-walker (deloitte-ts-start-of-current-fiscal-year))

  ;; walk forward in 4 week periods until >= today ??
  (while (ts> (ts-now) period-walker)
    (setq period-walker (ts-adjust 'day 28 period-walker))
    (setq period (+ period 1)))

  ;; thats our period.
  (setq period-s (s-concat (deloitte-current-fiscal-year-abbrev) "-P"
                           (number-to-string period)))

  (if (called-interactively-p 'any)
      (message period-s))

  period-s)
