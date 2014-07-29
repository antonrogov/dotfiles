(require 'cask "/usr/local/Cellar/cask/0.6.0/cask.el")
(cask-initialize)
(require 'pallet)
(require 'evil)
(require 'powerline)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq cursor-type 'box)
(setq default-cursor-type 'box)

(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(global-hl-line-mode 1)
(set-face-background 'hl-line "#333233")

(global-linum-mode 1)
(setq linum-format "%5d ")

(set-default 'fill-column 78)
(set-default 'truncate-lines t)

(show-paren-mode t)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)
(setq-default default-tab-width 2)
(setq-default c-basic-offset 2)
(setq ruby-indent-level 2)
(setq coffee-tab-width 2)

(evil-mode 1)
(load-theme 'railscasts t nil)
