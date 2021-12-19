;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Install straight.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Basic Configurations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-screen t)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq ring-bell-function 'ignore)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq require-final-newline t)
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'auto-fill-mode)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default indent-tabs-mode nil)   
(setq-default tab-width 4)            
;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)
(global-display-line-numbers-mode 0) ; line number in margin
(global-hl-line-mode 0) ; highlight current line
(global-auto-revert-mode 1)
;; scroll to the bottom of repls on output
(add-hook 'comint-output-filter-functions 'comint-postoutput-scroll-to-bottom)

(defvar default-gc-cons-threshold most-positive-fixnum
  "for startup make hella big during startup.")

;; make garbage collector less invasive
(setq gc-cons-threshold default-gc-cons-threshold gc-cons-percentage 0.6)

;; ediff in same window
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; my email
(setq user-full-name "Donald Brady" user-mail-address "donald.brady@gmail.com")

;; make epa ask for passwords in minibuffer
(setq epa-pinentry-mode 'loopback)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Savefile, backup and autosave directories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst dbrady-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p dbrady-savefile-dir) (make-directory dbrady-savefile-dir))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; saveplace remembers your location in a file when saving files
(straight-use-package 'saveplace)
(setq save-place-file (expand-file-name "saveplace" dbrady-savefile-dir))
(setq-default save-place t)

(straight-use-package 'savehist)
(setq savehist-additional-variables
      ;; search entries
      '(search-ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (expand-file-name "savehist" dbrady-savefile-dir))
(savehist-mode +1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Handle any custom code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; custom settings will be saved in custom.el and loaded from there
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))


;; load any .el files in the /lisp directory
(defun load-directory (dir)
  (let ((load-it (lambda (f)
                   (load-file (concat (file-name-as-directory dir) f)))
                 ))
    (mapc load-it (directory-files dir nil "\\.el$"))))

(load-directory "~/.emacs.d/lisp")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Vanilla Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; enable use-package syntactic sugar
(straight-use-package 'use-package)

(straight-use-package 'eglot)
(straight-use-package 'elec-pair)
(straight-use-package 'flycheck)
(straight-use-package 'git-timemachine)
(straight-use-package 'gnuplot)
(straight-use-package 's) ;; some nice easy string manipulation functions
(straight-use-package 'magit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Recent File Saving
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'recentf)
(setq recentf-save-file (expand-file-name "recentf" dbrady-savefile-dir))
(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 15)
(setq recentf-auto-cleanup 'never)
(recentf-mode +1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Dired Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dired mode is built in and powerful but easy to forget the commands and
;; capabilities. Make things a bit easier to remember for me

;; dired-x comes with emacs but isn't loaded by default.
(require 'dired-x)

(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq dired-dwim-target t) ;; guess destination
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

(define-key dired-mode-map (kbd "% f") 'find-name-dired)
(define-key dired-mode-map (kbd "% .") 'dired-omit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Text Scaling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'default-text-scale)
(default-text-scale-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Ivy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Ivy is a completion framework

(straight-use-package 'ivy)
(setq ivy-use-virtual-buffers t)
(setq ivy-use-selectable-prompt t)
(setq enable-recursive-minibuffers t)
(ivy-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Swiper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'swiper)
(define-key global-map (kbd "\C-s") 'swiper)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Orderless
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'orderless)
(setq completion-styles '(orderless))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Marginalia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable richer annotations using the Marginalia package
(use-package marginalia :straight t
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Pdf Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'pdf-tools)
(pdf-loader-install)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Yas Snippets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'yasnippet)
(straight-use-package 'yasnippet-snippets)
(yas-global-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Projetile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'projectile)
(setq projectile-switch-project-action #'projectile-switch-project)
(projectile-mode +1)
(define-key global-map (kbd "\C-c p p") projectile-switch-project-action)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Org Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'org)
(straight-use-package 'org-superstar)
(straight-use-package 'org-edna)
(straight-use-package 'org-ql)
(straight-use-package 'counsel)
(require 'org-habit)
     
;; Some basic configuration for Org Mode beginning with minor modes for spell
;; checking and replacing the =*='s with various types of bullets.
   
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(define-key org-mode-map (kbd "C-c l") 'org-store-link)
(define-key org-mode-map (kbd "C-x n s") 'org-toggle-narrow-to-subtree)
(define-key org-mode-map (kbd "C-c C-j") 'counsel-org-goto)
     
(setq org-image-actual-width nil)
(setq org-modules (append '(org-protocol) org-modules))
(setq org-modules (append '(habit) org-modules))
(setq org-catch-invisible-edits 'smart)
(setq org-ctrl-k-protect-subtree t)
(set-face-attribute 'org-headline-done nil :strike-through t)
(setq org-return-follows-link t)
(setq org-adapt-indentation t)

;; Org File Locations

;; My setup now includes two org-directories under an umberlla OrgDocuments
;; directory. They are personal and dcllp (work). The default opening setup is
;; to default to personal.
   
(setq org-directory-personal "~/OrgDocuments/personal")
(setq org-directory-work "~/OrgDocuments/dcllp")
(setq org-directory org-directory-personal)
(setq org-id-locations-file (expand-file-name ".org-id-locations" org-directory))
(setq org-attach-dir-relative t)
(setq org-agenda-files (directory-files-recursively org-directory "org$"))
(setq org-default-notes-file (concat org-directory "/index.org"))

;; Org Roam

;; Likewise org-roam defaults to personal.
   
(setq org-roam-v2-ack t)
(straight-use-package 'org-roam)
(setq org-roam-directory (expand-file-name "roam" org-directory))
(org-roam-db-sync)

;; required for org-roam bookmarklet 
(require 'org-roam-protocol)

;; Org-roam Capture Templates
    
;; Starter pack. If there is only one, it uses automatically without asking.

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags: %^G:\n")
         :unnarrowed t)
        ("y" "yank" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags: %^G\n%c\n")
         :unnarrowed t)
        ("o" "org-roam-it" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags:\n{ref}\n")
         :unnarrowed t)))


;; Language Support

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ruby . t)
   (python . t)
   (sql . t)
   (shell . t)
   (clojure . t)
   (gnuplot . t)))

;; Don't ask before evaluating code blocks.

(setq org-confirm-babel-evaluate nil)

;; =htmlize= is used to ensure that exported code blocks use syntax highlighting.

;; Translate regular ol' straight quotes to typographically-correct curly quotes
;; when exporting.

(setq org-export-with-smart-quotes t)

;;    Settings related to source code blocks

(setq org-src-fontify-natively t) ;; syntax highlighting in source blocks
(setq org-src-tab-acts-natively t) ;; Make TAB act as if language's major mode.
(setq org-src-window-setup 'current-window) ;; Use the current window rather than popping open a new onw

;; Task Handling and Agenda

;; Establishes the states and other settings related to task handling. 

(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-deadline-warning-days 7)

(setq org-todo-keywords '((sequence
                           "TODO(t)"
                           "STARTED(s)"
                           "WAITING(w)" "|"
                           "DONE(d)"
                           "SUSPENDED(u)"
                           "SKIPPED(k)")))
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-reschedule 'note)

;; agenda settings
(setq org-agenda-span 1)
(setq org-agenda-start-on-weekday nil)

;; Normally bound to org-agenda-sunrise-sunset which is kinda useless
(add-hook 'org-agenda-mode-hook (lambda ()
                                  (define-key org-agenda-mode-map (kbd "S") 'org-agenda-schedule)))
;; Normally bound to toggle diary inclusion which would never really do
(add-hook 'org-agenda-mode-hook (lambda ()
                                  (define-key org-agenda-mode-map (kbd "D") 'org-agenda-deadline)))

;;
;; Stealing Prot's agenda setup which is really nice and doesn't depend on org-super-agenda
;;

(setq org-agenda-custom-commands
      `(("A" "Daily agenda and top priority tasks"
         ((tags-todo "*"
                     ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
                      (org-agenda-skip-function
                       `(org-agenda-skip-entry-if
                         'notregexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))))
                      (org-agenda-block-separator nil)
                      (org-agenda-overriding-header "Important tasks without a date\n")))
          (agenda "" ((org-agenda-span 1)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-scheduled-past-days 0)
                      ;; We don't need the `org-agenda-date-today'
                      ;; highlight because that only has a practical
                      ;; utility in multi-day views.
                      (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                      (org-agenda-format-date "%A %-e %B %Y")
                      (org-agenda-overriding-header "\nToday's agenda\n")))
          (agenda "" ((org-agenda-start-on-weekday nil)
                      (org-agenda-start-day "+1d")
                      (org-agenda-span 3)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                      (org-agenda-overriding-header "\nNext three days\n")))
          (agenda "" ((org-agenda-time-grid nil)
                      (org-agenda-start-on-weekday nil)
                      ;; We don't want to replicate the previous section's
                      ;; three days, so we start counting from the day after.
                      (org-agenda-start-day "+3d")
                      (org-agenda-span 14)
                      (org-agenda-show-all-dates nil)
                      (org-agenda-time-grid nil)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-agenda-entry-types '(:deadline))
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                      (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n")))))
        ("P" "Plain text daily agenda and top priorities"
         ((tags-todo "*"
                     ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
                      (org-agenda-skip-function
                       `(org-agenda-skip-entry-if
                         'notregexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))))
                      (org-agenda-block-separator nil)
                      (org-agenda-overriding-header "Important tasks without a date\n")))
          (agenda "" ((org-agenda-span 1)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-scheduled-past-days 0)
                      ;; We don't need the `org-agenda-date-today'
                      ;; highlight because that only has a practical
                      ;; utility in multi-day views.
                      (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                      (org-agenda-format-date "%A %-e %B %Y")
                      (org-agenda-overriding-header "\nToday's agenda\n")))
          (agenda "" ((org-agenda-start-on-weekday nil)
                      (org-agenda-start-day "+1d")
                      (org-agenda-span 3)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                      (org-agenda-overriding-header "\nNext three days\n")))
          (agenda "" ((org-agenda-time-grid nil)
                      (org-agenda-start-on-weekday nil)
                      ;; We don't want to replicate the previous section's
                      ;; three days, so we start counting from the day after.
                      (org-agenda-start-day "+3d")
                      (org-agenda-span 14)
                      (org-agenda-show-all-dates nil)
                      (org-agenda-time-grid nil)
                      (org-deadline-warning-days 0)
                      (org-agenda-block-separator nil)
                      (org-agenda-entry-types '(:deadline))
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                      (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n"))))
         ((org-agenda-with-colors nil)
          (org-agenda-prefix-format "%t %s")
          (org-agenda-current-time-string ,(car (last org-agenda-time-grid)))
          (org-agenda-fontify-priorities nil)
          (org-agenda-remove-tags t))
         ("agenda.txt"))))

(defvar prot-org-custom-daily-agenda
  ;; NOTE 2021-12-08: Specifying a match like the following does not
  ;; work.
  ;;
  ;; tags-todo "+PRIORITY=\"A\""
  ;;
  ;; So we match everything and then skip entries with
  ;; `org-agenda-skip-function'.
  `((tags-todo "*"
               ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
                (org-agenda-skip-function
                 `(org-agenda-skip-entry-if
                   'notregexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))))
                (org-agenda-block-separator nil)
                (org-agenda-overriding-header "Important tasks without a date\n")))
    (agenda "" ((org-agenda-span 1)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator nil)
                (org-scheduled-past-days 0)
                ;; We don't need the `org-agenda-date-today'
                ;; highlight because that only has a practical
                ;; utility in multi-day views.
                (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                (org-agenda-format-date "%A %-e %B %Y")
                (org-agenda-overriding-header "\nToday's agenda\n")))
    (agenda "" ((org-agenda-start-on-weekday nil)
                (org-agenda-start-day "+1d")
                (org-agenda-span 3)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator nil)
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-overriding-header "\nNext three days\n")))
    (agenda "" ((org-agenda-time-grid nil)
                (org-agenda-start-on-weekday nil)
                ;; We don't want to replicate the previous section's
                ;; three days, so we start counting from the day after.
                (org-agenda-start-day "+3d")
                (org-agenda-span 14)
                (org-agenda-show-all-dates nil)
                (org-agenda-time-grid nil)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator nil)
                (org-agenda-entry-types '(:deadline))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n"))))
  "Custom agenda for use in `org-agenda-custom-commands'.")

(setq org-agenda-custom-commands
      `(("A" "Daily agenda and top priority tasks"
         ,prot-org-custom-daily-agenda)
        ("P" "Plain text daily agenda and top priorities"
         ,prot-org-custom-daily-agenda
         ((org-agenda-with-colors nil)
          (org-agenda-prefix-format "%t %s")
          (org-agenda-current-time-string ,(car (last org-agenda-time-grid)))
          (org-agenda-fontify-priorities nil)
          (org-agenda-remove-tags t))
         ("agenda.txt"))))


;; Diary Settings
;; I've don't use the diary file but it's useful for holidays.

(setq calendar-bahai-all-holidays-flag nil)
(setq calendar-christian-all-holidays-flag t)
(setq calendar-hebrew-all-holidays-flag t)
(setq calendar-islamic-all-holidays-flag t)

;; Calfw

;;    [[https://github.com/kiwanami/emacs-calfw][Calfw]] generates useful calendar views suitable for printing or providing a
;;    more visual outlook on the day, week, two weeks, or month

(straight-use-package 'calfw)
(straight-use-package 'calfw-org)
(require 'calfw)
(require 'calfw-org)

(defun db:my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    ;;    (cfw:howm-create-source "Blue")  ; howm source
    ;;    (cfw:cal-create-source "Orange") ; diary source
    ;;    (cfw:ical-create-source "Moon" "~/moon.ics" "Gray")  ; ICS source1
    ;;    (cfw:ical-create-source "gcal" "https://..../basic.ics" "IndianRed") ; google calendar ICS
    )))

;; Org Edna
;; Provides more powerful org dependency management.

(org-edna-mode)

(defun db/org-edna-blocked-by-descendants ()
  "Adds PROPERTY blocking this tasks unless descendants are DONE"
  (interactive)
  (org-set-property "BLOCKER" "descendants"))

(defun db/org-edna-blocked-by-ancestors ()
  "Adds PROPERTY blocking this tasks unless ancestors are DONE"
  (interactive)
  (org-set-property "BLOCKER" "ancestors"))

(defun db/org-edna-current-id ()
  "Get the current ID to make it easier to set up BLOCKER ids"
  (interactive)
  (set-register 'i (org-entry-get (point) "ID"))
  (message "ID stored"))

(defun db/org-edna-blocked-by-id ()
  "Adds PROPERTY blocking task at point with specific task ID"
  (interactive)
  (org-set-property "BLOCKER" (s-concat "ids(" (get-register 'i) ")")))

(define-key org-mode-map (kbd "C-c C-x <up>") 'db/org-edna-blocked-by-ancestors)
(define-key org-mode-map (kbd "C-c C-x <down>") 'db/org-edna-blocked-by-descendants)
(define-key org-mode-map (kbd "C-c C-x <left>") 'db/org-edna-current-id)
(define-key org-mode-map (kbd "C-c C-x <right>") 'db/org-edna-blocked-by-id)
(define-key org-mode-map (kbd "C-c C-x i") 'org-id-get-create)
;; override y (agenda year) with more useful todo yesterday for marking habits done prior day 
(define-key org-agenda-mode-map (kbd "y") 'org-agenda-todo-yesterday)


;; Filter Refile Targets

;; I have monthly log files used to take notes / journal that are sources of refile
;; items but not targets. They are named YYYY-MM(w).org

(defun db-filtered-refile-targets ()
  "Removes month journals as valid refile targets"
  (remove nil (mapcar (lambda (x)
                        (if (string-match-p "journals" x)
                            nil x)) org-agenda-files)))

(setq org-refile-targets '((db-filtered-refile-targets :maxlevel . 10)))

;; Org Capture Setup

;; Org capture templates for Chrome org-capture from [[https://github.com/sprig/org-capture-extension][site]].

;;    Added this file: ~/.local/share/applications/org-protocol.desktop~ using the
;;    following command:

;;      cat > "${HOME}/.local/share/applications/org-protocol.desktop" << EOF
;;      [Desktop Entry]
;;      Name=org-protocol
;;      Exec=emacsclient %u
;;      Type=Application
;;      Terminal=false
;;      Categories=System;
;;      MimeType=x-scheme-handler/org-protocol;
;;      EOF

;;    and then run

;;      update-desktop-database ~/.local/share/applications

(require 'org-protocol)

;; *** Setting up org-protocol handler. This page has best description:
;;     [[https://github.com/sprig/org-capture-extension#set-up-handlers-in-emacs][This page]] has the best description. This is working in linux only, hence the todo. 

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat 
   (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform))
  )

(defvar my/org-contacts-template "* %(org-contacts-template-name)
        :PROPERTIES:
        :ADDRESS: %^{289 Cleveland St. Brooklyn, 11206 NY, USA}
        :MOBILE: %^{MOBILE}
        :BIRTHDAY: %^{yyyy-mm-dd}
        :EMAIL: %(org-contacts-template-email)
        :NOTE: %^{NOTE}
        :END:" "Template for org-contacts.")

;; if you set this variable you have to redefine the default t/Todo.
(setq org-capture-templates 
      `(
        ;; TODO     (t) Todo template
        ("t" "Todo" entry (file+headline ,org-default-notes-file "Refile")
         "* TODO %?"
         :empty-lines 1)
        
        ;; Note (n) template
        ("n" "Note" entry (file+headline ,org-default-notes-file "Refile")
         "* %? %(%i)"
         :empty-lines 1)
        
        ;; Protocol (p) template
        ("p" "Protocol" entry (file+headline ,org-default-notes-file "Refile")
         "* %^{Title}
                    Source: %u, %c
                   ,#+BEGIN_QUOTE
                   %i
                   ,#+END_QUOTE
                   %?"
         :empty-lines 1)
        
        ;; Protocol Link (L) template
        ("L" "Protocol Link" entry (file+headline ,org-default-notes-file "Refile")
         "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]"
         :empty-lines 1)
        
        ;; Goal (G) template
        ("G" "Goal" entry (file+headline ,org-default-notes-file "Refile")
         "* GOAL %^{Describe your goal}
      Added on %U - Last reviewed on %U
           :SMART:
           :Sense: %^{What is the sense of this goal?}
      :Measurable: %^{How do you measure it?}
         :Actions: %^{What actions are needed?}
       :Resources: %^{Which resources do you need?}
         :Timebox: %^{How much time are you spending for it?}
             :END:"
         :empty-lines 1)
        ;; Contact (c) template
        ("c" "Contact" entry (file+headline ,(concat org-directory "/contacts.org") "Contacts")
         "* %(org-contacts-template-name)
      :PROPERTIES:
       :ADDRESS: %^{289 Cleveland St. Brooklyn, 11206 NY, USA}
      :BIRTHDAY: %^{yyyy-mm-dd}
         :EMAIL: %(org-contacts-template-email)
           :TEL: %^{NUMBER}
          :NOTE: %^{NOTE}
      :END:"
         :empty-lines 1)
        ))

   
;; Personal and Work Toggle
;; Need to add mode line display of context

   
(defun db/org-work-context ()
  (interactive)
  (setq org-directory org-directory-work)
  (db/org-switch-context))

(defun db/org-personal-context ()
  (interactive)
  (setq org-directory org-directory-personal)
  (db/org-switch-context))

(defun db/org-switch-context ()
  (setq org-agenda-files (directory-files-recursively org-directory "org$"))
  (setq org-default-notes-file (concat org-directory "/index.org"))
  (setq org-id-locations-file (expand-file-name ".org-id-locations" org-directory))
  (setq org-roam-directory (expand-file-name "roam" org-directory))
  (setq org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
  (org-roam-db-sync))
   

;; Other Customizations

;; Reading Email with mu4e

;; Load mu4e
   
;; So, mu4e isn't in melpa (wtf) and has to be installed by installin mu.

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; Contexts

(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "gmail"
           :enter-func (lambda () (mu4e-message "Entering gmail context"))
           :leave-func (lambda () (mu4e-message "Leaving gmail Context"))
           ;; we match based on the contact-fields of the message
           :match-func (lambda (msg)
                         (when msg
                           (mu4e-message-contact-field-matches msg
                                                               :to "donald.brady@gmail.com")))
           :vars '( ( user-mail-address	    . "donald.brady@gmail.com"  )
                    ( user-full-name	    . "Donald Brady" )
                    ( mu4e-compose-signature .
                      (concat
                       "Donald Brady\n"
                       "e: donald.brady@gmail.com\n"))))))



(setq mu4e-context-policy 'pick-first)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; these must start with a "/", and must exist
;; (i.e.. /home/user/Maildir/gmail/Sent must exist) you use e.g. 'mu mkdir' and
;; 'mu init' to make the Maildirs if they don't already exist.

(setq mu4e-sent-folder   "/gmail/Sent")
(setq mu4e-drafts-folder "/gmail/Drafts")
(setq mu4e-trash-folder  "/gmail/Trash")
(setq mu4e-refile-folder "/gmail/Archive")

;; Fetching

;; Use mbsync for fetching email.

(setq mu4e-get-mail-command "mbsync -V gmail")

;; Composing

;; Reading

(setq mu4e-attachment-dir "~/Downloads")  

(define-key mu4e-view-mode-map (kbd "C-c C-o") 'mu4e~view-browse-url-from-binding)  

;; View images inline

(setq mu4e-view-show-images t)
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))


;; Sending

;; You will need to install =msmtp= and configure that as needed.
   
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil 't)
(setq sendmail-program "msmtp") 


;; Org Agena Integration

(require 'org-mu4e)
(setq org-mu4e-link-query-in-headers-mode nil)

;; Org Contacts

;; (straight-use-package 'org-contacts)

(setq org-contacts-files '("~/OrgDocuments/personal/contacts.org"))
(setq mu4e-org-contacts-file (car org-contacts-files))
(add-to-list 'mu4e-headers-actions
             '("org-contact-add" . mu4e-action-add-org-contact) t)
(add-to-list 'mu4e-view-actions
             '("org-contact-add" . mu4e-action-add-org-contact) t)

;; Key Binding
(global-set-key (kbd "C-c m") 'mu4e)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Elfeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(straight-use-package 'elfeed-org)
(use-package elfeed :straight t
  :ensure elfeed-org
  :config
  (setq elfeed-set-max-connections 32)
  (setq rmh-elfeed-org-files (list (expand-file-name "rss-feeds.org" org-directory-personal)))
  (elfeed-org)
  :bind
  (("C-c r" . elfeed)
   :map elfeed-show-mode-map
   ("o" . elfeed-show-visit)
   :map elfeed-search-mode-map
   ("o" . elfeed-search-browse-url)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Blogging / Org2Blog
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://www.donald-brady.com


(straight-use-package 'org2blog)
(require 'org2blog)
(setq org2blog/wp-blog-alist
      '(
        ("wordpress"
         :url "https://donaldbrady.wordpress.com/xmlrpc.php"
         :username "donald.brady@gmail.com")))
(setq org2blog/wp-image-upload t)
(setq org2blog/wp-image-thumbnails t)

(define-key global-map (kbd "\C-c h") 'org2blog-user-interface)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Globally set keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; keyboard macros
(global-set-key (kbd "<f1>") 'start-kbd-macro)
(global-set-key (kbd "<f2>") 'end-kbd-macro)
(global-set-key (kbd "<f3>") 'call-last-kbd-macro)

(define-key global-map (kbd "\C-ca") 'org-agenda)
(define-key global-map (kbd "\C-cc") 'org-capture)
(define-key global-map (kbd "C-c n b") 'org-roam-buffer-toggle)
(define-key global-map (kbd "C-c n f") 'org-roam-node-find)
(define-key global-map (kbd "C-c n c") 'org-roam-capture)              
(define-key global-map (kbd "C-c n g") 'org-roam-graph)
(define-key global-map (kbd "C-c n i") 'org-roam-insert)
(define-key global-map (kbd "C-c n .") 'org-roam-dailies-goto-today)
(define-key global-map (kbd "C-c n d") 'org-roam-dailies-capture-today)
(define-key global-map (kbd "C-c n y") 'org-roam-dailies-goto-yesterday)
(define-key global-map (kbd "C-c n t") 'org-roam-dailies-goto-tomorrow)
(define-key global-map (kbd "C-c n i") 'org-roam-node-insert)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Lenovo Function Key Bindings
(global-set-key (kbd "<XF86Favorites>") 'bury-buffer) ;; The Star on F12
(global-set-key (kbd "<f12>") 'bury-buffer) ;; F12 on logi keybpard

;; M-0 to toggle hiding
(global-set-key (kbd "M-0") 'hs-toggle-hiding)

;; toggle line numbers
(global-set-key (kbd "C-c l") 'display-line-numbers-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-theme 'modus-vivendi t)
(setq modus-themes-variable-pitch-ui t)
(setq modus-themes-variable-pitch-headings t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; start a server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "server")
(unless (server-running-p) (server-start))
(put 'upcase-region 'disabled nil)
