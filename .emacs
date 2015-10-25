(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (railscasts)))
 '(custom-safe-themes
   (quote
    ("4f4d18627707a30c38990103586758f4439943174ef6ed6155af3a17b6e211ed" "f36b8b8e1e2d90060ca145f85b3991476c5d5dbd651bc9d22437efe5b076354a" "9e7e1bd71ca102fcfc2646520bb2f25203544e7cc464a30c1cbd1385c65898f4" default)))
 '(evil-toggle-key "C-`")
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(linum-format "%5d ")
 '(tab-always-indent (quote complete))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:inherit highlight :background "#333233")))))

(global-set-key "\C-o" 'other-window)
(global-set-key "\C-ch" help-map)
;(global-set-key "\C-ck" kill-line)

(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)))
(require 'evil)
(evil-mode 1)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(menu-bar-mode -1)

(set-keyboard-coding-system nil)

(set-default 'fill-column 78)
(set-default 'truncate-lines t)
(show-paren-mode t)
(set-default 'show-trailing-whitespace t)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)
(setq-default default-tab-width 2)
(setq-default c-basic-offset 2)
(setq ruby-indent-level 2)
(setq coffee-tab-width 2)

(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-repl-display-in-current-window t)
(setq cider-show-error-buffer nil)
(setq cider-prompt-save-file-on-load 'always-save)
(setq cider-auto-select-test-report-buffer nil)

(evil-define-key 'normal clojure-mode-map ",e" 'find-file)


(defun cider-test-run-tests-in-current-ns ()
  "Saves and evals the buffer, and then runs any clojure.test tests defined in the current namespace."
  (interactive)
  (save-buffer)
  (cider-load-buffer)
  (cider-test-run-tests nil))

(evil-define-key 'normal clojure-mode-map ",t" 'cider-test-run-tests-in-current-ns)


(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(define-key evil-normal-state-map ",," 'switch-to-previous-buffer)


(add-to-list 'tgt-projects '((:root-dir "~/code/chess")
                             (:src-dirs "src")
                             (:test-dirs "test")
                             (:test-suffixes "_test")))
(setq tgt-open-in-new-window nil)
(define-key evil-normal-state-map ",." 'tgt-toggle)


(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

(define-key global-map (kbd "RET") 'newline-and-indent)
