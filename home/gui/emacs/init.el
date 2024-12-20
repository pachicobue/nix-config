;;; init.el --- Emacs config -*- lexical-binding: t -*-

;;; Code:
(use-package leaf
  :ensure t)
(leaf leaf
  :config
  (leaf leaf-keywords
    :ensure t
    :config
    (leaf-keywords-init))
  (leaf leaf-tree
    :ensure t
    :config
    (leaf imenu-list
      :config
      (setopt imenu-list-size 0.25
              imenu-list-position 'right))))

;; Warn if daemon
(leaf *Check-not-daemon
  :if (daemonp)
  :config
  (display-warning "'Emacs as daemon' is out of support! Some package config may not work!"))

;; Builtin
(leaf *Builtin
  :config
  (leaf server
    :preface (require 'server)
    :unless (server-running-p)
    :config
    (server-start))
  (leaf *esc-not-meta
    :config
    (define-key key-translation-map (kbd "ESC") (kbd "C-g"))
    (setq-default x-alt-keysym 'meta))
  (leaf *c-source-defined
    :leaf-defer nil
    :hook
    (after-change-focus-function . garbage-collect)
    :config
    (setq-default debug-on-error t)
    (setq-default create-lockfiles nil)
    (setq-default use-short-answers t)
    (setq-default user-full-name "pachicobue"
                  user-login-name "pachicobue")
    (setq-default history-length 1000
                  history-delete-duplicates t)
    (setq-default gc-cons-percentage 0.2
                  gc-cons-threshold (* 128 1024 1024)
                  garbage-collection-messages t)
    (add-to-list 'default-frame-alist '(font . "Moralerspace Neon NF"))
    (add-to-list 'default-frame-alist '(alpha-background . 0.8)))
  (leaf select
    :config
    (setopt select-enable-clipboard nil))
  (leaf cus-edit
    :config
    (setopt custom-files null-device))
  (leaf starup
    :config
    (setopt user-mail-address "tigerssho@gmail.com"))
  (leaf files
    :config
    (setopt make-backup-files nil
            backup-inhibited nil
            auto-save-default nil)
    (auto-save-visited-mode -1))
  (leaf mule-cmds
    :config
    (set-language-environment "japanese")
    (prefer-coding-system 'utf-8))
  (leaf menu-bar
    :config
    (menu-bar-mode -1))
  (leaf scroll-bar
    :config
    (scroll-bar-mode -1))
  (leaf tool-bar
    :config
    (tool-bar-mode -1))
  (leaf so-long
    :config
    (global-so-long-mode +1))
  (leaf saveplace
    :config
    (save-place-mode +1))
  (leaf recentf
    :config
    (setopt recentf-max-saved-items 1000
            recentf-auto-cleanup 'never)
    (recentf-mode +1))
  (leaf savehist
    :config
    (savehist-mode +1))
  (leaf autorevert
    :config
    (global-auto-revert-mode +1))
  (leaf subword
    :config
    (global-subword-mode +1))
  (leaf simple
    :config
    (indent-tabs-mode nil))
  (leaf delsel
    :config
    (delete-selection-mode +1)))

;; Appearance
(leaf *Appearance
  :config
  (leaf nerd-icons
    :ensure t)
  (leaf nerd-icons-dired
    :ensure t
    :hook
    (dired-mode-hook . nerd-icons-dired-mode))
  (leaf dimmer
    :ensure t
    :require t ;; Needed
    :defvar dimmer-prevent-dimming-predicates
    :init
    (defun advise-dimmer-config-change-handler ()
      "Advise to only force process if no predicate is truthy."
      (let ((ignore (cl-some (lambda (f) (and (fboundp f) (funcall f)))
                             dimmer-prevent-dimming-predicates)))
        (unless ignore
          (when (fboundp 'dimmer-process-all)
            (dimmer-process-all t)))))
    (defun corfu-frame-p ()
      "Check if the buffer is a corfu frame buffer."
      (string-match-p "\\` \\*corfu" (buffer-name)))
    (defun dimmer-configure-corfu ()
      "Convenience settings for corfu users."
      (add-to-list 'dimmer-prevent-dimming-predicates
                   #'corfu-frame-p))
    :config
    (setopt dimmer-fraction 0.07
            dimmer-adjustment-mode :background
            dimmer-use-colorspace :rgb
            dimmer-watch-frame-focus-events nil)
    (advice-add
     'dimmer-config-change-handler
     :override 'advise-dimmer-config-change-handler)
    (dimmer-configure-corfu)
    (dimmer-configure-which-key)
    (dimmer-configure-magit)
    (dimmer-configure-org)
    (dimmer-mode +1))
  (leaf moody
    :ensure t
    :config
    (moody-replace-mode-line-front-space)
    (moody-replace-mode-line-buffer-identification)
    (moody-replace-eldoc-minibuffer-message-function))
  (leaf minions
    :ensure t
    :config
    (minions-mode +1))
  (leaf mlscroll
    :ensure t
    :config
    (mlscroll-mode +1))
  (leaf diff-hl
    :ensure t
    :leaf-defer nil ;; Needed for daemon
    :hook
    ((dired-mode-hook    . diff-hl-dired-mode)
     (magit-pre-refresh  . diff-hl-magit-pre-refresh)
     (magit-post-refresh . diff-hl-magit-post-refresh))
    :config
    (global-diff-hl-mode +1)
    (diff-hl-flydiff-mode +1)
    (global-diff-hl-show-hunk-mouse-mode +1))
  (leaf spacious-padding
    :ensure t
    :config
    (setopt spacious-padding-widths
            '(:internal-border-width 3
                                     :header-line-width 4
                                     :mode-line-width 0
                                     :tab-width 4
                                     :right-divider-width 0
                                     :scroll-bar-width 0
                                     :left-fringe-width 8
                                     :right-fringe-width 0))
    (spacious-padding-mode +1))
  (leaf rainbow-delimiters
    :ensure t
    :hook
    (prog-mode . rainbow-delimiters-mode))
  (leaf treemacs
    :ensure t
    :bind
    ("C-S-b" . treemacs)
    :config
    (setopt treemacs-text-scale -1)
    (leaf treemacs-nerd-icons
      :ensure t
      :after treemacs nerd-icons
      :require t
      :config
      (treemacs-load-theme "nerd-icons"))
    (leaf treemacs-projectile
      :ensure t
      :after treemacs projectile
      :config
      (treemacs-project-follow-mode +1)))
  (leaf ef-themes
    :ensure t
    :config
    (setopt ef-themes-mixed-fonts t
            ef-themes-variable-pitch-ui t)
    (ef-themes-select 'ef-night)))

(leaf *History
  :config
  (leaf vundo
    :ensure t)
  (leaf undohist
    :ensure t
    :config
    (undohist-initialize)))

(leaf *Minibuffer
  :config
  (leaf vertico
    :ensure t
    :config
    (setopt vertico-cycle t
            vertico-resize nil
            vertico-count 20)
    (vertico-mode +1))
  (leaf consult
    :ensure t
    :config
    (leaf consult-dir
      :ensure t)
    (leaf consult-flycheck
      :ensure t
      :after (consult flycheck))
    (leaf consult-eglot
      :ensure t
      :after (consult eglot))
    (leaf embark-consult
      :ensure t
      :after (consult embark)))
  (leaf orderless
    :ensure t
    :config
    (setopt completion-styles '(orderless basic)
            completion-category-overrides '((file (styles basic partial-completion)))))
  (leaf marginalia
    :ensure t
    :config (marginalia-mode +1))
  (leaf which-key
    :ensure t
    :config (which-key-mode +1)))

(leaf *EnvVar
  :config
  (leaf envrc
    :ensure t
    :hook (after-init-hook . envrc-global-mode)))

(leaf *I8N
  :config
  (leaf fcitx
    :when (and (eq system-type 'gnu/linux)
               (executable-find "fcitx5-remote"))
    :leaf-defer nil
    :ensure t
    :hook
    (meow-insert-exit-hook . fcitx--deactivate)
    :config
    (setopt fcitx-use-dbus 'fcitx5)
    (setopt fcitx-remote-command "fcitx5-remote")
    (fcitx-aggressive-setup)))

(leaf *Completion
  :config
  (leaf corfu
    :ensure t
    :bind (:corfu-map
           ("SPC" . corfu-insert-separator)
           ("TAB" . corfu-next)
           ("S-TAB" . corfu-prev))
    :config
    (setopt corfu-auto t
            corfu-auto-delay 0.0
            corfu-popupinfo-delay 0.0
            corfu-auto-prefix 2
            corfu-cycle t
            corfu-preselect 'prompt
            corfu-quit-no-match 'separator)
    (global-corfu-mode +1)
    (corfu-popupinfo-mode +1))
  (leaf corfu-terminal
    :ensure t
    :config
    (unless (display-graphic-p)
      (corfu-terminal-mode +1)))
  (leaf nerd-icons-corfu
    :ensure t
    :after corfu nerd-icons
    :config
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)))

(leaf *Language
  :config
  (use-package reformatter ;; leaf does not work properly...Why?
    :ensure t
    :hook
    (((nix-mode nix-ts-mode) . nixfmt-on-save-mode)
     ((json-mode
       json-ts-mode
       conf-toml-mode
       toml-ts-mode
       html-mode
       mhtml-mode
       html-ts-mode
       css-mode
       css-ts-mode
       js-mode
       js-ts-mode
       markdown-mode
       markdown-ts-mode) . dprint-on-save-mode)
     ((python-mode python-ts-mode) . ruff-on-save-mode)
     ((c-mode
       c-ts-mode
       c++-mode
       c++-ts-mode) . clang-format-on-save-mode))
    :config
    (reformatter-define nixfmt
      :program "nixfmt" :args '("-"))
    (reformatter-define dprint
      :program "dprint" :args `("fmt" "--stdin" ,buffer-file-name))
    (reformatter-define ruff
      :program "ruff" :args `("format" "--stdin-filename" ,buffer-file-name "-"))
    (reformatter-define clang-format
      :program "clang-formatter"))
  (leaf eglot
    :ensure t
    :hook
    ((c-mode-hook
      c-ts-mode-hook
      c++-mode-hook
      c++-ts-mode-hook
      python-mode-hook
      python-ts-mode-hook
      nix-mode-hook
      nix-ts-mode-hook
      html-mode-hook
      mhtml-mode-hook
      html-ts-mode-hook
      json-mode-hook
      json-ts-mode-hook
      markdown-mode-hook
      markdown-ts-mode-hook
      rust-mode-hook
      rust-ts-mode-hook) . eglot-ensure))
  (leaf treesit-auto
    :require t
    :ensure t
    :config
    (setopt treesit-auto-install 'prompt)
    (treesit-auto-add-to-auto-mode-alist 'all)
    (global-treesit-auto-mode))
  (leaf nix-mode
    :ensure t)
  (leaf nix-ts-mode
    :ensure t)
  (leaf json-mode
    :ensure t
    :mode
    ("\\.jsonc\\'" . jsonc-mode)
    :config
    (setopt js-indent-level 2))
  (leaf markdown-mode
    :ensure t
    :config
    (setopt markdown-fontify-code-blocks-natively t))
  (leaf markdown-ts-mode
    :ensure t)
  (leaf rust-mode
    :ensure t
    :config
    (setopt rust-mode-treesitter-derive t
            rust-formatter-on-save t))
  (leaf aggressive-indent
    :ensure t
    :hook
    (emacs-lisp-mode-hook . aggressive-indent-mode))
  (leaf whitespace
    :config
    (setopt whitespace-style
            '(face
              ;; indentation
              tabs
              tab-mark
              ;; spaces
              ;; space-mark
              ;; newline
              ;; newline-mark
              trailing
              ;; lines-tail
              ))
    :hook
    ((text-mode-hook prog-mode-hook) . (lambda () (whitespace-mode +1)))))

(leaf *Keybind
  :config
  (leaf meow
    :require t
    :ensure t
    :config
    (defun helix-A-command ()
      (interactive)
      (meow-line 1)
      (meow-append))
    (defun helix-I-command ()
      (interactive)
      (meow-join 1)
      (meow-append))
    (defun helix-J-command ()
      (interactive)
      (meow-join -1)
      (meow-kill))
    (defun my-comment-dwim (arg)
      (interactive "*P")
      (if (use-region-p)
          (comment-or-uncomment-region (region-beginning) (region-end))
        (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

    (setopt meow-use-clipboard nil)
    (setopt meow-selection-command-fallback
            '((meow-change . meow-change-char)
              (meow-kill . meow-delete)
              (meow-cancel-selection . keyboard-quit)
              (meow-pop-selection . meow-pop-grab)
              (meow-beacon-change . meow-beacon-change-char)))
    (defun meow-setup ()
      (setopt meow-cheatsheet-layout 'meow-cheatsheet-layout-qwerty)
      (setopt meow-leader-key "SPC")
      (meow-leader-define-key
       '("w" . save-buffer)
       '("y" . meow-clipboard-save)
       '("p" . meow-clipboard-yank)
       '("c" . my-comment-dwim))
      (meow-motion-overwrite-define-key
       '("j" . meow-next)
       '("k" . meow-prev))
      (meow-normal-define-key
       '("h" . meow-left)
       '("j" . meow-next)
       '("k" . meow-prev)
       '("l" . meow-right)
       '("w" . meow-next-word)
       '("b" . meow-back-word)
       '("d" . meow-kill)
       '("y" . meow-save)
       '("p" . meow-yank)
       '("o" . meow-open-below)
       '("O" . meow-open-above)
       '("u" . undo-only)
       '("U" . undo-redo)
       '("x" . meow-line)
       '("A" . helix-A-command)
       '("I" . helix-I-command)
       '("J" . helix-J-command)
       )
      )
    (meow-setup)
    (meow-global-mode +1)))

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
