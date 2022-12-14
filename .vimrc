let mapleader = ","
let g:mapleader = ","

let g:fireplace_no_maps = 1
let g:NERDCreateDefaultMappings = 0

set nocompatible

" allow unsaved background buffers and remember marks/undo for them
set hidden

set number
set numberwidth=5
set ruler
syntax on
set statusline=%1*%3*\ %<%f\ %*%2*%*\ %h%m%r%=\ %l,%c%V\ \ %P

set encoding=utf-8

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn
set wildignore+=vendor/gems/*,vendor/ruby/**,**/bower_components/**,**/node_modules/**,**/tmp/**

" Status bar
set laststatus=2

" highlight current line
set cursorline
set colorcolumn=81

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
" set noequalalways

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

call pathogen#infect()

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
set t_Co=256

" if $ITERM_PROFILE == "Dark"
if filereadable(expand("~/.light"))
  set background=light
else
  set background=dark
end
color AR

set fillchars+=vert:│

" https://groups.google.com/forum/#!msg/vim_dev/r3CPPl6AVRM/wCgbD4PU5NAJ
set timeout timeoutlen=1000 ttimeoutlen=100

" Directories for swp files
set nobackup
set nowritebackup
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Show (partial) command in the status line
set showcmd

set autoread
set nojoinspaces

" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
" set re=1

augroup vimrcEx
  au!

  " Remember last location in file
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

  au FileType text setlocal textwidth=80

  au BufRead,BufNewFile *.rabl set ft=ruby
  au BufNewFile,BufRead *.json set ft=javascript
  au BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:&gt;
  au BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:&gt;

  au FileType python,c,cpp,objc,go set et ts=4 sw=4 sts=4
  au FileType clojure set iskeyword-=/

  " Don't syntax highlight markdown because it's often wrong
  au! FileType mkd setlocal syn=off

  au BufNewfile,BufRead *.tsx set ft=typescript.tsx
  au BufNewfile,BufRead *.jsx set ft=javascript.jsx
augroup END

" disable arrow keys
nnoremap   <Up>     <NOP>
nnoremap   <Down>   <NOP>
nnoremap   <Left>   <NOP>
nnoremap   <Right>  <NOP>
inoremap   <Up>     <NOP>
inoremap   <Down>   <NOP>
inoremap   <Left>   <NOP>
inoremap   <Right>  <NOP>
vnoremap   <Up>     <NOP>
vnoremap   <Down>   <NOP>
vnoremap   <Left>   <NOP>
vnoremap   <Right>  <NOP>

map <leader>y "*y
map <leader>н "*y
map <leader>p "*p
map <leader>з "*p
map <leader>rt :!ctags --extra=+f --exclude=.git --exclude=log --exclude=tmp -R *<CR><CR>
map <leader>/ <plug>NERDCommenterToggle
map <leader>i :w\|:!reload-safari<CR><CR>
vmap > >gv
vmap < <gv
nnoremap <leader><leader> <c-^>

let g:NERDSpaceDelims = 1
let g:CommandTBackspaceMap = ['<BS>', '<C-h>']
let g:CommandTCursorLeftMap = ['<Left>', '<C-b>']
let g:CommandTCursorRightMap = ['<Right>', '<C-f>']

" calculations
function! MyCalc(str)
  return system("echo 'scale=2 ; print " . a:str . "' | bc -l")
endfunction
map <silent> <leader>= :s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
vmap <silent> <leader>= :s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
command! -nargs=+ MyCalc :echo MyCalc("<args>")

" %:h alias
cnoremap <expr> %% expand('%:h').'/'
nnoremap <leader>d :e %:h<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SelectaCommand(choice_command, selecta_args, vim_command)
  let res_file = tempname()
  let command = a:choice_command . " | fzf --no-height > " . res_file
  silent! !clear 2> /dev/null
  exec "silent !" . command
  " call system(printf('tput cup %d > /dev/tty; %s < /dev/tty 2> /dev/tty', height, command))
  redraw!
  let selection = readfile(res_file)

  if len(selection) > 0
    exec a:vim_command . " " . selection[0]
  endif

  " try
  "   let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  " catch /Vim:Interrupt/
  "   " Swallow the ^C so that the redraw below happens; otherwise there will be
  "   " leftovers from selecta on the screen
  "   redraw!
  "   return
  " endtry
  " redraw!
  " exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand("fd -t f -E '*.gif' " . a:path, "", ":e")
endfunction

function! SelectaNodeModule(path)
  let command = "find " . a:path . "/node_modules -type d"
  call SelectaCommand(command, "", ":e")
endfunction

function! SelectaBowerComponent(path)
  let command = "find " . a:path . " -type f -path " . a:path : "/bower_components"
  call SelectaCommand(command, "", ":e")
endfunction

command! -nargs=+ OpenBundledGem :exec "e `bundle show " . substitute("<args>", "\n", '', '')  . " 2>/dev/null`"

function! SelectaBundle()
  call SelectaCommand("bundle list 2>/dev/null| grep '^  *' | cut -d ' ' -f 4", "", ":OpenBundledGem")
endfunction

nnoremap <leader>f :call SelectaFile(".")<cr>
nnoremap <leader>а :call SelectaFile(".")<cr>
nnoremap <leader>gv :call SelectaFile("app/views")<cr>
nnoremap <leader>gc :call SelectaFile("app/controllers")<cr>
nnoremap <leader>gm :call SelectaFile("app/models")<cr>
nnoremap <leader>gh :call SelectaFile("app/helpers")<cr>
nnoremap <leader>gl :call SelectaFile("lib")<cr>
nnoremap <leader>gf :call SelectaFile("features")<cr>
nnoremap <leader>gn :call SelectaNodeModule(".")<cr>
nnoremap <leader>gbc :call SelectaBowerComponent(".")<cr>
nnoremap <leader>gbu :call SelectaBundle()<cr>
nnoremap <leader>e :call SelectaFile(expand('%:h'))<cr>

function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("fd -t f .", "-s " . @z, ":e")
endfunction
nnoremap <leader>gt :call SelectaIdentifier()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git integration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
endfun
command! -nargs=? GG call GitGrep(<f-args>)

function! GitGrepIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  call GitGrep('-w -e ', @z)
endfunction

function! GitGrepSelected()
  normal gv"zy
  call GitGrep('-e ', @z)
endfunction

function! GitAddFile()
  :w
  let path = expand('%')
  exec ':silent !git add ' . path
  redraw!
endfunction

nnoremap <leader>gg :call GitGrepIdentifier()<cr>
vnoremap <leader>gg :call GitGrepSelected()<cr>
nnoremap <leader>ga :call GitAddFile()<cr>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gu :cexpr system('git diff --name-only --diff-filter=U \| sed -E "s/\$/:1: merge conflict/"')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>rl :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file

  if match(current_file, '^spec/') != -1
    let new_file = substitute(new_file, '^spec/', '', '')

    if match(new_file, '^views/') != -1
      let new_file = substitute(new_file, '_spec\.rb$', '', '')
    elseif match(new_file, '^javascripts/') != -1
      let new_file = 'assets/' . substitute(new_file, '_spec\(\.js\|\.coffee\|\.js\.coffee\)$', '*', '')
    else
      let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    end

    let dir = split(new_file, '/')[0]
    if isdirectory('app/' . dir)
      let new_file = 'app/' . new_file
    end
  else
    if match(new_file, '^app/') != -1
      let new_file = substitute(new_file, '^app/', '', '')
    end

    if match(new_file, '^views/') != -1
      let new_file = substitute(new_file, '$', '_spec.rb', '')
    elseif match(new_file, '^assets/javascripts') != -1
      let new_file = substitute(new_file, '^assets/', '', '')
      let new_file = substitute(new_file, '\(\.js\|\.coffee\|\.js\.coffee\)$', '_spec.coffee', '')
    else
      let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    end

    let new_file = 'spec/' . new_file
  endif

  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
"
" Pressing these hotkeys will do the following depending on the file:
" * in test files it will remember the file, change the run options, and run it
" * in production files it will change the run options and run remembered test
"   file
"
" Run options are changed depending on the hotkey:
" * <cr> does not change the options when pressed in production code or in the
"   same test file, resets (or not?) the options when pressed in a different test file
" * <leader>tt reset the options (no spring, no debug, no async)
" * <leader>ts toggles spring
" * <leader>td toggles debug
" * <leader>ta toggles async
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType ruby nnoremap <cr> :call RunTests()<cr>
au FileType ruby,javascript map <leader>T :call RunNearestTest()<cr>
au FileType ruby,javascript map <leader>tt :call ResetTestOptionsAndRunTests()<cr>
au FileType ruby map <leader>ts :call ToggleTestSpring()<cr>
au FileType ruby map <leader>td :call ToggleTestDebug()<cr>
au FileType ruby map <leader>ta :call ToggleTestAsync()<cr>
" au FileType ruby,cucumber map <leader>st :call RunTestFile(0, 'spring ')<cr>
" au FileType javascript map <leader>st :call RunTestFile(0, 'browser ')<cr>
" au FileType ruby,cucumber map <leader>dt :call RunTestFile(0, 'STDOUT=1 ')<cr>
" au FileType ruby,cucumber map <leader>dsT :call RunNearestTest('STDOUT=1 spring ')<cr>
" au FileType ruby,cucumber map <leader>r :call RunTestFile(1)<cr>
" au FileType ruby,cucumber map <leader>sr :call RunTestFile(1, 'spring ')<cr>
" au FileType ruby,cucumber map <leader>ar :call RunRSpecAsync('', '')<cr>
" au FileType ruby,cucumber map <leader>w :call RunScenarios('', '--profile wip')<cr>
" au FileType ruby,cucumber map <leader>sw :call RunScenarios('spring ', '--profile wip')<cr>
" au FileType ruby,cucumber map <leader>dw :call RunScenarios('STDOUT=1 ', '--profile wip')<cr>

au FileType ruby map <leader>l :call RunLinter("rubocop -f e FILENAME \| grep '^/'")<cr>
au FileType javascript map <leader>l :call RunLinter("eslint -f unix FILENAME \| grep '^/'")<cr>
au FileType scss map <leader>l :call RunLinter("stylelint -f compact FILENAME \| perl -pe 's/^\\s+(.*)$/\\1/' \| perl -pe 's/([^:]+): line ([0-9]+), col ([0-9]+), [^ ]+ -[ \\n]+(.*)/\\1:\\2:\\3: \\4/'")<cr>

" au FileType ruby map <leader>dT :call RunNearestTest('STDOUT=1 ')<cr>
" au FileType ruby map <leader>sT :call RunNearestTest('spring ')<cr>
" au FileType ruby map <leader>sdT :call RunNearestTest('STDOUT=1 spring ')<cr>
" au FileType ruby map <leader>dsT :call RunNearestTest('STDOUT=1 spring ')<cr>
" au FileType javascript map <leader>sT :call RunNearestTest('browser ')<cr>
"
" au FileType ruby,javascript map <leader>a :call RunTests(0, '', '')<cr>
" au FileType ruby map <leader>c :call RunScenarios()<cr>

function! RunTests()
  if IsTestFile() && (!exists("t:test_file_path") || t:test_file_path != @%)
    let t:test_file_suffix = ''
  end

  call RunCurrentOrLatestTests()
endfunction

function! RunNearestTest()
  if !IsTestFile()
    return
  end

  if t:test_file_suffix != ''
    let t:test_file_suffix = ''
  else
    let t:test_file_suffix = ':' . line('.')
  end

  call RunCurrentOrLatestTests()
endfunction

function! ResetOptionsAndRunTests()
  call ResetTestOptions()
  call RunCurrentOrLatestTests()
endfunction

function! ToggleTestSpring()
  if match(t:test_file_prefix, 'spring ') != -1
    let t:test_file_prefix = substitute(t:test_file_prefix, 'DISABLE_SPRING=1 ', '', '')
    let t:test_file_prefix = substitute(t:test_file_prefix, 'spring ', '', '')
    let t:test_file_prefix = t:test_file_prefix . 'DISABLE_SPRING=1 '
    echo 'Spring disabled.'
  else
    let t:test_file_prefix = substitute(t:test_file_prefix, 'DISABLE_SPRING=1 ', '', '')
    let t:test_file_prefix = t:test_file_prefix . 'spring '
    echo 'Spring enabled.'
  end
endfunction

function! ToggleTestDebug()
  call ToggleTestPreifxOption('STDOUT=1 ')
endfunction

function! ToggleTestAsync()
  let t:test_file_async = t:test_file_async == 0 ? 1 : 0
endfunction

function! ToggleTestPreifxOption(option)
  if match(t:test_file_prefix, a:option) != -1
    let t:test_file_prefix = substitute(t:test_file_prefix, a:option, '', '')
  else
    let t:test_file_prefix = t:test_file_prefix . a:option
  end
endfunction

function! ResetTestOptions()
  let t:test_is_async = 0
  let t:test_file_prefix = ''
  let t:test_file_suffix = ''
endfunction

call ResetTestOptions()

function! IsTestFile()
  return match(expand("%"), '\(.feature\|_spec.rb\|_spec.js.coffee\|.spec.coffee\|-test.js\)$') != -1
endfunction

function! RunCurrentOrLatestTests()
  if IsTestFile()
    let t:test_file_path = @%
  elseif !exists("t:test_file_path")
    return
  end

  call RunTestsWithOptions(t:test_is_async, t:test_file_prefix, t:test_file_path, t:test_file_suffix)
endfunction

function! RunTestsWithOptions(async, prefix, filename, suffix)
  :w

  if filereadable("bin/run-test")
    call RunCommand(a:prefix . "bin/run-test " . a:filename . a:suffix)
  elseif filereadable("bin/rspec")
    call RunCommand(a:prefix . "bin/rspec " . a:filename . a:suffix)
  elseif a:async
    call RunRSpecAsync(a:prefix, a:filename)
  elseif match(a:filename, '\.feature$') != -1
    call RunScenarios(a:prefix, a:filename)
  elseif match(a:filename, '_spec.coffee$') != -1
    call RunKonacha(a:filename)
  elseif match(a:filename, '\.js.coffee$') != -1
    call RunJasmine(a:filename)
  else
    call RunRSpec(a:prefix, a:filename, a:suffix)
  end
endfunction

function! JumpToError(...)
  let has_valid_error = 0

  for error in getqflist()
    if error['valid']
      let has_valid_error = 1
      break
    endif
  endfor

  if has_valid_error
    let error_message = error['text']
    silent cc!
    redraw!
    return [1, error_message]
  else
    let message = a:0 > 0 ? a:1 : 'All tests passed'
    redraw!
    return [0, ' ' . message]
  endif
endfunction

function! DrawBar(message)
  let w = &columns - 13
  echon repeat(' ', w) . "\r " . a:message[0:w - 1]
endfunction

function! RedBar(message)
  hi RedBar ctermbg=167 ctermfg=white
  echohl RedBar
  call DrawBar(a:message)
  echohl
endfunction

function! GreenBar(message)
  hi GreenBar ctermbg=2 ctermfg=white
  echohl GreenBar
  call DrawBar(a:message)
  echohl
endfunction

function! ShowBar(response)
  if a:response[0]
    call RedBar(a:response[1])
  else
    call GreenBar(a:response[1])
  endif
endfunction

function! RunCommandWithBar(command, success)
  :w
  cexpr system(a:command)
  call ShowBar(JumpToError(a:success))
endfunction

function! RunRSpecAsync(prefix, filename)
  call RunCommandWithBar(a:prefix . 'rspec --color --require "~/.vim/rspec_formatter" --format VimFormatter ' . a:filename)
endfunction

function! RunLinter(command)
  let cmd = substitute(a:command, 'FILENAME', @%, 'g')
  call RunCommandWithBar(cmd, 'All checks passed')
endfunction

function! RunCompiler(command)
  let cmd = substitute(a:command, 'FILENAME', @%, 'g')
  call RunCommandWithBar(cmd, 'Compiled successfully')
endfunction


function! RunScenarios(prefix, ...)
  :w

  if a:0
    let args = a:1
  else
    let args = ""
  endif

  call RunCommand(a:prefix . "cucumber --color -r features " . args)
endfunction

function! RunRSpec(prefix, filename, suffix)
  call RunCommand(a:prefix . "rspec --color " . a:filename . a:suffix)
endfunction

function! RunCommand(command)
  exec ":silent !echo;echo " . a:command
  exec ":!" . a:command
endfunction

if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Test quickfix list management
"
" If the tests write a tmp/quickfix file, these mappings will navigate through
" it
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! BufferIsOpen(bufname)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      return 1
    endif
  endfor
  return 0
endfunction

function! ToggleQuickfix()
  if BufferIsOpen("Quickfix List")
    cclose
  else
    call OpenQuickfix()
  endif
endfunction

function! OpenQuickfix()
  " cgetfile tmp/quickfix
  belowright cwindow 10
  if &ft == "qf"
    cc
  endif
endfunction

nnoremap <leader>q :call ToggleQuickfix()<cr>
" nnoremap <leader>q :cc<cr>
nnoremap <leader>j :cnext<cr>
nnoremap <leader>k :cprev<cr>
" nnoremap <leader>gj :lnext<cr>
" nnoremap <leader>gk :lprev<cr>
"

function! ToggleScratch()
  if BufferIsOpen("Scratch")
    bun "Scratch"
  else
    botright 10new
    setlocal buftype=nofile bufhidden=wipe noswapfile nowrap
    put=@s
  endif
endfunction

nnoremap <leader>s :call ToggleScratch()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CLOJURE STUFF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ClojureRepl(cmd)
  " try
  "   call fireplace#session_eval(a:cmd, {'ns': fireplace#client().user_ns()})
  " catch /^Clojure:.*/
  "   return ''
  " endtry

  let client = fireplace#client()
  let response = client.eval(a:cmd, {'ns': client.user_ns()}) "fireplace#ns()})
  " let response = fireplace#ns_eval(a:cmd)
  let substitution_pat =  '\e\[[0-9;]*m\|\r\|\n$'

  let @s = get(response, 'out', '') . get(response, 'err', '') . get(response, 'ex', '')

  if get(response, 'err', '') !=# ''
    return { 'err': substitute(response.err, substitution_pat, '', 'g') }
  elseif get(response, 'ex', '') !=# ''
    return { 'err': 'Clojure: ' . response.ex }
  elseif get(response, 'out', '') =~# '[\n^]FAIL '
    let lines = split(response.out, "\r\\=\n")
    let errors = []
    let i = 0

    while i < len(lines)
      if lines[i] =~# '^FAIL'
        let mm = split(lines[i], "(")[2]
        let mm = split(strpart(mm, 0, len(mm) - 1), ":")
        let error = {'type': 'E', 'lnum': mm[1], 'text': lines[i + 1] . lines[i + 2]}
        let error.filename = fireplace#findresource(mm[0], fireplace#path())
        call add(errors, error)
        let i += 3
      else
        let i += 1
      endif
    endwhile

    return { 'errors': errors }
  elseif has_key(response, 'out') || has_key(response, 'value')
    return { 'out': get(response, 'out', ''), 'value': get(response, 'value', 'nil') }
  else
    return { 'err': 'Clojure: Something went wrong: ' . string(response) }
  endif
