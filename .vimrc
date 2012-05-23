let mapleader = ","
let g:mapleader = ","

set nocompatible

set number
set numberwidth=5
set ruler
syntax on

set t_Co=256

" set encoding
set encoding=utf-8

" set nowrap
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
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
"let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
"map <Leader>n :NERDTreeToggle<CR>

" Command-T configuration
"let g:CommandTMaxHeight=20

" ZoomWin configuration
"map <Leader><Leader> :ZoomWin<CR>

" CTags
"map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
"map <C-\> :tnext<CR>

" Gundo configuration
"nmap <F5> :GundoToggle<CR>
"imap <F5> <ESC>:GundoToggle<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Hammer<CR>
endfunction

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Guardfile,config.ru,*.rabl} set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

au BufRead,BufNewFile *.{c,h,cpp,cc,hh} set et ts=4 sw=4 sts=4

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

call pathogen#infect()

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
vmap <C-k> [egv
vmap <C-j> ]egv

" Enable syntastic syntax checking
" let g:syntastic_enable_signs=1
" let g:syntastic_quiet_warnings=1

" gist-vim defaults
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color railscasts

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Turn off jslint errors by default
" let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd

if has("gui_running")
  " Automatically resize splits when resizing MacVim window
  autocmd VimResized * wincmd =
endif

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

" highlight current line
set cursorline
set colorcolumn=81

hi def link diffAdded		DiffAdd
hi def link diffRemoved		DiffDelete

function! RunShellCommand(cmdline)
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
    if part[0] =~ '\v[%#<]'
      let expanded_part = fnameescape(expand(part))
      let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    endif
  endfor
  tabnew
  setlocal buftype=nofile syntax=diff bufhidden=wipe nobuflisted noswapfile nowrap
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
endfunction

function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "http://[^ ,;\t]*")
  exec "!open ".line
endfunction

map <Leader>w :call Browser()<CR>
map <Leader>gs :Gstatus<CR>
map <Leader>gc :Gcommit<CR>
map <Leader>gd :call RunShellCommand('git diff')<CR>
map <Leader>gdc :call RunShellCommand('git diff --cached')<CR>
map <Leader>rt :!ctags --extra=+f --exclude=.git --exclude=log -R *<CR><CR>
