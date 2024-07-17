;; -*- lexical-binding: t; -*-

(setq inhibit-startup-message t)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

(setq native-comp-async-report-warnings-errors nil)

(straight-use-package 'use-package)

(setq mac-command-modifier      'super
      ns-command-modifier       'super
      mac-option-modifier       'meta
      ns-option-modifier        'meta
      ;; Free up the right option for character composition
      mac-right-option-modifier 'none
      ns-right-option-modifier  'none)

(setq ns-use-native-fullscreen nil)

;; Visit files opened outside of Emacs in existing frame, not a new one
(setq ns-pop-up-frames nil)

;; (setq mac-redisplay-dont-reset-vscroll t
;;       mac-mouse-wheel-smooth-scroll nil)

;; (require 'ns-auto-titlebar nil t)
;; (ns-auto-titlebar-mode +1)

(set-frame-size nil 200 50)

;; Don't resize the frames in steps; it looks weird, especially in tiling window
;; managers, where it can leave unseemly gaps.
(setq frame-resize-pixelwise t)

;; But do not resize windows pixelwise, this can cause crashes in some cases
;; when resizing too many windows at once or rapidly.
(setq window-resize-pixelwise nil)

;;; Scrolling

(setq hscroll-margin 2
      hscroll-step 1
      fast-but-imprecise-scrolling t
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered.
      scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)

;; (add-to-list 'default-frame-alist '(selected-frame) 'name nil)
;; (add-to-list 'default-frame-alist '(ns-appearance . dark))
;; (customize-set-variable mac-right-option-modifier nil)
;; (customize-set-variable mac-command-modifier 'super)
;; (customize-set-variable ns-function-modifier 'hyper))

(defvar ar/font-size 12)
(defvar ar/font-fixed-width "Iosevka Code") ;;"JetBrains Mono")
(defvar ar/font-variable-width "SF Pro") ;;Iosevka Quasi") ;;"Inter")
(defvar ar/font-emoji "Apple Color Emoji")
(defvar ar/font-emoji-size-diff -3) ;;-2)

;; (set-face-attribute 'variable-pitch-text nil :height 1.0)
;; (set-fontset-font (face-attribute 'variable-pitch :font t) 'cyrillic (font-spec :family "Iosevka Quasi"))

(defun ar/set-font-size (size)
  (setq ar/font-size size)
  ;; changing font size changes the window size so save it here and restore after
  (let ((w (- (frame-pixel-width) 20)) ;; left-fringe + right-fringe + internal-border-width * 2
        (h (- (frame-pixel-height) 4))) ;; internal-border-width * 2
    ;; line-height: 1.55, line-spacing is added both above and below the text
    (setq-default line-spacing (ceiling (* size 0.275))) ;0.25)))
    (dolist (face '(default fixed-pitch variable-pitch))
      (set-face-attribute face nil :height (* size 10)))
    (set-fontset-font t 'emoji (font-spec :family ar/font-emoji :size (+ size ar/font-emoji-size-diff)))
    (set-frame-size nil w h t)))

(defun ar/change-font-size (inc)
  (ar/set-font-size (+ ar/font-size inc)))

(dolist (face '(default fixed-pitch))
  (set-face-attribute face nil :family ar/font-fixed-width))
(set-face-attribute 'variable-pitch nil :family ar/font-variable-width)

(set-face-attribute 'variable-pitch-text nil :height 1.0)

(ar/set-font-size ar/font-size)
(set-fontset-font t 'armenian (font-spec :family "SF Armenian"))

(straight-use-package 'all-the-icons)

;; (use-package emojify
;;   :straight t
;;   :hook (erc-mode . emojify-mode)
;;   :commands emojify-mode)

(push '("^\\*\\(\\(rspec-\\)\\?compilation\\|helpful \\|Help\\|Embark Export:\\)"
        (display-buffer-reuse-window display-buffer-same-window)
        (inhibit-switch-frame . t)) display-buffer-alist)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(blink-cursor-mode -1)

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

;; Typing yes/no is obnoxious when y/n will do
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  ;; DEPRECATED: Remove when we drop 27.x support
  (advice-add #'yes-or-no-p :override #'y-or-n-p))

;; Explicitly define a width to reduce the cost of on-the-fly computation
(setq-default display-line-numbers-width 3)

;; Show absolute line numbers for narrowed regions to make it easier to tell the
;; buffer is narrowed, and where you are, exactly.
(setq-default display-line-numbers-widen t)

(setq display-line-numbers-type 'relative)

(dolist (mode '(prog-mode text-mode conf-mode))
  (add-hook (intern (format "%s-hook" mode))
            #'display-line-numbers-mode))

(setq-default fill-column 99)

;; don't ask to follow git symlinks
(setq vc-follow-symlinks t)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

(setq-default show-trailing-whitespace t)

(defun ar/hide-trailing-whitespace ()
  (setq-local show-trailing-whitespace nil))

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq standard-indent 2)
(setq css-indent-offset 2)
(setq sh-basic-offset 2)

;; Auto-insert matching bracket
;; (electric-pair-mode 1)

;; Turn on paren match highlighting
(show-paren-mode 1)

;; Enable savehist-mode for command history
(savehist-mode 1)

(recentf-mode 1)

;; (setq completion-cycle-threshold 3)
(setq tab-always-indent 'complete)

(setq delete-by-moving-to-trash t)

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(defvar +ligatures-composition-alist
  '((?!  . "\\(?:!\\(?:==\\|[!=]\\)\\)")                                      ; (regexp-opt '("!!" "!=" "!=="))
    (?#  . "\\(?:#\\(?:###?\\|_(\\|[#(:=?[_{]\\)\\)")                         ; (regexp-opt '("##" "###" "####" "#(" "#:" "#=" "#?" "#[" "#_" "#_(" "#{"))
    (?$  . "\\(?:\\$>>?\\)")                                                  ; (regexp-opt '("$>" "$>>"))
    (?%  . "\\(?:%%%?\\)")                                                    ; (regexp-opt '("%%" "%%%"))
    (?&  . "\\(?:&&&?\\)")                                                    ; (regexp-opt '("&&" "&&&"))
    (?*  . "\\(?:\\*\\(?:\\*[*/]\\|[)*/>]\\)?\\)")                            ; (regexp-opt '("*" "**" "***" "**/" "*/" "*>" "*)"))
    (?+  . "\\(?:\\+\\(?:\\+\\+\\|[+:>]\\)?\\)")                              ; (regexp-opt '("+" "++" "+++" "+>" "+:"))
    (?-  . "\\(?:-\\(?:-\\(?:->\\|[>-]\\)\\|<[<-]\\|>[>-]\\|[:<>|}~-]\\)\\)") ; (regexp-opt '("--" "---" "-->" "--->" "->-" "-<" "-<-" "-<<" "->" "->>" "-}" "-~" "-:" "-|"))
    (?.  . "\\(?:\\.\\(?:\\.[.<]\\|[.=>-]\\)\\)")                             ; (regexp-opt '(".-" ".." "..." "..<" ".=" ".>"))
    (?/  . "\\(?:/\\(?:\\*\\*\\|//\\|==\\|[*/=>]\\)\\)")                      ; (regexp-opt '("/*" "/**" "//" "///" "/=" "/==" "/>"))
    (?:  . "\\(?::\\(?:::\\|[+:<=>]\\)?\\)")                                  ; (regexp-opt '(":" "::" ":::" ":=" ":<" ":=" ":>" ":+"))
    (?\; . ";;")                                                              ; (regexp-opt '(";;"))
    (?0  . "0\\(?:\\(x[a-fA-F0-9]\\).?\\)") ; Tries to match the x in 0xDEADBEEF
    ;; (?x . "x") ; Also tries to match the x in 0xDEADBEEF
    ;; (regexp-opt '("<!--" "<$" "<$>" "<*" "<*>" "<**>" "<+" "<+>" "<-" "<--" "<---" "<->" "<-->" "<--->" "</" "</>" "<<" "<<-" "<<<" "<<=" "<=" "<=<" "<==" "<=>" "<===>" "<>" "<|" "<|>" "<~" "<~~" "<." "<.>" "<..>"))
    (?<  . "\\(?:<\\(?:!--\\|\\$>\\|\\*\\(?:\\*?>\\)\\|\\+>\\|-\\(?:-\\(?:->\\|[>-]\\)\\|[>-]\\)\\|\\.\\(?:\\.?>\\)\\|/>\\|<[<=-]\\|=\\(?:==>\\|[<=>]\\)\\||>\\|~~\\|[$*+./<=>|~-]\\)\\)")
    (?=  . "\\(?:=\\(?:/=\\|:=\\|<[<=]\\|=[=>]\\|>[=>]\\|[=>]\\)\\)")         ; (regexp-opt '("=/=" "=:=" "=<<" "==" "===" "==>" "=>" "=>>" "=>=" "=<="))
    (?>  . "\\(?:>\\(?:->\\|=>\\|>[=>-]\\|[:=>-]\\)\\)")                      ; (regexp-opt '(">-" ">->" ">:" ">=" ">=>" ">>" ">>-" ">>=" ">>>"))
    (??  . "\\(?:\\?[.:=?]\\)")                                               ; (regexp-opt '("??" "?." "?:" "?="))
    (?\[ . "\\(?:\\[\\(?:|]\\|[]|]\\)\\)")                                    ; (regexp-opt '("[]" "[|]" "[|"))
    (?\\ . "\\(?:\\\\\\\\[\\n]?\\)")                                          ; (regexp-opt '("\\\\" "\\\\\\" "\\\\n"))
    (?^  . "\\(?:\\^==?\\)")                                                  ; (regexp-opt '("^=" "^=="))
    (?w  . "\\(?:wwww?\\)")                                                   ; (regexp-opt '("www" "wwww"))
    (?{  . "\\(?:{\\(?:|\\(?:|}\\|[|}]\\)\\|[|-]\\)\\)")                      ; (regexp-opt '("{-" "{|" "{||" "{|}" "{||}"))
    (?|  . "\\(?:|\\(?:->\\|=>\\||=\\|[]=>|}-]\\)\\)")                        ; (regexp-opt '("|=" "|>" "||" "||=" "|->" "|=>" "|]" "|}" "|-"))
    (?_  . "\\(?:_\\(?:|?_\\)\\)")                                            ; (regexp-opt '("_|_" "__"))
    (?\( . "\\(?:(\\*\\)")                                                    ; (regexp-opt '("(*"))
    (?~  . "\\(?:~\\(?:~>\\|[=>@~-]\\)\\)")))                                 ; (regexp-opt '("~-" "~=" "~>" "~@" "~~" "~~>"))

(defvar +ligature--composition-table (make-char-table nil))

(defun +ligature-init-composition-table-h ()
  (dolist (char-regexp +ligatures-composition-alist)
    (set-char-table-range
     +ligature--composition-table
     (car char-regexp) `([,(cdr char-regexp) 0 font-shape-gstring])))
  (set-char-table-parent +ligature--composition-table composition-function-table))

(+ligature-init-composition-table-h)

(defun +ligatures-init-buffer-h ()
  (if (boundp '+ligature--composition-table)
      (setq-local composition-function-table +ligature--composition-table)))

(add-hook 'after-change-major-mode-hook #'+ligatures-init-buffer-h)

;; Don't generate backups or lockfiles. While auto-save maintains a copy so long
;; as a buffer is unsaved, backups create copies once, when the file is first
;; written, and never again until it is killed and reopened. This is better
;; suited to version control, and I don't want world-readable copies of
;; potentially sensitive material floating around our filesystem.
(setq create-lockfiles nil
      make-backup-files nil
      ;; But in case the user does enable it, some sensible defaults:
      version-control t     ; number each backup file
      backup-by-copying t   ; instead of renaming current file (clobbers links)
      delete-old-versions t ; clean up after itself
      kept-old-versions 5
      kept-new-versions 5
      backup-directory-alist (list (cons "." (concat user-emacs-directory "backup/")))
      tramp-backup-directory-alist backup-directory-alist)

(setq auto-save-default nil)
;; (setq auto-save-default t
;;       ;; Don't auto-disable auto-save after deleting big chunks. This defeats
;;       ;; the purpose of a failsafe. This adds the risk of losing the data we
;;       ;; just deleted, but I believe that's VCS's jurisdiction, not ours.
;;       auto-save-include-big-deletions t
;;       ;; Keep it out of `doom-emacs-dir' or the local directory.
;;       auto-save-list-file-prefix (concat doom-cache-dir "autosave/")
;;       tramp-auto-save-directory  (concat doom-cache-dir "tramp-autosave/")
;;       auto-save-file-name-transforms
;;       (list (list "\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
;;                   ;; Prefix tramp autosaves to prevent conflicts with local ones
;;                   (concat auto-save-list-file-prefix "tramp-\\2") t)
;;             (list ".*" auto-save-list-file-prefix t)))

;; Create missing directories when we open a file that doesn't exist under a
;; directory tree that may not exist.
(defun +doom-create-missing-directories-h ()
  "Automatically create missing directories when creating new files."
  (unless (file-remote-p buffer-file-name)
    (let ((parent-directory (file-name-directory buffer-file-name)))
      (and (not (file-directory-p parent-directory))
           (y-or-n-p (format "Directory `%s' does not exist! Create it?"
                             parent-directory))
           (progn (make-directory parent-directory 'parents)
                  t)))))
(add-hook 'find-file-not-found-functions #'+doom-create-missing-directories-h)

(use-package hide-mode-line
  :straight t)

(defun ar/backward-kill-word (arg)
  (interactive "p")
  (let (kill-ring)
    (ignore-errors (backward-kill-word arg))))

(defun ar/project-vterm (name)
  (ar/project-buffer name #'ar/vterm))

(defun ar/project-terminal ()
  (interactive)
  (let* ((name (projectile-project-name))
         (bufs (seq-filter (lambda (b)
                             (string-match (concat "\\*" name ":") (buffer-name b)))
                           (projectile-project-buffers)))
         (choice (completing-read "Terminal: " (mapcar #'buffer-name bufs) nil nil nil t ""))
         (buf (get-buffer choice)))
    (if buf
        (switch-to-buffer buf)
      (ar/vterm (concat "*" name ":" (if (> (length choice) 0) choice "vterm") "*")))))

(defvar ar/popup-buffers '())

(defun ar/popup-toggle ()
  (interactive)
  (if-let ((window (cl-find-if (lambda (w)
                                 (eq 'popup (window-parameter w 'window-slot)))
                               (window-list))))
      (delete-window window)
    (let* ((name (safe-persp-name (get-current-persp)))
           (buffer (nth 1 (cl-find-if (lambda (e) (string-equal name (car e)))
                                      ar/popup-buffers))))
      (unless buffer
        (setq buffer (current-buffer))
        (push (list name buffer) ar/popup-buffers))
      (window--make-major-side-window buffer 'bottom 'popup))))

(defun ar/project-find-file ()
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (call-interactively #'find-file)))

(defun ar/project-shell-cmd (&optional arg)
  (interactive "P")
  (call-interactively (if arg #'projectile-run-async-shell-command-in-root
                        #'projectile-run-shell-command-in-root)))

(defun ar/shell-cmd (&optional arg)
  (interactive "P")
  (call-interactively (if arg #'async-shell-command #'shell-command)))

;; Toggle between split windows and a single window
(defun ar/zoom-window ()
  (interactive)
  (when (not (window-minibuffer-p (selected-window)))
    (if (= 1 (count-windows))
        (jump-to-register ?u)
      (window-configuration-to-register ?u)
      (delete-other-windows))))

(defun ar/org-clock-toggle ()
  (interactive)
  (if (org-clocking-p)
      (org-clock-out)
    (call-interactively 'org-clock-in)))

(use-package general
  :straight t
  :config
  (general-create-definer ar/leader-def
    :states '(normal motion visual)
    :keymaps 'override
    :prefix "SPC")
  (general-create-definer ar/local-leader-def :prefix "SPC m")

  (general-def
    :states 'normal
    "g s" #'transpose-chars)

  (general-def
   :states '(normal visual)
   "g c" #'evilnc-comment-operator)

  (general-def
   :states 'normal
   :keymaps 'prog-mode-map
   "[ e" #'previous-error
   "] e" #'next-error)

  (general-def
   :states 'visual
   :keymaps 'prog-mode-map
   "g l" #'align-regexp)

  (general-def
    :states 'visual
    "g r" #'eval-region)

  ;; (use-package quickrun
  ;;   :straight t
  ;;   :config
  ;;   (general-define-key
  ;;    :states '(normal visual)
  ;;    "gr" #'quickrun-region))

  ;; Minibuffer
  (general-define-key
   :keymaps '(minibuffer-local-map
              minibuffer-local-ns-map
              minibuffer-local-completion-map
              minibuffer-local-must-match-map
              minibuffer-local-isearch-map
              read-expression-map)
   [escape] #'abort-recursive-edit
   "C-a"    #'move-beginning-of-line
   "TAB"    #'completion-at-point
   ;; "C-b" #'evil-backward-char
   ;; "C-f" #'evil-forward-char
   ;; "C-j"    #'next-line
   ;; "C-k"    #'previous-line
   "C-w"    #'ar/backward-kill-word)

  ;; Leader
  (ar/leader-def
   "SPC" #'universal-argument
   "!" #'ar/shell-cmd
   "`" #'consult-buffer
   ";" #'pp-eval-expression
   "," #'evil-switch-to-windows-last-buffer
   "." #'find-file
   "<" #'consult-project-buffer
   "/" #'consult-ripgrep
   "b d" #'kill-current-buffer
   "b i" #'ibuffer
   "b n" #'next-buffer
   "b p" #'previous-buffer
   "b w" #'widen
   "f D" #'ar/delete-file
   "f f" #'find-file
   "f F" #'ar/project-find-file
   "f r" #'consult-recent-file
   "f R" #'doom/move-this-file
   "f s" (lambda () (interactive) (consult-ripgrep default-directory))
   "f y" #'doom/yank-buffer-path
   "f Y" #'doom/yank-buffer-path-relative-to-project
   "g b" #'magit-blame-addition
   "g f" #'magit-find-file
   "g g" #'magit-status
   "g l" #'magit-log-buffer-file
   "h '" #'describe-char
   "h f" #'describe-face
   "h k" #'helpful-key
   "h K" #'describe-keymap
   "h m" #'describe-mode
   "h o" #'helpful-symbol
   "n f" #'org-roam-node-find
   "n i" #'org-roam-node-insert
   "o a" (lambda () (interactive) (org-agenda nil "n"))
   "o m" #'mu4e
   "o t" #'ar/vterm
   "o w" (lambda (arg)
           (interactive "p")
           (let ((org-habit-show-habits-only-for-today (eq arg 1)))
             (org-agenda nil "w")))
   "p a" #'projectile-add-known-project
   "p b" #'ar/project-find-file
   "p c" #'ar/compile
   "p d" #'projectile-remove-known-project
   "p e" #'ar/project-shell-cmd
   "p E" #'envrc-allow
   "p f" #'projectile-find-file
   "p p" (lambda () (interactive) (ar/project-vterm "term"))
   "p P" #'projectile-switch-project
   "p r" (lambda () (interactive) (ar/project-vterm "run"))
   "p R" #'ar/projectile-purge-root-cache
   "p s" (lambda () (interactive) (ar/project-vterm "ssh"))
   "p t" #'ar/project-terminal
   "p T" #'ar/popup-toggle
   "t t" #'ar/org-clock-toggle
   "t w" #'visual-line-mode
   "w =" #'balance-windows
   "w o" #'ar/zoom-window
   "w O" #'delete-other-windows
   "w q" #'delete-window
   "y c" #'yas-new-snippet)

  (general-override-mode 1))

;; (general-define-key
;;  :keymaps (evil-ex-completion-map evil-ex-search-keymap)
;;       "C-a" #'evil-beginning-of-line
;;       "C-b" #'evil-backward-char
;;       "C-f" #'evil-forward-char
;;       :gi "C-j" #'next-complete-history-element
;;       :gi "C-k" #'previous-complete-history-element)

(global-set-key (kbd "s--") (lambda () (interactive) (ar/change-font-size -2)))
(global-set-key (kbd "s-=") (lambda () (interactive) (ar/change-font-size +2)))
(global-set-key (kbd "s-h") #'evil-window-left)
(global-set-key (kbd "s-j") #'evil-window-down)
(global-set-key (kbd "s-k") #'evil-window-up)
(global-set-key (kbd "s-l") #'evil-window-right)
(global-set-key (kbd "M-s-h") #'evil-window-decrease-width)
(global-set-key (kbd "M-s-j") #'evil-window-increase-height)
(global-set-key (kbd "M-s-k") #'evil-window-decrease-height)
(global-set-key (kbd "M-s-l") #'evil-window-increase-width)

(defun ar/underscore-as-word (orig &rest args)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (with-syntax-table table
      (apply orig args))))

(use-package evil
  :straight t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-minibuffer t)
  (setq evil-want-C-i-jump t)
  (setq evil-want-C-u-scroll t)
  (setq evil-respect-visual-line-mode t)
  ;; C-h is backspace in insert state
  ;; (customize-set-variable 'evil-want-C-h-delete t)
  (setq evil-symbol-word-search t)

  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-fine-undo t)

  (setq evil-undo-system 'undo-fu)

  ;; (setq evil-collection-setup-minibuffer t)
  (setq evil-collection-want-unimpaired-p nil)
  ;; (setq evil-collection-want-find-usages-bindings-p nil)
  :config
  (evil-mode 1)

  ;; treat _ as part of inner word
  (advice-add #'evil-inner-word :around #'ar/underscore-as-word)
  (advice-add #'evil-ex-search-word-backward :around #'ar/underscore-as-word)

  ;; (defadvice evil-inner-word (around underscore-as-word activate)
  ;;   (let ((table (copy-syntax-table (syntax-table))))
  ;;     (modify-syntax-entry ?_ "w" table)
  ;;     (with-syntax-table table
  ;;       ad-do-it)))

  ;; Try to fix escape
  ;; (evil-set-command-properties 'evil-force-normal-state :suppress-operator t)

  (defun +evil-disable-ex-highlights-h (&rest r)
    (when (evil-ex-hl-active-p 'evil-ex-search)
      (evil-ex-nohighlight)
      t))

  (advice-add `evil-force-normal-state :after #'+evil-disable-ex-highlights-h)

  ;; Make evil search more like vim
  (evil-select-search-module 'evil-search-module 'evil-search)

  ;; Make C-g revert to normal state
  ;;(define-key evil-insert-state-map (kbd "C-g") 'evil-force-normal-state)

  ;; Rebind `universal-argument' to 'C-M-u' since 'C-u' now scrolls the buffer
  ;;(global-set-key (kbd "C-M-u") 'universal-argument)

  ;; Use visual line motions even outside of visual-line-mode buffers
  ;;(evil-global-set-key 'motion "j" 'evil-next-visual-line)
  ;;(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; Make sure some modes start in Emacs state
  (dolist (mode '(custom-mode vterm-mode))
    (add-to-list 'evil-emacs-state-modes mode))

  (defun +default-disable-delete-selection-mode-h ()
    (delete-selection-mode -1))
  (add-hook 'evil-insert-state-entry-hook #'delete-selection-mode)
  (add-hook 'evil-insert-state-exit-hook  #'+default-disable-delete-selection-mode-h)

  (add-hook 'after-change-major-mode-hook
            (lambda () (setq-local evil-shift-width tab-width)))

  ;; keep visual mode after shifting
  (defun ar/evil-visual-restore (&rest r)
    (evil-normal-state)
    (evil-visual-restore))

  (advice-add #'evil-shift-right :after #'ar/evil-visual-restore))

;; (keymap-unset evil-insert-state-map "C-g")

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :straight t
  :after evil
  :config
  ;; Turn on Evil Nerd Commenter
  (evilnc-default-hotkeys))

(use-package evil-surround
  :straight t
  :config
  (global-evil-surround-mode 1))

(use-package evil-multiedit
  :straight t
  :config
  (general-def
    :states '(normal visual)
    "g n" #'evil-multiedit-match-and-next
    "g p" #'evil-multiedit-match-and-prev
    "g t" #'evil-multiedit-toggle-or-restrict-region))

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (clojure "https://github.com/oakmac/tree-sitter-clojure")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript"
                    "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (markdown "https://github.com/MDeiml/tree-sitter-markdown")
        (org "https://github.com/milisims/tree-sitter-org")
        (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript"
             "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                    "master" "typescript/src")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(require 'rust-ts-mode)
(require 'ruby-ts-mode)
(require 'typescript-ts-mode)

(defun ar/treesit-node-range (&optional node)
  (let* ((range (list (treesit-node-start node) (treesit-node-end node)))
         (range (sort range #'<))
         (start (car range))
         (end (cadr range))
         (parent (treesit-node-parent node)))
    (if (and parent (or (eq (point) start) (eq (point) (1- end))))
        (ar/treesit-node-range parent)
      (cons start end))))

(defun ar/treesit-goto-beginning-of-node ()
  (interactive)
  (let* ((node (treesit-node-at (point)))
         (range (ar/treesit-node-range node)))
    (goto-char (car range))))

(evil-define-text-object ar/evil-textobj-treesit-node (count &rest args)
  (let ((node (treesit-node-at (point)))
        (range (ar/treesit-node-range (treesit-node-at (point)))))
    (evil-range (car range) (cdr range))))

(define-key evil-inner-text-objects-map "n" 'ar/evil-textobj-treesit-node)
(define-key evil-outer-text-objects-map "n" 'ar/evil-textobj-treesit-node)

(general-def
  :keymaps 'prog-mode-map
  :states 'normal
  "g u" #'ar/treesit-goto-beginning-of-node)

;; (define-derived-mode org-ts-mode org-mode "Org"
;;   "Major mode for editing Org, powered by tree-sitter."
;;   :group 'org
;;   :syntax-table org-ts-mode--syntax-table
;;   (when (treesit-ready-p 'org)
;;     (treesit-parser-create 'org)
;;     (setq-local syntax-propertize-function #'org-ts-mode--syntax-propertize)
;;     (setq-local treesit-font-lock-settings org-ts-mode--font-lock-settings)
;;     (setq-local treesit-simple-indent-rules org-ts-mode--indent-rules)
;;     (treesit-major-mode-setup)))

;; (require 'yaml-ts-mode)
;; (global-tree-sitter-mode)
;; (push '(org-mode . org) tree-sitter-major-mode-language-alist)
;; (use-package tree-sitter
;;   :straight t
;;   :config
;;   (push '(org-mode . org) tree-sitter-major-mode-language-alist))
;; (global-tree-sitter-mode)
;; (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; (use-package tree-sitter-langs
;;   :straight t)

;; (treesit-search-forward-goto "function_definition" 'end)

;; (use-package evil-textobj-tree-sitter
;;   :straight t
;;   :config
;;   (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))
;;   (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
;;   ;; (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj ("class.outer")))
;;   (general-define-key
;;    :states '(normal visual)
;;    :keymaps 'prog-mode-map
;;    "] f" (lambda () (interactive) (evil-textobj-tree-sitter-goto-textobj "function.outer"))
;;    "[ f" (lambda () (interactive) (evil-textobj-tree-sitter-goto-textobj "function.outer" t))
;;    "] F" (lambda () (interactive) (evil-textobj-tree-sitter-goto-textobj "function.outer" nil t))
;;    "[ F" (lambda () (interactive) (evil-textobj-tree-sitter-goto-textobj "function.outer" t t))))

(use-package smartparens
  :straight t
  :config
  ;; Overlays are too distracting and not terribly helpful. show-parens does
  ;; this for us already (and is faster), so...
  (setq sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil
        ;; The default is 100, because smartparen's scans are relatively expensive
        ;; (especially with large pair lists for some modes), we reduce it, as a
        ;; better compromise between performance and accuracy.
        sp-max-prefix-length 25
        ;; No pair has any business being longer than 4 characters; if they must, set
        ;; it buffer-locally. It's less work for smartparens.
        sp-max-pair-length 4
        sp-autodelete-wrap t
        sp-autodelete-pair t
        sp-autodelete-opening-pair t
        sp-autodelete-closing-pair t)

  (defun doom-disable-smartparens-navigate-skip-match-h ()
    (setq sp-navigate-skip-match nil
          sp-navigate-consider-sgml-tags nil))
  (add-hook 'after-change-major-mode-hook #'doom-disable-smartparens-navigate-skip-match-h)

  (require 'smartparens-config)
  (sp-local-pair 'swift-mode "{" nil :post-handlers '(("|| " "SPC") ("||\n[i]" "RET")))
  ;; (add-hook 'js-ts-mode #'smartparens-mode)
  ;;(smartparens-global-mode)

  (general-define-key
   :states '(normal motion)
   :keymaps '(prog-mode-map)
   "[ s" #'sp-backward-sexp
   "] s" #'sp-forward-sexp
   "[ u" #'sp-backward-up-sexp
   "] u" #'sp-up-sexp))

(use-package org
  :straight t
  :init
  (setq org-directory "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/"
        org-modules '(org-habit)
        org-indirect-buffer-display 'current-window
        org-hide-leading-stars t
        org-use-fast-todo-selection 'expert
        org-M-RET-may-split-line nil
        org-startup-indented t
        org-startup-folded 'content
        org-tags-column 0
        org-ellipsis " ▼"
        org-log-into-drawer t
        org-clock-string-limit 1
        org-clock-display-default-range 'thismonth
        org-startup-with-inline-images t
        org-image-actual-width nil
        org-edit-src-content-indentation 0
        org-src-window-setup 'current-window
        org-file-apps '((auto-mode . emacs) (directory . emacs)
                        (remote . emacs)
                        (system . "open %s")
                        ("pdf" . emacs)
                        ("ps.gz" . "gv %s")
                        ("eps.gz" . "gv %s")
                        ("dvi" . "xdvi %s")
                        ("fig" . "xfig %s")
                        (t . "open %s"))
        org-todo-keywords '((sequence "TODO(t!)" "WIP(s!)" "|" "DONE(d!)")
                            (sequence "PROJ(p!)" "PWIP(s!)" "|" "DONE(d!)")
                            (sequence "HBT(b!)" "|" "DONE(d!)")
                            (type "WAIT(w!)" "HOLD(h!)" "IDEA(i!)" "|" "DONE(d!)")
                            (type "|" "KILL(k@)")
                            (sequence "[ ](T)" "|" "[X](D)")
                            (sequence "[-](S)" "[?](W)" "|"))
        org-todo-keyword-faces '(("TODO" . (:inherit success))
                                 ("PROJ" . (:inherit success))
                                 ("HBT"  . (:inherit success))
                                 ("WIP"  . (:inherit error))
                                 ("PWIP" . (:inherit error))
                                 ("WAIT" . (:inherit error))
                                 ("HOLD" . (:inherit error))
                                 ("IDEA" . (:inherit warning)))
        org-capture-templates '(("i" "Inbox" entry (file "inbox.org")
                                 "* %i%a%?\n%U\n")
                                ("c" "Clip" entry (file "inbox.org")
                                 "* %(org-cliplink-capture)%?\n%U\n")))

  (setq org-agenda-files (concat org-directory "agenda")
        org-agenda-window-setup 'current-window
        org-agenda-search-view-max-outline-level 2
        org-agenda-current-time-string "<- NOW"
        org-agenda-block-separator ?―
        org-habit-completed-glyph ?x
        org-habit-show-done-always-green t
        org-habit-following-days 1
        org-habit-preceding-days 30
        org-habit-graph-column 70
        org-agenda-time-grid '((daily today remove-match)
                               (800 1000 1200 1400 1600 1800 2000)
                               " ┄┄┄┄┄ "
                               "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))

  (setq org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 3))
        ;; Without this, completers like ivy/helm are only given the first level of
        ;; each outline candidates. i.e. all the candidates under the "Tasks" heading
        ;; are just "Tasks/". This is unhelpful. We want the full path to each refile
        ;; target! e.g. FILE/Tasks/heading/subheading
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil)

  (setq org-attach-auto-tag "attach"
        org-attach-use-inheritance t
        org-attach-id-dir (concat org-directory "files"))

  (setq org-agenda-category-icon-alist nil)
  (add-to-list 'org-agenda-category-icon-alist (list "emacs" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "keyboard" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "monsters" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "pomodoro" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "zero" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "trading" (list "") nil nil :ascent 'center))
  ;; (add-to-list 'org-agenda-category-icon-alist (list "forecast" (list "") nil nil :ascent 'center))
  (add-to-list 'org-agenda-category-icon-alist (list "forecast" (list "") nil nil :ascent 'center))

  (setq org-agenda-custom-commands
        (quote
         (("w" "This week"
           ((agenda "" ((org-agenda-overriding-header "This week:")
                        (org-agenda-span 'week)
                        (org-agenda-start-on-weekday 1)
                        (org-agenda-start-day "+0d")
                        (org-agenda-use-time-grid nil)
                        (org-agenda-show-log t)
                        (org-agenda-log-mode-items '(state clock))
                        (org-agenda-prefer-last-repeat t)
                        (org-agenda-prefix-format " %i %?-12t% s")
                        (org-agenda-sorting-strategy '(time-up priority-down category-keep))))))
          ("n" "Today"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-agenda-span 'day)
                        (org-agenda-ndays 1)
                        (org-agenda-show-log t)
                        (org-agenda-include-diary nil);; t)
                        (org-agenda-log-mode-items '(clock state))
                        (org-agenda-scheduled-leaders '("" "%2dd overdue: "))
                        (org-agenda-prefer-last-repeat t)
                        (org-agenda-prefix-format " %i %?-12t% s")
                        (org-agenda-sorting-strategy '(time-up priority-down category-keep))
                        (org-agenda-start-on-weekday nil)
                        (org-agenda-start-day "+0d")))
            (tags "-habit/!+WIP|+PWIP" ((org-agenda-overriding-header " ")))
            (tags "-habit/!+WAIT|+HOLD" ((org-agenda-overriding-header " ")))
            (tags "-hack+TODO<>\"DONE\""
                  ((org-agenda-overriding-header "Inbox")
                   (org-tags-match-list-sublevels nil)
                   (org-agenda-sorting-strategy '(tsia-down))
                   (org-agenda-max-entries 10)
                   (org-agenda-prefix-format " - ")
                   ;; (org-agenda-prefix-format "  * %?-12t% s")
                   (org-agenda-files (list "inbox.org"))))
            (tags-todo "-habit+CATEGORY=\"Forecast\"+TODO=\"TODO\""
                       ((org-agenda-overriding-header "Forecast")
                        (org-agenda-prefix-format "%i ")
                        (org-agenda-sorting-strategy '(tsia-down))
                        (org-agenda-max-entries 5)))
            (tags-todo "-habit+CATEGORY<>\"Forecast\"+TODO=\"TODO\""
                       ((org-agenda-overriding-header "Personal")
                        (org-agenda-prefix-format "%i ")
                        (org-agenda-sorting-strategy '(tsia-down))
                        (org-agenda-max-entries 10)))
            )))))

  (general-define-key
   :keymaps 'org-mode-map
   :states '(normal motion)
   "RET" #'org-open-at-point))

(use-package org-download
  :straight t
  :config
  (setq org-download-method 'attach
        org-download-image-dir (concat org-directory "files")
        org-download-heading-lvl nil
        org-download-image-org-width 300
        org-download-timestamp "%Y%m%d-%H%M%S-"))

(use-package org-cliplink
  :straight t)

(use-package evil-org
  :straight t
  :after org
  :hook (org-mode . evil-org-mode)
  ;; :hook (org-mode . tree-sitter-hl-mode)
  :hook (org-agenda-mode . ar/hide-trailing-whitespace)
  :config
  (evil-org-set-key-theme)
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(general-def
 :states '(normal motion)
 :keymaps 'org-agenda-mode-map
 [escape] #'ignore
 "o" #'ignore
 "q" #'org-agenda-quit)

(general-def
 :states '(visual)
 :keymaps 'org-agenda-mode-map
 "j" #'evil-next-line
 "k" #'evil-previous-line)

(ar/local-leader-def
  :states '(normal motion)
  :keymaps 'org-mode-map
  "!" #'org-babel-tangle
  "d i" #'org-download-image
  "d p" #'org-download-clipboard
  "l p" #'org-cliplink
  "l t" #'org-toggle-link-display
  "c" #'org-edit-src-code
  "r" #'org-refile
  "s" #'org-narrow-to-subtree
  "t" #'org-todo
  "q" #'org-set-tags-command)

(defun ar/org-roam-node-slug (orig &rest args)
  (string-replace "_" "-" (apply orig args)))

(defvar org--inhibit-version-check t)

(use-package org-roam
  :straight t
  :init
  (setq org-roam-v2-ack t
        org-roam-directory org-directory
        org-roam-node-display-template "${title}"
        org-roam-extract-new-file-path "${slug}.org"
        org-roam-capture-templates '(("d" "default" plain "%?"
                                      :target (file+head "${slug}.org"
                                                        "#+title: ${title}\n%U\n\n")
                                      :unnarrowed t)))
  :config
  (advice-add 'org-roam-node-slug :around #'ar/org-roam-node-slug)
  (org-roam-db-autosync-mode))

(defun ar/delete-file ()
  (interactive)
  (let ((path (buffer-file-name)))
    (unless path
      (user-error "Buffer is not visiting any file"))
    (unless (file-exists-p path)
      (error "File doesn't exist: %s" path))
    (delete-file path t)
    (kill-current-buffer)))

(defun doom/yank-buffer-path (&optional root)
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or (buffer-file-name (buffer-base-buffer))
                        (bound-and-true-p list-buffers-directory)))
      (let ((path (abbreviate-file-name
                   (if root
                       (file-relative-name filename root)
                     filename))))
        (kill-new path)
        (if (string= path (car kill-ring))
            (message "Copied path: %s" path)
          (user-error "Couldn't copy filename in current buffer")))
    (error "Couldn't find filename in current buffer")))

(defun doom/yank-buffer-path-relative-to-project ()
  (interactive)
  (doom/yank-buffer-path (projectile-project-root)))

(defun doom/move-this-file (new-path &optional force-p)
  "Move current buffer's file to NEW-PATH.

If FORCE-P, overwrite the destination file if it exists, without confirmation."
  (interactive
   (list (read-file-name "Move file to: ")
         current-prefix-arg))
  (unless (and buffer-file-name (file-exists-p buffer-file-name))
    (user-error "Buffer is not visiting any file"))
  (let ((old-path (buffer-file-name (buffer-base-buffer)))
        (new-path (expand-file-name new-path)))
    (when (directory-name-p new-path)
      (setq new-path (concat new-path (file-name-nondirectory old-path))))
    (make-directory (file-name-directory new-path) 't)
    (rename-file old-path new-path (or force-p 1))
    (set-visited-file-name new-path t t)
    ;; (doom-files--update-refs old-path new-path)
    (message "File moved to %S" (abbreviate-file-name new-path))))

(use-package envrc
  :straight t
  :config
  (envrc-global-mode))

(setq compilation-ask-about-save nil
      compilation-scroll-output t)

;; https://emacs.stackexchange.com/questions/24698/ansi-escape-sequences-in-compilation-mode
(defun ar/colorize-compilation ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))
(add-hook 'compilation-filter-hook #'ar/colorize-compilation)

(defvar ar/compile-term nil)
(defvar ar/projectile-compile-commands (make-hash-table :test 'equal))

;; (defun ar/compile (&optional arg)
;;   (interactive "P")
;;   (let* ((command (eval compile-command))
;;          (command (if arg (compilation-read-command command) command))
;;          (default-directory (projectile-project-root)))
;;     ;; (when arg (setq ar/compile-term (not ar/compile-term)))
;;     (setq compile-command command)
;;     (when buffer-file-name (save-buffer))
;;     (compilation-start command ar/compile-term)))

;; (defun ar/compile (&optional arg)
;;   (interactive)
;;   (let* ((root (projectile-project-root))
;;          (command (gethash root ar/projectile-compile-commands))
;;          (command (compilation-read-command command))
;;          (default-directory root))
;;     (puthash root command ar/projectile-compile-commands)
;;     (when buffer-file-name (save-buffer))
;;     (compilation-start command ar/compile-term)))

;; (defun ar/expand-compile-command (command)
;;   (->> command
;;        (replace-regexp-in-string
;;         "\\(\\W\\|^\\)%F\\(\\W\\|$\\)"
;;         (concat "\\1" (regexp-quote (shell-quote-argument (or buffer-file-name "%F"))) "\\2"))
;;        (replace-regexp-in-string
;;         "\\(\\W\\|^\\)%L\\(\\W\\|$\\)"
;;         (concat "\\1" (number-to-string (line-number-at-pos)) "\\2"))))

(defun ar/expand-compile-command (command root)
  (if buffer-file-name
      (->> command
           (s-replace "%f" (shell-quote-argument (file-relative-name buffer-file-name)))
           (s-replace "%l" (concat
                            (shell-quote-argument (file-relative-name buffer-file-name))
                            ":"
                            (number-to-string (line-number-at-pos)))))
    command))

(defun ar/compile (&optional arg)
  (interactive)
  (let* ((root (projectile-project-root))
         (default-directory root)
         (command (gethash root ar/projectile-compile-commands))
         (command (compilation-read-command command))
         (command (ar/expand-compile-command command root))
         (compilation-buffer-name-function
          (lambda (mode) (projectile-compilation-buffer-name "compilation")))
         (mode (if (string-match-p "^erspec" command)
                   'rspec-compilation-mode
                 (if arg t 'compilation-mode))))
    (puthash root command ar/projectile-compile-commands)
    (when buffer-file-name (save-buffer))
    (compilation-start command mode)))

(defun ar/comint-stop ()
  (interactive)
  (comint-interrupt-subjob)
  (evil-force-normal-state))

(general-define-key
 :states '(insert)
 :keymaps '(comint-mode-map)
 "C-c C-c" #'ar/comint-stop)

(general-define-key
 :states '(normal motion)
 :keymaps '(comint-mode-map)
 "q" #'quit-window)

(general-define-key
 :states '(normal motion)
 ;; :keymaps '(prog-mode-map)
 "RET" #'ar/compile
 "] e" #'next-error
 "[ e" #'previous-error)

(general-define-key
 :states '(normal motion)
 :keymaps '(emacs-lisp-mode-map lisp-interaction-mode-map)
 "RET" #'eval-last-sexp)

(use-package undo-fu
  :straight t
  ;; :hook (doom-first-buffer . undo-fu-mode)
  :config
  ;; Increase undo history limits to reduce likelihood of data loss
  (setq undo-limit 400000           ; 400kb (default is 160kb)
        undo-strong-limit 3000000   ; 3mb   (default is 240kb)
        undo-outer-limit 48000000)  ; 48mb  (default is 24mb)
  )

(defvar ar/persp-prev "main")
(defvar ar/persp-binds `((1 . ,ar/persp-prev)))

(advice-add 'persp-activate
            :before
            (lambda (name &rest r)
              (setq ar/persp-prev (or persp-last-persp-name name)))
            '((name . "set-persp-prev")))

(defun ar/persp-switch-to-main ()
  (interactive)
  (persp-switch "main"))

(defun ar/persp-switch-back ()
  (interactive)
  (persp-switch ar/persp-prev))

(defun ar/persp-switch (number)
  (unless (active-minibuffer-window)
    (when-let ((name (alist-get number ar/persp-binds)))
      (persp-switch name)
      (message "[%d] %s" number name))))

(defun ar/persp-bind (number)
  (let ((name (safe-persp-name (get-current-persp))))
    (if-let ((entry (assoc number ar/persp-binds)))
        (setcdr entry name)
      (add-to-list 'ar/persp-binds (cons number name)))))

(defun ar/persp-kill ()
  (interactive)
  (let* ((persp (get-current-persp))
         (name (persp-name persp))
         (buf (cl-find-if (lambda (b)
                            (with-current-buffer b
                              (string-equal name (projectile-project-name))))
                          (persp-buffers persp)))
         (root (when buf (with-current-buffer buf (projectile-project-root)))))
    ;; (root (replace-regexp-in-string "/$" "" root)))
    (if (not name)
        (message "Can't kill main workspace")
      (ar/persp-switch-to-main)
      (persp-kill name)
      (setq ar/persp-binds
            (cl-remove-if (lambda (entry) (string-equal name (cdr entry)))
                          ar/persp-binds))
      (when root
        (mapc (lambda (b)
                (when (projectile-project-buffer-p b root)
                  (kill-buffer b)))
              (buffer-list))))))

(defun ar/persp-add-current-buffer (window)
  (or (not persp-mode)
      (persp-buffer-filtered-out-p
       (or (buffer-base-buffer (current-buffer))
           (current-buffer))
       persp-add-buffer-on-after-change-major-mode-filter-functions)
      (persp-add-buffer (current-buffer) (get-current-persp) nil nil)))

(defvar ar/persp-old-uniquify-style nil)

(defun ar/persp-disable-uniquify ()
  (cond (persp-mode
         ;; `uniquify' breaks persp-mode. It renames old buffers, which causes
         ;; errors when switching between perspective (their buffers are
         ;; serialized by name and persp-mode expects them to have the same
         ;; name when restored).
         (when uniquify-buffer-name-style
           (setq ar/persp-old-uniquify-style uniquify-buffer-name-style))
         (setq uniquify-buffer-name-style nil))
        (t
         (when ar/persp-old-uniquify-style
           (setq uniquify-buffer-name-style ar/persp-old-uniquify-style)))))

(use-package persp-mode
  :straight t
  :config
  (setq persp-auto-resume-time -1 ; Don't auto-load on startup
        persp-auto-save-opt 0 ; Don't auto-save
        persp-nil-hidden t
        ;; persp-nil-name ar/persp-prev
        persp-set-last-persp-for-new-frames t
        persp-autokill-buffer-on-remove 'kill-weak
        persp-kill-foreign-buffer-behaviour 'kill)

  (global-set-key (kbd "s-p") #'persp-switch)
  (global-set-key (kbd "s-,") #'ar/persp-switch-back)

  (general-def
    ;; :states '(normal visual motion)
    "s-1" (lambda () (interactive) (ar/persp-switch 1))
    "s-2" (lambda () (interactive) (ar/persp-switch 2))
    "s-3" (lambda () (interactive) (ar/persp-switch 3))
    "s-4" (lambda () (interactive) (ar/persp-switch 4))
    "s-5" (lambda () (interactive) (ar/persp-switch 5))
    "s-6" (lambda () (interactive) (ar/persp-switch 6))
    "s-7" (lambda () (interactive) (ar/persp-switch 7))
    "s-8" (lambda () (interactive) (ar/persp-switch 8))
    "s-9" (lambda () (interactive) (ar/persp-switch 9))
    "s-0" (lambda () (interactive) (ar/persp-switch 0))
    "C-s-1" (lambda () (interactive) (ar/persp-bind 1))
    "C-s-2" (lambda () (interactive) (ar/persp-bind 2))
    "C-s-3" (lambda () (interactive) (ar/persp-bind 3))
    "C-s-4" (lambda () (interactive) (ar/persp-bind 4))
    "C-s-5" (lambda () (interactive) (ar/persp-bind 5))
    "C-s-6" (lambda () (interactive) (ar/persp-bind 6))
    "C-s-7" (lambda () (interactive) (ar/persp-bind 7))
    "C-s-8" (lambda () (interactive) (ar/persp-bind 8))
    "C-s-9" (lambda () (interactive) (ar/persp-bind 9))
    "C-s-0" (lambda () (interactive) (ar/persp-bind 0)))
  ;; (dotimes (i 9)
  ;;   (let ((key (concat "s-" (number-to-string i))))
  ;;     (global-set-key (kbd key) (lambda () (interactive) (ar/persp-switch i)))
  ;;     (global-set-key (kbd (concat "C-" key)) (lambda () (interactive) (ar/persp-bind i)))))

  (ar/leader-def
    :states '(normal visual)
    :keymaps 'general-override-mode-map
    "TAB d" #'ar/persp-kill)

  (add-hook 'persp-mode-hook #'ar/persp-disable-uniquify)
  (add-hook 'window-buffer-change-functions #'ar/persp-add-current-buffer)

  ;; Running `persp-mode' multiple times resets the perspective list...
  (unless (equal persp-mode t)
    (persp-mode)
    (ar/persp-switch-to-main)))

(defvar ar/buffer-binds nil)

(defun ar/buffer-switch (number)
  (when-let ((persp (safe-persp-name (get-current-persp)))
             (binds (alist-get persp ar/buffer-binds))
             (buf (alist-get number binds)))
    (select-window
     (display-buffer buf '((display-buffer-reuse-window
                            display-buffer-same-window))))))

(defun ar/buffer-bind (number)
  (let ((persp (safe-persp-name (get-current-persp)))
        (buf (current-buffer)))
    (if-let ((binds (assoc persp ar/buffer-binds)))
      (if-let ((entry (assoc number binds)))
          (setcdr entry buf)
        (push (cons number buf) (cdr binds)))
      (push (cons persp (list (cons number buf))) ar/buffer-binds))))

(dotimes (i 9)
  (let ((n (number-to-string i)))
    (ar/leader-def
      :states '(normal visual motion)
      :keymaps 'general-override-mode-map
      (concat "" n) (lambda () (interactive) (ar/buffer-switch i))
      (concat "b " n) (lambda () (interactive) (ar/buffer-bind i)))))

(use-package yasnippet
  :straight t
  :config
  (add-to-list 'yas-snippet-dirs (expand-file-name "snippets" init-emacs-directory))
  (yas-global-mode)
  (general-def
    :keymaps 'yas-minor-mode-map
    :states 'insert
    "M-<tab>" #'yas-expand))

(use-package yasnippet-capf
  :straight t
  :config
  (setq yasnippet-capf--properties
    (list :annotation-function (lambda (_) " snippet")
          :company-kind (lambda (_) 'snippet)
          :company-doc-buffer #'yasnippet-capf--doc-buffer
          :exit-function (lambda (_ status)
                          (when (string= "finished" status)
                            (yas-expand)))
          :exclusive 'no))

  (defalias 'snippets-complete 'yasnippet-capf)

  (defun snippets-setup-capf ()
    (setq-local completion-at-point-functions
                (cons (cape-super-capf #'snippets-complete
                                       (car completion-at-point-functions))
                      (cdr completion-at-point-functions))))

  ;; (add-hook 'conf-mode-hook 'snippets-setup-capf)
  ;; (add-hook 'prog-mode-hook 'snippets-setup-capf)
  ;; (add-hook 'text-mode-hook 'snippets-setup-capf)
  )

(defun ar/switch-project-action ()
  (persp-switch (projectile-project-name))
  (magit-status))

(defun ar/project-buffer (name create-fn)
  (let* ((name (concat "*" (projectile-project-name) ":" name "*"))
         (buf (get-buffer name)))
    (if buf
        (switch-to-buffer buf)
      (funcall create-fn name))))

(use-package projectile
  :straight t
  :init
  (setq projectile-auto-discover nil
        projectile-track-known-projects-automatically nil
        projectile-enable-caching (not noninteractive)
        projectile-globally-ignored-files '(".DS_Store" "TAGS")
        projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
        projectile-kill-buffers-filter 'kill-only-files
        projectile-ignored-projects '("~/")
        projectile-git-use-fd nil
        projectile-git-submodule-command nil
        projectile-enable-caching nil
        projectile-indexing-method 'alien
        projectile-switch-project-action #'ar/switch-project-action)
  :config
  (cl-letf (((symbol-function 'projectile--cleanup-known-projects) #'ignore))
    (projectile-mode))

  (setq projectile-project-root-files-bottom-up
        '(".git")
        ;; This will be filled by other modules. We build this list manually so
        ;; projectile doesn't perform so many file checks every time it resolves
        ;; a project's root -- particularly when a file has no project.
        projectile-project-root-files '()
        projectile-project-root-files-top-down-recurring '("Makefile"))

  (defun ar/projectile-purge-root-cache ()
    (mapc
     (lambda (func)
       (remhash (format "%s-%s" func default-directory) projectile-project-root-cache))
     projectile-project-root-functions))

  ;; Per-project compilation buffers
  (setq compilation-buffer-name-function #'projectile-compilation-buffer-name
        compilation-save-buffers-predicate #'projectile-current-project-buffer-p))

(defun ar/magit-display-buffer (buffer)
  (let ((buffer-mode (buffer-local-value 'major-mode buffer)))
    (display-buffer
     buffer (if (bound-and-true-p git-commit-mode)
                (let ((size 0.75))
                  `(display-buffer-below-selected
                    . ((window-height . ,(truncate (* (window-height) size))))))
              '(display-buffer-same-window)))))

(use-package magit
  :straight t
  :hook (magit-process-mode . goto-address-mode)
  :hook (magit-mode . hide-mode-line-mode)
  :hook (magit-popup-mode . hide-mode-line-mode)
  :config
  (setq transient-default-level 5
        magit-display-buffer-function #'ar/magit-display-buffer
        magit-diff-refine-hunk t ; show granular diffs in selected hunk
        ;; Don't autosave repo buffers. This is too magical, and saving can
        ;; trigger a bunch of unwanted side-effects, like save hooks and
        ;; formatters. Trust the user to know what they're doing.
        magit-save-repository-buffers nil
        magit-diff-paint-whitespace-lines 'both
        ;; Don't display parent/related refs in commit buffers; they are rarely
        ;; helpful and only add to runtime costs.
        magit-revision-insert-related-refs nil
        magit-bury-buffer-function #'magit-mode-quit-window)
  ;; (add-hook 'magit-process-mode-hook #'goto-address-mode)
  ;; (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode)

  ;; (defun +magit/quit (&optional kill-buffer)
  ;;   "Bury the current magit buffer.

  ;; If KILL-BUFFER, kill this buffer instead of burying it.
  ;; If the buried/killed magit buffer was the last magit buffer open for this repo,
  ;; kill all magit buffers for this repo."
  ;;   (interactive "P")
  ;;   (let ((topdir (magit-toplevel)))
  ;;     (funcall magit-bury-buffer-function kill-buffer)
  ;;     (or (cl-find-if (lambda (win)
  ;;                       (with-selected-window win
  ;;                         (and (derived-mode-p 'magit-mode)
  ;;                             (equal magit--default-directory topdir))))
  ;;                     (window-list))
  ;;         (+magit/quit-all))))

  ;; (defun +magit--kill-buffer (buf)
  ;;   "TODO"
  ;;   (when (and (bufferp buf) (buffer-live-p buf))
  ;;     (let ((process (get-buffer-process buf)))
  ;;       (if (not (processp process))
  ;;           (kill-buffer buf)
  ;;         (with-current-buffer buf
  ;;           (if (process-live-p process)
  ;;               (run-with-timer 5 nil #'+magit--kill-buffer buf)
  ;;             (kill-process process)
  ;;             (kill-buffer buf)))))))

  ;; (defun +magit/quit-all ()
  ;;   "Kill all magit buffers for the current repository."
  ;;   (interactive)
  ;;   (mapc #'+magit--kill-buffer (magit-mode-get-buffers))
  ;;   (+magit-mark-stale-buffers-h))

  ;; (define-key magit-mode-map "q" #'+magit/quit)
  ;; (define-key magit-mode-map "Q" #'+magit/quit-all)

  ;; Close transient with ESC
  (define-key transient-map [escape] #'transient-quit-one)

  (evil-define-key* 'normal magit-status-mode-map [escape] nil)

  ;;(straight-use-package 'evil-collection-magit)
  ;; (require 'evil-collection-magit)
  ;; (evil-collection-magit-setup)
  ;; (require 'evil-collection-magit-section)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'magit-mode-map
   ;; "q" #'+magit/quit
   ;; "Q" #'+magit/quit-all
   "]" #'magit-section-forward-sibling
   "[" #'magit-section-backward-sibling
   "g r" #'magit-refresh
   "g R" #'magit-refresh-all)

  (general-define-key
   :states '(normal visual)
   :keymaps '(magit-blame-mode-map
              magit-blame-read-only-mode-map)
   "RET" #'magit-show-commit)

  (general-define-key
   :states '(normal motion)
   :keymaps '(smerge-mode-map)
   "] c" #'smerge-next
   "[ c" #'smerge-prev
   "g m u" #'smerge-keep-upper
   "g m l" #'smerge-keep-lower)
  ;; (general-def 'normal emacs-lisp-mode-map
  ;;   "K" 'elisp-slime-nav-describe-elisp-thing-at-point)

  ;; (map! (:map magit-mode-map
  ;;         :nv "q" #'+magit/quit
  ;;         :nv "Q" #'+magit/quit-all
  ;;         :nv "]" #'magit-section-forward-sibling
  ;;         :nv "[" #'magit-section-backward-sibling
  ;;         :nv "gr" #'magit-refresh
  ;;         :nv "gR" #'magit-refresh-all)
  ;;       (:map magit-status-mode-map
  ;;         :nv "gz" #'magit-refresh)
  ;;       (:map magit-diff-mode-map
  ;;         :nv "gd" #'magit-jump-to-diffstat-or-diff))
  )

(use-package drag-stuff
  :straight t
  :config
  (general-define-key
   :states '(normal)
   "M-k" #'drag-stuff-up
   "M-j" #'drag-stuff-down))

(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

(add-to-list 'auto-mode-alist (cons "\\.keymap\\'" #'c-mode))

(use-package dockerfile-mode
  :straight t)

;; (use-package clojure-mode
;;   :straight t)

(use-package web-mode
  :straight t
  :mode "\\.html\\'"
  :mode "\\.erb\\'"
  ;; :hook (web-mode . smartparens-mode)
  :preface
  (setq web-mode-part-padding 2)
  :config
  (setq-default web-mode-css-indent-offset 2
                web-mode-code-indent-offset 2))

(general-define-key
  :states '(normal motion)
  :keymaps '(web-mode-map)
  "[ t" #'web-mode-element-beginning
  "] t" #'web-mode-element-end
  "[ m" #'web-mode-element-previous
  "] m" #'web-mode-element-next)

(general-define-key
  :states '(visual)
  :keymaps '(web-mode-map)
  "g w" #'web-mode-element-wrap)

(ar/local-leader-def
  :states '(normal motion)
  :keymaps '(web-mode-map)
  "t" #'web-mode-navigate)

(setq js-chain-indent t
      js-indent-level tab-width)

;; (pushnew! projectile-project-root-files "package.json")
;; (pushnew! projectile-globally-ignored-directories "^node_modules$" "^flow-typed$"))
;; (use-package js2-mode
;;   :straight t
;;   :mode "\\.js\\'"
;;   :hook ((js2-mode . javascript-ts-mode);;tree-sitter-hl-mode)
;;          (js2-mode . rainbow-delimiters-mode)
;;          (js2-mode . smartparens-mode)
;;          (js2-mode . lsp-deferred))
;;   :config
;;   (setq js-chain-indent t
;;         js2-basic-offset tab-width
;;         js2-skip-preprocessor-directives t
;;         js2-mode-show-parse-errors nil
;;         js2-mode-show-strict-warnings nil
;;         js2-strict-missing-semi-warning nil
;;         js2-highlight-level 3
;;         js2-idle-timer-delay 0.15))

;; (use-package typescript-mode
;;   :straight t
;;   :hook ((typescript-mode . typescript-ts-mode);;tree-sitter-hl-mode)
;;          (typescript-mode . rainbow-delimiters-mode)
;;          (typescript-mode . smartparens-mode)
;;          (typescript-mode . lsp-deferred))
;;   :config
;;   (setq typescript-indent-level 2)
;;   ;; :init
;;   ;; (add-to-list 'auto-mode-alist
;;   ;;              (cons "\\.tsx\\'" #'typescript-tsx-mode))
;;   )



;; (use-package rjsx-mode
;;   :straight t
;;   :config
;;   (setq js-chain-indent t
;;         ;; These have become standard in the JS community
;;         js2-basic-offset 2
;;         ;; Don't mishighlight shebang lines
;;         js2-skip-preprocessor-directives t
;;         ;; let flycheck handle this
;;         js2-mode-show-parse-errors nil
;;         js2-mode-show-strict-warnings nil
;;         ;; Flycheck provides these features, so disable them: conflicting with
;;         ;; the eslint settings.
;;         js2-strict-missing-semi-warning nil
;;         ;; maximum fontification
;;         js2-highlight-level 3
;;         js2-idle-timer-delay 0.15)
;;   )

(use-package yaml-mode
  :straight t
  :mode "\\.yaml\\'")

;; (add-hook 'ruby-ts-mode #'rainbow-delimiters-mode)
;; (add-hook 'ruby-ts-mode #'smartparens-mode)
;; (add-hook 'ruby-ts-mode #'lsp-deferred)

;; (use-package ruby-mode
;;   :hook ((ruby-mode . smartparens-mode)
;;          (ruby-mode . lsp-deferred)))
;; (add-hook 'ruby-mode-hook sp-max-pair-length 6)

;; (use-package rubocop
;;   :straight t
;;   :hook (ruby-mode . rubocop-mode))
;; (add-hook 'compilation-filter-hook #'inf-ruby-auto-enter)

(defvar ar/rspec-file nil)
(defvar ar/rspec-enter-enabled nil)

(defun ar/rspec-enter-toggle ()
  (interactive)
  (setq-local ar/rspec-enter-enabled (not ar/rspec-enter-enabled)))


(defun ar/rspec-run (&optional single)
  (interactive "P")
  (save-buffer)
  (let ((file (buffer-file-name)))
    (setq ar/rspec-file
          (if (rspec-spec-file-p file)
              (if single
                  (cons file
                        (save-restriction
                          (widen)
                          (number-to-string (line-number-at-pos))))
                file)
            (or ar/rspec-file (rspec-spec-file-for file))))
    (if ar/rspec-file
        (rspec-run-single-file ar/rspec-file (rspec-core-options))
      (message "No spec file"))))

(defun ar/ruby-enter (&optional single)
  (interactive "P")
  (save-buffer)
  (if ar/rspec-enter-enabled
      (ar/rspec-run single)
    (ar/compile single)))

(use-package rspec-mode
  :straight t
  :config
  (setq rspec-use-bundler-when-possible nil
        rspec-use-spring-when-possible nil
        ;; rspec-spec-command "direnv exec . rspec"
        rspec-command-options (concat "--require "
                                      init-emacs-directory
                                      "/rspec_formatter.rb --format EmacsRspecFormatter")
        rspec-use-relative-path t))

(use-package slim-mode
  :straight t
  :config
  (setq slim-indent-offset 2))

(general-define-key
  :states '(normal motion)
  :keymaps 'ruby-base-mode-map
  "[ t" (lambda () (interactive) (ruby-move-to-block -1))
  "] t" (lambda () (interactive) (ruby-move-to-block 1)))

(ar/local-leader-def
  :states '(normal motion)
  :keymaps 'ruby-base-mode-map
  "'" #'ruby-toggle-string-quotes)

;; (general-define-key
;;   :states '(normal)
;;   :keymaps 'rspec-verifiable-mode-map
;;   "RET" #'ar/ruby-enter)

;; (general-define-key
;;   :states '(normal)
;;   :keymaps 'rspec-mode-map
;;   "RET" #'ar/rspec-run)

(ar/local-leader-def
  :states '(normal motion)
  :keymaps '(rspec-verifiable-mode-map rspec-mode-map)
  "t b" #'ar/rspec-enter-toggle
  "t t" #'rspec-toggle-spec-and-target)

(use-package realgud
  :straight t
  :config
  (setq realgud-safe-mode nil
        realgud-populate-common-fn-keys-function nil)

  ;; always use current window
  (defun realgud-window-src (&optional opt-buffer)
    (let* ((buffer (or opt-buffer (current-buffer)))
           (src-buffer (realgud-get-srcbuf buffer))
           (window (selected-window)))
      (set-window-buffer window src-buffer)))

  ;; disable stay-in-cmdbuf? and shortkey-mode?
  (defun realgud-track-loc-action (loc cmdbuf &optional not-selected-frame shortkey-on-tracing?)
    (if (realgud-loc? loc)
        (let* ((cmdbuf-loc-hist (realgud-cmdbuf-loc-hist cmdbuf))
               (cmdbuf-local-overlay-arrow?
                (with-current-buffer cmdbuf
                  (local-variable-p 'overlay-arrow-variable-list)))
               (stay-in-cmdbuf? nil)
               ;; (with-current-buffer cmdbuf
               ;;   (not (realgud-sget 'cmdbuf-info 'in-srcbuf?))))
               (shortkey-mode? nil)
               ;; (with-current-buffer cmdbuf
               ;;   (realgud-sget 'cmdbuf-info 'src-shortkey?)))
               (srcbuf)
               (srcbuf-loc-hist))
          (setq srcbuf (realgud-loc-goto loc))
          (realgud-srcbuf-init-or-update srcbuf cmdbuf)
          (setq srcbuf-loc-hist (realgud-srcbuf-loc-hist srcbuf))
          (realgud-cmdbuf-add-srcbuf srcbuf cmdbuf)

          ;; (with-current-buffer srcbuf
          ;;   (realgud-short-key-mode-setup
          ;;    (and shortkey-on-tracing?
          ;;         (or realgud-short-key-on-tracing? shortkey-mode?))))

          ;; Do we need to go back to the process/command buffer because other
          ;; output-filter hooks run after this may assume they are in that
          ;; buffer? If so, we may have to use set-buffer rather than
          ;; switch-to-buffer in some cases.
          (set-buffer cmdbuf)

          (unless (realgud-sget 'cmdbuf-info 'no-record?)
            (realgud-loc-hist-add srcbuf-loc-hist loc)
            (realgud-loc-hist-add cmdbuf-loc-hist loc)
            (realgud-fringe-history-set cmdbuf-loc-hist cmdbuf-local-overlay-arrow?))

          ;; FIXME turn into fn. combine with realgud-track-hist-fn-internal
          (if stay-in-cmdbuf?
              (let ((cmd-window (realgud-window-src-undisturb-cmd srcbuf)))
                (with-current-buffer srcbuf
                  (if (and (boundp 'realgud-overlay-arrow1)
                           (markerp realgud-overlay-arrow1))
                      (realgud-window-update-position srcbuf realgud-overlay-arrow1)))
                (when cmd-window (select-window cmd-window)))
            (with-current-buffer srcbuf
              (realgud-window-src srcbuf)
              (realgud-window-update-position srcbuf realgud-overlay-arrow1))
            ;; reset 'in-srcbuf' to allow the command buffer to keep point focus
            ;; when used directly. 'in-srcbuf' is set 't' early in the stack
            ;; (prior to common command code, e.g. this) when any command is run
            ;; from a source buffer
            (with-current-buffer cmdbuf
              (realgud-cmdbuf-info-in-srcbuf?= nil)))))
    (with-current-buffer-safe (realgud-get-cmdbuf)
                              (run-hooks 'realgud-update-hook)))

  ;; don't switch to realgud buffer
  (defun realgud:run-process(debugger-name script-filename cmd-args minibuffer-history &optional no-reset)
    (let ((cmd-buf))
      (setq cmd-buf (apply 'realgud-exec-shell debugger-name script-filename
                           (car cmd-args) no-reset (cdr cmd-args)))
      ;; FIXME: Is there probably is a way to remove the
      ;; below test and combine in condition-case?
      (let ((process (get-buffer-process cmd-buf)))
        (if (and process (eq 'run (process-status process)))
            (with-current-buffer cmd-buf
                                        ;(switch-to-buffer cmd-buf)
              (realgud:track-set-debugger debugger-name)
              (realgud-cmdbuf-info-in-debugger?= 't)
              (realgud-cmdbuf-info-cmd-args= cmd-args)
              (when realgud-cmdbuf-info
                (let* ((info realgud-cmdbuf-info)
                       (cmd-args (realgud-cmdbuf-info-cmd-args info))
                       (cmd-str  (mapconcat 'identity  cmd-args " ")))
                  (if (boundp 'starting-directory)
                      (realgud-cmdbuf-info-starting-directory= starting-directory))
                  (set minibuffer-history
                       (cl-remove-duplicates
                        (cons cmd-str (eval minibuffer-history)) :from-end)))))
          (progn
            (when cmd-buf (switch-to-buffer cmd-buf))
            (message "Error running command: %s" (mapconcat 'identity cmd-args " ")))))
      cmd-buf))

  (general-define-key
   :states '(normal)
   :keymaps '(prog-mode-map)
   "SPC d b" 'realgud:cmd-break
   "SPC d B" 'realgud:cmd-delete
   "SPC d u" 'realgud:cmd-older-frame
   "SPC d d" 'realgud:cmd-newer-frame
   "SPC d e" 'ar/realgud-eval
   "SPC d i" 'realgud:cmd-step
   "SPC d o" 'realgud:cmd-finish
   "SPC d n" 'realgud:cmd-next
   "SPC d l" (lambda ()
               (interactive)
               (when-let ((buf (realgud-get-cmdbuf)))
                 (switch-to-buffer buf)))
   "SPC d c" 'realgud:cmd-continue))

(use-package realgud-byebug
  :straight t
  :config
  ;; fix regexp and skip kill confirmation
  (defun realgud:byebug-reset ()
    (interactive)
    (let ((kill-buffer-query-functions nil))
      (dolist (buffer (buffer-list))
        (when (string-match "\\*byebug .+\\*" (buffer-name buffer))
          (kill-buffer buffer)))))

  (general-define-key
   :states '(normal)
   :keymaps '(ruby-base-mode-map)
   "SPC d a" (lambda ()
               (interactive)
               (let ((default-directory (projectile-project-root))
                     (port (or (getenv "BYEBUG_PORT") "8989")))
                 (save-excursion (realgud:byebug (concat "byebug -R " port)))))
   "SPC d A" 'realgud:byebug-reset))

(add-hook 'rust-ts-mode-hook (lambda () (setq-local tab-width 4)))

(defvar rustc-compilation-location
  (let ((file "\\([^\n]+\\)")
        (start-line "\\([0-9]+\\)")
        (start-col "\\([0-9]+\\)"))
    (concat "\\(" file ":" start-line ":" start-col "\\)")))

(defvar rustc-compilation-regexps
  (let ((re (concat "^\\(?:error\\|\\(warning\\)\\|\\(note\\)\\)[^\0]+?--> "
                    rustc-compilation-location)))
    (cons re '(4 5 6 (1 . 2) 3)))
  "Specifications for matching errors in rustc invocations.
See `compilation-error-regexp-alist' for help on their format.")

(defvar rustc-colon-compilation-regexps
  (let ((re (concat "^ *::: " rustc-compilation-location)))
    (cons re '(2 3 4 0 1)))
  "Specifications for matching `:::` hints in rustc invocations.
See `compilation-error-regexp-alist' for help on their format.")

(defvar rustc-refs-compilation-regexps
  (let ((re "^\\([0-9]+\\)[[:space:]]*|"))
    (cons re '(nil 1 nil 0 1)))
  "Specifications for matching code references in rustc invocations.
See `compilation-error-regexp-alist' for help on their format.")

;; Match test run failures and panics during compilation as
;; compilation warnings
(defvar cargo-compilation-regexps
  '("', \\(\\([^:]+\\):\\([0-9]+\\)\\)"
    2 3 nil nil 1)
  "Specifications for matching panics in cargo test invocations.
See `compilation-error-regexp-alist' for help on their format.")

(defun rustc-scroll-down-after-next-error ()
  "In the new style error messages, the regular expression
matches on the file name (which appears after `-->`), but the
start of the error appears a few lines earlier.  This hook runs
after `next-error' (\\[next-error]); it simply scrolls down a few lines in
the compilation window until the top of the error is visible."
  (save-selected-window
    (when (eq major-mode 'rust-ts-mode)
      (select-window (get-buffer-window next-error-last-buffer 'visible))
      (when (save-excursion
              (beginning-of-line)
              (looking-at " *-->"))
        (let ((start-of-error
               (save-excursion
                 (beginning-of-line)
                 (while (not (looking-at "^[a-z]+:\\|^[a-z]+\\[E[0-9]+\\]:"))
                   (forward-line -1))
                 (point))))
          (set-window-start (selected-window) start-of-error))))))

(add-to-list 'compilation-error-regexp-alist-alist
            (cons 'rustc-refs rustc-refs-compilation-regexps))
(add-to-list 'compilation-error-regexp-alist 'rustc-refs)
(add-to-list 'compilation-error-regexp-alist-alist
            (cons 'rustc rustc-compilation-regexps))
(add-to-list 'compilation-error-regexp-alist 'rustc)
(add-to-list 'compilation-error-regexp-alist-alist
            (cons 'rustc-colon rustc-colon-compilation-regexps))
(add-to-list 'compilation-error-regexp-alist 'rustc-colon)
(add-to-list 'compilation-error-regexp-alist-alist
            (cons 'cargo cargo-compilation-regexps))
(add-to-list 'compilation-error-regexp-alist 'cargo)
(add-hook 'next-error-hook #'rustc-scroll-down-after-next-error)
;; (use-package rust-mode
;;   :straight t)
;;   :mode "\\.rs$"
;;   :hook ((rust-mode . rust-ts-mode);;tree-sitter-hl-mode)
;;          (rust-mode . rainbow-delimiters-mode)
;;          (rust-mode . smartparens-mode)
;;          (rust-mode . lsp-deferred))
;;   :config
;;   (setq rust-prettify-symbols-alist nil))
;; (use-package rustic
;;   :straight t
;;   :mode "\\.rs$"
;;   :hook ((rustic-mode . rainbow-delimiters-mode)
;;          (rustic-mode . lsp-deferred))
;;   :preface
;;   ;; HACK `rustic' sets up some things too early. I'd rather disable it and let
;;   ;;   our respective modules standardize how they're initialized.
;;   (setq rustic-lsp-client nil)
;;   (with-eval-after-load 'rustic-lsp
;;     (remove-hook 'rustic-mode-hook 'rustic-setup-lsp))
;;   (with-eval-after-load 'rustic-flycheck
;;     (remove-hook 'rustic-mode-hook #'flycheck-mode)
;;     (remove-hook 'rustic-mode-hook #'flymake-mode-off)
;;     (remove-hook 'flycheck-mode-hook #'rustic-flycheck-setup))
;;   :config
;;   (setq rust-prettify-symbols-alist nil)
;;   (setq rustic-lsp-client 'lsp-mode)
;;   ;; (add-hook 'rustic-mode-local-vars-hook #'rustic-setup-lsp 'append)
;;   )

(use-package swift-mode
  :straight t)
  ;; :hook (swift-mode . smartparens-mode))

(use-package consult
  :straight t
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

(general-def
  :keymaps 'prog-mode-map
  :states 'normal
  "g o" #'xref-find-definitions-other-window
  "g i" #'xref-find-references)
)

(defun ar/search-for-identifier-at-point ()
  (interactive)
  (consult-ripgrep projectile-project-root
                   (xref-backend-identifier-at-point (xref-find-backend))))

(defun ar/jump-to-same-indent (direction)
  (interactive "P")
  (let ((start-indent (current-indentation)))
    (while
        (and (not (bobp))
             (zerop (forward-line (or direction 1)))
             (or (= (current-indentation) 0)
                 (> (current-indentation) start-indent)))))
  (back-to-indentation))

(general-define-key
 :states '(normal motion)
 :keymaps 'prog-mode-map
 "g d" #'xref-find-definitions
 "g i" #'ar/search-for-identifier-at-point
 "g o" #'xref-find-definitions-other-window
 "[ i" (lambda () (interactive) (ar/jump-to-same-indent -1))
 "] i" #'ar/jump-to-same-indent)

(defun ar/vertico-select-other-window ()
  (interactive)
  (let* ((selected-item (vertico--candidate))
         (parts (s-split ":" selected-item)))
    (when selected-item
      (find-file-other-window (car parts))
      (goto-line (string-to-number (cadr parts))))))

;; (straight-use-package 'corfu-terminal)
;; (straight-use-package 'wgrep)
(use-package vertico
  :straight t
  :init
  (add-to-list 'load-path
               (expand-file-name "straight/build/vertico/extensions"
                                 straight-base-dir))
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  ;; (require 'vertico-directory)

  (setq-default completion-in-region-function
                (lambda (&rest args)
                  (apply (if vertico-mode
                             #'consult-completion-in-region
                           #'completion--in-region)
                         args)))

  (general-def
   :keymaps 'vertico-map
   :states '(normal insert)
   "C-n" #'vertico-next
   "C-p" #'vertico-previous
   "C-o" #'ar/vertico-select-other-window
   "C-s-n" #'vertico-next-group
   "C-s-p" #'vertico-previous-group)

  (vertico-mode))

(use-package vertico-posframe
  :straight t
  :init
  (setq vertico-posframe-border-width 1
        vertico-posframe-parameters '((left-fringe . 5)
                                      (right-fringe . 5)))
  :config
  (vertico-posframe-mode))

(use-package marginalia
  :straight t
  :config
  (setq marginalia-annotators '(marginalia-annotators-heavy
                                marginalia-annotators-light nil))

  (marginalia-mode 1))

(use-package orderless
  :straight t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides nil))

;; (use-package fussy
;;   :straight t
;;   :config
;;   (setq fussy-filter-fn #'fussy-filter-default
;;         fussy-max-candidate-limit 5000
;;         completion-styles '(fussy basic)
;;         completion-category-defaults nil
;;         completion-category-overrides nil))

;; (use-package hotfuzz
;;   :straight t
;;   :config
;;   (setq completion-styles '(hotfuzz)
;;         completion-category-defaults nil
;;         completion-category-overrides nil))

;; (use-package fzf-native
;;   :straight
;;   (:repo "dangduc/fzf-native"
;;    :host github
;;    :files (:defaults "*.c" "*.h" "*.txt"))
;;   :init
;;   (setq fzf-native-always-compile-module t)
;;   :config
;;   (setq fussy-score-fn 'fussy-fzf-native-score)
;;   (fzf-native-load-own-build-dyn))

(use-package embark
  :straight t
  :config
  ;; Use Embark to show bindings in a key prefix with `C-h`
  (setq prefix-help-command #'embark-prefix-help-command)

  (global-set-key [remap describe-bindings] #'embark-bindings)
  ;; (global-set-key (kbd "C-.") 'embark-act)
  )

(use-package embark-consult
  :straight t
  :config
  ;; (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  (general-define-key
   :keymaps '(minibuffer-local-map minibuffer-mode-map)
   ;; "C-o" #'find-file-other-window
   "C-c C-e" #'embark-export))

(defun ar/set-basic-completion ()
  (setq-local completion-styles '(basic)))

(use-package corfu
  :straight t
  :hook (corfu-mode . ar/set-basic-completion)
  :hook (prog-mode . corfu-mode)
  :hook (org-mode . corfu-mode)
  ;; :init
  ;; (add-to-list 'load-path
  ;;              (expand-file-name "straight/build/corfu/extensions"
  ;;                                straight-base-dir))
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :init
  (setq corfu-cycle t ;; Allows cycling through candidates
        corfu-auto nil ;; Enable auto completion
        corfu-auto-prefix 1 ;; Complete with less prefix keys
        corfu-auto-delay 0 ;; No delay for completion
        ;;corfu-quit-at-boundary nil
        ;; corfu-preview-current nil
        ;; corfu-preselect 'first
        corfu-preview-current 'insert
        corfu-preselect 'prompt
        corfu-popupinfo-delay 0.1
        corfu-popupinfo-hide nil
        corfu-echo-documentation 0.1) ;; Echo docs for current completion option
  ;; (global-corfu-mode)
  :config
  (cl-defgeneric corfu--popup-show (pos off width lines &optional curr lo bar)
    "Show LINES as popup at POS - OFF.
WIDTH is the width of the popup.
The current candidate CURR is highlighted.
A scroll bar is displayed from LO to LO+BAR."
    (let ((lh (default-line-height)))
      (with-current-buffer (corfu--make-buffer " *corfu*")
        (let* ((ch (default-line-height))
               (cw (default-font-width))
               (ml (ceiling (* cw corfu-left-margin-width)))
               (mr (ceiling (* cw corfu-right-margin-width)))
               (bw (ceiling (min mr (* cw corfu-bar-width))))
               (marginl (and (> ml 0) (propertize " " 'display `(space :width (,ml)))))
               (marginr (and (> mr 0) (propertize " " 'display `(space :align-to right))))
               (sbar (when (> bw 0)
                       (concat (propertize " " 'display `(space :align-to (- right (,mr))))
                               (propertize " " 'display `(space :width (,(- mr bw))))
                               (propertize " " 'face 'corfu-bar 'display `(space :width (,bw))))))
               (pos-obj (posn-object-x-y pos))
               (pos (posn-x-y pos))
               (pos-x (- (or (car pos) 0) (or (car pos-obj) 0)))
               (pos-y (- (or (cdr pos) 0) (or (cdr pos-obj) 0)))
               (width (+ (* width cw) ml mr))
               ;; XXX HACK: Minimum popup height must be at least 1 line of the
               ;; parent frame (#261).
               (height (max lh (* (length lines) ch)))
               (edge (window-inside-pixel-edges))
               (border (alist-get 'child-frame-border-width corfu--frame-parameters))
               (x (max 0 (min (+ (car edge) (- pos-x ml (* cw off) border))
                              (- (frame-pixel-width) width))))
               (yb (+ (cadr edge) (window-tab-line-height) pos-y lh))
               (y (if (> (+ yb (* corfu-count ch) lh lh) (frame-pixel-height))
                      (- yb height lh border border)
                    yb))
               (row 0))
          (with-silent-modifications
            (erase-buffer)
            (insert (mapconcat (lambda (line)
                                 (let ((str (concat marginl line
                                                    (if (and lo (<= lo row (+ lo bar)))
                                                        sbar
                                                      marginr))))
                                   (when (eq row curr)
                                     (add-face-text-property
                                      0 (length str) 'corfu-current 'append str))
                                   (cl-incf row)
                                   str))
                               lines "\n"))
            (goto-char (point-min)))
          (setq corfu--frame (corfu--make-frame corfu--frame x y
                                                width height (current-buffer)))))))

  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode)

  (general-def
    :states 'insert
    :keymaps 'corfu-map
    [escape] #'corfu-quit)

  (general-def
   :keymaps 'corfu-popupinfo-map
   "C-s-p" #'corfu-popupinfo-scroll-down
   "C-s-n" #'corfu-popupinfo-scroll-up))

(use-package kind-icon
  :straight t
  :after corfu
  :config
  (setq kind-icon-default-face 'corfu-default
        kind-icon-blend-background nil)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; (setq-local completion-styles '(basic))
;; (kill-local-variable 'completion-styles)
;; (setq completion-styles '(basic))
;; (orderless basic)

;; (define-key corfu-map (kbd "TAB") #'corfu-next)
;; (define-key corfu-map [tab] #'corfu-next)

(use-package cape
  :straight t
  :config
  (setq cape-dabbrev-min-length 1
        cape-dabbrev-check-other-buffers 'some
        dabbrev-case-replace nil
        dabbrev-case-fold-search nil
        cape--dabbrev-properties (list :annotation-function (lambda (_) " code")
                                       :company-kind (lambda (_) 'text)
                                       :exclusive 'no))


  ;; Add useful defaults completion sources from cape

  (setq completion-at-point-functions (list (cape-super-capf #'cape-dabbrev #'cape-file)))
  ;; (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  (defun ar/elisp-mode-setup-completion ()
    (setq-local completion-at-point-functions
                `(,(cape-super-capf
                    #'snippets-complete
                    #'elisp-completion-at-point
                    #'cape-dabbrev)
                  cape-file)))
  (add-hook 'emacs-lisp-mode-hook #'ar/elisp-mode-setup-completion)

  ;; Silence the pcomplete capf, no errors or messages!
  ;; Important for corfu
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

  ;; Ensure that pcomplete does not write to the buffer
  ;; and behaves as a pure `completion-at-point-function'.
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)

(defvar cape-super-max-results-per-source nil)

(defun cape-wrap-super (&rest capfs)
  "Call CAPFS and return merged completion result.
The functions `cape-wrap-super' and `cape-capf-super' are experimental."
  (when-let ((results (delq nil (mapcar #'funcall capfs))))
    (pcase-let* ((`((,beg ,end . ,_)) results)
                 (cand-ht (make-hash-table :test #'equal))
                 (tables nil)
                 (last-try-plist nil)
                 (prefix-len nil))
      (cl-loop for (beg2 end2 . rest) in results do
;; CHANGE: use the longest beg/end range
               (when (< beg2 beg) (setq beg beg2))
               (when (> end2 end) (setq end end2))
               (push rest tables)
               (let ((plen (plist-get (cdr rest) :company-prefix-length)))
                 (cond
                  ((eq plen t)
                   (setq prefix-len t))
                  ((and (not prefix-len) (integerp plen))
                   (setq prefix-len plen))
                  ((and (integerp prefix-len) (integerp plen))
                   (setq prefix-len (max prefix-len plen))))))
      (setq tables (nreverse tables))
      (setq last-try-plist nil)
      `(,beg ,end
        ,(lambda (str pred action)
           (pcase action
             (`(boundaries . ,_) nil)
             ('metadata
              '(metadata (category . cape-super)
                         (display-sort-function . identity)
                         (cycle-sort-function . identity)))
             ('t ;; all-completions
              (let ((ht (make-hash-table :test #'equal))
                    (candidates nil))
                (cl-loop for (table . plist) in tables do
                         (let* ((pr (if-let (pr (plist-get plist :predicate))
                                        (if pred
                                            (lambda (x) (and (funcall pr x) (funcall pred x)))
                                          pr)
                                      pred))
                                (md (completion-metadata "" table pr))
                                (sort (or (completion-metadata-get md 'display-sort-function)
                                          #'identity))
                                (cands (funcall sort (all-completions str table pr)))
;; CHANGE: limit number of candidates from each source
                                (cands (if cape-super-max-results-per-source
                                           (take cape-super-max-results-per-source cands)
                                         cands)))
                           (cl-loop for cell on cands
                                    for cand = (car cell) do
                                    (if (eq (gethash cand ht t) t)
                                        (puthash cand plist ht)
                                      (setcar cell nil)))
                           (push cands candidates)))
                (setq cand-ht ht)
                (delq nil (apply #'nconc (nreverse candidates)))))
             (_ ;; try-completion and test-completion
;; CHANGE: check all sources before returning t (single match)
              (let* ((res (cl-loop
                           for (table . plist) in tables collect
                           (let ((res (complete-with-action
                                       action table str
                                       (if-let (pr (plist-get plist :predicate))
                                           (if pred
                                               (lambda (x) (and (funcall pr x) (funcall pred x)))
                                             pr)
                                         pred))))
                             (when res (setq last-try-plist plist)) ;; TODO: use cand-ht instead?
                             res)))
                     (res (delq nil res))
                     (len (length res)))
                (cond
                 ;; only one source returned a result - just forward it
                 ((= len 1) (car res))
                 ;; all sources returned the same result
                 ((cl-loop for i in res always (equal i (car res)))
                  ;; if all t then there are several exact matches - return str
                  (if (eq (car res) t) str (car res)))
                 ;; several sources returned different prefixes - choose the longest common
                 ;; need to replace t (exact matches) with str before
                 ((> len 1) (try-completion str (cons str (delq t res))))
                 (t nil))))))
        :exclusive no
        :company-prefix-length ,prefix-len
        ,@(mapcan
           (lambda (prop)
             (list prop (lambda (cand &rest args)
;; CHANGE: cand-ht is empty in case of single match so we save last-try-plist
                          (when-let* ((plist (or (gethash cand cand-ht) last-try-plist))
                                      (fun (plist-get plist prop)))
                            (apply fun cand args)))))
           '(:company-docsig :company-location :company-kind
                             :company-doc-buffer :company-deprecated
                             :annotation-function :exit-function))))))
;;(advice-add #'cape-wrap-super :override #'ar/cape-wrap-super)
)

;; (defun ar/indent-or-complete ()
;;   (interactive)
;;   (unless (yas-expand)
;;     (if (< (current-column) (current-indentation))
;;         (funcall indent-line-function)
;;       (let ((syn (syntax-after (- (point) 1))))
;;         (if (or (eq (point) (line-beginning-position))
;;                 (member 0 syn))
;;             (insert-tab)
;;           (completion-at-point))))))

(defun ar/indent-or-complete ()
  (interactive)
  (if (< (current-column) (current-indentation))
      (funcall indent-line-function)
    (let ((syn (syntax-after (- (point) 1))))
      (if (or (eq (point) (line-beginning-position))
              (equal 0 (car syn)))
          (insert-tab)
        ;; only complete for 2 or 3 syntax?
        (completion-at-point)))))

(general-def
 :states 'insert
 "TAB" #'ar/indent-or-complete)
;;  "C-p" #'completion-at-point)

(general-def
 :keymaps 'vertico-map
 :states 'insert
 "TAB" #'vertico-insert)
;; (general-define-key
;;  :keymaps 'minibuffer-local-map
;;  :states 'insert
;;  "TAB" #'vertico-insert)

(use-package dumb-jump
  :straight t
  :config
  (setq dumb-jump-prefer-searcher 'rg
        dumb-jump-aggressive nil)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(setq lsp-use-plists t)

(use-package lsp-mode
  :straight t
  :hook (prog-mode . lsp-deferred)
  :hook (lsp-completion-mode . ar/lsp)
  :init
  (setq lsp-keymap-prefix nil);;"C-s-l")
  :config
  ;; Make breadcrumbs opt-in; they're redundant with the modeline and imenu
  (setq lsp-headerline-breadcrumb-enable nil)

  (setq lsp-response-timeout 0.5)

  (setq lsp-lens-enable nil)
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-enable-snippet t)
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-warn-no-matched-clients nil)
  (setq lsp-enable-suggest-server-download nil)

  (setq lsp-signature-function 'lsp-signature-posframe ;;'ignore)
        lsp-signature-render-documentation nil
        lsp-signature-posframe-params
        (list :poshandler #'posframe-poshandler-point-bottom-left-corner-upward
              :left-fringe 5
              :right-fringe 5
              :border-width 1))

  (defface lsp-posframe '((t :inherit tooltip)) "LSP posframe")
  (defface lsp-posframe-border '((t :inherit tooltip)) "LSP posframe border")

  (defun lsp-signature-posframe (str)
    "Use posframe to show the STR signatureHelp string."
    (if str
        (let ((fit-frame-to-buffer-margins (list nil nil nil 4)))
          (apply #'posframe-show
                 (with-current-buffer (get-buffer-create " *lsp-signature*")
                   (erase-buffer)
                   (insert str)
                   (visual-line-mode 1)
                   (lsp--setup-page-break-mode-if-present)
                   (current-buffer))
                 (append
                  lsp-signature-posframe-params
                  (list :position (point)
                        :background-color (face-attribute 'lsp-posframe :background nil t)
                        :foreground-color (face-attribute 'lsp-posframe :foreground nil t)
                        :border-color (face-attribute 'lsp-posframe-border :foreground nil t)))))
      (posframe-hide " *lsp-signature*")))

  (setq lsp-completion-provider :none) ;; we use Corfu!
  (setq lsp-completion-show-detail nil)

  (setq lsp-solargraph-multi-root nil)

  (defun lsp-solargraph--build-command ()
    '("direnv" "exec" "." "solargraph" "stdio"))

  (defun ar/lsp-mode-setup-completion ()
    (setq-local completion-at-point-functions
                `(,(cape-super-capf
                    ;; #'snippets-complete
                    #'lsp-completion-at-point
                    #'cape-dabbrev)
                  cape-file))
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(basic)))
  (add-hook 'lsp-completion-mode-hook #'ar/lsp-mode-setup-completion)

  ;; disable inline type hints by default
  (defvar ar/allow-lsp-inlay-hints-mode nil)

  (setq lsp-inlay-hint-enable t
        lsp-rust-analyzer-display-parameter-hints t)

  (defun ar/lsp-inlay-hints-mode (orig &rest args)
    (when ar/allow-lsp-inlay-hints-mode
      (apply orig args)))
  (advice-add #'lsp-inlay-hints-mode :around #'ar/lsp-inlay-hints-mode)

  (defun ar/toggle-lsp-inlay-hints-mode ()
    (interactive)
    (let ((ar/allow-lsp-inlay-hints-mode t))
      (lsp-inlay-hints-mode (if lsp-inlay-hints-mode -1 1))))

  ;; fix newlines in markdown docs
  (defun lsp--fontlock-with-mode (str mode)
    "Fontlock STR with MODE."
    (let ((lsp-buffer-major-mode major-mode))
      (with-temp-buffer
        (with-demoted-errors "Error during doc rendering: %s"
          (insert
           (if (eq mode 'lsp--render-markdown)
               (replace-regexp-in-string "\\`\n" ""
                                         (replace-regexp-in-string "\\(```\\|---\\)\n\n" "\\1\n" str))
             str))
          (delay-mode-hooks (funcall mode))
          (cl-flet ((window-body-width () lsp-window-body-width))
            ;; This can go wrong in some cases, and the fontification would
            ;; not work as expected.
            ;;
            ;; See #2984
            (ignore-errors (font-lock-ensure))
            (lsp--display-inline-image mode)
            (when (eq mode 'lsp--render-markdown)
              (lsp--fix-markdown-links))))
        (lsp--buffer-string-visible))))

  ;; try to load functions to override them later
  ;; (let (item (lsp-completion--make-item '(:label "test")))
  ;;   (lsp-completion--annotate item)
  ;;   (lsp-completion--get-documentation item))

  ;; (ar/lsp)
  ;; (advice-add #'lsp :after #'ar/lsp-initialize)

  (setq lsp-auto-execute-action nil)

  (defun ar/lsp-code-action ()
    (interactive)
    (let ((lsp-response-timeout 0.2))
      (call-interactively #'lsp-execute-code-action)))

  ;; (defun ar/lsp-code-action ()
  ;;   (interactive)
  ;;   (lsp-cancel-request-by-token :ar/lsp-code-action)
  ;;   (lsp-request-async
  ;;   "textDocument/codeAction"
  ;;   (lsp--text-document-code-action-params nil)
  ;;   (lambda (res)
  ;;     (condition-case err
  ;;         ;; this doesn't work most of th times for some reason
  ;;         ;; and sync version always works
  ;;         (lsp-execute-code-action (lsp--select-action res))
  ;;       (quit nil)))
  ;;   :error-handler (lambda (err)
  ;;                     (error (lsp:json-error-message (cl-first err))))
  ;;   :mode 'current
  ;;   :cancel-token :ar/lsp-code-action))

  (general-define-key
   :states '(normal visual)
   :keymaps 'lsp-mode-map
   "g a" #'ar/lsp-code-action)

  (ar/leader-def
    :states '(normal motion)
    :keymaps 'lsp-mode-map
    "l d" #'lsp-describe-session
    "l f" #'lsp-format-region
    "l h" #'ar/toggle-lsp-inlay-hints-mode
    "l o" #'lsp-organize-imports
    "l r" #'lsp-rename
    "l W" #'lsp-restart-workspace)

  (lsp-dependency 'stylelint-lsp
                  '(:system "stylelint-lsp")
                  '(:npm :package "stylelint-lsp"
                         :path "stylelint-lsp"))

  (defun lsp-stylelint--server-command ()
    (list (lsp-package-path 'stylelint-lsp) "--stdio"))

  (lsp-defun lsp-stylelint--apply-code-action ((&Command :arguments?))
    (lsp--apply-text-edits (cl-caddr arguments?) 'code-action))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection #'lsp-stylelint--server-command)
    :activation-fn (lsp-activate-on "css" "scss" "sass" "less")
    :priority 0
    ;; :action-handlers (lsp-ht ("_css.applyCodeAction" #'lsp-stylelint--apply-code-action))
    :server-id 'stylelint-ls
    :download-server-fn (lambda (_client callback error-callback _update?)
                          (lsp-package-ensure 'stylelint-lsp callback error-callback)))))

(use-package lsp-tailwindcss
  :straight t
  :init
  (setq lsp-tailwindcss-add-on-mode t))

;; use filter text instead of label as completion title
(cl-defun ar/lsp-completion--make-item (item &key markers prefix)
  "Make completion item from lsp ITEM and with MARKERS and PREFIX."
  (-let (((&CompletionItem :filter-text?
                           :label
                           :sort-text?
                           :_emacsStartPoint start-point)
          item))
    (propertize (concat (or filter-text? label))
                'lsp-completion-item item
                'lsp-sort-text sort-text?
                'lsp-completion-start-point start-point
                'lsp-completion-markers markers
                'lsp-completion-prefix prefix)))

;; (defun ar/lsp-completion--annotate (item)
;;   "Annotate ITEM detail."
;;   (-let (((&CompletionItem :detail? :kind? :label-details?)
;;           (plist-get (text-properties-at 0 item) 'lsp-completion-item)))
;;     (concat (when (and lsp-completion-show-detail detail?)
;;               (concat " " (s-replace "\r" "" detail?)))
;;             (when (and lsp-completion-show-label-description label-details?)
;;               (when-let ((description (and label-details?
;;                                            (lsp:label-details-description label-details?))))
;;                 (format " %s" description)))
;;             (when lsp-completion-show-kind
;;               (when-let ((kind-name (and kind? (aref lsp-completion--item-kind kind?))))
;;                 (format " %s" (downcase kind-name)))))))

(defun ar/lsp-completion--annotate (item)
  "Annotate ITEM detail."
  (-let (((&CompletionItem :kind? :label)
          (plist-get (text-properties-at 0 item) 'lsp-completion-item)))
    (concat (when label
              (format " %s" (if (string-prefix-p item label)
                                (substring label (length item))
                              label)))
            (when lsp-completion-show-kind
              (when-let ((kind-name (and kind? (aref lsp-completion--item-kind kind?))))
                (format " %s" (downcase kind-name)))))))

(defun ar/lsp-completion--get-documentation (item)
  (unless (get-text-property 0 'lsp-completion-resolved item)
    (let ((resolved-item
          (-some->> item
            (get-text-property 0 'lsp-completion-item)
            (lsp-completion--resolve)))
          (len (length item)))
      (put-text-property 0 len 'lsp-completion-item resolved-item item)
      (put-text-property 0 len 'lsp-completion-resolved t item)))
  (when-let ((plist (get-text-property 0 'lsp-completion-item item)))
    (concat (when-let ((detail (lsp:completion-item-detail? plist))
                      (mode (if (eq major-mode 'js2-mode) 'typescript-mode major-mode)))
              (concat (lsp--fontlock-with-mode (s-replace "\r" "" detail) mode) "\n"))
            (-some->> (lsp:completion-item-documentation? plist)
              (lsp--render-element)))))

(defun ar/lsp ()
  (advice-add #'lsp-completion--make-item :override #'ar/lsp-completion--make-item)
  (advice-add #'lsp-completion--annotate :override #'ar/lsp-completion--annotate)
  (advice-add #'lsp-completion--get-documentation :override #'ar/lsp-completion--get-documentation)
  (remove-hook 'lsp-completion-mode-hook #'ar/lsp))

;; (use-package lsp-ui
;;   :straight t
;;   :config
;;   (setq lsp-ui-sideline-enable nil
;;         lsp-ui-doc-enable nil
;;         lsp-ui-doc-border "#aaaaaa"
;;         lsp-ui-doc-include-signature t
;;         lsp-ui-doc--hide-on-next-command t)
;;
;;   (general-define-key
;;    :states '(normal motion)
;;    :keymaps '(lsp-mode-map)
;;    "g h" #'lsp-ui-doc-show
;;    "g H" #'lsp-ui-doc-focus-frame))

(defvar ar/lsp-hover-buf " *ar-lsp-hover*")

(defun ar/lsp-hover-hide ()
  (remove-hook 'post-command-hook 'ar/lsp-hover-hide)
  (posframe-hide ar/lsp-hover-buf))

(lsp-defun ar/lsp-hover-show-callback ((hover &as &Hover? :contents) bounds buffer)
  (when (and hover
             (>= (point) (car bounds))
             (<= (point) (cdr bounds))
             (eq buffer (current-buffer)))
    (let ((doc (lsp--render-element contents)))
      (posframe-show
      (with-current-buffer (get-buffer-create ar/lsp-hover-buf t)
        (erase-buffer)
        (insert doc)
        (goto-char (point-min))
        (visual-line-mode 1)
        (current-buffer))
      :position (point)
      :foreground-color (face-attribute 'lsp-posframe :foreground nil t)
      :background-color (face-attribute 'lsp-posframe :background nil t)
      :border-width 1
      :left-fringe 5
      :right-fringe 5
      :override-parameters '((cursor-type box))
      :accept-focus t
      :border-color (face-attribute 'lsp-posframe-border :foreground nil t)))))

(defun ar/lsp-hover-show ()
  (interactive)
  (when (lsp-feature? "textDocument/hover")
    (-if-let (bounds (or (and (symbol-at-point) (bounds-of-thing-at-point 'symbol))
                         (and (looking-at "[[:graph:]]") (cons (point) (1+ (point))))))
        (let ((buf (current-buffer)))
          (ar/lsp-hover-hide)
          (lsp-request-async
           "textDocument/hover"
           (lsp--text-document-position-params)
           (lambda (hover)
             (when (equal buf (current-buffer))
               (ar/lsp-hover-show-callback hover bounds buf)))
           :mode 'tick
           :cancel-token :ar/lsp-hover-show))
      (ar/lsp-hover-hide))))

(general-define-key
 :states '(normal motion emacs)
 :keymaps '(lsp-mode-map)
 "g h" #'ar/lsp-hover-show)

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook (prog-mode . copilot-mode)
  :config
  (setq copilot-node-executable "/opt/node/20.11.1/bin/node"
        copilot-network-proxy '(:host "127.0.0.1" :port 8081)
        copilot-idle-delay 0.5
        copilot-clear-overlay-ignore-commands '(corfu-next corfu-previous))
  (defun ar/copilot--post-command-debounce (buffer) t)
  (defun ar/copilot-auto (enable)
    (if enable
        (advice-remove #'copilot--post-command-debounce #'ar/copilot--post-command-debounce)
      (advice-add #'copilot--post-command-debounce
                  :override #'ar/copilot--post-command-debounce)))
  (ar/copilot-auto t)
  :bind (:map copilot-mode-map
         ;;("M-<tab>" . 'copilot-complete)
         ;;("M-TAB" . 'copilot-complete)
         ("S-M-<tab>" . copilot-panel-complete)
         ("S-M-TAB" . copilot-panel-complete)
         :map copilot-completion-map
         ("s-<return>" . 'copilot-accept-completion)
         ("s-RET" . 'copilot-accept-completion)
         ("S-s-<return>" . 'copilot-accept-completion-by-word)
         ("S-s-RET" . 'copilot-accept-completion-by-word)
         ("M-<tab>" . 'copilot-next-completion)
         ("M-TAB" . 'copilot-next-completion)))

(defun ar/find-next-error (dir min-level)
  (let* ((start (point))
         (pos start)
         cmp min max next-fn err)
    (if (> dir 0)
        (setq cmp '<
              min (point-min)
              max (point-max)
              next-fn 'next-single-char-property-change)
      (setq cmp '>
            min (point-max)
            max (point-min)
            next-fn 'previous-single-char-property-change))
    (catch 'not-found
      (while (or (not err)
                 (funcall cmp (flycheck-error-pos err) pos)
                 (and min-level
                      (< (flycheck-error-level-severity (flycheck-error-level err))
                         (flycheck-error-level-severity min-level))))
        (setq next-pos (funcall next-fn pos 'flycheck-error))
        (if (= next-pos max)
            (if (= start min)
                (progn
                  (setq err nil)
                  (throw 'not-found nil))
              (setq start min pos min err nil))
          (setq err (get-char-property next-pos 'flycheck-error)
                pos next-pos))))
    err))

(defun ar/flycheck-display-error-at-point ()
  (interactive)
  (with-demoted-errors "Flycheck error display error: %s"
    (let ((errors (flycheck-overlay-errors-at (point))))
      (flycheck-cancel-error-display-error-at-point-timer)
      (when (eq (point) (line-end-position))
        (goto-char (1- (point))))
      (setq flycheck--last-error-display-tick (flycheck--error-display-tick))
      (when (and flycheck-mode errors)
        (flycheck-display-errors errors)))))

(defun ar/next-diag (&optional dir level)
  (interactive)
  (if-let ((err (ar/find-next-error (or dir 1) level)))
      (progn
        (flycheck-jump-to-error err)
        (ar/flycheck-display-error-at-point))
    (message "There are no errors!")))

(defun ar/prev-diag () (interactive)
       (ar/next-diag -1))

(mapc #'evil-declare-not-repeat
      '(ar/next-diag ar/prev-diag))

;; (defun ar/prev-error ()
;;   (interactive)
;;   (ar/next-diag -1 'error))

;; (defun ar/next-error ()
;;   (interactive)
;;   (ar/next-diag 1 'error))

(defun string-wrap (str len)
  (let (wrapped)
    (while (> (length str) len)
      (setq wrapped (concat wrapped (substring str 0 len))
            str (substring str len))
      (when (> (length str) 0)
        (setq wrapped (concat wrapped "\n"))))
    (concat wrapped str)))

(use-package flycheck
  :straight t
  :config
  (setq flycheck-display-errors-delay 0.1)

  (flycheck-define-checker slim-lint
    "A Slim linter."
    :command ("slim-lint" "--reporter=checkstyle" source-original)
    :error-parser flycheck-parse-checkstyle
    :modes slim-mode))

(use-package flycheck-posframe
  :straight t
  :after flycheck
  :hook (flycheck-mode . flycheck-posframe-mode)
  :config
  (setq flycheck-posframe-border-width 1)

  (defun flycheck-posframe-format-error (err)
    (let* ((str (flycheck-error-format-message-and-id err))
           (no-space (if (string-prefix-p " " str) (substring str 1) str))
           ;;(newlines (string-replace "\n" " \n   " (string-wrap no-space 99))))
           (newlines (string-replace "\n" " \n   " no-space)))
      (propertize (concat " ■ " newlines " ")
                  'face
                  `(:inherit ,(flycheck-posframe-get-face-for-error err)))))

  ;; (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;; (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  ;; (flycheck-add-mode 'javascript-eslint 'typescript-tsx-mode)
  ;; (flycheck-add-mode 'typescript-tslint 'typescript-tsx-mode)

  (add-hook 'flycheck-posframe-inhibit-functions #'evil-insert-state-p)
  (add-hook 'flycheck-posframe-inhibit-functions #'evil-replace-state-p)

  (when (timerp posframe-hidehandler-timer)
    (cancel-timer posframe-hidehandler-timer))

  (setq posframe-hidehandler-timer
        (run-with-idle-timer 0.1 t #'posframe-hidehandler-daemon-function)))

(general-define-key
 :states '(normal motion)
 ;; :keymaps '(flycheck-mode-map)
 :keymaps '(prog-mode-map)
 "[ d" #'ar/prev-diag
 "] d" #'ar/next-diag
 ;; "] e" #'next-error
 ;; "[ e" #'previous-error
 "[ s" #'sp-backward-sexp
 "] s" #'sp-forward-sexp
 "[ u" #'sp-backward-up-sexp
 "] u" #'sp-up-sexp)
 ;; "[ e" #'ar/prev-error
 ;; "] e" #'ar/next-error)

(use-package helpful
  :straight t)

(use-package elisp-demos
  :straight t
  :after helpful
  :config
  (push
   '("^\\*helpful "
     (display-buffer-reuse-window display-buffer-same-window)
     (inhibit-switch-frame . t))
   display-buffer-alist)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

(defun ar/setup-vterm-mode ()
  (setq-local confirm-kill-processes nil ;; Don't prompt about dying processes when killing vterm
              hscroll-margin 0)          ;; Prevent premature horizontal scrolling
  (ar/hide-trailing-whitespace)
  (hide-mode-line-mode 1)
  (auto-composition-mode -1))

(defun ar/vterm (&optional name)
  (interactive)
  ;; HACK forces vterm to redraw, fixing strange artefacting in the tty.
  ;; (save-window-excursion
  ;;   (pop-to-buffer "*scratch*"))
  (let* ((project-root (projectile-project-root))
         (default-directory project-root)
         display-buffer-alist)
    (setenv "PROOT" project-root)
    (vterm (or name "*vterm*"))))

(use-package vterm
  :straight t
  ;; :hook (vterm-mode . ar/setup-vterm-mode)
  :init
  ;; Once vterm is dead, the vterm buffer is useless. Why keep it around? We can
  ;; spawn another if want one.
  (setq vterm-kill-buffer-on-exit t)
  ;; 5000 lines of scrollback, instead of 1000
  (setq vterm-max-scrollback 5000)
  :config

(define-derived-mode vterm-mode fundamental-mode "VTerm"
  "Major mode for vterm buffer."
  (buffer-disable-undo)
  (and (boundp 'display-line-numbers)
       (let ((font-height (expt text-scale-mode-step text-scale-mode-amount)))
         (setq vterm--linenum-remapping
               (face-remap-add-relative 'line-number :height font-height))))
  (hack-dir-local-variables)
  (let ((vterm-env (assq 'vterm-environment dir-local-variables-alist)))
    (when vterm-env
      (make-local-variable 'vterm-environment)
      (setq vterm-environment (cdr vterm-env))))
  (let ((process-environment (append vterm-environment
                                     `(,(concat "TERM="
                                                vterm-term-environment-variable)
                                       ,(concat "EMACS_VTERM_PATH="
                                                (file-name-directory (find-library-name "vterm")))
                                       "INSIDE_EMACS=vterm"
                                       "LINES"
                                       "COLUMNS")
                                     process-environment))
        ;; TODO: Figure out why inhibit is needed for curses to render correctly.
        (inhibit-eol-conversion nil)
        (coding-system-for-read 'binary)
        (process-adaptive-read-buffering nil)
        (height (floor (window-screen-lines)))
        (width (max (- (window-body-width) (vterm--get-margin-width))
                    vterm-min-window-width)))
    (setq vterm--term (vterm--new height
                                  width vterm-max-scrollback
                                  vterm-disable-bold-font
                                  vterm-disable-underline
                                  vterm-disable-inverse-video
                                  vterm-ignore-blink-cursor
                                  vterm-set-bold-hightbright))
    (setq buffer-read-only t)
    (setq-local scroll-conservatively 101)
    (setq-local scroll-margin 0)
    (setq-local hscroll-margin 0)
    (setq-local hscroll-step 1)
    (setq-local truncate-lines t)

    ;; Disable all automatic fontification
    (setq-local font-lock-defaults '(nil t))

    (add-function :filter-return
                  (local 'filter-buffer-substring-function)
                  #'vterm--filter-buffer-substring)
    (setq vterm--process
          (make-process
           :name "vterm"
           :buffer (current-buffer)
           :command
           `("/bin/sh" "-c"
             ,(format
               "stty -nl sane %s erase ^? rows %d columns %d >/dev/null && exec %s"
               ;; Some stty implementations (i.e. that of *BSD) do not
               ;; support the iutf8 option.  to handle that, we run some
               ;; heuristics to work out if the system supports that
               ;; option and set the arg string accordingly. This is a
               ;; gross hack but FreeBSD doesn't seem to want to fix it.
               ;;
               ;; See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=220009
               (if (eq system-type 'berkeley-unix) "" "iutf8")
               height width (vterm--get-shell)))
           ;; :coding 'no-conversion
           :connection-type 'pty
           :file-handler t
           :filter #'vterm--filter
           ;; The sentinel is needed if there are exit functions or if
           ;; vterm-kill-buffer-on-exit is set to t.  In this latter case,
           ;; vterm--sentinel will kill the buffer
           :sentinel (when (or vterm-exit-functions
                               vterm-kill-buffer-on-exit)
                       #'vterm--sentinel))))

  ;; Change major-mode is not allowed
  ;; Vterm interfaces with an underlying process. Changing the major
  ;; mode can break this, leading to segmentation faults.
  (add-hook 'change-major-mode-hook
            (lambda () (interactive)
              (user-error "You cannot change major mode in vterm buffers")) nil t)

  (vterm--set-pty-name vterm--term (process-tty-name vterm--process))
  (process-put vterm--process 'adjust-window-size-function
               #'vterm--window-adjust-process-window-size)

  (ar/hide-trailing-whitespace)
  (hide-mode-line-mode 1)
  (auto-composition-mode -1)
  ;; Support to compilation-shell-minor-mode
  ;; Is this necessary? See vterm--compilation-setup
  (setq next-error-function 'vterm-next-error-function)
  (setq-local bookmark-make-record-function 'vterm--bookmark-make-record))

  (general-def
    :states '(insert)
    :keymaps '(vterm-mode-map)
    "C-c" #'vterm--self-insert
    "C-z" #'vterm--self-insert)
  (general-def
    :states '(normal insert)
    :keymaps '(vterm-mode-map)
    "C-x C-z" #'evil-collection-vterm-toggle-send-escape))

;; (evil-define-key 'insert 'vterm-mode-map (kbd "M-b") #'vterm--self-insert
;;                                          (kbd "M-f") #'vterm--self-insert)

(defun ar/pair-layout ()
  (interactive)
  (delete-other-windows)
  (let* ((w 230) (h 63))
    (when (> (window-height) (+ h window-min-width))
      (split-window-vertically h))
    (when (> (window-width) (+ w window-min-width))
      (split-window-horizontally w))))

(use-package all-the-icons-dired
  :straight t)

(defun ar/dired-open-file (&optional arg)
  (interactive "P")
  (dired-do-shell-command "open" arg (dired-get-marked-files t arg)))

(use-package dired
  :config
  (setq dired-dwim-target t
        dired-hide-details-hide-symlink-targets nil
        ;; don't prompt to revert, just do it
        dired-auto-revert-buffer #'dired-buffer-stale-p
        ;; Always copy/delete recursively
        dired-recursive-copies  'always
        dired-recursive-deletes 'top
        ;; Ask whether destination dirs should get created when copying/removing files.
        dired-create-destination-dirs 'ask
        dired-listing-switches "-Ahlo"
        dired-omit-files "\\`[.]?#"
        dired-kill-when-opening-new-dired-buffer t
        dired-no-confirm t
        dired-deletion-confirmer (lambda (x) t))

  (general-define-key
   :states '(normal)
   :keymaps '(dired-mode-map)
   "C-o" #'ar/dired-open-file
   "q" #'kill-current-buffer
   "H" #'dired-hide-dotfiles-mode)

  (general-define-key
    :states '(normal motion)
    :keymaps 'image-mode-map
    "y" (lambda ()
      (interactive)
      (call-process "pbcopyf" nil nil nil (buffer-file-name)))
    "m" #'image-mode-mark-file
    "u" #'image-mode-unmark-file)

  (ar/leader-def
   :states '(normal visual)
   :keymaps 'general-override-mode-map
   "o h" (lambda () (interactive) (dired "~"))))

(use-package diredfl
  :straight t
  :hook (dired-mode . diredfl-mode)
  :config
  (set-face-attribute 'diredfl-date-time nil :weight 'normal))

(use-package dired-hide-dotfiles
  :straight t
  :hook (dired-mode . dired-hide-dotfiles-mode))

(setq delighted-modes '((tsx-ts-mode . ("TSX"))))

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  ;; :hook (doom-modeline-mode . size-indication-mode) ; filesize in modeline
  :hook (doom-modeline-mode . column-number-mode)   ; cursor column in modeline
  :init
  ;; (:option doom-modeline-height 15
  ;;          doom-modeline-bar-width 6
  ;;          doom-modeline-lsp t
  ;;          doom-modeline-github nil
  ;;          doom-modeline-mu4e nil
  ;;          doom-modeline-irc t
  ;;          doom-modeline-minor-modes t
  ;;          doom-modeline-persp-name nil
  ;;          doom-modeline-buffer-file-name-style 'truncate-except-project
  ;;          doom-modeline-major-mode-icon nil)
  ;; (custom-set-faces '(mode-line ((t (:height 0.85))))
  ;;                   '(mode-line-inactive ((t (:height 0.85)))))
  ;; We display project info in the modeline ourselves
  (setq projectile-dynamic-mode-line nil)

  ;; Set these early so they don't trigger variable watchers
  (setq doom-modeline-bar-width 3
        doom-modeline-height 25
        doom-modeline-github nil
        doom-modeline-mu4e nil
        doom-modeline-persp-name nil
        doom-modeline-minor-modes nil
        doom-modeline-major-mode-icon nil
        doom-modeline-env-version nil
        ;; doom-modeline-icon nil
        ;; doom-modeline-modal nil
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-buffer-file-name-style 'relative-from-project
        ;; Only show file encoding if it's non-UTF-8 and different line endings
        ;; than the current OSes preference
        doom-modeline-buffer-encoding nil ;;'nondefault
        doom-modeline-default-eol-type 2)
  :config
  (add-to-list 'doom-modeline-mode-alist '(magit-mode . nil)))

(use-package which-key
  :straight t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1.0))

(defun ar/mu4e-action-toggle-tag (msg tag)
  (let* ((tags (mu4e-message-field msg :tags))
         (docid (mu4e-message-field msg :docid))
         (sign (if (member tag tags) "-" "+")))
    (mu4e-action-retag-message msg (concat sign tag ",-\\Inbox"))
    (mu4e--server-move docid nil "+S-u-N")))

(defun ar/mu4e-action-tag-paper-trail (msg)
  (ar/mu4e-action-toggle-tag msg "Paper Trail"))

(defun ar/mu4e-action-tag-the-feed (msg)
  (ar/mu4e-action-toggle-tag msg "The Feed"))

(defun ar/mu4e-action-tag-sfc (msg)
  (ar/mu4e-action-toggle-tag msg "SFC"))

(defun ar/mu4e-tag-stripe (msg)
  (let* ((tags (mu4e-message-field msg :tags))
         (color (cond
                 ((member "Paper Trail" tags) 'all-the-icons-lblue)
                 ((member "The Feed" tags) 'all-the-icons-green)
                 ((member "SFC" tags) 'all-the-icons-red)
                 ((member "SFC/FB" tags) 'all-the-icons-lred)
                 ((member "Warnings" tags) 'all-the-icons-lpurple)
                 ((member "\\Inbox" tags) 'all-the-icons-yellow)
                 (t nil))))
    (if color (propertize "▌" 'face color 'help-echo color) "")))

(defun +mu4e--mark-seen (docid _msg target)
  (mu4e--server-move docid (mu4e--mark-check-target target) "+S-u-N"))

(defun +mu4e-gmail-fix-flags-h (mark msg)
  (pcase mark
    (`trash  (mu4e-action-retag-message msg "-\\Inbox,+\\Trash,-\\Draft"))
    (`delete (mu4e-action-retag-message msg "-\\Inbox,+\\Trash,-\\Draft"))
    (`refile (mu4e-action-retag-message msg "-\\Inbox"))
    (`flag   (mu4e-action-retag-message msg "+\\Starred"))
    (`unflag (mu4e-action-retag-message msg "-\\Starred"))))

(defun ar/compose-invoice ()
  (interactive)
  (cl-letf*
      ((file (read-file-name "Attach: " "/Volumes/accounting/SFC/" nil t ""))
       ((symbol-function 'mu4e~draft-newmsg-construct)
        (lambda ()
          (concat
           (mu4e~draft-header "From" (or (mu4e~draft-from-construct) ""))
           (mu4e~draft-header "Reply-To" mu4e-compose-reply-to-address)
           (mu4e~draft-header "To" "Jane Speakman <jane.s@snow-forecast.com>")
           (mu4e~draft-header "Cc" "xero@snow-forecast.com, Nick Russill <nick.russill@snow-forecast.com>, Yar Dmitriev <yar@snow-forecast.com>")
           (mu4e~draft-header "Subject" (file-name-base file))
           (mu4e~draft-common-construct)))))
    (mu4e-compose-new)
    (mail-add-attachment file)))

(use-package mu4e
  :config
  (setq mu4e-bookmarks
        '((:name "Inbox" :query "tag:\\\\Inbox" :key ?i)
          (:name "Unread" :query "flag:unread and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?u)
          (:name "Today's messages" :query "date:today..now and not tag:warnings and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?t)
          (:name "SFC" :query "\"tag:SFC\" and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?s)
          (:name "Paper Trail" :query "\"tag:Paper Trail\" and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?p)
          (:name "The Feed" :query "\"tag:The Feed\" and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?f)
          (:name "Last 7 days" :query "date:7d..now and not tag:\\\\Trash and not maildir:/gmail/[Gmail].Trash" :key ?w)
          (:name "Sent" :query "from:anton@blackbits.pro" :key ?n)
          (:name "Trash" :query "maildir:/gmail/[Gmail].Trash" :key ?b)
          (:name "Spam" :query "maildir:/gmail/[Gmail].Spam" :key ?m)
          (:name "Messages with images" :query "mime:image/*" :key ?o))
        mu4e-org-contacts-file "contacts.org"
        mu4e-user-mail-address-list '("anton@blackbits.pro"
                                      "antonrogov@me.com"
                                      "antondropbox@gmail.com")
        ;; "elraril@gmail.com"
        mu4e-get-mail-command "~/bin/check-mail"
        sendmail-program "~/bin/queue-mail"
        send-mail-function 'sendmail-send-it
        ;; mu4e-sent-messages-behavior 'sent
        mu4e-sent-messages-behavior 'delete
        message-send-mail-function 'sendmail-send-it
        message-sendmail-extra-arguments (list '"-a" "gmail")
        message-sendmail-envelope-from 'header
        message-citation-line-function 'message-insert-formatted-citation-line
        message-kill-buffer-on-exit t
        mu4e-split-view nil
        mu4e-headers-visible-flags '(draft flagged new passed replied trashed attach encrypted signed)
        ;; mu4e-headers-attach-mark '("a" . "")
        ;; mu4e-headers-flagged-mark '("F" . "")
        ;; mu4e-headers-list-mark '("l" . "")
        mu4e-use-fancy-chars t
        mu4e-headers-attach-mark '("a" . "@")
        mu4e-headers-list-mark '("l" . "L")
        mu4e-headers-fields '((:tag-stripe . 2)
                              (:human-date . 12)
                              (:flags . 6) ; 3 icon flags
                              (:from-or-to . 25)
                              (:subject))
        mu4e-compose-format-flowed t
        mu4e-headers-actions '(("capture message"  . ar/capture-message)
                               ("sfc tag" . (lambda (msg)
                                              (ar/mu4e-action-tag-sfc msg)
                                              (mu4e-headers-next)))
                               ("paper trail tag" . (lambda (msg)
                                                      (ar/mu4e-action-tag-paper-trail msg)
                                                      (mu4e-headers-next)))
                               ("feed tag" . (lambda (msg)
                                               (ar/mu4e-action-tag-the-feed msg)
                                               (mu4e-headers-next)))
                               ("show this thread" . mu4e-action-show-thread))
        mu4e-view-actions '(("c capture message"  . ar/capture-message)
                            ("b view in browser" . (lambda (msg)
                                                   (let ((browse-url-handlers nil)
                                                         (browse-url-browser-function
                                                          (lambda (url &optional _rest)
                                                            (xwidget-webkit-browse-url url t))))
                                                     (mu4e-action-view-in-browser msg))))
                            ("s sfc tag" . (lambda (msg)
                                           (ar/mu4e-action-tag-sfc msg)
                                           (mu4e-headers-next)))
                            ("p paper trail tag" . (lambda (msg)
                                                   (ar/mu4e-action-tag-paper-trail msg)
                                                   (mu4e-view-headers-next)))
                            ("f feed tag" . (lambda (msg)
                                            (ar/mu4e-action-tag-the-feed msg)
                                            (mu4e-view-headers-next)))
                            ("t show this thread" . mu4e-action-show-thread))
        mu4e-confirm-quit nil
        mu4e-headers-thread-single-orphan-prefix '("─>" . "─▶")
        mu4e-headers-thread-orphan-prefix        '("┬>" . "┬▶ ")
        mu4e-headers-thread-connection-prefix    '("│ " . "│ ")
        mu4e-headers-thread-first-child-prefix   '("├>" . "├▶")
        mu4e-headers-thread-child-prefix         '("├>" . "├▶")
        mu4e-headers-thread-last-child-prefix    '("└>" . "╰▶")
        mu4e-context-policy 'pick-first ;; start with the first (default) context;
        mu4e-compose-context-policy 'ask ;; ask for context if no context matches;
        mu4e-contexts `(,(make-mu4e-context
                          :name "main"
                          :enter-func
                          (lambda () (mu4e-message "entering main context..."))
                          :leave-func
                          (lambda () (mu4e-message "leaving main context..."))
                          :match-func
                          (lambda (msg) t)
                          ;; (when msg
                          ;;   (mu4e-message-contact-field-matches msg
                          ;;                                       :to "dummy@icloud.com")))
                          :vars '((user-full-name . "Anton Rogov")
                                  (user-mail-address . "anton@blackbits.pro" )
                                  (smtpmail-smtp-user . "anton@blackbits.pro")
                                  (mu4e-sent-folder . "/gmail/sent")
                                  (mu4e-refile-folder . "/gmail/[Gmail].All Mail")
                                  (mu4e-drafts-folder . "/gmail/[Gmail].All Mail")
                                  (mu4e-trash-folder . "/gmail/[Gmail].Trash")))))
  (setf (alist-get 'delete mu4e-marks)
        (list
         :char '("D" . "✘")
         :prompt "Delete"
         :show-target (lambda (_target) "delete")
         :action #'+mu4e--mark-seen)
        (alist-get 'trash mu4e-marks)
        (list :char '("d" . "▼")
              :prompt "dtrash"
              :dyn-target (lambda (_target msg) (mu4e-get-trash-folder msg))
              :action #'+mu4e--mark-seen)
        ;; Refile will be my "archive" function.
        (alist-get 'refile mu4e-marks)
        (list :char '("r" . "▼")
              :prompt "rrefile"
              :dyn-target (lambda (_target msg) (mu4e-get-refile-folder msg))
              :action #'+mu4e--mark-seen
              #'+mu4e--mark-seen))
  (add-to-list 'mu4e-header-info-custom
               '(:tag-stripe . (:name "Tag Stripe"
                                :shortname " "
                                :help "which tag this email has"
                                :function
                                (lambda (msg) (ar/mu4e-tag-stripe msg)))))
  (add-hook 'mu4e-mark-execute-pre-hook #'+mu4e-gmail-fix-flags-h)
  (push
   '("^\\*mu4e"
     (display-buffer-reuse-window display-buffer-same-window)
     (inhibit-switch-frame . t))
   display-buffer-alist)

  (add-hook 'mu4e-headers-mode-hook #'ar/hide-trailing-whitespace)
  ;; (set-face-attribute 'mu4e-header-highlight-face nil :underline nil)
  ;; (set-face-attribute 'mu4e-unread-face nil :bold nil)
  )

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :straight t
  :config
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil)
  (general-def
    :states '(normal motion)
    :keymaps 'pdf-view-mode-map
    "q" #'kill-current-buffer)
  )

(use-package saveplace-pdf-view
  :straight t)

(use-package doom-themes
  :straight t
  :config
  (setq custom-safe-themes '("b5c48b41ae4342a2834a9a986febdcf1153aeeeb92a8865ce6050a6d98fe224a"
                             "5534cc713fb1de0ab42ec88dc8f4478e1dc840df79acab3430baf92d292a31ae"
                             default)))

(setq auto-dark-dark-theme 'ar-tomorrow-night
      auto-dark-light-theme 'ar-tomorrow-day)

(defun ar/change-dark (dark)
  (disable-theme (if dark auto-dark-light-theme auto-dark-dark-theme))
  (load-theme (if dark auto-dark-dark-theme auto-dark-light-theme))
  (vertico-posframe-cleanup)
  (kind-icon-reset-cache))

(use-package auto-dark
  :straight t
  :config
  (advice-add 'auto-dark--set-theme :after
              (lambda (&rest r)
                (ignore-errors
                  (vertico-posframe-cleanup)
                  (kind-icon-reset-cache)))
              '((name . "update others")))
  (auto-dark-mode))
;; (load-theme 'ar-tomorrow-night)
;; (ar/change-dark t)

(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode)

(setq indicate-buffer-boundaries nil
      indicate-empty-lines nil)

(setq ring-bell-function 'ignore
      visible-bell nil)

;; lower value means more but faster gc runs
(setq gc-cons-threshold (* 2 1024 1024))

;; default 4k is too low
(setq read-process-output-max (* 10 1024 1024))

(setq warning-minimum-level :error)
