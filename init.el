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
;; Set the custom file path
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(setq user-full-name "Donald Brady" user-mail-address "donald.brady@gmail.com")

;;
;; Packages to load
;;

(elpaca ace-window)
(elpaca all-the-icons)
(elpaca all-the-icons-dired)
(elpaca avy)
(elpaca counsel)
(elpaca deadgrep)
(elpaca demap)
(elpaca denote)
(elpaca diminish)
(elpaca doom-themes)
(elpaca ef-themes)
(elpaca elfeed)
(elpaca elfeed-org)
(elpaca ellama)
(elpaca embark)
(elpaca embark-consult)
(elpaca exec-path-from-shell)
(elpaca frecentf)
(elpaca git-gutter)
(elpaca git-timemachine)
(elpaca gnuplot)
(elpaca golden-ratio)
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
(elpaca org)
(elpaca org-attach-screenshot)
;; (elpaca org-contrib)
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
(elpaca spacious-padding)
(elpaca swiper)
(elpaca transient)
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
(load-theme 'ef-autumn)
(nyan-mode)
(spacious-padding-mode)

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
(setq yas-snippet-dirs '("~/.config/yas" "~/.emacs.d/snippets"))

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
;; Ace Window
;;
(require 'ace-window)
(global-set-key [remap other-window] 'ace-window)
(custom-set-faces
 '(aw-leading-char-face
   ((t (:foreground "black" :background "yellow" :weight bold :height 3.0)))))
(setq aw-char-position 'left
      aw-keys '(?j ?h ?k ?l ?a ?s ?d))


;;
;; Denote
;;

;; Remember to check the doc strings of those variables.
(setq denote-directory (expand-file-name "/Users/d/Library/Mobile Documents/com~apple~CloudDocs/OrgDocuments/personal"))
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
(setq org-directory (expand-file-name "/Users/d/Library/Mobile Documents/com~apple~CloudDocs/OrgDocuments/personal"))
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
(setq org-table-convert-region-max-lines 5000)

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
         (:name "skyskopes" :tag "skyskopes")
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
  "d f"    'org-roam-dailies-goto-next-note
  "d b"    'org-roam-dailies-goto-previous-note
  ;; roam hang of C-c o r
  "r b"    'org-roam-buffer-toggle
  "r f"    'org-roam-node-find
  "r c"    'org-roam-capture              
  "r g"    'org-roam-graph
  "r i"    'org-roam-node-insert
  ;; counsel mish mash
  "r r"    'consult-ripgrep
  "j"      'counsel-org-goto-all
  "n o"    'counsel-org-agenda-headlines
  "n l"    'db/counsel-org-agenda-insert-link-to-headlines
  "r l"    'counsel-org-link
  "s"      'org-attach-screenshot)

;; override y (agenda year) with more useful todo yesterday for marking habits done prior day 
(define-key org-agenda-mode-map (kbd "y") 'org-agenda-todo-yesterday)


;;
;; function to insert all org-roam documents matching a tag
;;
(defun db/org-roam-insert-links-by-tag (tag)
  "Insert links to all Org-roam nodes with the given TAG."
  (interactive "sEnter tag: ")
  (let ((nodes (org-roam-node-list))
        (links ""))
    (dolist (node nodes)
      (when (member tag (org-roam-node-tags node))
        (setq links (concat links (format "- [[id:%s][%s]]\n"
                                          (org-roam-node-id node)
                                          (org-roam-node-title node))))))
    (if (string-empty-p links)
        (message "No nodes found with tag: %s" tag)
      (insert links))))


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
