" AR theme based on Tomorrow Night by http://chriskempson.com

set background=dark
let g:colors_name = "ar"

hi clear
syntax reset

hi link @variable.declaration Variable
hi link @variable.import Variable
hi link @variable Identifier
hi link @type.tsx Type
hi link @type.builtin.tsx Type
hi link @tag.tsx Function
hi link @tag.attribute.tsx Variable
hi link @tag.delimiter.tsx Function

hi link @function.builtin.ruby Function
" hi link @function.call.ruby Identifier
hi link @variable.member.ruby Variable

hi link @markup.raw.block.slim Identifier

" Vim Highlighting
hi NormalNC ctermbg=234
hi LineNr ctermfg=240
hi NonText ctermfg=240
"call <SID>X("SpecialKey", s:selection, "", "")
hi Search ctermfg=7 ctermbg=235
"call <SID>X("TabLine", s:window, s:foreground, "reverse")
"call <SID>X("TabLineFill", s:window, s:foreground, "reverse")
hi StatusLine ctermbg=235 cterm=none
hi StatusLineNC ctermbg=238 cterm=none
"call <SID>X("VertSplit", s:line, s:line, "none")
hi WinSeparator ctermfg=239 ctermbg=235 cterm=none
hi Visual ctermfg=none ctermbg=237
hi Directory ctermfg=4
"call <SID>X("ModeMsg", s:green, "", "")
"call <SID>X("MoreMsg", s:green, "", "")
"call <SID>X("Question", s:green, "", "")
"call <SID>X("WarningMsg", s:red, "", "")
hi MatchParen ctermbg=237 cterm=none
"call <SID>X("Folded", s:comment, s:background, "")
"call <SID>X("FoldColumn", "", s:background, "")
if version >= 700
  hi CursorLine ctermbg=235
  hi CursorLineNr ctermfg=7 cterm=none
  hi CursorColumn ctermbg=235 cterm=none
  hi PMenu ctermbg=233 cterm=none
  hi PMenuSel ctermbg=236 cterm=none
  hi PMenuKind ctermfg=4
  hi PMenuKindSel ctermfg=4
  hi PMenuMatch ctermfg=4 cterm=none
  hi PMenuMatchSel ctermfg=4 cterm=none
  hi PMenuExtra ctermfg=240 cterm=none
  hi PMenuExtraSel ctermfg=240 ctermbg=236 cterm=none
  "hi NormalFloat ctermfg=249 ctermbg=0
  hi NormalFloat ctermfg=7 ctermbg=0
  hi FloatBorder ctermfg=240
  hi SignColumn ctermbg=none
end
if version >= 703
  hi ColorColumn ctermbg=235 cterm=none
end

" Standard Highlighting
hi Comment ctermfg=243
"call <SID>X("Todo", s:comment, s:background, "")
"call <SID>X("Title", s:comment, "", "")
"call <SID>X("Delimiter", s:base7, "", "none")
hi Identifier ctermfg=7
hi Variable ctermfg=1
hi @variable ctermfg=7
hi Statement ctermfg=5 cterm=none
"call <SID>X("Conditional", s:foreground, "", "")
"call <SID>X("Repeat", s:foreground, "", "")
"call <SID>X("Structure", s:purple, "", "")
hi Function ctermfg=4
hi Constant ctermfg=179
hi Keyword ctermfg=5
hi String ctermfg=2
hi Special ctermfg=179 "ctermfg=4
"call <SID>X("PreProc", s:purple, "", "")
"call <SID>X("Operator", s:base7, "", "none")
hi Type ctermfg=3
"call <SID>X("Define", s:purple, "", "none")
"call <SID>X("Include", s:blue, "", "")
" call <SID>X("Ignore", "666666", "", "")

"hi CmpItemKindDefault ctermfg=4

"hi MiniStatuslineModeNormal ctermfg=235 ctermbg=4
"hi MiniStatuslineModeInsert ctermfg=235 ctermbg=2
"hi MiniStatuslineModeVisual ctermfg=235 ctermbg=5
"hi MiniStatuslineModeReplace ctermfg=235 ctermbg=3
"hi MiniStatuslineModeCommand ctermfg=235 ctermbg=4
"hi MiniStatuslineModeOther ctermfg=235 ctermbg=1

