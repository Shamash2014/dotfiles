;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-theme 'doom-nova
      lsp-auto-guess-root t
      dart-format-on-save t)

(add-hook 'dart-mode-hook 'lsp)
(add-hook 'js2-mode-hook #'run-import-js)
(add-hook 'typescript-mode-hook #'run-import-js)

(with-eval-after-load "projectile"
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD"))

(def-package! flutter :init (map! :map dart-mode-map :localleader "r r" #'flutter-run-or-hot-reload))

(map! :ne "SPC m c a" #'lsp-execute-code-action)
(map! :map js2-mode-map  :localleader "i f" #'import-js-fix)
(map! :map typescript-mode-map  :localleader "i f" #'import-js-fix)
