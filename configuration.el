(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

(setq load-prefer-newer t)

(setq user-full-name "Donald Brady" user-mail-address "donaldbrady@gmail.com")

(defconst dbrady-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p dbrady-savefile-dir) (make-directory dbrady-savefile-dir))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" dbrady-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package savehist
  :config
  (setq savehist-additional-variables
  ;; search entries
  '(search-ring regexp-search-ring)
  ;; save every minute
  savehist-autosave-interval 60
  ;; keep the home clean
  savehist-file (expand-file-name "savehist" dbrady-savefile-dir))
  (savehist-mode +1))

(setq inhibit-startup-screen t)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq ring-bell-function 'ignore)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq require-final-newline t)
(setq-default fill-column 100)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default indent-tabs-mode nil)   
(setq-default tab-width 4)            
;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(setq ispell-program-name (executable-find "hunspell"))
(setq ispell-hunspell-dict-paths-alist '(("en_US" "C:/msys64/usr/share/hunspell/en_US.aff")))
(setq ispell-local-dictionary "en_US")
(setq ispell-local-dictionary-alist '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
(use-package flyspell
  :config
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (add-hook 'gfm-mode-hook 'flyspell-mode)
  (add-hook 'org-mode-hook 'flyspell-mode)
  (add-hook 'git-commit-mode-hook 'flyspell-mode)
  (add-hook 'mu4e-compose-mode-hook 'flyspell-mode))

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

;; (use-package abbrev
;;   :config
;;   (setq save-abbrevs 'silently)
;;   (setq-default abbrev-mode t))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" dbrady-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume))

(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper))

;; binds C-M-= and C-M-- to increase and decrease the face size
(use-package default-text-scale
  :config
  (setq default-text-scale-mode t))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(use-package gnuplot)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (ruby . t)
   (dot . t)
   (gnuplot . t)))

(setq org-confirm-babel-evaluate nil)

(use-package htmlize)

(setq org-export-with-smart-quotes t)

;; use hippie-expand instead of dabbrev
  (global-set-key (kbd "M-/") #'hippie-expand)
  (global-set-key (kbd "s-/") #'hippie-expand)
  
  ;; keyboard macros
  (global-set-key (kbd "<f1>") #'start-kbd-macro)
  (global-set-key (kbd "<f2>") #'end-kbd-macro)
  (global-set-key (kbd "<f3>") #'call-last-kbd-macro)
  
  ;; replace buffer-menu with ibuffer
  (global-set-key (kbd "C-x C-b") #'ibuffer)
