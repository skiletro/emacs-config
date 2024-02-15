;; NOTE: init.el is generated using config.org. Please edit that file in Emacs.

(setq gc-cons-threshold (* 85 1000 1000))

;; Initialise package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Init use-package on non-linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ; Downloads packages if evaluated

;; (setq use-package-verbose t)
(defun skil/display-startup-time ()
  (message "Emacs loaded %d packages in %s with %d GCs."
           (length package-activated-list)
           (format "%.3f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'skil/display-startup-time)

(use-package gcmh
  :init (gcmh-mode 1))

(setq user-emacs-directory "~/.cache/emacs")
(use-package no-littering)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq custom-file (concat user-emacs-directory "/custom.el"))
;; (load-file custom-file)

;; Set username and email (for Git primarily)
(setq user-full-name "skiletro"
      user-mail-address "19377854+skiletro@users.noreply.github.com")

;; Fixes a little bug on Windows
(set-language-environment "UTF-8")

;; Sets the backup location to the emacs cache directory (defined above)
(setq backup-directory-alist `(("." . ,(expand-file-name "file-backups" user-emacs-directory))))

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1)   ; Disable the menu bar

(setq ring-bell-function 'ignore) ; Get rid of the bell sound

(column-number-mode) ; Column and row number in modeline
(global-display-line-numbers-mode t) ; Line numbers

(pixel-scroll-precision-mode t) ; Scroll through images without it jumping everywhere

(setq confirm-kill-emacs 'y-or-n-p) ; Confirmation on close

;; Disable line numbers for some modes
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Change window name to something simpler
(setq frame-title-format "%b - Emacs")

(add-to-list 'custom-theme-load-path "~/.emacs.d/oxocarbon/")
(use-package autothemer)
(load-theme 'oxocarbon :no-confirm)

(set-face-attribute 'default nil :font "Iosevka NF" :height 120)
(set-face-attribute 'fixed-pitch nil :font "Iosevka NF" :height 120)
(set-face-attribute 'variable-pitch nil :font "Bahnschrift" :height 120)

(use-package dashboard
  :config (dashboard-setup-startup-hook))
(setq dashboard-buffer-name "*dashboard*"
      dashboard-banner-logo-title nil ; Subtitle
      dashboard-startup-banner 'logo
      dashboard-center-content t
      dashboard-display-icons-p t
      dashboard-set-heading-icons t
      dashboard-set-file-icons t
      dashboard-items '((recents . 5)
                        (bookmarks . 3)
                        (projects . 5)))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

;; More completion functions for Ivy
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; M-x Enhancement (adds history with no extra config)
(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0))

(use-package general
  :config
  (general-create-definer skil/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))
(skil/leader-keys
  "b"  '(:which-key "buffer")
  "b." '(counsel-switch-buffer :which-key "Switch buffer")
  "bn" '(next-buffer :which-key "Next buffer")
  "bN" '(skil/new-empty-buffer :which-key "New empty buffer")
  "bp" '(previous-buffer :which-key "Previous buffer")
  "bk" '(kill-this-buffer :which-key "Kill current buffer")
  "bs" '(save-buffer :which-key "Save current buffer")

  "f"  '(:which-key "file")
  "ff" '(find-file :which-key "Find file")

  "q"  '(:which-key "quit/kill")
  "qq" '(evil-quit :which-key "Quit Emacs"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (evil-mode)
  (evil-set-undo-system 'undo-redo)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join))

;; Auto configure modes with vim bindings 
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))
(skil/leader-keys
  "h"  '(:which-key "help")
  "hf" '(describe-function :which-key "Describe function")
  "hc" '(describe-command :which-key "Describe command")
  "hv" '(describe-variable :which-key "Describe variable")
  "hk" '(describe-key :which-key "Describe-key"))

(use-package evil-tutor
  :commands (evil-tutor-start))

(use-package org
  :commands (org-capture org-agenda)
  :hook
  (org-mode . skil/org-mode-setup)
  (org-mode . skil/org-icons-setup)
  :custom
  (org-ellipsis "▸")
  (org-directory "~/org/")
                                        ;(org-agenda-files '("~/org/tasks.org"))
  (org-hide-emphasis-markers t)
  (org-return-follows-link t))

(defun skil/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(defun skil/org-icons-setup ()
  (interactive)
  (setq prettify-symbols-alist
        (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                '(("TODO" . "")
                  ("WAIT" . "")
                  ("NOPE" . "")
                  ("DONE" . "")
                  ("#+property:" . "")
                  (":properties:" . "")
                  (":end:" . "―")
                  ("#+startup:" . "")
                  ("#+title: " . "")
                  ("#+results:" . "")
                  ("#+name:" . "")
                  ("#+filetags:" . "")
                  ("#+html_head:" . "")
                  ("#+subtitle:" . "")
                  ("#+author:" . "")
                  (":Effort:" . "")
                  ("schedule:" . "")
                  ("deadline:" . "")
                  (":toc:" . ""))))
  (prettify-symbols-mode 1))

(setq org-link-frame-setup
      '((vm . vm-visit-folder-other-frame)
        (vm-imap . vm-visit-imap-folder-other-frame)
        (gnus . org-gnus-no-new-news)
        (file . find-file)
        (wl . wl-other-frame)))

(use-package org-modern
  :custom
  (org-hide-emphasis-markers t)
  (org-modern-table nil)
  (org-modern-tag nil)
  (org-modern-keyword nil)
  (org-modern-todo nil)
  (org-modern-block-fringe nil)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)))
(skil/leader-keys
  "nr"  '(:which-key "org-roam")
  "nri" '(org-roam-node-insert :which-key "Insert node")
  "nrf" '(org-roam-node-find :which-key "Find node"))

(with-eval-after-load 'org
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

(defun skil/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/config.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'skil/org-babel-tangle-config)))

(use-package toc-org
  :hook (org-mode . toc-org-mode))

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(setq org-preview-latex-image-directory (concat user-emacs-directory "/latex-images"))
;; (setq org-preview-latex-default-process 'dvisvgm)
(setq org-preview-latex-default-process 'dvipng) ; Bug with dvisvmg at the moment where text wrapped in \{text} isn't being rendered correctly.

(use-package org-download
  :after org
  :config
    (setq-default org-download-image-dir "./_assets") 
  :hook (dired-mode-hook . org-download-enable))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :config (lsp-enable-which-key-integration t))

(use-package company
  :after lsp-mode) ; auto complete-at-point
(use-package company-box ; nicer looking company mode
  :hook (company-mode . company-box-mode))
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))
(use-package lsp-ivy
  :after lsp)

(use-package ccls
  :after lsp
  :hook (c++-mode . lsp-deferred))

(use-package lsp-pyright
  :after lsp
  :hook (python-mode . lsp-deferred))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))
(skil/leader-keys
  "p"  '(projectile-command-map :which-key "project"))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer function #'magit-display-buffer-same-window-except-diff-v1))
(skil/leader-keys
  "g"  '(:which-key "magit")
  "gg" '(magit-status :which-key "Magit status")
  "gG" '(magit-status-here :which-key "Magit status here")
  "gR" '(magit-revert :which-key "Magit revert"))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
(skil/leader-keys
  "bc" '(evilnc-comment-or-uncomment-lines :which-key "Comment/uncomment code"))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(defun skil/new-empty-buffer ()
  "Create a new empty buffer."
  (interactive)
  (let ((xbuf (generate-new-buffer "*new*")))
    (switch-to-buffer xbuf)
    (funcall initial-major-mode)
    xbuf))

(defvar skil/is-big nil)
(defun skil/temp-text-scaling ()
  "Toggles temporary text scaling (a.k.a., big text mode"
  (interactive)
  (if skil/is-big
      (progn
        (text-scale-increase 0)
        (setq skil/is-big nil))
    (progn
      (text-scale-increase 2)
      (setq skil/is-big t))))

"Reloads Emacs init.el"
(defun skil/reload-init-file ()
  (interactive)
  (load-file user-init-file))

(setq gc-cons-threshold (* 2 1000 1000))
