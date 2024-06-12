;;; themes/ar-tomorrow-day-theme.el -*- lexical-binding: t; -*-

(require 'doom-themes)

(def-doom-theme
 ar-tomorrow-day
 "A light theme based off of Chris Kempson's Tomorrow Dark."

 ;; name        gui       256       16
 ((bg         '("#ffffff" "white"   "white" ))
  (bg-alt     '("#fcfcfc" nil       nil     ))
  ;; (base0      '("#f2f2f2" "white"   "white" ))
  ;; (base1      '("#e4e4e4" "#e4e4e4"         ))
  ;; (base2      '("#dedede" "#cccccc"         ))
  (base0      '("#fafafa" "#e4e4e4"         ))
  (base1      '("#f8f8f8" "#cccccc"         ))
  (base2      '("#f2f2f2" "white"   "white" ))
  (base3      '("#d6d4d4" "#cccccc" "silver"))
  (base4      '("#c0bfbf" "#c0c0c0" "silver"))

  (base5      '("#a3a1a1" "#adadad" "silver"))
  (base6      '("#8a8787" "#949494" "silver"))
  (base7      '("#696769" "#6b6b6b" "silver"))
  (base8      '("#000000" "#000000" "black" ))
  (fg         '("#4d4d4c" "#3a3a3a" "black"))
  (fg-alt     (doom-darken fg 0.6))

  ;; (grey       '("#8e908c" "#999999" "silver"))
  ;; ;; (red        '("#c82829" "#cc3333" "red"))
  ;; (red        '("#ad353d" "#cc3333" "red"))
  ;; ;; (orange     '("#f5871f" "#ff9933" "brightred"))
  ;; ;; (orange     '("#d4741b" "#ff9933" "brightred"))
  ;; ;; (orange     '("#bc793b" "#ff9933" "brightred"))
  ;; (orange     '("#c0913b" "#ff9933" "brightred"))
  ;; (yellow     '("#eab700" "#ffcc00" "yellow"))
  ;; (dark-yellow '("#9b8e3b" "#ffcc00" "yellow"))
  ;; (green      '("#718c00" "#669900" "green"))
  ;; ;; (blue       '("#4271ae" "#339999" "brightblue"))
  ;; (blue       '("#3b649b" "#339999" "brightblue"))
  ;; (dark-blue  (doom-darken blue 0.25))
  ;; ;; (teal       '("#3e999f" "#339999" "brightblue"))
  ;; (teal       '("#327A7F" "#339999" "brightblue"))
  ;; ;; (magenta    '("#c678dd" "#c9b4cf" "magenta"))
  ;; (magenta    '("#9e60b1" "#c9b4cf" "magenta"))
  ;; (violet     '("#8959a8" "#996699" "brightmagenta"))
  ;; ;; (violet     '("#7d519a" "#996699" "brightmagenta"))
  ;; ;; (violet     '("#925EB4" "#996699" "brightmagenta"))
  ;; (cyan       '("#8abeb7" "#8abeb7" "cyan"))
  ;; ;; (cyan       '("#5D817C" "#8abeb7" "cyan"))
  ;; (dark-cyan  (doom-lighten cyan 0.4))

  (grey        '("#8e908c" "#999999" "silver"))
  ;; (red         '("#7f3f44" "#cc3333" "red"))
  (red         '("#723F43" "#cc3333" "red"))
  (light-red   '("#ad353d" "#cc3333" "red"))
  ;; (orange      '("#b37300" "#ff9933" "brightred"))
  (orange      '("#b27200" "#ff9933" "brightred"))
  (yellow      '("#cfa400" "#ffcc00" "yellow"))
  ;; (dark-yellow '("727239" "#ffcc00" "yellow"))
  (dark-yellow '("#a68a00" "#ffcc00" "yellow"))
  (green       '("#6b8501" "#669900" "green"))
  ;; (blue        '("#3f5a7f" "#339999" "brightblue"))
  (blue        '("#3f5573" "#339999" "brightblue"))
  (dark-blue   (doom-darken blue 0.25))
  (teal        '("#327a7f" "#339999" "brightblue"))
  (magenta     '("#72457f" "#c9b4cf" "magenta"))
  (violet      '("#744b8f" "#996699" "brightmagenta"))
  (cyan        '("#5d817c" "#8abeb7" "cyan"))
  (dark-cyan   (doom-lighten cyan 0.4))

  ;; face categories

  ;; face categories
  (highlight      blue)
  (vertical-bar   base3)
  (selection      base2)
  (builtin        blue)
  (comments       grey)
  (doc-comments   grey)
  (constants      orange)
  (functions      blue)
  (keywords       violet)
  (methods        blue)
  (operators      fg)
  (type           dark-yellow);;(doom-darken yellow 0.5))
  (strings        green)
  (variables      red)
  (numbers        orange)
  (region         selection)
  (error          red)
  (warning        yellow)
  (success        green)
  (vc-modified    (doom-lighten yellow 0.4))
  (vc-added       (doom-lighten green 0.4))
  (vc-deleted     red)

  ;; custom categories
  (border                   base4)
  (org-block-bg             "#fdfdfd")
  (modeline-bg              `(,(doom-lighten (car bg-alt) 0.4) ,@(cdr base3)))
  (modeline-bg-alt          bg)
  (modeline-bg-inactive     bg) ;; `(,(doom-darken (car bg) 0.04) ,@(cdr base1)))
  (modeline-bg-alt-inactive bg)
  (modeline-fg              fg)
  (modeline-fg-inactive     comments)
  (modeline-fg-alt-inactive comments)
  (-modeline-pad            nil))

 ;;;; Base theme face overrides
 (;;((font-lock-doc-face &override) :slant 'italic)
  ((line-number &override) :foreground base4 :italic nil)
  ((line-number-current-line &override) :foreground base8 :italic nil)
  (mode-line
   :background modeline-bg :foreground modeline-fg
   :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
  (mode-line-inactive
   :background modeline-bg-inactive :foreground modeline-fg-inactive
   :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
  (mode-line-highlight :inherit 'bold :background highlight :foreground base2)
  ((header-line &override) :background base2)
  ((nobreak-space &override) :foreground "#e4e4e4")
  ((show-paren-match &override) :background base3)
  ((evil-ex-lazy-highlight &override) :background base1)
  (lsp-face-highlight-textual :background base0)

  ;;;; magit
  ((magit-diff-context &override) :foreground base6 :background bg-alt)
  ((magit-diff-context-highlight &override) :foreground fg :background bg)
  ((magit-diff-added &override) :foreground "#6b8501" :background "#f6f7ef")
  ((magit-diff-removed &override) :foreground "#a44f56" :background "#fbf3f3")
  ((magit-diff-added-highlight &override) :bold nil :foreground "#6b8501" :background "#f6f7ef")
  ((magit-diff-removed-highlight &override) :bold nil :foreground "#a44f56" :background "#fbf3f3")
  ((magit-header-line &override) :box `(:line-width 3 :color ,bg) :foreground fg :background bg)
  (magit-diff-revision-summary-highlight :foreground base8 :background bg-alt :bold nil)
  (magit-diff-revision-summary :foreground base8 :background bg)
  ((magit-diff-hunk-heading &override) :foreground base7 :bold nil)
  ;; (magit-diff-file-heading :foreground fg)
  (magit-tag :foreground orange)

  (diff-refine-added :inverse-video nil :bold t :foreground "#6b8501" :background "#f6f7ef")
  (diff-refine-removed :inverse-video nil :bold t :foreground "#a44f56" :background "#fbf3f3")

  ;;;; doom-modeline
  (doom-modeline-bar :background highlight)
  (doom-modeline-bar-inactive :foreground bg :background bg)
  (doom-modeline-buffer-path :foreground violet :weight 'bold)
  (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)

  (lsp-face-highlight-textual :background base2)

  (tree-sitter-hl-face:property :inherit 'font-lock-constant-face)
  (tree-sitter-hl-face:function.call :foreground fg)

  (eldoc-highlight-function-argument :foreground orange)

  (markdown-code-face :background bg)

  (web-mode-symbol-face :foreground orange)

  ;; ((tooltip &override) :foreground fg :background bg)
  (lsp-posframe :foreground fg :background bg)
  (lsp-posframe-border :foreground border)

  ;;;; corfu
  (corfu-default :background bg)
  (corfu-current :background base2)
  (completions-common-part :foreground blue)
  (completions-first-difference :weight 'normal)

  ;;;; vertico
  (vertico-posframe-border :background border)

  ;;;; flycheck
  (flycheck-error :underline `(:style wave :color ,light-red))
  (flycheck-fringe-error :foreground light-red)
  (flycheck-posframe-background-face :background "#fdfdfd")
  (flycheck-posframe-border-face :foreground border)
  (flycheck-posframe-info-face :inherit 'success)
  (flycheck-posframe-warning-face :foreground orange)
  (flycheck-posframe-error-face :foreground light-red)

  ;;;; mu4e
  (mu4e-highlight-face :inherit nil :foreground blue :weight 'bold)
  ((mu4e-header-highlight-face &override) :underline nil :background base1)
  ((mu4e-unread-face &override) :bold nil)

  ;;;; ivy
  (ivy-current-match :background region :distant-foreground grey :weight 'ultra-bold)
  (ivy-minibuffer-match-face-1 :foreground base5 :weight 'light)
  (ivy-minibuffer-match-face-2 :inherit 'ivy-minibuffer-match-face-1 :foreground violet :weight 'ultra-bold)
  (ivy-minibuffer-match-face-3 :inherit 'ivy-minibuffer-match-face-2 :foreground blue)
  (ivy-minibuffer-match-face-4 :inherit 'ivy-minibuffer-match-face-2 :foreground red)

  ((link &override) :weight 'normal);; :underline t)

  ;;;; org <built-in>
  (org-block :background org-block-bg)
  ;; ((org-block &override)            :background org-block-bg)
  ;; ((org-block-background &override) :background org-block-bg)
  ;; ((org-block-begin-line &override) :background org-block-bg)
  ;; ((org-quote &override)            :background org-block-bg)
  (org-habit-overdue-face :foreground "#eee" :background "#ad353d")
  (org-habit-clear-face :foreground "#eee" :background "#85b861")
  (org-habit-ready-face :foreground "#eee" :background "#6c8e22" :weight 'normal)
  (org-habit-clear-future-face :foreground "#000" :background "#c4dbb5")
  (org-habit-ready-future-face :foreground "#eee" :background "#6c8e22" :weight 'normal)

  ;;;; outline <built-in>
  ((outline-1 &override) :foreground teal :weight 'normal)
  ((outline-2 &override) :foreground blue :weight 'normal)
  ((outline-3 &override) :foreground violet)
  ((outline-4 &override) :foreground blue)
  ((outline-5 &override) :foreground violet)
  ((outline-6 &override) :foreground blue)
  ((outline-7 &override) :foreground violet)
  ((outline-8 &override) :foreground blue)

  ;;;; rainbow-delimiters
  ;; (rainbow-delimiters-depth-1-face :foreground violet)
  ;; (rainbow-delimiters-depth-2-face :foreground blue)
  ;; (rainbow-delimiters-depth-3-face :foreground green)
  ;; (rainbow-delimiters-depth-4-face :foreground magenta)
  ;; (rainbow-delimiters-depth-5-face :foreground orange)
  ;; (rainbow-delimiters-depth-6-face :foreground yellow)
  ;; (rainbow-delimiters-depth-7-face :foreground teal)
  ;; (rainbow-delimiters-depth-8-face :foreground violet)
  ;; (rainbow-delimiters-depth-9-face :foreground blue)
  (rainbow-delimiters-depth-1-face :foreground base7)
  (rainbow-delimiters-depth-2-face :foreground base6)
  (rainbow-delimiters-depth-3-face :foreground base7)
  (rainbow-delimiters-depth-4-face :foreground base6)
  (rainbow-delimiters-depth-5-face :foreground base7)
  (rainbow-delimiters-depth-6-face :foreground base6)
  (rainbow-delimiters-depth-7-face :foreground base7)
  (rainbow-delimiters-depth-8-face :foreground base6)
  (rainbow-delimiters-depth-9-face :foreground base7)

  ;;;; solaire-mode
  (solaire-mode-line-face :inherit 'mode-line :background modeline-bg-alt)
  (solaire-mode-line-inactive-face
   :inherit 'mode-line-inactive
   :background modeline-bg-alt-inactive
   :foreground modeline-fg-alt-inactive)

  ;;;; treemacs
  (treemacs-git-untracked-face :foreground yellow)

  ;;;; whi
  (whitespace-tab :background (doom-lighten base2 0.6)
                  :foreground comments)))
