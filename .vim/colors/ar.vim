" Vim color scheme

hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "AR"

if &background == "light"
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
  hi VertSplit                 ctermfg=10 ctermbg=none cterm=none
  hi CursorLineNr              ctermfg=0 ctermbg=13 cterm=none
  hi ColorColumn               ctermbg=13

  hi SignColumn ctermfg=14 ctermbg=7

  hi ALEError ctermbg=203
  hi ALEErrorSign ctermfg=203
  hi ALEErrorSignLineNr ctermfg=203
  hi ALEStyleError ctermbg=203
  hi ALEStyleErrorSign ctermfg=203
  hi ALEWarning ctermbg=230
  hi ALEWarningSign ctermfg=178
  hi ALEWarningSignLineNr ctermfg=178
  hi ALEStyleWarning ctermbg=203
  hi ALEStyleWarningSign ctermfg=203
  hi ALEStyleWarningSignLineNr ctermfg=203
  hi ALEInfo ctermbg=203
  hi ALEInfoSign ctermfg=203
  hi ALEInfoSignLineNr ctermfg=203
  hi ALESignColumnWithErrors ctermbg=203

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
else
  hi Normal         ctermfg=white ctermbg=234
  hi Cursor         ctermfg=0 ctermbg=250
  hi CursorLine     ctermbg=235 cterm=NONE
  hi CursorLineNr   ctermfg=248 ctermbg=235 cterm=NONE
  hi Search         ctermfg=NONE ctermbg=236 cterm=underline
  hi Visual         ctermbg=60
  hi LineNr         ctermfg=242
  hi StatusLine     cterm=NONE ctermfg=2 ctermbg=0
  hi StatusLineNC   cterm=NONE ctermfg=8 ctermbg=0
  hi User1          cterm=reverse ctermfg=2 ctermbg=0
  hi User3          cterm=reverse ctermfg=2 ctermbg=0
  hi User2          ctermfg=2 ctermbg=0
  hi VertSplit      ctermfg=250 ctermbg=none cterm=none
  hi ColorColumn    ctermbg=235

  hi SignColumn ctermfg=242 ctermbg=234

  hi ALEError ctermbg=203
  hi ALEErrorSign ctermfg=203
  hi ALEErrorSignLineNr ctermfg=203
  hi ALEStyleError ctermbg=203
  hi ALEStyleErrorSign ctermfg=203
  hi ALEWarning ctermbg=203
  hi ALEWarningSign ctermfg=203
  hi ALEWarningSignLineNr ctermfg=203
  hi ALEStyleWarning ctermbg=203
  hi ALEStyleWarningSign ctermfg=203
  hi ALEStyleWarningSignLineNr ctermfg=203
  hi ALEInfo ctermbg=203
  hi ALEInfoSign ctermfg=203
  hi ALEInfoSignLineNr ctermfg=203
  hi ALESignColumnWithErrors ctermbg=203

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
  hi Pmenu                     guifg=#F6F3E8 guibg=#444444 gui=NONE ctermfg=white ctermbg=234
  " selected item in popup
  hi PmenuSel                  guifg=#000000 guibg=#A5C261 gui=NONE ctermfg=234 ctermbg=2
  " scrollbar in popup
  hi PMenuSbar                 guibg=#5A647E gui=NONE
  " thumb of the scrollbar in the popup
  hi PMenuThumb                guibg=#AAAAAA gui=NONE


  "rubyComment
  hi Comment                   guifg=#BC9458 gui=italic ctermfg=137
  hi Todo                      guifg=#BC9458 guibg=NONE gui=italic ctermfg=94

  "rubyPseudoVariable
  "nil, self, symbols, etc
  hi Constant                  guifg=#6D9CBE ctermfg=73

  "rubyClass, rubyModule, rubyDefine
  "def, end, include, etc
  hi Define                    guifg=#CC7833 ctermfg=173

  "rubyInterpolation
  hi Delimiter                 guifg=#519F50

  "rubyError, rubyInvalidVariable
  hi Error                     guifg=#FFFFFF guibg=#990000 ctermfg=221 ctermbg=88

  "rubyFunction
  hi Function                  guifg=#FFC66D gui=NONE ctermfg=221 cterm=NONE

  "rubyIdentifier
  "@var, @@var, $var, etc
  hi Identifier                guifg=#D0D0FF gui=NONE ctermfg=73 cterm=NONE

  "rubyInclude
  "include, autoload, extend, load, require
  hi Include                   guifg=#CC7833 gui=NONE ctermfg=173 cterm=NONE

  "rubyKeyword, rubyKeywordAsMethod
  "alias, undef, super, yield, callcc, caller, lambda, proc
  hi Keyword                   guifg=#CC7833 ctermfg=172 cterm=NONE

  " same as define
  hi Macro                     guifg=#CC7833 gui=NONE ctermfg=172

  "rubyInteger
  hi Number                    guifg=#A5C261 ctermfg=107

  " #if, #else, #endif
  hi PreCondit                 guifg=#CC7833 gui=NONE ctermfg=172 cterm=NONE

  " generic preprocessor
  hi PreProc                   guifg=#CC7833 gui=NONE ctermfg=103

  "rubyControl, rubyAccess, rubyEval
  "case, begin, do, for, if unless, while, until else, etc.
  hi Statement                 guifg=#CC7833 gui=NONE ctermfg=172 cterm=NONE

  "rubyString
  hi String                    guifg=#A5C261 ctermfg=107

  hi Title                     guifg=#FFFFFF ctermfg=15

  "rubyConstant
  hi Type                      guifg=#DA4939 gui=NONE ctermfg=167 cterm=NONE

  hi DiffAdd                   guifg=#A5C261 guibg=NONE ctermfg=34 ctermbg=NONE
  hi DiffDelete                guifg=#DA4939 guibg=NONE ctermfg=124 ctermbg=NONE
  hi diffFile                  guifg=#FFFFFF guibg=#6D9CBE ctermfg=15 ctermbg=26
  hi link diffAdded DiffAdd
  hi link diffRemoved DiffDelete

  hi link htmlTag              xmlTag
  hi link htmlTagName          xmlTagName
  hi link htmlEndTag           xmlEndTag

  hi xmlTag                    guifg=#E8BF6A
  hi xmlTagName                guifg=#E8BF6A
  hi xmlEndTag                 guifg=#E8BF6A
endif
