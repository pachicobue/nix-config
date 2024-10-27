;;; init.el --- Emacs config -*- lexical-binding: t -*-

;;; Code:
(setq-default debug-on-error t)
(setopt make-backup-files nil)
(setopt backup-inhibited nil)
(setopt custom-file null-device)
(setopt use-short-answers t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; abcdefghijklmno
;; あいうえおかきくけこ
(add-to-list 'default-frame-alist '(font . "Moralerspace Neon NF"))

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
(use-package dimmer
  :config
  (setopt dimmer-fraction 0.07
          dimmer-adjustment-mode :background
          dimmer-use-colorspace :rgb
          dimmer-watch-frame-focus-events nil)
  (dimmer-configure-which-key)
  (dimmer-configure-magit)
  (dimmer-configure-org)
  (dimmer-mode +1))
(use-package moody
  :config
  (moody-replace-mode-line-front-space)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-eldoc-minibuffer-message-function))
(use-package nano-modeline
  :config
  (setopt nano-modeline-padding '(0.20 . 0.25))
  (nano-modeline-text-mode t)
  (line-number-mode -1)
  (setq-default mode-line-format (delete '(vc-mode vc-mode) mode-line-format)))
(use-package minions
  :config
  (minions-mode +1))
(use-package mlscroll
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'mlscroll-mode)
    (mlscroll-mode +1)))
(use-package diff-hl
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook #'diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh #'diff-hl-magit-post-refresh)
  (diff-hl-flydiff-mode +1)
  (global-diff-hl-show-hunk-mouse-mode +1))
(use-package spacious-padding
  :config
  (setopt spaciout-padding-widths '(:internal-border-width 3
                                    :header-line-width 4
                                    :mode-line-width 0
                                    :tab-width 4
                                    :right-divider-width 0
                                    :scroll-bar-width 4
                                    :left-fringe-width 8
                                    :right-fringe-width 8))
  (spacious-padding-mode +1))
(use-package perfect-margin
  :config (perfect-margin-mode +1))

(use-package ef-themes
  :config
  (setopt ef-themes-mixed-fonts t
          ef-themes-variable-pitch-ui t)
  (ef-themes-select 'ef-autumn))

(use-package vertico
  :config
  (setopt vertico-cycle t
          vertico-resize nil
          vertico-count 20))

(use-package consult)
(use-package consult-dir)
(use-package consult-flycheck
  :after (consult flycheck))
(use-package consule-eglot
  :after (consult eglot))
(use-package embark-consult
  :after (embark consult))
(use-package orderless
  :config
  (setopt completion-styles '(orderless basic)
          completion-category-overrides '((file (styles basic partial-completion)))))
(use-package marginalia
  :config (marginalia-mode +1))

(use-package which-key
  :config (which-key-mode +1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))

;; Language
(use-package reformatter
  :config
  (reformatter-define nixfmt
    :program "nixfmt" :args '("-")))

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
