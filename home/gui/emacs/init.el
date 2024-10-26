;;; init.el --- Emacs config -*- lexical-binding: t -*-

;;; Code:

(setopt make-backup-files nil)
(setopt backup-inhibited nil)
(setopt create-lockfiles nil)
(setopt custom-file null-device)
(setopt use-short-answer t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(add-to-list 'default-frame-alist '(font . "MonaspiceNe Nerd Font Mono"))

(setopt gc-cons-percentage 0.2
	gc-cons-threshold (* 128 1024 1024))
(setopt garbage-collection-message t)
(add-hook 'after-change-focus-function #'garbage-collect)

(use-package so-long
  :config (global-so-long-mode +1))

(use-package saveplace
  :init (save-place-mode +1))

(use-package recentf
  :config
  (recentf-mode +1)
  (setopt recentf-max-saved-items 1000)
  (setopt recentf-auto-cleanup 'never))

(use-package savehist
  :config (savehist-mode +1))

(use-package autorevert
  :config (global-auto-revert-mode +1))

(use-package subword
  :config (global-subword-mode +1))

(use-package files
  :config (auto-save-visited-mode -1))

(use-package simple
  :custom (indent-tabs-mode nil))

(use-package delsel
  :config (delete-selection-mode +1))

(setopt show-trailing-whitespace t)

;; Appearance
(use-package nerd-icons)
(use-package moody
  :config
  (moody-replace-mode-line-front-space)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-eldoc-minibuffer-message-function))
(use-package minions
  :config
  (minions-mode +1))
(use-package mlscroll
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'mlscroll-mode)
    (progn
      (setopt mlscroll-shortfun-min-width 11)
      (mlscroll-mode +1))))
(use-package diff-hl
  :config
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode +1)
  (diff-hl-flydiff-mode +1)
  (global-diff-hl-show-hunk-mouse-mode +1))
(use-package spacious-padding
  :custom
  (spacious-padding-widths '(:internal-border-width 6
                             :header-line-width 10
                             :mode-line-width 0
                             :tab-width 0
                             :right-divider-width 0
                             :scroll-bar-width 0
                             :left-fringe-width 8
                             :right-fringe-width 8))
  :config (spacious-padding-mode +1))
(use-package perfect-margin
  :config (perfect-margin-mode +1))
(use-package centaur-tabs
  :config
  (setopt centaur-tabs-style "alternate")
  (setopt centaur-tabs-set-icons t)
  (setopt centaur-tabs-icon-type 'nerd-icons)
  (setopt centaur-tabs-set-bar 'under)
  (setopt centaur-tabs-set-modified-marker t)
  (setopt centaur-tabs-cycle-scope 'tabs)
  (setq centaur-tabs-height 40)
  (centaur-tabs-mode +1))

(use-package ef-themes
  :custom
  (ef-themes-mixed-fonts t)
  (ef-themes-variable-pitch-ui t)
  :config
  (load-theme 'ef-winter t))

(use-package vertico
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-count 20)
  :config (vertico-mode +1))
(use-package consult)
(use-package consult-dir)
(use-package consult-flycheck
  :after (consult flycheck))
(use-package consule-eglot
  :after (consult eglot))
(use-package embark-consult
  :after (embark consult))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file basic partial-completion))))
(use-package marginalia
  :config (marginalia-mode +1))

(use-package which-key
  :config (which-key-mode +1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))

;; キーマップ
(use-package meow
  :custom
  (meow-use-clipboard t)
  :config
  (defun meow-setup ()
    (setopt meow-cheatsheet-layout 'meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("w" . meow-next-word)
     '("W" . meow-next-symbol)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("<escape>" . ignore)))
  (meow-setup)
  (meow-global-mode +1))

(provide 'init)
;;; init.el ends here
