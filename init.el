;; -*- lexical-binding: t -*-

;;
;; Emacs configuration file
;; donald.brady@gmail.com
;;

;;
;; Use elpaca package manager instead of use-package
;;

(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))


;;
;; Basic Settings
;;

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
(setq tab-always-indent 'complete)
(global-hl-line-mode 0)                                                        ;; highlight current line
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq-default buffer-file-coding-system 'utf-8-unix)    
(add-hook 'comint-output-filter-functions 'comint-postoutput-scroll-to-bottom) ;; scroll to the bottom of repls on output
(setq delete-by-moving-to-trash t)
(global-unset-key (kbd "C-z"))
(setq confirm-kill-processes nil)
(setq custom-safe-themes t)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(setq user-full-name "Donald Brady" user-mail-address "donald.brady@gmail.com")

;;
;; Packages to load
;;

(elpaca all-the-icons)
(elpaca all-the-icons-dired)
(elpaca avy)
(elpaca counsel)
(elpaca deadgrep)
(elpaca demap)
(elpaca (denote :tag "3.3.0"))
(elpaca diminish)
(elpaca doom-themes)
(elpaca ef-themes)
(elpaca elfeed)
(elpaca elfeed-org)
(elpaca embark)
(elpaca embark-consult)
(elpaca exec-path-from-shell)
(elpaca frecentf)
(elpaca git-gutter)
(elpaca git-timemachine)
(elpaca gnuplot)
(elpaca hydra)
(elpaca jinx)
(elpaca lem)
(elpaca magit)
(elpaca marginalia)
(elpaca mastodon)
(elpaca mpv)
(elpaca nerd-icons)
(elpaca nyan-mode)
(elpaca orderless)
(elpaca (org :tag "release_9.7.7"))
(elpaca org-attach-screenshot)
(elpaca org-contrib)
(elpaca org-download)
(elpaca org-present)
(elpaca org-ql)
(elpaca org-roam)
(elpaca org-side-tree)
(elpaca org-super-agenda)
(elpaca org-superstar)
(elpaca org2blog)
(elpaca pdf-tools)
(elpaca projectile)
(elpaca s)
(elpaca swiper)
(elpaca treesit-auto)
(elpaca vertico)
(elpaca visual-fill-column)
(elpaca which-key)
(elpaca yasnippet)
(elpaca yasnippet-snippets)

(elpaca-wait)

;;
;; Set up save-file, recent files, and auto-save features
;;

(require 'savehist)
(require 'saveplace)

(defconst dbrady-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p dbrady-savefile-dir) (make-directory dbrady-savefile-dir))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(savehist-mode +1)

(setq recentf-save-file (expand-file-name "recentf" dbrady-savefile-dir))
(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 15)
(setq recentf-auto-cleanup 'never)
(recentf-mode +1)


;;
;; OS Specific Setups
;;

(when (and (eq system-type 'gnu/linux)
           (string-match
            "Linux.*Microsoft.*Linux"
            (shell-command-to-string "uname -a")))
  (setq
   browse-url-generic-program  "/mnt/c/Windows/System32/cmd.exe"
   browse-url-generic-args     '("/c" "start")
   browse-url-browser-function #'browse-url-generic))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)
  (keymap-global-unset "s-W")) ;; prevent Command+w from closing the frame


;;
;; Visual Appearance including Theme
;;
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(which-key-mode t)
(load-theme 'ef-deuteranopia-dark)
(nyan-mode)

(defun db/set-transparency (alpha)
  "Set the alpha (transparency) value of the current frame."
  (interactive "nEnter alpha value (0-100, default is 100): ")
  (setq alpha (if (null alpha) 100 alpha)) ; Set default to 100 if no input
  (when (and (numberp alpha) (>= alpha 0) (<= alpha 100))
    (set-frame-parameter (selected-frame) 'alpha alpha)
    (message "Frame alpha set to %d" alpha)))


;;
;; Jinx Spellchecker
;;

(keymap-global-set "M-$" 'jinx-correct)
(global-jinx-mode)


;;
;; Abbrevs
;;
(setq-default abbrev-mode t)

(defun db/expand-abbrev-or-dynamic ()
"Try to expand Emacs abbrev; if it fails, try dynamic abbrev."
(interactive)
(or (expand-abbrev)
    (dabbrev-expand nil)))


;;
;; Avy
;;

(keymap-global-set "M-g l" 'avy-goto-line)
(keymap-global-set "M-g c" 'avy-goto-char-timer)

;;
;; Dired Mode
;;

(require 'dired-x) ;; dired-x comes with emacs but isn't loaded by default.

(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq dired-dwim-target t) ;; guess destination
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;; add these simple keys to dired mode
(define-key dired-mode-map (kbd "% f") 'find-name-dired)
(define-key dired-mode-map (kbd "% .") 'dired-omit-mode)
(define-key dired-mode-map (kbd "% w") 'db/wsl-open-in-external-app)


;;
;; PDF Tools
;;

(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-page)
           
(define-key pdf-view-mode-map "?" 'hydra-pdftools/body)
(define-key pdf-view-mode-map "<s-spc>" 'pdf-view-scroll-down-or-next-page)
(define-key pdf-view-mode-map "g"  'pdf-view-first-page)
(define-key pdf-view-mode-map "G"  'pdf-view-last-page)
(define-key pdf-view-mode-map "l"  'image-forward-hscroll)
(define-key pdf-view-mode-map "h"  'image-backward-hscroll)
(define-key pdf-view-mode-map "j"  'pdf-view-next-page)
(define-key pdf-view-mode-map "k"  'pdf-view-previous-page)
(define-key pdf-view-mode-map "e"  'pdf-view-goto-page)
(define-key pdf-view-mode-map "u"  'pdf-view-revert-buffer)
(define-key pdf-view-mode-map "al" 'pdf-annot-list-annotations)
(define-key pdf-view-mode-map "ad" 'pdf-annot-delete)
(define-key pdf-view-mode-map "aa" 'pdf-annot-attachment-dired)
(define-key pdf-view-mode-map "am" 'pdf-annot-add-markup-annotation)
(define-key pdf-view-mode-map "at" 'pdf-annot-add-text-annotation)
(define-key pdf-view-mode-map "y"  'pdf-view-kill-ring-save)
(define-key pdf-view-mode-map "i"  'pdf-misc-display-metadata)
(define-key pdf-view-mode-map "s"  'pdf-occur)
(define-key pdf-view-mode-map "b"  'pdf-view-set-slice-from-bounding-box)
(define-key pdf-view-mode-map "r"  'pdf-view-reset-slice)


;;
;; Yas Snippets
;;

(yas-global-mode 1)


;;
;; Vertico
;;
(vertico-mode)
(vertico-multiform-mode)
(add-to-list 'vertico-multiform-categories '(jinx grid (vertico-grid-annotate . 20)))


;;
;; Marginalia
;;

(marginalia-mode 1)


;;
;; Embark
;;

(keymap-global-set "C-." 'embark-act)        ;; pick some comfortable binding
(keymap-global-set "C-;" 'embark-dwim)       ;; good alternative: M-.
(keymap-global-set "C-h B" 'embark-bindings) ;; alternative for `describe-bindings'

;; Hide the mode line of the Embark live/completions buffers
(add-to-list 'display-buffer-alist '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*" nil (window-parameters (mode-line-format . none))))


;;
;; Orderless
;;
(setq completion-styles '(orderless basic))


;;
;; Swiper
;;
(keymap-global-set "C-s" 'swiper)


;;
;; Swiper
;;
(projectile-mode +1)

;;
;; Denote
;;

;; Remember to check the doc strings of those variables.
(setq denote-directory (expand-file-name "~/OrgDocuments/personal"))
(setq denote-save-buffers nil)
(setq denote-known-keywords '("threev" "personal" "daily"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-file-type nil) ; Org is the default, set others here
(setq denote-prompts '(title keywords))
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)
(setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))

;; Pick dates, where relevant, with Org's advanced interface:
(setq denote-date-prompt-use-org-read-date t)


;; Read this manual for how to specify `denote-templates'.  We do not
;; include an example here to avoid potential confusion.


(setq denote-date-format nil) ; read doc string

;; By default, we do not show the context of links.  We just display
;; file names.  This provides a more informative view.
(setq denote-backlinks-show-context t)

;; Also see `denote-link-backlinks-display-buffer-action' which is a bit
;; advanced.

;; If you use Markdown or plain text files (Org renders links as buttons
;; right away)
(add-hook 'text-mode-hook #'denote-fontify-links-mode-maybe)

;; We use different ways to specify a path for demo purposes.
(setq denote-dired-directories
      (list denote-directory
            (thread-last denote-directory (expand-file-name "attachments"))
            (expand-file-name "~/Documents/books")))

;; Generic (great if you rename files Denote-style in lots of places):
;; (add-hook 'dired-mode-hook #'denote-dired-mode)
;;
;; OR if only want it in `denote-dired-directories':
(add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)


;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
(denote-rename-buffer-mode 1)

;; Denote DOES NOT define any key bindings.  This is for the user to
;; decide.  For example:
(let ((map global-map))
  (define-key map (kbd "C-c n n") #'denote)
  (define-key map (kbd "C-c n c") #'denote-region) ; "contents" mnemonic
  (define-key map (kbd "C-c n N") #'denote-type)
  (define-key map (kbd "C-c n d") #'denote-date)
  (define-key map (kbd "C-c n z") #'denote-signature) ; "zettelkasten" mnemonic
  (define-key map (kbd "C-c n s") #'denote-subdirectory)
  (define-key map (kbd "C-c n t") #'denote-template)
  ;; If you intend to use Denote with a variety of file types, it is
  ;; easier to bind the link-related commands to the `global-map', as
  ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
  ;; `markdown-mode-map', and/or `text-mode-map'.
  (define-key map (kbd "C-c n i") #'denote-link) ; "insert" mnemonic
  (define-key map (kbd "C-c n I") #'denote-add-links)
  (define-key map (kbd "C-c n b") #'denote-backlinks)
  (define-key map (kbd "C-c n f f") #'denote-find-link)
  (define-key map (kbd "C-c n f b") #'denote-find-backlink)
  ;; Note that `denote-rename-file' can work from any context, not just
  ;; Dired bufffers.  That is why we bind it here to the `global-map'.
  (define-key map (kbd "C-c n r") #'denote-rename-file)
  (define-key map (kbd "C-c n R") #'denote-rename-file-using-front-matter))

;; Key bindings specifically for Dired.
(let ((map dired-mode-map))
  (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
  (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-files)
  (define-key map (kbd "C-c C-d C-k") #'denote-dired-rename-marked-files-with-keywords)
  (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))

(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

;; Also check the commands `denote-link-after-creating',
;; `denote-link-or-create'.  You may want to bind them to keys as well.


;; If you want to have Denote commands available via a right click
;; context menu, use the following and then enable
;; `context-menu-mode'.
(add-hook 'context-menu-functions #'denote-context-menu)


;;;;
;;;; Org Mode
;;;;
(setq org-directory "~/OrgDocuments/personal")
(setq org-id-locations-file (expand-file-name ".org-id-locations" org-directory))
(setq org-attach-dir-relative t)

;; various helper functions for finding files
(defun db/current-index-file ()
  "Returns the current index file which is dependent on current context" 
  (expand-file-name "index.org" org-directory))

(setq org-default-notes-file (db/current-index-file))


(defun db/current-monthly-journal ()
  "Returns the current months journal"
  (setq current-year (format-time-string "%Y"))
  (setq current-month (format-time-string "%m"))
  (concat org-directory "/journals/" current-year "/" current-year "-" current-month ".org"))

(defun db/get-all-directories (directory)
  "Return a list of DIRECTORY and all its subdirectories, excluding directories with a '.orgexclude' file."
  (let ((directories '()))
    (dolist (file (directory-files directory t))
      (when (and (file-directory-p file)
                 (not (string-prefix-p "." (file-name-nondirectory file)))
                 (not (file-exists-p (expand-file-name ".orgexclude" file))))
        (setq directories (append directories (list file)))))
    (append (list directory) (mapcan 'db/get-all-directories directories))))

(defun db/get-org-files-in-directories (directories)
  "Return a list of all .org and .org.gpg files within the given DIRECTORIES."
  (let ((org-files '()))
    (dolist (dir directories)
      (dolist (file (directory-files dir t))
        (let ((name (file-name-nondirectory file)))
          (when (or (and (not (string-prefix-p "." name)) (string-suffix-p ".org" name))
                    (and (not (string-prefix-p "." name)) (string-suffix-p ".org.gpg" name))
                    )
            (push file org-files)))))
    org-files))

(defun db/org-agenda-files ()
  (db/get-org-files-in-directories (db/get-all-directories org-directory)))

(setq org-agenda-files (db/org-agenda-files))

(defun db/refresh-org-files-list ()
  "Update the list of org-agenda-file"
  (interactive)
  (setq org-agenda-files (db/org-agenda-files)))


(defun db/last-download ()
  (let ((downloads-dir "~/Downloads/"))
    (if (file-directory-p downloads-dir)
        (progn
          (setq files (cl-delete ".DS_Store" (directory-files "~/Downloads" t nil 'nosort) :test 'equal))
          (if files
              (progn
                (setq newest-file
                      (car (last (sort (cl-remove-if-not #'file-regular-p files)
                                       (lambda (a b)
                                         (time-less-p (nth 5 (file-attributes a))
                                                      (nth 5 (file-attributes b))))))))
                (if newest-file
                    (find-file newest-file)
                  (message "No files found in %s" downloads-dir))))))))

(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(setq org-image-actual-width nil)
;;(setq org-modules (append '(org-protocol) org-modules))
(setq org-catch-invisible-edits 'smart)
(setq org-ctrl-k-protect-subtree t)
;;(set-face-attribute 'org-headline-done nil :strike-through t)
(setq org-return-follows-link t)
(setq org-adapt-indentation t)
(setq org-odt-preferred-output-format "docx")
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)

;; all my org related keys will be set up in this keymap
(global-set-key
 (kbd "C-c o")
 (define-keymap
   :prefix 'db/org-key-map
   "l" 'org-store-link
   "c" 'org-capture
   "a" 'org-agenda))

(setq org-roam-v2-ack t)
(setq org-roam-directory (expand-file-name "roam" org-directory))
(setq org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
(setq org-roam-db-autosync-mode t)

;; required for org-roam bookmarklet 
(require 'org-roam-protocol)

;; Org-roam Capture Templates

;; Starter pack. If there is only one, it uses automatically without asking.

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags: %^G:\n\n* ${title}\n\n")
         :unnarrowed t)
        ("y" "yank" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags: %^G\n\n%c\n\n")
         :unnarrowed t)
        ("r" "region" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags: %^G\n\n%i\n\n")
         :unnarrowed t)

        ("o" "org-roam-it" plain "%?"
         :if-new (file+head"%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                           "#+title: ${title}\n#+filetags:\n{ref}\n")
         :unnarrowed t)))

(add-hook 'org-capture-after-finalize-hook
          (lambda ()
            (if (org-roam-file-p)
                (org-roam-db-sync))))

;; this is required to get matching on tags
(setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:10}" 'face 'org-tag)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ruby . t)
   (python . t)
   (sql . t)
   (shell . t)
   (clojure . t)
   (gnuplot . t)))

(setq org-confirm-babel-evaluate nil)
(setq org-export-with-smart-quotes t)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-window-setup 'current-window)

(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-deadline-warning-days 7)

(setq org-todo-keywords '((sequence
                           "TODO(t)"
                           "STARTED(s)"
                           "WAITING(w)"
                           "DELEGATED(g)"
                           "HOLD(h)" "|"
                           "DONE(d)"
                           "SUSPENDED(u)")))


(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "blue" :weight bold))
        ("STARTED" . (:foreground "green"))
        ("DONE" . (:foreground "pink"))
        ("WAITING" . (:foreground "orange"))
        ("DELEGATED" . (:foreground "orange"))
        ("HOLD" . (:foreground "orange"))
        ("SUSPENDED" . (:foreground "forest green"))
        ("TASK" . (:foreground "blue"))))

(setq org-tags-exclude-from-inheritance '("project" "interview" "call" "errand" "meeting")
      org-stuck-projects '("+project/-MAYBE-DONE"
                           ("TODO" "WAITING" "DELEGATED") ()))

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-reschedule 'note)

;; agenda settings
(setq org-agenda-span 1)
(setq org-agenda-start-on-weekday nil)

(add-hook 'org-agenda-mode-hook (lambda ()
                                  (define-key org-agenda-mode-map (kbd "S") 'org-agenda-schedule)))
(add-hook 'org-agenda-mode-hook (lambda ()
                                  (define-key org-agenda-mode-map (kbd "D") 'org-agenda-deadline)))

(require 'org-super-agenda)
(setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Today"  ; Optionally specify section name
                :time-grid t  ; Items that appear on the time grid
                :todo "TODAY")  ; Items that have this TODO keyword
         (:name "Projects"
                :tag "project")
         (:name "Important"
                :priority "A")
         ;; Set order of multiple groups at once
         ;; (:order-multi (2 (:name "Shopping in town"
         ;;                         ;; Boolean AND group matches items that match all subgroups
         ;;                         :and (:tag "shopping" :tag "@town"))
         ;;                  (:name "Food-related"
         ;;                         ;; Multiple args given in list with implicit OR
         ;;                         :tag ("food" "dinner"))
         ;;                  (:name "Personal"
         ;;                         :habit t
         ;;                         :tag "personal")
         ;;                  (:name "Space-related (non-moon-or-planet-related)"
         ;;                         ;; Regexps match case-insensitively on the entire entry
         ;;                         :and (:regexp ("space" "NASA")
         ;;                                       ;; Boolean NOT also has implicit OR between selectors
         ;;                                       :not (:regexp "moon" :tag "planet")))))
         ;; Groups supply their own section names when none are given
         (:todo "WAITING" :order 8)  ; Set order of this section
         (:todo "DELEGATED" :order 8)
         (:name "NBAs" :tag "nba")
         (:name "threev" :tag "threev")
         (:name "srv" :tag "shiftright")
         (:name "rpr" :tag "rpr")
         (:name "Errands" :tag "errand")
         (:name "Chores" :tag "chore")
         (:name "Calls" :tag "call")
         (:todo ("EVENT" "INFO" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
                ;; Show this group at the end of the agenda (since it has the
                ;; highest number). If you specified this group last, items
                ;; with these todo keywords that e.g. have priority A would be
                ;; displayed in that group instead, because items are grouped
                ;; out in the order the groups are listed.
                :order 9)
         (:priority<= "B"
                      ;; Show this section after "Today" and "Important", because
                      ;; their order is unspecified, defaulting to 0. Sections
                      ;; are displayed lowest-number-first.
                      :order 1)
         ;; After the last group, the agenda will display items that didn't
         ;; match any of these groups, with the default order position of 99
         (:name "Reading"
                :tag "read")

         ))
(org-super-agenda-mode t)

(setq calendar-bahai-all-holidays-flag nil)
(setq calendar-christian-all-holidays-flag t)
(setq calendar-hebrew-all-holidays-flag t)
(setq calendar-islamic-all-holidays-flag t)

(require 'org-ql-search)

(defun db-filtered-refile-targets ()
  "Removes month journals as valid refile targets"
  (remove nil (mapcar (lambda (x)
                        (if (string-match-p "journals" x)
                            nil x)) org-agenda-files)))

(setq org-refile-targets '((db-filtered-refile-targets :maxlevel . 10)))

(require 'org-protocol)

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat 
   (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform))
  )

(defvar db/org-contacts-template "* %(org-contacts-template-name)
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

        ;; ("t" "Tasks")

        ;; TODO     (t) Todo template
        ("t" "Todo" entry (file+headline ,org-default-notes-file "Refile")
         "* TODO %?"
         :empty-lines 1)

        ;; ;; Note (n) template
        ("n" "Note" entry (file+headline ,org-default-notes-file "Refile")
         "* %? %(%i)"
         :empty-lines 1)

        ;; Protocol (p) template
        ("p" "Protocol" entry (file+headline ,org-default-notes-file "Refile")
         "* %^{Title}
                    Source: %u, %c
                   #+BEGIN_QUOTE
                   %i
                   #+END_QUOTE
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

(require 'org-download)
(setq org-download-method 'attach)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(define-keymap
  :keymap db/org-key-map
  ;; dalies hang of C-c o d
  "d ."    'org-roam-dailies-goto-today
  "d d"    'org-roam-dailies-capture-today
  "d y"    'org-roam-dailies-goto-yesterday
  "d t"    'org-roam-dailies-goto-tomorrow
  ;; roam hang of C-c o r
  "r b"    'org-roam-buffer-toggle
  "r f"    'org-roam-node-find
  "r c"    'org-roam-capture              
  "r g"    'org-roam-graph
  "r i"    'org-roam-node-insert
  ;; counsel mish mash
  "r r"    'counsel-rg
  "j"      'counsel-org-goto-all
  "n o"    'counsel-org-agenda-headlines
  "n l"    'db/counsel-org-agenda-insert-link-to-headlines
  "r l"    'counsel-org-link
  "s"      'org-attach-screenshot)

;; override y (agenda year) with more useful todo yesterday for marking habits done prior day 
(define-key org-agenda-mode-map (kbd "y") 'org-agenda-todo-yesterday)


;;
;; Elfeed
;;
(setq elfeed-set-max-connections 32)
(setq rmh-elfeed-org-files (list (expand-file-name "rss-feeds.org" org-directory)))
(elfeed-org)
(keymap-global-set "C-c r" 'elfeed)
(define-key elfeed-show-mode-map (kbd "o") 'elfeed-show-visit)
(define-key elfeed-search-mode-map (kbd "o") 'elfeed-search-browse-url)


;;
;; Org2Blog
;;
(setq org2blog/wp-blog-alist
      '(
        ("wordpress"
         :url "https://donaldbrady.wordpress.com/xmlrpc.php"
         :username "donald.brady@gmail.com")))
(setq org2blog/wp-image-upload t)
(setq org2blog/wp-image-thumbnails t)
(setq org2blog/wp-show-post-in-browser 'ask)
(keymap-global-set "C-c h" 'org2blog-user-interface)

;;
;; Fediverse/Mastodon
;;
(setq mastodon-tl--show-avatars t)
(setq mastodon-media--avatar-height 40)
(require 'mastodon)
(mastodon-discover)

(setq mastodon-instance-url "https://mastodon.social"
      mastodon-active-user "donald_brady")

;;
;; Fediverse/Lem
;;
(setq lem-instance-url "https://lemmy.world")
(setq shr-max-image-proportion 0.5)


;;
;; Gitgutter
;;
(setq git-gutter:modified-sign "|")
(setq git-gutter:added-sign "+")
(setq git-gutter:deleted-sign "-")
(global-git-gutter-mode t)


;;
;; Treesitter
;;
(require 'treesit-auto)
(global-treesit-auto-mode)


;;
;; Hydra
;;
(defvar my-refile-map (make-sparse-keymap))

(defmacro my-defshortcut (key file)
  `(progn
     (set-register ,key (cons 'file ,file))
     (bookmark-store ,file (list (cons 'filename ,file)
                                 (cons 'position 1)
                                 (cons 'front-context-string "")) nil)
     (define-key my-refile-map
                 (char-to-string ,key)
                 (lambda (prefix)
                   (interactive "p")
                   (let ((org-refile-targets '(((,file) :maxlevel . 6)))
                         (current-prefix-arg (or current-prefix-arg '(4))))
                     (call-interactively 'org-refile))))))

(defmacro defshortcuts (name body &optional docstring &rest heads)
  (declare (indent defun) (doc-string 3))
  (cond ((stringp docstring))
        (t
         (setq heads (cons docstring heads))
         (setq docstring "")))
  (list
   'progn
   (append `(defhydra ,name (:exit t))
           (mapcar (lambda (h)
                     (list (elt h 0) (list 'find-file (elt h 1)) (elt h 2)))
                   heads))
   (cons 'progn
         (mapcar (lambda (h) (list 'my-defshortcut (string-to-char (elt h 0)) (elt h 1)))
                 heads))))

(defmacro defshortcuts+ (name body &optional docstring &rest heads)
  (declare (indent defun) (doc-string 3))
  (cond ((stringp docstring))
        (t
         (setq heads (cons docstring heads))
         (setq docstring "")))
  (list
   'progn
   (append `(defhydra+ ,name (:exit t))
           (mapcar (lambda (h)
                     (list (elt h 0) (list 'find-file (elt h 1)) (elt h 2)))
                   heads))
   (cons 'progn
         (mapcar (lambda (h) (list 'my-defshortcut (string-to-char (elt h 0)) (elt h 1)))
                 heads))))


(defshortcuts my-file-shortcuts ()
              ("b" "~/OrgDocuments/personal/Books/first-90-days/the-first-90-days.org" "Current Book")
              ("c" "~/.emacs.d/init.el" "Emacs Configuration")
              ;;         ("d" (db/last-download) "Last Download")
              ("i" (db/current-index-file) "Index File")
              ("j" (db/current-monthly-journal) "Monthly Journal File")
              ("p" "~/OrgDocuments/personal/peloton.org" "Peloton Log")
              ("s" "~/OrgDocuments/personal/shopping.org" "Shopping List"))

(keymap-global-set "C-c f" 'my-file-shortcuts/body)

(defhydra mastodon-help (:color blue :hint nil)
  "
Timelines^^   Toots^^^^           Own Toots^^   Profiles^^      Users/Follows^^  Misc^^
^^-----------------^^^^--------------------^^----------^^-------------------^^------^^-----
_H_ome        _n_ext _p_rev       _r_eply       _A_uthors       follo_W_         _X_ lists
_L_ocal       _T_hread of toot^^  wri_t_e       user _P_rofile  _N_otifications  f_I_lter
_F_ederated   (un) _b_oost^^      _e_dit        ^^              _R_equests       _C_opy URL
fa_V_orites   (un) _f_avorite^^   _d_elete      _O_wn           su_G_estions     _S_earch
_#_ tagged    (un) p_i_n^^        ^^            _U_pdate own    _M_ute user      _h_elp
_@_ mentions  (un) boo_k_mark^^   show _E_dits  ^^              _B_lock user
boo_K_marks   _v_ote^^
trendin_g_
_u_pdate
"
  ("H" mastodon-tl--get-home-timeline)
  ("L" mastodon-tl--get-local-timeline)
  ("F" mastodon-tl--get-federated-timeline)
  ("V" mastodon-profile--view-favourites)
  ("#" mastodon-tl--get-tag-timeline)
  ("@" mastodon-notifications--get-mentions)
  ("K" mastodon-profile--view-bookmarks)
  ("g" mastodon-search--trending-tags)
  ("u" mastodon-tl--update :exit nil)

  ("n" mastodon-tl--goto-next-toot)
  ("p" mastodon-tl--goto-prev-toot)
  ("T" mastodon-tl--thread)
  ("b" mastodon-toot--toggle-boost :exit nil)
  ("f" mastodon-toot--toggle-favourite :exit nil)
  ("i" mastodon-toot--pin-toot-toggle :exit nil)
  ("k" mastodon-toot--bookmark-toot-toggle :exit nil)
  ("c" mastodon-tl--toggle-spoiler-text-in-toot)
  ("v" mastodon-tl--poll-vote)

  ("A" mastodon-profile--get-toot-author)
  ("P" mastodon-profile--show-user)
  ("O" mastodon-profile--my-profile)
  ("U" mastodon-profile--update-user-profile-note)

  ("W" mastodon-tl--follow-user)
  ("N" mastodon-notifications-get)
  ("R" mastodon-profile--view-follow-requests)
  ("G" mastodon-tl--get-follow-suggestions)
  ("M" mastodon-tl--mute-user)
  ("B" mastodon-tl--block-user)

  ("r" mastodon-toot--reply)
  ("t" mastodon-toot)
  ("e" mastodon-toot--edit-toot-at-point)
  ("d" mastodon-toot--delete-toot)
  ("E" mastodon-toot--view-toot-edits)

  ("I" mastodon-tl--view-filters)
  ("X" mastodon-tl--view-lists)
  ("C" mastodon-toot--copy-toot-url)
  ("S" mastodon-search--search-query)
  ("h" describe-mode)
  )

(define-key mastodon-mode-map "?" 'mastodon-help/body)

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

  (define-key dired-mode-map "?" 'hydra-dired/body)

(defhydra hydra-pdftools (:color blue :hint nil)
        "
                                                                      ╭───────────┐
       Move  History   Scale/Fit     Annotations  Search/Link    Do   │ PDF Tools │
   ╭──────────────────────────────────────────────────────────────────┴───────────╯
         ^^_g_^^      _B_    ^↧^    _+_    ^ ^     [_al_] list    [_s_] search    [_u_] revert buffer
         ^^^↑^^^      ^↑^    _H_    ^↑^  ↦ _W_ ↤   [_am_] markup  [_o_] outline   [_i_] info
         ^^_p_^^      ^ ^    ^↥^    _0_    ^ ^     [_at_] text    [_F_] link      [_d_] dark mode
         ^^^↑^^^      ^↓^  ╭─^─^─┐  ^↓^  ╭─^ ^─┐   [_ad_] delete  [_f_] search link
    _h_ ←pag_e_→ _l_  _N_  │ _P_ │  _-_    _b_     [_aa_] dired
         ^^^↓^^^      ^ ^  ╰─^─^─╯  ^ ^  ╰─^ ^─╯   [_y_]  yank
         ^^_n_^^      ^ ^  _r_eset slice box
         ^^^↓^^^
         ^^_G_^^
   --------------------------------------------------------------------------------
        "
        ("\\" hydra-master/body "back")
        ("<ESC>" nil "quit")
        ("al" pdf-annot-list-annotations)
        ("ad" pdf-annot-delete)
        ("aa" pdf-annot-attachment-dired)
        ("am" pdf-annot-add-markup-annotation)
        ("at" pdf-annot-add-text-annotation)
        ("y"  pdf-view-kill-ring-save)
        ("+" pdf-view-enlarge :color red)
        ("-" pdf-view-shrink :color red)
        ("0" pdf-view-scale-reset)
        ("H" pdf-view-fit-height-to-window)
        ("W" pdf-view-fit-width-to-window)
        ("P" pdf-view-fit-page-to-window)
        ("n" pdf-view-next-page-command :color red)
        ("p" pdf-view-previous-page-command :color red)
        ("d" pdf-view-dark-minor-mode)
        ("b" pdf-view-set-slice-from-bounding-box)
        ("r" pdf-view-reset-slice)
        ("g" pdf-view-first-page)
        ("G" pdf-view-last-page)
        ("e" pdf-view-goto-page)
        ("o" pdf-outline)
        ("s" pdf-occur)
        ("i" pdf-misc-display-metadata)
        ("u" pdf-view-revert-buffer)
        ("F" pdf-links-action-perfom)
        ("f" pdf-links-isearch-link)
        ("B" pdf-history-backward :color red)
        ("N" pdf-history-forward :color red)
        ("l" image-forward-hscroll :color red)
        ("h" image-backward-hscroll :color red))

;;
;; keyboard macros
;;
(keymap-global-set "<f1>" 'start-kbd-macro)
(keymap-global-set "<f2>" 'end-kbd-macro)
(keymap-global-set "<f3>" 'call-last-kbd-macro)

;;
;; replace buffer-menu with ibuffer
;;
(keymap-global-set "C-x C-b" 'ibuffer)
(keymap-global-set "<f12>" 'bury-buffer) ;; F12 on logi keybpard
(keymap-global-set "C-c M-l" 'global-display-line-numbers-mode)

;;
;; allow clocking out from anywhere regardless of mode
;;
(keymap-global-set "C-c C-x C-o" 'org-clock-out)

;; expansions
(keymap-global-set "M-/" 'db/expand-abbrev-or-dynamic)

;; Freestyle 2 Keyboard for Map special bindings
(keymap-global-set "M-<kp-delete>" 'backward-kill-word)

;;
;; Load any files in lisp firectory
;;
(defun load-directory (dir)
  (let ((load-it (lambda (f)
           (load-file (concat (file-name-as-directory dir) f)))
         ))
(mapc load-it (directory-files dir nil "\\.el$"))))

(setq db-lisp-dir (concat user-emacs-directory "/lisp"))
(if (file-exists-p db-lisp-dir) (load-directory db-lisp-dir))

;;
;; Start a Server
;;
(load "server")
(unless (server-running-p) (server-start))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/Users/donaldbrady/OrgDocuments/personal/threev/umang-immigration.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/turkey-trip.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/threev.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/skyskopes.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/payroll.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/operations.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/my-linkedin.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/marketing.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/funding-close.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/exelon-rfi.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/carta-onboarding.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/candidate-tracking.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/benefits.org"
     "/Users/donaldbrady/OrgDocuments/personal/threev/accounting.org"
     "/Users/donaldbrady/OrgDocuments/personal/rock-paper-reality/sow-review.org"
     "/Users/donaldbrady/OrgDocuments/personal/rock-paper-reality/rpr-clocktable.org"
     "/Users/donaldbrady/OrgDocuments/personal/rock-paper-reality/rock-paper-reality.org"
     "/Users/donaldbrady/OrgDocuments/personal/rock-paper-reality/report.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-16.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-15.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-07-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-28.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-27.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-26.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-25.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-24.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-21.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-20.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-14.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-13.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-06-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-31.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-29.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-28.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-24.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-21.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-16.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-15.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-14.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-05-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-30.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-29.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-26.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-25.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-24.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-23.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-22.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-16.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-15.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-04-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-29.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-28.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-27.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-26.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-22.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-21.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-20.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-15.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-14.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-13.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-03-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-29.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-28.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-27.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-26.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-25.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-23.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-22.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-21.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-20.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-16.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-02-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-31.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-30.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-29.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-28.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-26.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-25.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-24.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-23.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-22.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-21.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-19.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-18.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-17.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-16.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-15.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-14.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/daily/2024-01-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-19--21-21-02Z--cli_tools.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-19--21-08-24Z--arr_quality.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-19--17-12-53Z--judith_additional_tasks.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-16--16-45-24Z--overstory.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-10--22-54-30Z--ashby_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-02--20-42-10Z--proforma_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-07-01--17-35-51Z--rpr_content_system.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-25--15-49-29Z--threev_board_briefing.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-25--15-22-07Z--threev_platform.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-24--21-53-58Z--min_io.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-21--21-40-10Z--seedpocalypse.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-17--17-23-00Z--pge_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-13--16-16-02Z--klir.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-12--16-39-41Z--technosylva.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-11--22-43-03Z--okr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-11--15-08-18Z--e_samrt_systems.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-09--22-53-27Z--rag.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-06-08--22-13-12Z--moms_ipad.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-26--12-08-30Z--instanbul_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-17--18-25-03Z--docker_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-15--21-08-42Z--generative_ai_naysaying.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-15--16-51-23Z--senpilot.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-13--17-32-16Z--iou.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-10--21-22-05Z--vc_commitments.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-10--18-34-59Z--hardstyle_kettlebell_certified_instructor_manual.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-09--22-50-15Z--kettlebell_workouts.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-08--21-26-45Z--curie_vision.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-07--16-42-02Z--born_consulting.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-07--16-00-40Z--kali_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-06--16-08-54Z--type_1_and_type_2_errors.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-02--21-42-19Z--basic_handgun.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-02--21-35-09Z--uk_information.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-02--21-30-56Z--dad_black_and_white.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-05-02--21-26-11Z--boston_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-30--18-29-04Z--frequent_flyer_programs.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-30--14-41-43Z--vegan_rawgurt.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-26--19-11-18Z--gmail_grooming.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-23--18-07-10Z--eren_aksu.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-23--18-05-13Z--umang_sharma.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-23--15-49-50Z--eren_intro_letter.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-19--16-57-16Z--goldilocks_valuation_matrix.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-14--19-33-18Z--intenseye.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-13--17-51-31Z--rm_kettlebell_chart.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-13--17-21-40Z--training_program.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-11--20-53-14Z--microsoft_and_pge.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-02--20-42-59Z--rpr_monthly_summary.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-04-01--16-48-22Z--copernicus_climate_atlas.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-29--18-41-03Z--exelon_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-28--19-40-57Z--map.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-27--20-49-35Z--org_capture_macos.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-24--20-16-15Z--seiko_5_sports_field_gmt.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-21--17-15-03Z--appfolio_engineering_blog.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-15--20-05-00Z--yolo_world.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-15--17-40-54Z--carta.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-14--21-48-17Z--safe.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-14--17-37-10Z--employer_of_record_eor.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-14--16-55-03Z--conelabs_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-10--22-29-16Z--saas_idea.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-10--00-38-37Z--utility_capex_preferences.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-05--22-59-37Z--darrell_keller.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-05--17-13-03Z--constellationclearsight.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-05--15-00-40Z--claude_api_key.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-04--22-51-58Z--ai_skepticism.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-03-02--22-23-55Z--compiling_emacs_on_macos.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-28--18-03-27Z--mrr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-28--18-01-58Z--nrr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-28--16-49-57Z--neara.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-22--22-21-24Z--msft_accelerator_benefits.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-20--18-53-35Z--story_coffee.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-19--18-18-53Z--questions_for_quickbooks.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-15--00-50-02Z--delta_egift.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-15--00-34-36Z--anxiety.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-13--07-06-30Z--jitens_japan_deck.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-02-01--21-13-38Z--pge_tech.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-31--21-37-26Z--pge_sherlock.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-27--23-40-09Z--saas_pegasus.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-26--21-19-49Z--harvest.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-23--15-38-58Z--bant.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-19--22-45-30Z--landing_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-19--20-46-45Z--a_matter_of_taste_serving_up_paul_liebrandt.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-19--19-19-31Z--donecle.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-19--19-09-08Z--westley_group.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-18--23-54-35Z--buzz_solutions.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-11--21-41-42Z--incredible_3g_generalist.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-08--20-29-29Z--blue_collar_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-05--03-41-43Z--bezi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-04--17-21-01Z--interline_dpc_report.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-03--17-34-32Z--karpowerships.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--17-17-54Z--enerjisa.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-56-36Z--breakout_blocks.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-55-33Z--buffer_block.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-54-53Z--strategic_block.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-41-07Z--lead_indicators.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-40-28Z--lag_indicators.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-36-51Z--smart_goals.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-33-05Z--the_12_week_year.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2024-01-02--01-07-44Z--addresses.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/20230323115558-what_is_chatgpt_doing.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-29--19-32-24Z--brexit_cartoon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-27--20-50-25Z--religion_cartoon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-26--21-24-14Z--fulcrum_features.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-26--20-47-04Z--pivot.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-26--20-40-54Z--arccollector.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-26--18-58-40Z--fulcrum.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-26--18-56-55Z--6_key_insights_to_help_utilities_evaluate_companies_using_drones_to_inspect_electrical_assets.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-24--19-08-19Z--musk_santa_cartoon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-19--16-02-01Z--mlops_cylce.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-08--21-03-51Z--founder_coop.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-12-05--17-18-41Z--t_mobile_analysis.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-28--23-45-42Z--synthesis_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-28--23-45-09Z--threev_competition.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-27--16-05-41Z--innovation_diffusion.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-22--19-41-45Z--skydio.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-10--12-31-50Z--graylog.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-11-08--00-15-06Z--bank_info.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-25--19-21-36Z--how_to_reset_outlook.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-22--00-15-07Z--digineox.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-22--00-11-58Z--hybirdtech.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-17--16-29-24Z--likexr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-12--16-55-49Z--inflation_cartoon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-10--14-56-30Z--draft_dev.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-10--14-55-33Z--the_use_less_group.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-09--00-00-15Z--founder_script.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-10-08--00-57-41Z--dubai_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-09-27--21-48-22Z--lisbon_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-09-26--17-41-28Z--ntp.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-09-13--13-09-43Z--prm_software.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-08-25--22-04-16Z--thelimitededition.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-08-20--14-36-48Z--emoji_insert.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-08-20--14-10-58Z--emphasize_region.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-08-02--18-59-26Z--ssh_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-27--19-44-35Z--trigger_sales_job.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-25--17-16-27Z--anchormydata.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-24--20-27-56Z--boa_hsa.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-23--19-26-34Z--prompt_engineering_course.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-22--23-24-44Z--seer_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-19--22-17-35Z--objaverse.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-19--14-42-22Z--understanding_your_computer_vision_teams_progress.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-19--14-31-49Z--too_many_open_files.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-18--21-28-34Z--unity_certified_creator_network.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-18--21-25-25Z--groove_jones.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-14--20-18-05Z--deloitte_independence_dashboard.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-14--16-17-12Z--design_joy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-13--16-56-47Z--nacv.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-11--22-10-37Z--neighbors.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-10--16-27-50Z--psylosybin.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-07--16-48-20Z--dyne.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-07--15-32-23Z--climate_reanalyzer.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-03--20-37-12Z--observability.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-03--14-10-25Z--elfeed_tube.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-07-02--16-42-59Z--flyscan.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-30--15-53-21Z--dnf_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-30--15-32-21Z--insync.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-29--12-29-32Z--peach_spiced_old_fashioned.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-27--21-14-28Z--progress_pride_flag.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-27--21-13-49Z--jet_streams.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-21--16-24-27Z--redesign_health.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-20--22-43-25Z--rendered_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-20--21-40-57Z--retail_conferences.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-19--20-22-33Z--covid19_vax_card.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-18--21-31-48Z--framer_com.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-18--14-27-11Z--enshitification.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--22-11-14Z--t3m_saas_magic_number.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--22-07-24Z--t3m_cac_payback.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--22-04-09Z--cac.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--22-03-27Z--cltv.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--22-02-52Z--arpa.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--21-58-18Z--carr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--21-54-54Z--sqo.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--21-54-01Z--sql.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--21-53-13Z--mql.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-14--21-52-33Z--b2b_saas_metrics.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-13--17-01-23Z--faas.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-12--23-46-27Z--facism.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-12--18-02-09Z--companyon_ventures.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-12--17-07-01Z--aaron_bespoke.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-10--23-52-43Z--chief_revenue_officer.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-10--13-54-26Z--chatgpt_prompts_to_try.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-10--13-52-20Z--si_thinking_hats_technique.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-10-36Z--dex.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-09-51Z--rum.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-02-31Z--slo.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-02-00Z--rasp.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-01-37Z--dem.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-09--17-01-11Z--i_o.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-07--22-04-11Z--jason_geller.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-07--19-10-04Z--emacs_on_fedora.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-05--21-39-25Z--vntana.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-05--21-34-49Z--smart_pixels.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-05--20-45-45Z--sara_oberest.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-04--13-41-24Z--eliezer_yudkowsky.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-04--13-36-35Z--halucinating.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-04--13-35-13Z--eliza_effect.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-03--14-52-37Z--super_bien.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-03--14-24-29Z--pedro_arboleda.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-02--18-19-15Z--buoy_studio.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-02--18-07-24Z--4d_pipeline.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-06-01--20-24-12Z--covision.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-31--16-13-48Z--patrick_johnson.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-31--16-12-09Z--stefano_provenzano.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-31--16-11-11Z--stefano_alddrovandi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-30--20-57-20Z--firas_raouf.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-30--20-49-45Z--scott_pobiner.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-30--20-46-03Z--justin_hamacher.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-29--22-00-45Z--meerkat.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-29--21-04-05Z--fashion_law.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-29--20-47-03Z--academics_on_mastodon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-29--20-26-22Z--open_llm_leaderboard.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-24--19-15-27Z--eye_prescription.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-24--15-26-52Z--pricing_test_spec.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-22--17-18-34Z--d_rates.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-18--14-18-52Z--workshop_okrs.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-14--13-39-55Z--ai_changing_manufacturing.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-08--14-11-14Z--vancouver_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-07--01-04-25Z--threev_site_map.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-06--23-44-32Z--git_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-04--21-38-08Z--traction3d.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-05-04--20-16-13Z--shift_right_ventures_llc.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-30--02-01-05Z--finchat.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-29--13-26-29Z--productivity_and_order.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-29--13-21-15Z--tescreal_bundle.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-27--18-03-33Z--simspace_weaver.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-27--17-52-01Z--twinmaker.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-26--03-03-40Z--passio_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-18--17-36-27Z--matt_rommel_consulting.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-18--15-41-20Z--vizient.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-17--16-52-28Z--washington_gastro.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-16--21-48-26Z--synthetic_data_pipeline_description.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-16--13-10-58Z--emacs_prelude.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-16--13-05-58Z--last_weeks_completed_todos.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-16--13-04-04Z--visual_rescheduling_guide.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-09--16-17-17Z--xixi_friend_ny_recommendations.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-09--13-39-17Z--exelon_synthetic_data_project.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-07--11-29-04Z--leapex.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-06--18-39-13Z--olympus.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-03--20-51-12Z--amazon_vams.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-04-02--23-46-07Z--amazon_sidewalk.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-28--21-19-51Z--synthetic_data_agency.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-26--14-16-18Z--forbes_councils.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-21--12-53-25Z--yirgacheffe_sidamo_more_a_guide_to_ethiopian_coffee_perfect_daily_grind.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-20--15-37-21Z--antler_venture_studio_model.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-18--09-25-59Z--agency_advisory_playbook.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-14--23-35-52Z--showin3d.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-13--22-59-28Z--insured_cash_sweep.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-12--00-44-49Z--kinetic_vision.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-11--03-36-25Z--hermes_volynka_leather_birkin_50_hac.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-06--00-00-58Z--brdg.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-05--15-55-34Z--spine.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-05--15-55-03Z--trigger.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-05--15-54-05Z--bully_entertainment.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-03-01--20-56-06Z--gphotos_sync.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-24--22-27-57Z--fs_studio.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-24--03-41-47Z--sythetic_data_directory.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--18-45-41Z--omniverse_deck.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--16-31-13Z--f1.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--16-28-42Z--accuracy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--16-24-43Z--recall.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--16-22-26Z--precision.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-22--00-18-37Z--org_gcal.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-21--21-54-19Z--glow_labs.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-21--18-51-18Z--deb_zell.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-20--16-12-45Z--image_segmentation_model.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-20--02-27-26Z--carrot_ventures.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-20--00-43-13Z--ken_davis_singapore_meetings.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-20--00-41-21Z--being_human.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-19--15-03-45Z--circular_economy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-19--15-01-39Z--trove.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-16--23-54-38Z--org_mode_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-13--18-44-39Z--glasgow_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-12--23-19-11Z--three_red_flags.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-07--14-09-08Z--alec_hufnagel.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-07--14-07-25Z--kelso.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-02-06--16-57-00Z--walmart_strivr_tire_change.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-31--03-38-25Z--omega_aqua_terra_xxl.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-30--22-08-09Z--deploying_vr_at_scale.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-30--19-06-30Z--rock_paper_reality.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-30--18-30-10Z--enosis.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-30--18-29-21Z--vangelis_lympouridis.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-30--18-26-21Z--contenta.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-25--21-31-29Z--riverside_fm.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-23--16-24-42Z--awe_workshop_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-22--14-44-49Z--post_hotel.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-17--18-08-19Z--scale_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-12--15-45-36Z--vall_e_voice_cloning.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-11--20-09-42Z--plant_based_mexican_in_la.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-10--18-20-06Z--345_global.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-09--17-15-22Z--sdg_pipeline.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-09--16-30-40Z--worlds_io.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-08--23-28-46Z--plus9time.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-06--16-40-07Z--arthur.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-04--16-04-39Z--kelly_ingrid.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-04--15-53-49Z--richard_kerris.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-03--21-18-29Z--hilarious_vc_post.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-03--20-56-13Z--mobius.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-03--01-14-25Z--transclusion.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2023-01-03--01-10-40Z--exocortex.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-30--03-18-45Z--jobs_to_be_done.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-30--03-15-53Z--tensor_flow_and_keras.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-28--21-31-40Z--assessing_your_people.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-16--20-47-36Z--inrupt.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-15--01-07-20Z--interests_archive.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-09--16-24-29Z--grand_seiko_green_birch.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-07--13-21-36Z--synthetic_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-12-05--16-52-13Z--onboarding_best_practices.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-29--19-26-22Z--waabi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-29--16-59-34Z--synthetic_data_deck_from_nvidia.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-20--14-34-22Z--duckdb.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-12--23-06-46Z--nerfstudio.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-11--21-01-11Z--yoga_asanas.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-11--17-43-54Z--yagna.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-09--01-42-27Z--agenhor.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-08--20-50-15Z--mr_iot_recording.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-08--20-49-17Z--unreal_fest_recording.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-08--03-16-50Z--freakonomics_change.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-05--22-32-11Z--casio_g_shock_gm_b2100gd.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-11-02--17-48-25Z--invoke_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-31--02-22-02Z--cocktail_ingredients.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-30--14-09-21Z--maslow_hierarchy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-23--21-58-08Z--cannes_award.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-22--04-20-05Z--singapore_cocktail_bars.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-21--19-24-02Z--margin_debt.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-18--01-55-48Z--nola_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-16--22-09-45Z--champagne.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-14--13-55-15Z--venture_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-13--03-23-28Z--puerto_rico.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-11--01-17-38Z--prescription.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-08--14-00-19Z--ny_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-10-06--16-02-51Z--sf_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-21--15-29-53Z--infinite_compute.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-20--15-21-47Z--roomplan.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-18--23-06-51Z--monocole.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-18--13-36-05Z--probablistic_machine_learning.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-17--14-30-08Z--rss.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-17--14-01-00Z--synthetic_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-13--13-28-07Z--cruch_culture.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-12--23-44-25Z--omniverse_cura.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-09-11--14-51-47Z--systemitizing_gtm_hiring.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-23--22-57-38Z--rolex_appraisal.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-23--12-56-05Z--texlive.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-19--14-04-53Z--blockchain_when_to_use.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-15--22-54-27Z--any_logic.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-11--18-59-07Z--visualcomponents.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-09--19-03-10Z--synthing.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-06--03-10-09Z--ruby_booby.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-06--03-04-55Z--perfect.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-06--02-58-55Z--mephisto.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-05--13-18-58Z--stephen_diehl_zotero.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-05--03-25-42Z--averna_daiquiri.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-03--15-03-29Z--cocktail_recipe_book.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-08-02--20-29-18Z--cheaper_faster_better.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-25--01-01-54Z--firefox_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-24--19-38-17Z--mckinsey_presentation_format.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-18--15-41-42Z--zero_based_infrastructure.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-13--16-42-37Z--beyondxr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-12--15-09-38Z--the_grid_factory.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-06--14-29-40Z--upi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-06--14-10-35Z--simple_guide_to_upping_management_game.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-06--03-30-57Z--cropx.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-06--01-45-00Z--singapore_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-07-05--18-25-14Z--ansible.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-30--19-52-51Z--org_table_with_wrapping.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-27--22-13-36Z--work_and_learn.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-20--15-23-25Z--engine_heuristic.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-20--15-17-32Z--fsi_activity.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-18--13-59-02Z--fzf.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-14--00-45-09Z--uk_passport.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-14--00-44-17Z--us_passport.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-14--00-25-47Z--kris_flyer.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-12--21-11-44Z--third_party_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-12--21-10-50Z--first_party_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-12--21-09-47Z--zero_party_data.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-12--21-03-00Z--four_platforms.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-06--00-58-53Z--symlinks_in_msys2.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-05--14-41-56Z--the_history_of_nfts.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-05--03-00-36Z--sugess_tourbillon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-03--19-39-03Z--nanome_ai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-03--17-23-44Z--unity_digital_twin_clients.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-06-01--17-24-12Z--digital_twin_quals.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-28--23-41-34Z--hyperbole_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-28--19-42-40Z--h20.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-24--01-37-39Z--skyward.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-20--13-56-54Z--saps_gameification_framework.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-01--14-39-05Z--questions_for_kelso.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-01--14-23-10Z--dpi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-01--14-22-18Z--moic.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-05-01--14-20-31Z--irr.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-26--19-53-38Z--babble_hypothesis.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-26--16-06-09Z--wonder.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-24--13-54-26Z--seiko_prospex_1965_diver.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-10--13-14-10Z--techno_fuedalism.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-10--13-08-01Z--build_muscle_naturally.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-08--03-18-07Z--mychart.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-05--14-02-20Z--rice_framework.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-04--16-23-35Z--chicago_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-04-02--14-35-28Z--crypto_skeptics.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-26--13-50-12Z--krayon.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-22--18-25-39Z--steven_diehl_zotero.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-21--01-27-56Z--david_gerald_blockchain_deck.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-20--14-13-05Z--de_sci.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-18--14-58-14Z--kinetic_vision.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-09--21-38-35Z--omniverse_for_developers.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-05--15-34-03Z--jlc_master_thin_pereptual_enamel.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-03-05--15-25-16Z--white_male_system.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-28--21-27-52Z--digital_humans.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-25--21-16-09Z--andrew_yangs_lobbying.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-25--14-49-04Z--great_eight_use_cases.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-25--04-51-35Z--nixie_clock.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-22--18-49-11Z--quantiphi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-21--03-56-54Z--decentralized_identity_did.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-02-13--15-29-15Z--david_rosenthal_ee380_talk.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-30--01-07-10Z--crypto_cartoons.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-27--05-24-59Z--therapists.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-22--16-42-45Z--the_real_trolley_problem.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-18--02-32-24Z--sartory_billiard.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-15--15-42-50Z--kelso_document_passwords.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-12--18-42-40Z--senti_ar.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2022-01-05--03-09-00Z--space_companies.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/20210601110155-arnold_and_son.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/20210601105932-angelus_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-31--18-09-26Z--hero_digital.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-31--18-03-11Z--bounteous.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-31--17-54-21Z--launch_consulting.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-31--16-26-58Z--the_case_against_ctypto.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-22--15-57-15Z--physical_digital_events_agencies.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-15--02-17-59Z--eth_address.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-14--21-53-45Z--full_stack_xr_developer.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-14--00-44-27Z--datascience_classification.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-09--22-58-02Z--grand_seiko_omiwatari.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-09--15-40-14Z--project_to_product.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-06--22-19-46Z--nyc_boutique_hotels.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-04--15-14-24Z--trilobe.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-12-02--22-17-53Z--jobs_to_be_done.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-11-29--09-41-10Z--hpm_emails.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-11-26--09-00-14Z--akrivia.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-11-25--16-41-22Z--montres_kf.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-11-02--04-08-33Z--bright_moments.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-31--23-21-05Z--mbsync.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-31--13-52-09Z--microaquire.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-30--14-08-35Z--art_and_crypto_merging.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-27--13-06-10Z--come_for_the_assets_stay_for_the_experience.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-27--03-00-11Z--gangs_of_wasseypur.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-27--02-58-00Z--desert_one.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-27--02-56-53Z--capital_in_the_twenty_first_century.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-26--21-03-50Z--dan_nieves.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-25--18-02-39Z--lalaland.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-25--16-26-48Z--storelab.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-19--19-48-09Z--graphic_facilitation.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-19--16-19-31Z--alphafold.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-17--02-08-00Z--farer.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-16--20-42-31Z--tuck_richards.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-16--13-50-13Z--ikigai.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-15--21-39-47Z--artya_tourbillion.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-15--15-30-47Z--procurement_negotiation.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-14--16-35-50Z--tom_taft.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-14--16-35-37Z--jim_herd.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-14--15-17-19Z--force_org_id_locations.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-13--15-52-53Z--moving_platform_mode.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-13--15-47-35Z--go_spooky.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-12--17-22-37Z--hamilton_4_0.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-11--13-40-36Z--watch_research.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-11--13-38-18Z--watch_collection.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-11--02-35-45Z--bitcoin_ponzi.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-08--20-25-14Z--perpetual_calendars.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-08--14-53-21Z--innovation_insight_for_immersive_technologies_in_frontline_working.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-04--04-43-37Z--sway_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-04--04-42-45Z--windows_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-10-04--04-41-39Z--linux_notes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-33-14Z--los_angeles_bars_and_restaurants.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-29-49Z--deloitte_mathematics.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-25-53Z--colin_accounts.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-22-28Z--colin_group_pension.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-21-14Z--colin_banks.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-20-05Z--colin_will.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-18-51Z--colin_pension.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-28--03-18-09Z--colin_next_of_kin.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-56-46Z--tokyo_cocktail_bars.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-56-12Z--bangkok_cocktail_bars.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-52-00Z--persimmon_cocktail.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-59Z--white_russian.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-58Z--whiskey_sour.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-57Z--ueno_san.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-56Z--tokyo_cooler.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-55Z--the_elegant_spice.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-54Z--simple_syrup_recipes.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-52Z--silver_monk_tequila.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-52Z--side_car.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-51Z--sea_salt_foam.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-50Z--san_pedro.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-50Z--rye_whisper.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-49Z--romanza.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-48Z--ramos_gin_fizz.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-46Z--pear_necessity.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-45Z--orange_fairy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-44Z--negroni.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-43Z--my_bitter_ex.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-32Z--mr_richter.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-29Z--martinez.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-28Z--marisol.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-28Z--margarhita.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-27Z--macdaddy.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-26Z--lusty_lady.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-25Z--lokoki.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-25Z--lemon_drop.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-24Z--leave_it_to_me_2.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-23Z--last_word.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-22Z--la_luna.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-22Z--floridita_daiquiri.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-21Z--kaffir_fling.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-20Z--jasmine.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-20Z--green_glass.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-19Z--gin_gin_mule.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-18Z--friday_sunrise.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-17Z--fernet_old_fashioned.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-16Z--especial_day.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-16Z--elegant_orange.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-15Z--elderflower_sour.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-14Z--cosmopolitan.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-13Z--cobbler_s_dream.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-12Z--clover_club.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-11Z--casino.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-10Z--caipirinha.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-10Z--bijou.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-51-08Z--bermuda_rum_swizzle.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-50-36Z--aviation.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-49-23Z--a_t_o_t_l_w.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-25--13-48-20Z--abbey.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-24--18-14-27Z--eight_steps_to_digital_twin.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-24--18-13-21Z--how_much_to_build_a_digital_twin.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-22--21-01-20Z--innovation_rates.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-19--16-33-30Z--vanguart_black_hole_tourbillion.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-08--21-33-31Z--smartechs.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-09-04--01-35-56Z--ressence_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-23--13-24-28Z--pdf_studio_pro_license.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-19--20-07-54Z--global_center_for_urban_transportation.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-16--22-49-28Z--national_association_of_boards.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-16--22-48-34Z--leader_leverage.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-13--15-15-52Z--gridraster.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-07--14-35-29Z--gshock_mrg_g2000r_1a.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-08-01--18-38-35Z--emacs_like_an_instrument.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-26--19-59-33Z--competitor_alliance_formation.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-23--19-14-19Z--asset_management_comparo.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-19--19-07-11Z--smart_energy_water.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-15--02-13-22Z--andreas_strehler.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-15--02-11-04Z--alchemists.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-15--02-06-50Z--moritz_grossman.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-15--02-03-26Z--atelier_de_chronometrie.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-14--01-06-10Z--mindfullness_and_i_or_we.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-11--21-42-47Z--hermes_h08.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-11--21-41-57Z--bulova_spaceview.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-11--21-41-00Z--rolex_datejust.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-11--21-39-43Z--accutron_dna.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-06--18-12-40Z--armin_strom_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-01--14-51-35Z--innovation_pipeline.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-01--14-42-58Z--business_books.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-07-01--14-29-14Z--automation_effects.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-30--15-02-37Z--emacs_and_wsl.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-28--00-28-16Z--rolex_model_guide.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-28--00-17-29Z--pinion_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-26--20-26-16Z--field_service_survey.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-26--20-23-30Z--performance_marketing.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-21--17-03-40Z--digital_twins.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-18--15-00-13Z--omniverse_parts.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-16--21-05-32Z--medevis.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-15--02-50-37Z--garrick_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-11--04-09-41Z--mckinsey_product_model.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-09--13-20-48Z--computer_vision_and_physics.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-09--03-15-35Z--holy_trinity.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-09--03-11-57Z--elliot_brown_watches.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-07--22-15-01Z--omniverse.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-07--22-07-52Z--tarik_hammadou.org"
     "/Users/donaldbrady/OrgDocuments/personal/roam/2021-06-04--15-07-34Z--edlore.org"
     "/Users/donaldbrady/OrgDocuments/personal/resume/resume.org"
     "/Users/donaldbrady/OrgDocuments/personal/python/python.org"
     "/Users/donaldbrady/OrgDocuments/personal/ocean/ocean_letter.org"
     "/Users/donaldbrady/OrgDocuments/personal/ocean/ocean.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2024/2024-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2023/2023-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2022/2022-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2021/2021-01.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-12.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-11.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-10.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-09.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-08.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-07.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-06.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-05.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-04.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-03.org"
     "/Users/donaldbrady/OrgDocuments/personal/journals/2020/2020-02.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/first-90-days/the-first-90-days.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/ShapeUp/ShapeUp.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/Project-to-Product/project-to-product.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/Private-Equity-Playbook/private-quity-playbook.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/Leading-Lean/LeadingLean.org"
     "/Users/donaldbrady/OrgDocuments/personal/Books/Complete-MandA/complete-m-and-a.org"
     "/Users/donaldbrady/OrgDocuments/personal/yoga.org"
     "/Users/donaldbrady/OrgDocuments/personal/vespa.org"
     "/Users/donaldbrady/OrgDocuments/personal/thailand.org"
     "/Users/donaldbrady/OrgDocuments/personal/taxes-2024.org"
     "/Users/donaldbrady/OrgDocuments/personal/spatial-guide.org"
     "/Users/donaldbrady/OrgDocuments/personal/shopping.org"
     "/Users/donaldbrady/OrgDocuments/personal/shift-right-ventures.org"
     "/Users/donaldbrady/OrgDocuments/personal/rss-feeds.org"
     "/Users/donaldbrady/OrgDocuments/personal/quotes.org"
     "/Users/donaldbrady/OrgDocuments/personal/peloton.org"
     "/Users/donaldbrady/OrgDocuments/personal/passport-renewal.org"
     "/Users/donaldbrady/OrgDocuments/personal/leadership.org"
     "/Users/donaldbrady/OrgDocuments/personal/latex-template.org"
     "/Users/donaldbrady/OrgDocuments/personal/kb.org"
     "/Users/donaldbrady/OrgDocuments/personal/internet.org"
     "/Users/donaldbrady/OrgDocuments/personal/index.org"
     "/Users/donaldbrady/OrgDocuments/personal/gr86.org"
     "/Users/donaldbrady/OrgDocuments/personal/friends-and-fam.org"
     "/Users/donaldbrady/OrgDocuments/personal/emacs.org"
     "/Users/donaldbrady/OrgDocuments/personal/contacts.org"
     "/Users/donaldbrady/OrgDocuments/personal/condo.org"
     "/Users/donaldbrady/OrgDocuments/personal/companyonvc.org"
     "/Users/donaldbrady/OrgDocuments/personal/clocktable.org"
     "/Users/donaldbrady/OrgDocuments/personal/amps.org.gpg"
     "/Users/donaldbrady/OrgDocuments/personal/12-week-year.org")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