hi DiagnosticWarn ctermfg=179
hi DiagnosticInfo ctermfg=247
hi DiagnosticHint ctermfg=240
hi DiagnosticVirtualTextError ctermfg=245
hi DiagnosticVirtualTextWarn ctermfg=245
hi DiagnosticVirtualTextInfo ctermfg=245
hi DiagnosticVirtualTextHint ctermfg=245

"hi DevIconDefault ctermfg=179

"hi FzfLuaGutter ctermbg=0
"hi FzfLuaPrompt ctermfg=243
"hi FzfLuaSelection ctermfg=7
"hi FzfLuaMatching ctermfg=9

"hi SnacksPickerInput ctermfg=7
hi SnacksPickerDir ctermfg=247
"hi SnacksPickerFile ctermfg=7
"hi SnacksPickerPathIgored ctermfg=247
"hi SnacksPickerPathHidden ctermfg=247

hi NeogitRemote ctermfg=2
"hi NeogitBranch ctermfg=12 cterm=none
hi NeogitBranch ctermfg=4 cterm=none
hi NeogitBranchHead ctermfg=4 cterm=bold
hi NeogitTagName ctermfg=179

hi NeogitGraphAuthor ctermfg=3
hi NeogitGraphRed ctermfg=1
hi NeogitGraphWhite ctermfg=7
hi NeogitGraphYellow ctermfg=3
hi NeogitGraphGreen ctermfg=2
hi NeogitGraphCyan ctermfg=6
hi NeogitGraphBlue ctermfg=4
hi NeogitGraphPurple ctermfg=5
hi NeogitGraphGray ctermfg=7
hi NeogitGraphOrange ctermfg=3
hi NeogitGraphBoldOrange ctermfg=3
hi NeogitGraphBoldRed ctermfg=1
hi NeogitGraphBoldWhite ctermfg=7
hi NeogitGraphBoldYellow ctermfg=3
hi NeogitGraphBoldGreen ctermfg=2
hi NeogitGraphBoldCyan ctermfg=6
hi NeogitGraphBoldBlue ctermfg=4
hi NeogitGraphBoldPurple ctermfg=5
hi NeogitGraphBoldGray ctermfg=7

hi NeogitHunkMergeHeader ctermfg=4
hi NeogitHunkMergeHeaderHighlight ctermfg=4
hi NeogitHunkMergeHeaderCursor ctermfg=4
hi NeogitHunkHeader ctermfg=3 ctermbg=236
hi NeogitHunkHeaderHighlight ctermfg=3 ctermbg=236
hi NeogitHunkHeaderCursor ctermfg=3

hi NeogitDiffContext ctermbg=233
"hi NeogitDiffContextHighlight ctermbg=0
"hi NeogitDiffContextCursor ctermbg=0

hi NeogitDiffAdditions ctermfg=10
hi NeogitDiffAdd ctermfg=2 ctermbg=233
hi NeogitDiffAddHighlight ctermfg=2
hi NeogitDiffAddCursor ctermfg=2
hi NeogitDiffDeletions ctermfg=9
hi NeogitDiffDelete ctermfg=1 ctermbg=233
hi NeogitDiffDeleteHighlight ctermfg=1
hi NeogitDiffDeleteCursor ctermfg=1

" Vim Highlighting
"call <SID>X("vimCommand", s:red, "", "none")

" Default GUI Colours
"if &background == "light"
"  let s:foreground = "111111"
"  let s:background = "ffffff"
"  let s:bg_alt = "fbfbfb"
"  let s:base1 = "fcfcfc"
"  let s:base4 = "c0bfbf"
"  let s:base5 = "c0bfbf"
"  let s:selection = "f0f0f0"
"  let s:line = "f9f9f9"
"  let s:comment = "8e908c"
"  let s:red = "723f43"
"  let s:orange = "b27200"
"  let s:yellow = "a68a00"
"  let s:green = "6b8501"
"  let s:aqua = "111111"
"  let s:blue = "111166"
"  let s:purple = "661166"
"  let s:window = "f2f2f2"
"else
"  let s:foreground = "c5c8c6"
"  let s:background = "161719"
"  let s:bg_alt = "1b1b1b"
"  let s:base1 = "212122" " cterm 235
"  let s:base4 = "3f4040"
"  let s:base5 = "5c5e5e"
"  let s:base6 = "757878"
"  let s:base7 = "969896"
"  let s:selection = "333535"
"  let s:line = "282a2e"
"  let s:comment = "5a5b5a"
"  let s:red = "dac1c1"
"  let s:orange = "de935f"
"  let s:yellow = "f0c674"
"  let s:green = "b5bd68"
"  let s:aqua = "8abeb7"
"  let s:blue = "b0b8bf"
"  let s:purple = "b294bb"
"  let s:window = "373b41"
"endif