endfunction

function! ClojureReload()
  let ns = fireplace#ns()
  let cmd = "(clojure.core/require '" . ns . " :reload-all)"
  call ClojureRepl(cmd)
endfunction

function! ClojureUnload()
  let ns = fireplace#ns()
  let cmd = "(remove-ns '" . ns . ")"
  call ClojureRepl(cmd)
endfunction

function! ClojureTest()
  silent! w

  let ns = fireplace#ns()
  let test_ns = ns

  if match(ns, '-test$') == -1
    let test_ns = ns . '-test'
  endif

  let cmd = "(do (clojure.core/require '" . ns . " :reload) (when (clojure.core/find-ns '" . test_ns . ") (clojure.test/run-tests '" . test_ns . ")))"

  let res = ClojureRepl(cmd)

  if has_key(res, 'err')
    let lines = split(res.err, "\n")
    call RedBar(lines[0])
  elseif has_key(res, 'errors')
    call setqflist(res.errors)
    call ShowBar(JumpToError())
  else
    let message = get(res, 'out', 'OK')
    if message !=# ''
      let lines = split(message, "\n")
      call GreenBar(lines[0])
    else
      call GreenBar('OK')
    endif
    " if message !=# ''
    "   let substitution_pat =  '\e\[[0-9;]*m\|\r\|\n$'
    "   echo substitute(message, substitution_pat, '', 'g')
    " else
    "   call setqflist(get(res, 'errors', []))
    "   call ShowBar(JumpToError('OK'))
    " endif
  endif
