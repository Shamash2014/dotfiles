;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq doom-theme 'doom-solarized-light
      display-line-numbers-type 'relative
      company-show-numbers  nil
      company-idle-delay 0.1
      dart-format-on-save t
      lsp-clients-typescript-plugins
        (vector
          (list :name "@vsintellicode/typescript-intellicode-plugin"
                :location "<home>/.vscode/extensions/visualstudioexptteam.vscodeintellicode-1.1.9/")))

(add-hook 'dart-mode-hook 'lsp)
(add-hook 'js2-mode-hook #'run-import-js)
(add-hook 'typescript-mode-hook #'run-import-js)

(with-eval-after-load "projectile"
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD"))

(def-package! flutter :init (map! :map dart-mode-map :localleader "r r" #'flutter-run-or-hot-reload))
(def-package! company-tabnine :init (add-to-list 'company-backends 'company-tabnine))

(map! :ne "SPC m c s" #'lsp-ivy-workspace-symbol)
(map! :ne "SPC m c a" #'lsp-execute-code-action)
(map! :map js2-mode-map  :localleader "i f" #'import-js-fix)
(map! :map typescript-mode-map  :localleader "i f" #'import-js-fix)
