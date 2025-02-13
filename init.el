(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/packages" user-emacs-directory))

(require 'options)
(require 'hooks)

(require 'visuals)
(require 'modeline)

(require 'packages)
(require 'dashboard)
(require 'lsp)
(require 'treesitter)
(require 'completion)
(require 'programming)

(require 'indentation)
