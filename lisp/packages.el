(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
			 ("gnu"    . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(defvar bootstrap-version)
(defvar comp-deferred-compilation-deny-list ()) ; workaround, otherwise straight shits itself
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

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq straight-vc-git-default-remote-name "straight")
(setq use-package-always-ensure t)

(setq straight-built-in-pseudo-packages '(emacs nadvice python image-mode project flymake))
(setq straight-use-package-by-default t)

(use-package jellybeans-plus-theme
  :straight (jellybeans-plus-theme :type git :host github :repo "jsmestad/jellybeans-plus-theme")
  :init
  (load-theme 'jellybeans-plus t))

(use-package all-the-icons
  :straight t
  :init (require 'all-the-icons))

(use-package ligature

  :straight (ligature :type git
		      :host github
		      :repo "mickeynp/ligature.el"
		      :build t)
  :config
  (ligature-set-ligatures 't
			  '("www"))
  ;; enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures '(eww-mode org-mode elfeed-show-mode)
			  '("ff" "fi" "ffi"))
  ;; enable all cascadia code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode
			  '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
			    ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
			    "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
			    "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
			    "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
			    "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
			    "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
			    "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
			    ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
			    "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
			    "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
			    "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
			    "\\\\" "://"))
  (global-ligature-mode t))


(use-package elcord
  :straight (:built t)
  :defer t
  :config
  (setopt elcord-use-major-mode-as-main-icon t
	  elcord-refresh-rate                5
	  elcord-boring-buffers-regexp-list  `("^ "
					       ,(rx "*" (+ any) "*")
					       ,(rx bol (or "Re: "
							    "Fwd: ")))))

(use-package which-key
  :straight (:build t)
  :defer t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package evil
  :straight (:build t)
  :init
  (setq evil-want-integration t
	evil-want-keybinding nil
	evil-want-C-u-scroll t
	evil-want-C-i-jump nil)
  (require 'evil-vars)
  :config
  (evil-mode 1)
  (setq evil-want-fine-undo t) ; more granular undo with evil
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-set-initial-state 'dired-mode 'emacs))

(use-package evil-nerd-commenter
  :straight (:build t)
  :config
  (evilnc-default-hotkeys))

(use-package key-chord
  :straight (:build t)
  :init
  (require 'key-chord)
  :config
  (key-chord-mode 1)
  (key-chord-define-global "jk" 'evil-normal-state)
  (key-chord-define-global "kj" 'evil-normal-state)
  )

(use-package nerd-icons
  :straight (:build t)
  :after corfu
  :defer t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)

  ;; Optionally:
  (setq nerd-icons-corfu-mapping
	'((array :style "cod" :icon "symbol_array" :face font-lock-type-face)
	  (boolean :style "cod" :icon "symbol_boolean" :face font-lock-builtin-face)
	  ;; ...
	  (t :style "cod" :icon "code" :face font-lock-warning-face)))
  ;; Remember to add an entry for `t', the library uses that as default.
  )
(use-package magit
  :straight (:build t)
  :defer t
  :init
  (setq forge-add-default-bindings nil)
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  (setopt magit-clone-default-directory "~/fromGIT/"
	  magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package ripgrep
  :if (executable-find "rg")
  :straight (:build t)
  :defer t)

(use-package ivy
  :straight (:build t))

(use-package projectile
  :straight (:build t)
  :after ivy
  :diminish projectile-mode
  :custom ((projectile-completion-system 'ivy))
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  :config
  (projectile-mode)
  (setq projectile-project-search-path '("~/Code", "~/.config"))
  (define-key projectile-mode-map (kbd "M-p") 'projectile-command-map))

(use-package shell-pop
  :defer t
  :straight (:build t)
  :custom
  (shell-pop-default-directory "$HOME")
  (shell-pop-shell-type (quote ("eshell" "*eshell*" (lambda () (eshell shell-pop-term-shell)))))
  (shell-pop-window-size 30)
  (shell-pop-full-span nil)
  (shell-pop-window-position "bottom")
  (shell-pop-autocd-to-working-dir t)
  (shell-pop-restore-window-configuration t)
  (shell-pop-cleanup-buffer-at-process-exit t))

(use-package vterm
  :defer t
  :straight (:build t)
  :config
  (setq vterm-shell "/usr/bin/zsh"
	vterm-always-compile-module t))

(use-package eshell-vterm
  :after eshell
  :straight (:build t)
  :config
  (eshell-vterm-mode)
  (defalias 'eshell/v 'eshell-exec-visual))

(use-package quickrun
  :straight (:build t)
  :bind ("C-C r" . quickrun))

(use-package crux
  :straight (:build t)
  :bind
  (("C-c o"     . crux-open-with)
   ("C-c w"     . crux-cleanup-buffer-or-region)
   ("C-x 4 t"   . crux-transpose-windows)
   ("C-c D"     . crux-delete-file-and-buffer)
   ("C-c r"     . crux-rename-file-and-buffer)
   ("C-c I"     . crux-find-user-init-file)
   ("M-o"       . crux-other-window-or-switch-buffer)))

(provide 'packages)
