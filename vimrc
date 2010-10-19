set nocompatible      " must be the first line
filetype on
filetype indent on
filetype plugin on
"set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
set statusline=-%n-%h%m%r%f\ %<%=%(col=%c%V\ \ line=%l\ \ totlin=%L%)\ %-Y\ %P


"" General options
syntax on
set bg=light
set number
set whichwrap=h,l,<,> " which key let you go to previous/next line
set wildmenu
set hidden
set backup
set backupdir=~/.vim/tmp,~/.tmp,/var/tmp,/tmp
set directory=~/.vim/tmp,~/.tmp,/var/tmp,/tmp
set autowrite
set hlsearch
set incsearch
set ignorecase
set smartcase         " noignorecase when capital in the search pattern
set history=100
set scrolloff=3       " context around cursor when reaching top/bottom
set laststatus=2      " show status line?  Yes, always!
set showmatch         " Show the matching bracket for the last ')'?
set showcmd           " Show current uncompleted command?  Absolutely!
set showmode          " Show the current mode?  YEEEEEEEEESSSSSSSSSSS!
set suffixes=.bak,.swp,.o,~,.class,.exe,.obj
                        " Suffixes to ignore in file completion
set title             " Permet de voir le tit. du doc. crt. ds les XTERM
set noerrorbells      " damn this beep!  ;-)
set visualbell
set smartindent
set expandtab
set sw=2
set ts=2
set ai

