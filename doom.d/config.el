;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq doom-theme 'doom-solarized-dark
      doom-font (font-spec :family "Monoid" :size 12)
      doom-unicode-font (font-spec :family "Monoid" :size 12)
      doom-big-font (font-spec :family "Monoid" :size 19)
      display-line-numbers-type 'visual
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
(def-package! company-tabnine :init
  (add-to-list 'company-backends 'company-tabnine)
  (setq +lsp-company-backend (list 'company-tabnine 'company-lsp)))

(def-package! ivy-taskrunner :init (ivy-taskrunner-minor-mode t))


(map! :ne "SPC m c s" #'lsp-ivy-workspace-symbol)
(map! :ne "SPC m c a" #'lsp-execute-code-action)
(map! :ne "SPC m c t" #'ivy-taskrunner)
(map! :map js2-mode-map  :localleader "i f" #'import-js-fix)
(map! :map typescript-mode-map  :localleader "i f" #'import-js-fix)


(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
   an error"
  (car (ignore-errors (apply 'process-lines (split-string cmd)))))

(defun reason-cmd-where (cmd)
  (let ((where (shell-cmd cmd)))
    (if (not (string-equal "unknown flag ----where" where))
      where)))

(let* ((refmt-bin (or (reason-cmd-where "refmt ----where")
                      (shell-cmd "which refmt")
                      (shell-cmd "which bsrefmt")))
       (merlin-bin (or (reason-cmd-where "ocamlmerlin ----where")
                       (shell-cmd "which ocamlmerlin")))
       (merlin-base-dir (when merlin-bin
                          (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
  ;; Add merlin.el to the emacs load path and tell emacs where to find ocamlmerlin
  (when merlin-bin
    (add-to-list 'load-path (concat merlin-base-dir "share/emacs/site-lisp/"))
    (setq merlin-command merlin-bin))

  (when refmt-bin
    (setq refmt-command refmt-bin)))

(add-hook 'reason-mode-hook (lambda ()
                              (add-hook 'before-save-hook 'refmt-before-save)
                              (merlin-mode)))

;; (use-package! lsp-mode
;;   :defer t :init (add-hook 'reason-mode-hook #'lsp!)
;;   :config
;;   (lsp-register-client (make-lsp-client :new-connection (lsp-stdio-connection "/Users/Shamash/rls-macos/reason-language-server.exe"))
;;                   :major-modes '(reason-mode)
;;                   :notification-handlers (ht ("client/registerCapability" 'ignore))
;;                   :priority 1
;;                   :server-id 'reason-ls))




(def-package! reason-mode :init
  (setq merlin-ac-setup t))



(add-to-list 'auto-mode-alist '("\\.re\\'" . reason-mode))