"if has("gui_running") || &t_Co == 88 || &t_Co == 256
"	" Returns an approximate grey index for the given grey level
"	fun <SID>grey_number(x)
"		if &t_Co == 88
"			if a:x < 23
"				return 0
"			elseif a:x < 69
"				return 1
"			elseif a:x < 103
"				return 2
"			elseif a:x < 127
"				return 3
"			elseif a:x < 150
"				return 4
"			elseif a:x < 173
"				return 5
"			elseif a:x < 196
"				return 6
"			elseif a:x < 219
"				return 7
"			elseif a:x < 243
"				return 8
"			else
"				return 9
"			endif
"		else
"			if a:x < 14
"				return 0
"			else
"				let l:n = (a:x - 8) / 10
"				let l:m = (a:x - 8) % 10
"				if l:m < 5
"					return l:n
"				else
"					return l:n + 1
"				endif
"			endif
"		endif
"	endfun
"
"	" Returns the actual grey level represented by the grey index
"	fun <SID>grey_level(n)
"		if &t_Co == 88
"			if a:n == 0
"				return 0
"			elseif a:n == 1
"				return 46
"			elseif a:n == 2
"				return 92
"			elseif a:n == 3
"				return 115
"			elseif a:n == 4
"				return 139
"			elseif a:n == 5
"				return 162
"			elseif a:n == 6
"				return 185
"			elseif a:n == 7
"				return 208
"			elseif a:n == 8
"				return 231
"			else
"				return 255
"			endif
"		else
"			if a:n == 0
"				return 0
"			else
"				return 8 + (a:n * 10)
"			endif
"		endif
"	endfun
"
"	" Returns the palette index for the given grey index
"	fun <SID>grey_colour(n)
"		if &t_Co == 88
"			if a:n == 0
"				return 16
"			elseif a:n == 9
"				return 79
"			else
"				return 79 + a:n
"			endif
"		else
"			if a:n == 0
"				return 16
"			elseif a:n == 25
"				return 231
"			else
"				return 231 + a:n
"			endif
"		endif
"	endfun
"
"	" Returns an approximate colour index for the given colour level
"	fun <SID>rgb_number(x)
"		if &t_Co == 88
"			if a:x < 69
"				return 0
"			elseif a:x < 172
"				return 1
"			elseif a:x < 230
"				return 2
"			else
"				return 3
"			endif
"		else
"			if a:x < 75
"				return 0
"			else
"				let l:n = (a:x - 55) / 40
"				let l:m = (a:x - 55) % 40
"				if l:m < 20
"					return l:n
"				else
"					return l:n + 1
"				endif
"			endif
"		endif
"	endfun
"
"	" Returns the actual colour level for the given colour index
"	fun <SID>rgb_level(n)
"		if &t_Co == 88
"			if a:n == 0
"				return 0
"			elseif a:n == 1
"				return 139
"			elseif a:n == 2
"				return 205
"			else
"				return 255
"			endif
"		else
"			if a:n == 0
"				return 0
"			else
"				return 55 + (a:n * 40)
"			endif
"		endif
"	endfun
"
"	" Returns the palette index for the given R/G/B colour indices
"	fun <SID>rgb_colour(x, y, z)
"		if &t_Co == 88
"			return 16 + (a:x * 16) + (a:y * 4) + a:z
"		else
"			return 16 + (a:x * 36) + (a:y * 6) + a:z
"		endif
"	endfun
"
"	" Returns the palette index to approximate the given R/G/B colour levels
"	fun <SID>colour(r, g, b)
"		" Get the closest grey
"		let l:gx = <SID>grey_number(a:r)
"		let l:gy = <SID>grey_number(a:g)
"		let l:gz = <SID>grey_number(a:b)
"
"		" Get the closest colour
"		let l:x = <SID>rgb_number(a:r)
"		let l:y = <SID>rgb_number(a:g)
"		let l:z = <SID>rgb_number(a:b)
"
"		if l:gx == l:gy && l:gy == l:gz
"			" There are two possibilities
"			let l:dgr = <SID>grey_level(l:gx) - a:r
"			let l:dgg = <SID>grey_level(l:gy) - a:g
"			let l:dgb = <SID>grey_level(l:gz) - a:b
"			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
"			let l:dr = <SID>rgb_level(l:gx) - a:r
"			let l:dg = <SID>rgb_level(l:gy) - a:g
"			let l:db = <SID>rgb_level(l:gz) - a:b
"			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
"			if l:dgrey < l:drgb
"				" Use the grey
"				return <SID>grey_colour(l:gx)
"			else
"				" Use the colour
"				return <SID>rgb_colour(l:x, l:y, l:z)
"			endif
"		else
"			" Only one possibility
"			return <SID>rgb_colour(l:x, l:y, l:z)
"		endif
"	endfun
"
"	" Returns the palette index to approximate the 'rrggbb' hex string
"	fun <SID>rgb(rgb)
"		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
"		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
"		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0
"
"		return <SID>colour(l:r, l:g, l:b)
"	endfun
"
"	" Sets the highlighting for the given group
"	fun <SID>X(group, fg, bg, attr)
"		if a:fg != ""
"			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
"		endif
"		if a:bg != ""
"			exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
"		endif
"		if a:attr != ""
"			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
"		endif
"	endfun


	" C Highlighting
	"call <SID>X("cType", s:yellow, "", "")
	"hi cType ctermfg=11
	"call <SID>X("cStorageClass", s:purple, "", "")
	"call <SID>X("cConditional", s:purple, "", "")
	"call <SID>X("cRepeat", s:purple, "", "")
	"
	"" PHP Highlighting
	"call <SID>X("phpVarSelector", s:red, "", "")
	"call <SID>X("phpKeyword", s:purple, "", "")
	"call <SID>X("phpRepeat", s:purple, "", "")
	"call <SID>X("phpConditional", s:purple, "", "")
	"call <SID>X("phpStatement", s:purple, "", "")
	"call <SID>X("phpMemberSelector", s:foreground, "", "")
	"
	"" Ruby Highlighting
	"call <SID>X("rubySymbol", s:green, "", "")
	"call <SID>X("rubyConstant", s:yellow, "", "")
	"call <SID>X("rubyAccess", s:yellow, "", "")
	"call <SID>X("rubyAttribute", s:blue, "", "")
	"call <SID>X("rubyInclude", s:blue, "", "")
	"call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
	"call <SID>X("rubyCurlyBlock", s:orange, "", "")
	"call <SID>X("rubyStringDelimiter", s:green, "", "")
	"call <SID>X("rubyInterpolationDelimiter", s:orange, "", "")
	"call <SID>X("rubyConditional", s:purple, "", "")
	"call <SID>X("rubyRepeat", s:purple, "", "")
	"call <SID>X("rubyControl", s:purple, "", "")
	"call <SID>X("rubyException", s:purple, "", "")
	"
	"" Crystal Highlighting
	"call <SID>X("crystalSymbol", s:green, "", "")
	"call <SID>X("crystalConstant", s:yellow, "", "")
	"call <SID>X("crystalAccess", s:yellow, "", "")
	"call <SID>X("crystalAttribute", s:blue, "", "")
	"call <SID>X("crystalInclude", s:blue, "", "")
	"call <SID>X("crystalLocalVariableOrMethod", s:orange, "", "")
	"call <SID>X("crystalCurlyBlock", s:orange, "", "")
	"call <SID>X("crystalStringDelimiter", s:green, "", "")
	"call <SID>X("crystalInterpolationDelimiter", s:orange, "", "")
	"call <SID>X("crystalConditional", s:purple, "", "")
	"call <SID>X("crystalRepeat", s:purple, "", "")
	"call <SID>X("crystalControl", s:purple, "", "")
	"call <SID>X("crystalException", s:purple, "", "")
	"
	"" Python Highlighting
	"call <SID>X("pythonInclude", s:purple, "", "")
	"call <SID>X("pythonStatement", s:purple, "", "")
	"call <SID>X("pythonConditional", s:purple, "", "")
	"call <SID>X("pythonRepeat", s:purple, "", "")
	"call <SID>X("pythonException", s:purple, "", "")
	"call <SID>X("pythonFunction", s:blue, "", "")
	"call <SID>X("pythonPreCondit", s:purple, "", "")
	"call <SID>X("pythonRepeat", s:aqua, "", "")
	"call <SID>X("pythonExClass", s:orange, "", "")
	"
	"" JavaScript Highlighting
	"call <SID>X("javaScriptBraces", s:foreground, "", "")
	"call <SID>X("javaScriptFunction", s:purple, "", "")
	"call <SID>X("javaScriptConditional", s:purple, "", "")
	"call <SID>X("javaScriptRepeat", s:purple, "", "")
	"call <SID>X("javaScriptNumber", s:orange, "", "")
	"call <SID>X("javaScriptMember", s:orange, "", "")
	"call <SID>X("javascriptNull", s:orange, "", "")
	"call <SID>X("javascriptGlobal", s:blue, "", "")
	"call <SID>X("javascriptStatement", s:red, "", "")
	"
	"" CoffeeScript Highlighting
	"call <SID>X("coffeeRepeat", s:purple, "", "")
	"call <SID>X("coffeeConditional", s:purple, "", "")
	"call <SID>X("coffeeKeyword", s:purple, "", "")
	"call <SID>X("coffeeObject", s:yellow, "", "")
	"
	"" HTML Highlighting
	"call <SID>X("htmlTag", s:red, "", "")
	"call <SID>X("htmlTagName", s:red, "", "")
	"call <SID>X("htmlArg", s:red, "", "")
	"call <SID>X("htmlScriptTag", s:red, "", "")
	"
	"" Diff Highlighting
	"call <SID>X("diffAdd", "", "4c4e39", "")
	"call <SID>X("diffDelete", s:background, s:red, "")
	"call <SID>X("diffChange", "", "2B5B77", "")
	"call <SID>X("diffText", s:line, s:blue, "")
	"
	"" ShowMarks Highlighting
	"call <SID>X("ShowMarksHLl", s:orange, s:background, "none")
	"call <SID>X("ShowMarksHLo", s:purple, s:background, "none")
	"call <SID>X("ShowMarksHLu", s:yellow, s:background, "none")
	"call <SID>X("ShowMarksHLm", s:aqua, s:background, "none")
	"
	"" Lua Highlighting
	"call <SID>X("luaStatement", s:purple, "", "")
	"call <SID>X("luaRepeat", s:purple, "", "")
	"call <SID>X("luaCondStart", s:purple, "", "")
	"call <SID>X("luaCondElseif", s:purple, "", "")
	"call <SID>X("luaCond", s:purple, "", "")
	"call <SID>X("luaCondEnd", s:purple, "", "")
	"
	"" Cucumber Highlighting
	"call <SID>X("cucumberGiven", s:blue, "", "")
	"call <SID>X("cucumberGivenAnd", s:blue, "", "")
	"
	"" Go Highlighting
	"call <SID>X("goDirective", s:purple, "", "")
	"call <SID>X("goDeclaration", s:purple, "", "")
	"call <SID>X("goStatement", s:purple, "", "")
	"call <SID>X("goConditional", s:purple, "", "")
	"call <SID>X("goConstants", s:orange, "", "")
	"call <SID>X("goTodo", s:yellow, "", "")
	"call <SID>X("goDeclType", s:blue, "", "")
	"call <SID>X("goBuiltins", s:purple, "", "")
	"call <SID>X("goRepeat", s:purple, "", "")
	"call <SID>X("goLabel", s:purple, "", "")
	"
	"" Clojure Highlighting
	"call <SID>X("clojureConstant", s:orange, "", "")
	"call <SID>X("clojureBoolean", s:orange, "", "")
	"call <SID>X("clojureCharacter", s:orange, "", "")
	"call <SID>X("clojureKeyword", s:green, "", "")
	"call <SID>X("clojureNumber", s:orange, "", "")
	"call <SID>X("clojureString", s:green, "", "")
	"call <SID>X("clojureRegexp", s:green, "", "")
	"call <SID>X("clojureParen", s:aqua, "", "")
	"call <SID>X("clojureVariable", s:yellow, "", "")
	"call <SID>X("clojureCond", s:blue, "", "")
	"call <SID>X("clojureDefine", s:purple, "", "")
	"call <SID>X("clojureException", s:red, "", "")
	"call <SID>X("clojureFunc", s:blue, "", "")
	"call <SID>X("clojureMacro", s:blue, "", "")
	"call <SID>X("clojureRepeat", s:blue, "", "")
	"call <SID>X("clojureSpecial", s:purple, "", "")
	"call <SID>X("clojureQuote", s:blue, "", "")
	"call <SID>X("clojureUnquote", s:blue, "", "")
	"call <SID>X("clojureMeta", s:blue, "", "")
	"call <SID>X("clojureDeref", s:blue, "", "")
	"call <SID>X("clojureAnonArg", s:blue, "", "")
	"call <SID>X("clojureRepeat", s:blue, "", "")
	"call <SID>X("clojureDispatch", s:blue, "", "")
	"
	"" Scala Highlighting
	"call <SID>X("scalaKeyword", s:purple, "", "")
	"call <SID>X("scalaKeywordModifier", s:purple, "", "")
	"call <SID>X("scalaOperator", s:blue, "", "")
	"call <SID>X("scalaPackage", s:red, "", "")
	"call <SID>X("scalaFqn", s:foreground, "", "")
	"call <SID>X("scalaFqnSet", s:foreground, "", "")
	"call <SID>X("scalaImport", s:purple, "", "")
	"call <SID>X("scalaBoolean", s:orange, "", "")
	"call <SID>X("scalaDef", s:purple, "", "")
	"call <SID>X("scalaVal", s:purple, "", "")
	"call <SID>X("scalaVar", s:aqua, "", "")
	"call <SID>X("scalaClass", s:purple, "", "")
	"call <SID>X("scalaObject", s:purple, "", "")
	"call <SID>X("scalaTrait", s:purple, "", "")
	"call <SID>X("scalaDefName", s:blue, "", "")
	"call <SID>X("scalaValName", s:foreground, "", "")
	"call <SID>X("scalaVarName", s:foreground, "", "")
	"call <SID>X("scalaClassName", s:foreground, "", "")
	"call <SID>X("scalaType", s:yellow, "", "")
	"call <SID>X("scalaTypeSpecializer", s:yellow, "", "")
	"call <SID>X("scalaAnnotation", s:orange, "", "")
	"call <SID>X("scalaNumber", s:orange, "", "")
	"call <SID>X("scalaDefSpecializer", s:yellow, "", "")
	"call <SID>X("scalaClassSpecializer", s:yellow, "", "")
	"call <SID>X("scalaBackTick", s:green, "", "")
	"call <SID>X("scalaRoot", s:foreground, "", "")
	"call <SID>X("scalaMethodCall", s:blue, "", "")
	"call <SID>X("scalaCaseType", s:yellow, "", "")
	"call <SID>X("scalaLineComment", s:comment, "", "")
	"call <SID>X("scalaComment", s:comment, "", "")
	"call <SID>X("scalaDocComment", s:comment, "", "")
	"call <SID>X("scalaDocTags", s:comment, "", "")
	"call <SID>X("scalaEmptyString", s:green, "", "")
	"call <SID>X("scalaMultiLineString", s:green, "", "")
	"call <SID>X("scalaUnicode", s:orange, "", "")
	"call <SID>X("scalaString", s:green, "", "")
	"call <SID>X("scalaStringEscape", s:green, "", "")
	"call <SID>X("scalaSymbol", s:orange, "", "")
	"call <SID>X("scalaChar", s:orange, "", "")
	"call <SID>X("scalaXml", s:green, "", "")
	"call <SID>X("scalaConstructorSpecializer", s:yellow, "", "")
	"call <SID>X("scalaBackTick", s:blue, "", "")
	"
	"" Git
	"call <SID>X("diffAdded", s:green, "", "")
	"call <SID>X("diffRemoved", s:red, "", "")
	"call <SID>X("gitcommitSummary", "", "", "bold")

	" Delete Functions
"	delf <SID>X
"	delf <SID>rgb
"	delf <SID>colour
"	delf <SID>rgb_colour
"	delf <SID>rgb_level
"	delf <SID>rgb_number
"	delf <SID>grey_colour
"	delf <SID>grey_level
"	delf <SID>grey_number
"endif