nnoremap ' `
nnoremap ` '
set modeline
set encoding=utf-8
set foldlevelstart=99

if (&shell=="/bin/zsh")
  set shell=/bin/bash
endif

if has("unix")
  set shcf=-ic
endif
let mapleader = ","

let $ADDED = '~/.vim/added/'
"if has("win32")
"  let $ADDED = $VIM.'/added/'
"endif

fun ActivateAddons()
  set runtimepath+=~/.vim-plugins/vim-addon-manager
  try
    call scriptmanager#Activate(['The_NERD_tree', 
      \ 'AutoClose1849', 'matchit.zip', 'repeat', 'surround', 
      \ 'taglist', 'snipMate', 'lodgeit', 'pydoc910', 'Gist'])
   ""   \ 'codefellow'
  catch /.*/
    echoe v:exception
  endtry
endf
call ActivateAddons()

"" Gist
" -c will put it in clipboard
let g:gist_clip_command = 'pbcopy'
" detect filetype with Gist filename
let g:gist_detect_filetype = 1
" to open browser on the gist after creating it
let g:gist_open_browser_after_post = 1

" in order to be able to fold xml blocks
let g:xml_syntax_folding = 1
let xml_use_xhtml = 1
let NERDTreeIgnore=['\.vim$', '\~$', '.*class$', '^boot$', '^lib$', '^lib_managed$', '^target$']
" guess what : I don't know what you do...
map <Leader>cd :exe 'cd ' . expand ("%:p:h")<CR>

""""""""""""""""""
" general mapping
 
" My mac can't make Ctrl-] work out f the box :-(
map  <C-]>
" reformat paragraphs
imap <C-J> <C-O>gqap
nmap <C-J>      gqap
vmap <C-J>      gq
" to have Ctrl-Spce triggering omnicomplete
inoremap <C-Space> <C-x><C-o>
inoremap <Nul> <C-x><C-o>
" make
map <F9> :make
" ctags
map <F10> :! ctags -R *
" tabs
"map <A-Right> :tabnext<CR>
map [5C :tabnext<CR>
"map <A-Left> :tabprevious<CR>
map [5D :tabprevious<CR>
map <C-n> :tabnew<CR>
map <C-e> :tabe
map <F2> :TlistToggle<CR>
map <F3> :NERDTreeToggle<CR>
map <C-p> :Lodgeit<CR>

""""""""""""""""""
"" Editing a mail
autocmd BufRead mutt-* set ft=mail
autocmd BufRead /tmp/mutt*      :source ~/.vim/mail.vim
" check syntax
autocmd FileType mail nmap <F9> :w<CR>:!aspell -e -c %<CR>:e<CR>
" comment or uncomment (current line or block)

""""""""""""""""""
" " Editing LaTeX
au BufNewFile *.tex r ~/.vim/modele.tex
" Comment
autocmd FileType tex map <F7> I%<ESC>j
autocmd FileType tex imap <C-F7> <C-O><F7>
autocmd FileType tex map <F8> :s/^\s*%*//
autocmd FileType tex imap <C-F8> <C-O><F8>

autocmd FileType tex set makeprg=latex
autocmd FileType tex map <F9> :make %
" to be improved
"autocmd FileType tex map <F10> :! xdvi %
" Entering in an environment

" emph, it, bf, sc


""""""""""""""""""
" " Editing HTML
au BufNewFile *.html r ~/.vim/modele.html
" Comments
autocmd Filetype html map <F8> :s/\(.*\)/<!--\1-->/
autocmd Filetype html imap <F8> <C-O><C-F8>

"""""""""""""""""""
" " Editing C
" Comment current line
autocmd Filetype c map <F7> I/*A*/j0
autocmd Filetype c imap <F7> I/*A*/j0i
" Uncomment
autocmd Filetype c map <F8> :s,/\*\(.*\)\*/,\1,
autocmd Filetype c imap <F8> <C-O><F8>
" autoformat comments (ANSI)
autocmd Filetype c set comments=sl1:/*,mb:*,elx:*/
autocmd Filetype c set fo=croq

"""""""""""""""""""
" " Editing XML
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Installed

" www.vim.org/scripts/script.php?script_id=301
" $ADDED/xml.vim

" www.vim.org/scripts/script.php?script_id=39
" copied macros/matchit.vim to plugin/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType xml set foldmethod=syntax

map <Leader>x :set filetype=xml<CR>
  \:source $VIMRUNTIME/syntax/xml.vim<CR>
  \:set foldmethod=syntax<CR>
  \:source $VIMRUNTIME/syntax/syntax.vim<CR>
  \:source $ADDED/xml.vim<CR>
  \:echo "XML mode is on"<CR>

" catalog should be set up
autocmd FileType xml nmap <Leader>l <Leader>cd:%w !xmllint --valid --noout -<CR>
autocmd FileType xml nmap <Leader>r <Leader>cd:%w !rxp -V -N -s -x<CR>
autocmd FileType xml nmap <Leader>d4 :%w !xmllint --dtdvalid 
 \ "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
 \ --noout -<CR>

autocmd FileType xml vmap <Leader>px !xmllint --format -<CR>
autocmd FileType xml nmap <Leader>px !!xmllint --format -<CR>
autocmd FileType xml nmap <Leader>pxa :%!xmllint --format -<CR>

autocmd FileType xml nmap <Leader>i :%!xsltlint<CR>

"""""""""""""""""""""""""
"" Editing Python
autocmd FileType python set ts=4
autocmd FileType python set sts=4
autocmd FileType python set sw=4
"" to make gf (goto file) work on import stmt
" add .py to the name (eg import gzip with cursor on gzip -> look for gzip.py
autocmd FileType python set suffixesadd=.py,
" some python to prepare python env like path for file lookup
autocmd FileType python pyfile $HOME/.vim/pyvimconfig.py
autocmd FileType python set tags+=$HOME/.vim/tags/python.ctags
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd FileType python map <C-h> :py evaluate_current_range()<CR>
autocmd FileType python map <F7> :py set_breakpoint()<CR>
" <S-F7> (why is it broken ?)
autocmd FileType python map [18;2~ :py remove_breakpoints()<CR>
autocmd FileType python map <F12> :! python %<CR>
 

"""""""""""""""""""""""""
"" Editing Scala

" to have ctags for scala : edit ~/.ctags according to
" http://www.praytothemachine.com/evil/2008/05/16/liftweb-ctags-vim/
let tlist_scala_settings = "scala;c:Class;t:Trait;m:Method;o:Object;r:Definition"
" snippets from : http://github.com/tommorris/scala-vim-snippets
autocmd FileType scala set makeprg=sbt\ -n\ compile
autocmd FileType scala set efm=%E\ %#[error]\ %f:%l:\ %m,%C\ %#[error]\ %p^,%-C%.%#,%Z,
       \%W\ %#[warn]\ %f:%l:\ %m,%C\ %#[warn]\ %p^,%-C%.%#,%Z,
       \%-G%.%#
