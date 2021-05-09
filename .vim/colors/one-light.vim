" Vim color scheme

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "one-light"

hi Normal                    ctermfg=0 ctermbg=7
hi Cursor                    ctermfg=0 ctermbg=15	
hi CursorLine                ctermbg=13 cterm=none
hi Search                    ctermfg=none ctermbg=15 cterm=underline
hi Visual                    ctermbg=15
hi LineNr                    ctermfg=14 cterm=none
hi StatusLine                ctermfg=7 ctermbg=10 cterm=none
hi StatusLineNC              ctermfg=15 ctermbg=10 cterm=none
hi User1                     ctermfg=10 ctermbg=14 cterm=none
hi User2                     ctermfg=14 ctermbg=10 cterm=none
hi User3                     ctermfg=7 ctermbg=14 cterm=none
hi VertSplit                 ctermfg=10 ctermbg=10 cterm=none
hi CursorLineNr              ctermfg=0 ctermbg=13 cterm=none
hi ColorColumn               ctermbg=13

" Folds
" -----
" line used for closed folds
hi Folded                    guifg=#F6F3E8 guibg=#444444 gui=NONE

" Invisible Characters
" ------------------
hi NonText                   guifg=#777777 gui=NONE
hi SpecialKey                guifg=#777777 gui=NONE

" Misc
" ----
" directory names and other special names in listings
hi Directory                 guifg=#A5C261 gui=NONE

" Popup Menu
" ----------
" normal item in popup
hi Pmenu                     ctermfg=0 ctermbg=13
" selected item in popup
hi PmenuSel                  ctermfg=0 ctermbg=15
" scrollbar in popup
hi PMenuSbar                 guibg=#5A647E gui=NONE
" thumb of the scrollbar in the popup
hi PMenuThumb                guibg=#AAAAAA gui=NONE


"rubyComment
hi Comment                   ctermfg=14
hi Todo                      ctermfg=12 ctermbg=15

"rubyPseudoVariable
"nil, self, symbols, etc
hi Constant                  ctermfg=4

"rubyClass, rubyModule, rubyDefine
"def, end, include, etc
hi Define                    ctermfg=3

"rubyInterpolation
hi Delimiter                 ctermfg=none

"rubyError, rubyInvalidVariable
hi Error                     ctermfg=1 ctermbg=203

"rubyFunction
hi Function                  ctermfg=11 cterm=none

"rubyIdentifier
"@var, @@var, $var, etc
hi Identifier                ctermfg=6 cterm=none

"rubyInclude
"include, autoload, extend, load, require
hi Include                   ctermfg=3 cterm=none

"rubyKeyword, rubyKeywordAsMethod
"alias, undef, super, yield, callcc, caller, lambda, proc
hi Keyword                   ctermfg=3 cterm=none

" same as define
hi Macro                     ctermfg=4

"rubyInteger
hi Number                    ctermfg=2

" #if, #else, #endif
hi PreCondit                 ctermfg=4 cterm=none

" generic preprocessor
hi PreProc                   ctermfg=4

"rubyControl, rubyAccess, rubyEval
"case, begin, do, for, if unless, while, until else, etc.
hi Statement                 ctermfg=3 cterm=none

"rubyString
hi String                    ctermfg=2

hi Title                     ctermfg=4

"rubyConstant
hi Type                      ctermfg=1 cterm=none


hi DiffAdd                   ctermfg=34 ctermbg=none
hi DiffDelete                ctermfg=124 ctermbg=none
hi diffFile                  ctermfg=12 ctermbg=none
hi link diffAdded DiffAdd
hi link diffRemoved DiffDelete

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag

" hi xmlTag                    ctermfg=4
" hi xmlTagName                ctermfg=4
" hi xmlEndTag                 ctermfg=4
