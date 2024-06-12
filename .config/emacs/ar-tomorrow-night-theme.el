;;; ar-tomorrow-night-theme.el -*- lexical-binding: t; -*-

(require 'doom-themes)

(def-doom-theme
 ar-tomorrow-night
 "A theme based off of Chris Kempson's Tomorrow Dark."

 ;; name        gui       256       16
 ((bg         '("#161719" nil       nil          ))
 ;; ((bg         '("#121314" nil       nil          ))
 ;; ((bg         '("#0d0d0d" nil       nil          ))
  ;; (bg-alt     '("#1d1f21" nil       nil          ))
  (bg-alt     '("#1b1b1b" nil       nil          ))
  (base0      '("#0d0d0d" "black"   "black"      ))
  (base1      '("#1b1b1b" "#1b1b1b"              ))
  (base2      '("#212122" "#1e1e1e"              ))
  (base3      '("#292b2b" "#292929" "brightblack"))
  (base4      '("#3f4040" "#3f3f3f" "brightblack"))
  (base5      '("#5c5e5e" "#525252" "brightblack"))
  (base6      '("#757878" "#6b6b6b" "brightblack"))
  (base7      '("#969896" "#979797" "brightblack"))
  (base8      '("#ffffff" "#ffffff" "white"      ))
  (fg         '("#c5c8c6" "#c5c5c5" "white"))
  (fg-alt     (doom-darken fg 0.4))

  (grey       '("#5a5b5a" "#5a5a5a" "brightblack"))
  (dark-red   '("#cc6666" "#cc6666" "red"))
  (red        '("#dac1c1" "#cc6666" "red"))
  (orange     '("#de935f" "#dd9955" "brightred"))
  (yellow     '("#f0c674" "#f0c674" "yellow"))
  (green      '("#b5bd68" "#b5bd68" "green"))
  ;; (blue       '("#81a2be" "#88aabb" "brightblue"))
  (blue       '("#b0b8bf" "#88aabb" "brightblue"))
  (dark-blue  '("#41728e" "#41728e" "blue"))
  (teal       blue) ; FIXME replace with real teal
  (magenta    '("#c9b4cf" "#c9b4cf" "magenta"))
  (violet     '("#b294bb" "#b294bb" "brightmagenta"))
  (cyan       '("#8abeb7" "#8abeb7" "cyan"))
  (dark-cyan  (doom-darken cyan 0.4))

  ;; (grey       '("#5a5b5a" "#5a5a5a" "brightblack"))
  ;; (red        '("#daa8a8" "#cc6666" "red"))
  ;; (orange     '("#de935f" "#dd9955" "brightred"))
  ;; (yellow     '("#dec89c" "#f0c674" "yellow"))
  ;; (green      '("#aeba38" "#b5bd68" "green"))
  ;; (blue       '("#acb6bf" "#88aabb" "brightblue"))
  ;; (dark-blue  '("#41728e" "#41728e" "blue"))
  ;; (teal       blue) ; FIXME replace with real teal
  ;; (magenta    '("#c9b4cf" "#c9b4cf" "magenta"))
  ;; (violet     '("#b091b9" "#b294bb" "brightmagenta"))
  ;; (cyan       '("#8abeb7" "#8abeb7" "cyan"))
  ;; (dark-cyan  (doom-darken cyan 0.4))

  ;; bg #161719
  ;; red #dac1c1
  ;; violet #b091b9
  ;; green #aeba38
  ;; yellow #dacbac
  ;; blue #b0b8bf
  ;; orange #de935f

  ;; face categories
  (highlight      blue)
  (vertical-bar   base0)
  (selection      "#333535");;`(,(car (doom-lighten bg 0.1)) ,@(cdr base1)))
  (builtin        blue)
  (comments       grey)
  (doc-comments   (doom-lighten grey 0.14))
  (constants      orange)
  (functions      blue)
  (keywords       violet)
  (methods        blue)
  (operators      fg)
  (type           yellow)
  (strings        green)
  (variables      red)
  (numbers        orange)
  (region         selection)
  (error          red)
  (warning        yellow)
  (success        green)
  (vc-modified    fg-alt)
  (vc-added       green)
  (vc-deleted     red)

  ;; custom categories
  (border          base5)
  (modeline-bg     base0);;`(,(doom-darken (car bg) 0.3) ,@(cdr base3)))
  (modeline-bg-alt bg);;`(,(car bg) ,@(cdr base1)))
  (modeline-fg     base8)
  (modeline-fg-alt comments)
  (-modeline-pad   nil))

 ;; --- faces ------------------------------
 (((line-number &override) :foreground base4 :italic nil)
  ((line-number-current-line &override) :foreground base7 :bold bold :italic nil)
  (mode-line
   :background modeline-bg :foreground modeline-fg
   :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
  (mode-line-inactive
   :background modeline-bg-alt :foreground modeline-fg-alt
   :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
  ((nobreak-space &override) :foreground base3)
  ((show-paren-match &override) :background base3)
  ((evil-ex-lazy-highlight &override) :background base3)

  ;;;; magit
  ((diff-removed &override) :foreground dark-red)
  ((magit-diff-removed &override) :foreground dark-red)
  ((magit-diff-added-highlight &override) :bold nil)
  ((magit-diff-removed-highlight &override) :foreground dark-red :bold nil)
  (diff-refine-added :inverse-video nil :bold t :foreground "#d6de91")
  (diff-refine-removed :inverse-video nil :bold t :foreground "#e88380")
  ((magit-header-line &override) :box `(:line-width 3 :color ,bg) :foreground fg :background bg)

  (smerge-upper :background bg-alt :foreground dark-red)
  (smerge-lower :background bg-alt :foreground dark-red)

  (lsp-face-highlight-textual :background base2)

  (sp-pair-overlay-face :background base1)

  (tree-sitter-hl-face:property :inherit 'font-lock-constant-face)
  ;; (tree-sitter-hl-face:function.macro :inherit 'font-lock-builtin-face)
  (tree-sitter-hl-face:function.call :foreground fg)

  ((link &override) :weight 'normal);; :underline t)

  (lsp-posframe :foreground fg :background bg)
  (lsp-posframe-border :foreground border)

  (markdown-code-face :background bg)

  (web-mode-symbol-face :foreground orange)

  ;;;; corfu
  (corfu-default :background bg)
  (corfu-current :background base3)
  (corfu-border :background border)
  (completions-common-part :foreground blue)
  (completions-first-difference :weight 'normal)

  ;;;; vertico
  (vertico-posframe-border :background border)

  ;;;; flycheck
  (flycheck-error :underline `(:style wave :color ,dark-red))
  (flycheck-fringe-error :foreground dark-red)
  (flycheck-posframe-background-face :background base1)
  (flycheck-posframe-border-face :foreground border)
  (flycheck-posframe-info-face :inherit 'success)
  (flycheck-posframe-warning-face :foreground yellow)
  (flycheck-posframe-error-face :foreground dark-red)

  (eldoc-highlight-function-argument :foreground orange)

  ;;;; mu4e
  (mu4e-highlight-face :inherit nil :foreground blue :weight 'bold)
  ((mu4e-header-highlight-face &override) :underline nil :background base2)
  ((mu4e-unread-face &override) :bold nil)

  ;;;; outline
  ((outline-1 &override) :weight 'normal)
  ((outline-2 &override) :weight 'normal)

  ;;;; org
  (org-block :background "#141517")
  ;; ((org-block &override)            :background org-block-bg)
  ;; ((org-block-background &override) :background org-block-bg)
  ;; ((org-block-begin-line &override) :background org-block-bg)
  ;; ((org-quote &override)            :background org-block-bg)
  (org-habit-overdue-face :foreground "#eee" :background "#7f3f44")
  (org-habit-clear-face :foreground "#eee" :background "#719258")
  (org-habit-ready-face :foreground "#eee" :background "#6c8e22" :weight 'normal)
  (org-habit-clear-future-face :foreground "#000" :background "#566d46")
  (org-habit-ready-future-face :foreground "#eee" :background "#6c8e22" :weight 'normal)

  ;;;; rainbow-delimiters
  (rainbow-delimiters-depth-1-face :foreground violet)
  (rainbow-delimiters-depth-2-face :foreground blue)
  (rainbow-delimiters-depth-3-face :foreground orange)
  (rainbow-delimiters-depth-4-face :foreground green)
  (rainbow-delimiters-depth-5-face :foreground magenta)
  (rainbow-delimiters-depth-6-face :foreground yellow)
  (rainbow-delimiters-depth-7-face :foreground teal)

  ;;;; doom-modeline
  (doom-modeline-bar-inactive      :foreground bg :background bg)
  (doom-modeline-buffer-path       :foreground violet :bold bold)
  (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)))
