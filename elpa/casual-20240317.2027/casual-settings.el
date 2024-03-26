;;; casual-settings.el --- Casual Settings Menu      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'calc)
(require 'transient)
(require 'casual-labels)
(require 'casual-angle-measure)

(transient-define-prefix casual-modes-menu ()
  "Casual modes menu."
  [["Modes"
    :pad-keys t
    ("A" calc-algebraic-mode
     :description (lambda ()
                    (casual--checkbox-label calc-algebraic-mode
                                            "Algebraic Mode"))
     :transient t)
    ("z" "Leading Zeroes" calc-leading-zeros
     :description (lambda ()
                    (casual--checkbox-label calc-leading-zeros
                                            "Leading Zeroes"))
     :transient t)
    ("F" calc-frac-mode :description casual-prefer-frac-label :transient t)
    ("s" calc-symbolic-mode :description casual-symbolic-mode-label :transient t)
    ("p" calc-polar-mode :description casual-cmplx-or-polar-label :transient t)
    ;; ("m" calc-matrix-mode :description casual-matrix-mode-label :transient nil) ; this is really about symbolic computation
    ("c" "Complex Number Format›" casual-complex-format-menu
     :description (lambda ()
                    (format "Complex Number Format (now %s)›"
                            (casual-complex-format-label)))
     :transient t)
    ("P" calc-precision
     :description (lambda ()
                    (format "Precision (now %d)" calc-internal-prec))
     :transient t)
    ("S" "Save Calc Settings" calc-save-modes :transient t)]
   ["Angular Measure"
    ("a" casual-angle-measure-menu
     :description (lambda ()
                    (format "Angle Measure (now %s)›"
                            (casual-angle-mode-label)))
     :transient t)]]
  [["Display"
    ("R" casual-radix-menu
     :description (lambda ()
                    (format "Radix (now %s)›" (casual-number-radix-label)))
     :transient t)
    ("f" casual-float-format-menu
     :description (lambda ()
                    (format "Float Formats (now %s)›"
                            (casual-float-format-label)))
     :transient t)
    ("g" calc-group-digits
     ;; TODO calc-group-digits can actually be an int 😦
     :description (lambda ()
                    (casual--checkbox-label calc-group-digits
                                            "Thousands Separators"))
     :transient t)
    ;; TODO show current value thousands separators
    ("," "Set Thousands Separator" calc-group-char :transient t)
    ("." "Decimal Separator" calc-point-char :transient t)
    ("H" "ℎ𝑚𝑠 Format" calc-hms-notation
     :description (lambda ()
                    (format
                     "ℎ𝑚𝑠 Format (%s)"
                     (format calc-hms-format "" "" "")))
     :transient t)]

   ["Reset"
    ("C-M-r" "Calc Reset" calc-reset :transient t)]]
  [:class transient-row
          ("C-g" "‹Back" ignore :transient transient--do-return)
          ("q" "Dismiss" ignore :transient transient--do-exit)])

(transient-define-prefix casual-complex-format-menu ()
  "Casual complex formats menu."
  ["Complex Number Format"
   :description (lambda ()
                  (format "Complex Number Format (now %s)"
                          (casual-complex-format-label)))
   ("c" calc-complex-notation
    :description "complex (rectangular) notation"
    :transient nil)

   ("i" calc-i-notation
    :description "𝑖 notation"
    :transient nil)

   ("j" calc-j-notation
    :description "𝑗 notation"
    :transient nil)]
  [:class transient-row
          ("C-g" "‹Back" ignore :transient transient--do-return)
          ("q" "Dismiss" ignore :transient transient--do-exit)
          ("U" "Undo Stack" calc-undo :transient t)])


(transient-define-prefix casual-float-format-menu ()
  "Casual float formats menu."
  ["Float Format (𝑛 is 𝟣: on stack)"
   ("n" "Normal" calc-normal-notation :transient nil)
   ("f" "Fixed Point 𝑛" calc-fix-notation :transient nil)
   ("s" "Scientific" calc-sci-notation :transient nil)
   ("e" "Engineering" calc-eng-notation :transient nil)]
  [:class transient-row
          ("C-g" "‹Back" ignore :transient transient--do-return)
          ("q" "Dismiss" ignore :transient transient--do-exit)
          ("U" "Undo Stack" calc-undo :transient t)])



(provide 'casual-settings)
;;; casual-settings.el ends here
