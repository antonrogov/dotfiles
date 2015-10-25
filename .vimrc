let mapleader = ","
let g:mapleader = ","

set nocompatible

" allow unsaved background buffers and remember marks/undo for them
set hidden

set number
set numberwidth=5
set ruler
syntax on
set statusline=%1*\ %<%f\ %*%2*%*\ %h%m%r%=\ %l,%c%V\ \ %P

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
nnoremap <CR> :nohlsearch<CR>/<BS>

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn
set wildignore+=vendor/gems/*,vendor/ruby/**,tmp/cache/**

" Status bar
set laststatus=2

" highlight current line
set cursorline
set colorcolumn=81

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

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
set background=dark
color railscasts

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

augroup vimrcEx
  au!

  " Remember last location in file
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

  au FileType text setlocal textwidth=78

  au BufRead,BufNewFile *.rabl set ft=ruby
  au BufNewFile,BufRead *.json set ft=javascript
  au BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:&gt;
  au BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:&gt;

  au FileType python,c,cpp,objc set et ts=4 sw=4 sts=4
  au FileType clojure set iskeyword-=/

  " Don't syntax highlight markdown because it's often wrong
  au! FileType mkd setlocal syn=off
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

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

map <leader>y "*y
map <leader>p "*p
map <Leader>gs :Gstatus<CR>
map <leader>ga :CommandTFlush<cr>\|:CommandT app/assets<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <Leader>rt :!ctags --extra=+f --exclude=.git --exclude=log --exclude=tmp -R *<CR><CR>
map <Leader>/ <plug>NERDCommenterToggle<CR>
map <Leader>l :w\|:!reload-safari<CR><CR>
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
map <silent> <Leader>= :s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
vmap <silent> <Leader>= :s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
command! -nargs=+ MyCalc :echo MyCalc("<args>")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile("")<cr>
map <leader>w :call RunScenarios("", "--profile wip")<cr>
map <leader>st :call RunTestFile("spring ")<cr>
map <leader>dt :call RunTestFile("LOG_LEVEL=DEBUG ")<cr>
map <leader>sw :call RunScenarios("spring ", "--profile wip")<cr>
map <leader>dw :call RunScenarios("LOG_LEVEL=DEBUG ", "--profile wip")<cr>

map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :call RunScenarios()<cr>

function! RunTestFile(prefix)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_spec.js.coffee\|.spec.coffee\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end

  call RunTests(a:prefix, t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile("", ":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTests(prefix, filename)
  if match(a:filename, '\.feature$') != -1
    call RunScenarios(a:prefix, a:filename)
  elseif match(a:filename, '_spec.coffee$') != -1
    call RunKonacha(a:filename)
  elseif match(a:filename, '\.js.coffee$') != -1
    call RunJasmine(a:filename)
  else
    call RunRSpec(a:prefix, a:filename)
  end
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

function! RunRSpec(prefix, filename)
  :w
  call RunCommand(a:prefix . "rspec --color " . a:filename)
endfunction

function! RunJasmine(filename)
  :w
  call RunCommand("guard-jasmine -s none -u http://localhost:8888/jasmine " . a:filename)
endfunction

function! RunKonacha(filename)
  :w
  call RunCommand("konacha " . a:filename)
endfunction

function! RunJasmineNode(filename)
  :w
  call RunCommand("jasmine-node --coffee " . a:filename)
endfunction

function! RunCommand(command)
  exec ":silent !echo;echo " . a:command
  exec ":!" . a:command
endfunction

if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