endfunction

au FileType clojure nnoremap <cr> :call ClojureTest()<cr>
au FileType clojure nmap <leader>cc :FireplaceConnect 8889<cr>
au FileType clojure map <leader>cl :Eval<cr>
au FileType clojure vmap <cr> :Eval<cr>
au FileType clojure map <leader>cr :w\|:call ClojureReload()<cr>
au FileType clojure map <leader>cu :call ClojureUnload()<cr>

au BufRead ~/notes/**/*.md setlocal tw=80
au FileType markdown nmap <cr> :w\|!markdown "%"<cr>

au FileType typescript nmap <cr> :call RunCompiler('tsc -m amd --outFile vendor/game.js src/game/*.ts')<cr>
au FileType typescript set errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m


function! SynStack()
  for ss in synstack(line('.'), col('.'))
    echo synIDattr(ss, 'name') . ' -> ' . synIDattr(synIDtrans(ss), 'name')
  endfor
endfunction
command! SynStack :call SynStack()

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" let g:ale_lint_on_enter = 0
let g:ale_javascript_eslint_options = '--cache --no-ignore'
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_sign_info = 'I'
let g:ale_sign_highlight_linenrs = 1
" let g:ale_set_quickfix = 1
" let g:ale_set_loclist = 1
let g:ale_linters = {'ruby': ['rubocop'], 'javascript': ['eslint'], 'typescript': ['tsserver', 'eslint'], 'typescript.tsx': ['tsserver', 'eslint']}
let g:ale_fixers = {'ruby': ['rubocop'], 'javascript': ['prettier'], 'typescript': ['prettier'], 'typescript.tsx': ['prettier']}
nnoremap <leader>d :ALEGoToDefinition<cr>
" nnoremap <leader>D :TsuTypeDefinition<cr>
nmap <silent> <leader>gk <Plug>(ale_previous_wrap)
nmap <silent> <leader>gj <Plug>(ale_next_wrap)

let g:vim_markdown_folding_disabled = 1
