set nocompatible      " must be the first line
filetype on
filetype indent on
filetype plugin on
"set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
" with CWD
"set statusline=[%n]%h%m%r%f\ \ cwd:\ %r%{getcwd()}%h%<%=%(pos=%l/%L:%c%V%)\ %-Y\ %P
set statusline=[%n]%h%m%r%f\ \ %{fugitive#statusline()}%h%<%=%(pos=%l/%L:%c%V%)\ %-Y\ %P


"" General options
syntax on
set bg=dark
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
set magic
set ignorecase
set smartcase         " noignorecase when capital in the search pattern
set history=100
set scrolloff=7       " context around cursor when reaching top/bottom
set laststatus=2      " show status line?  Yes, always!
set showmatch         " Show the matching bracket for the last ')'?
set showcmd           " Show current uncompleted command?  Absolutely!
set showmode          " Show the current mode?  YEEEEEEEEESSSSSSSSSSS!
set suffixes=.bak,.swp,.o,~,.class,.exe,.obj
                        " Suffixes to ignore in file completion
set title             " have your term title showing what you do
set noerrorbells      " damn this beep!  ;-)
set visualbell
set expandtab
set sw=2
set ts=2
set ai

nnoremap ' `
nnoremap ` '
set modeline
set encoding=utf-8
set foldlevelstart=99
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

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
    call vam#ActivateAddons(['The_NERD_tree', 'xmledit', 
      \ 'Command-T', "ZenCoding", "The_NERD_Commenter",
      \ 'AutoClose1849', 'matchit.zip', 'repeat', 'surround', 
      \ 'vim-addon-async','vim-addon-completion','vim-addon-json-encoding',
      \ 'tpope-markdown', 'scalacommenter', 'ensime',
      \ 'gitv', 'fugitive', 'git.zip',
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
" snipMate
let g:snippets_dir = '~/.vim-plugins/snipMate/snippets,~/.vim/snippets'
let g:snips_author = 'Hubert Behaghel'
" in order to be able to fold xml blocks
let g:xml_syntax_folding = 1
let xml_use_xhtml = 1
let NERDTreeIgnore=['\.vim$', '\~$', '.*class$', '^boot$', '^lib$', '^lib_managed$', '^target$']
" CommandT options
let g:CommandTMaxHeight = 15
" vim-addon-async
let g:vimcmd='mvim' " only my MacVim install has +clientserver

""""""""""""""""""
" general mapping
 
" My mac can't make Ctrl-] work out f the box :-(
if has("macunix")
  map  <C-]>
endif
" reformat paragraphs
imap <C-J> <C-O>gqap
nmap <C-J>      gqap
vmap <C-J>      gq
" to have Ctrl-Spce triggering omnicomplete
inoremap <C-Space> <C-x><C-o>
inoremap <Nul> <C-x><C-o>
" tabs
"map <A-Right> :tabnext<CR>
map [5C :tabnext<CR>
"map <A-Left> :tabprevious<CR>
map [5D :tabprevious<CR>
map <C-n> :tabnew<CR>
map <C-e> :tabe
map <F2> :TlistToggle<CR>
map <F3> :NERDTreeToggle<CR>
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
map <F9> :make
map <F10> :! ctags -R *
map <C-p> :Lodgeit<CR>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => QuickFix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>ce :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"" Restore cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

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

autocmd FileType tex set makeprg=pdflatex
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
""""""""""""""""""
" " Editing CSS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

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

" map <Leader>x :set filetype=xml<CR>
"   \:source $VIMRUNTIME/syntax/xml.vim<CR>
"   \:set foldmethod=syntax<CR>
"   \:source $VIMRUNTIME/syntax/syntax.vim<CR>
"   \:source $ADDED/xml.vim<CR>
"   \:echo "XML mode is on"<CR>

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
autocmd FileType scala let current_compiler = "sbt"
autocmd FileType scala set makeprg=sbt\ compile
autocmd FileType scala set efm=%E\ %#[error]\ %f:%l:\ %m,%C\ %#[error]\ %p^,%-C%.%#,%Z,
       \%W\ %#[warn]\ %f:%l:\ %m,%C\ %#[warn]\ %p^,%-C%.%#,%Z,
       \%-G%.%#
autocmd FileType scala set errorfile=target/error
" scalacommenter plugin
autocmd FileType scala source $HOME/.vim-plugins/scalacommenter/plugin/scalacommenter.vim 
autocmd FileType scala map <Leader>cw :call ScalaCommentWriter()<CR> 
autocmd FileType scala map <Leader>cf :call ScalaCommentFormatter()<CR> 
autocmd FileType scala let b:scommenter_class_author='Hubert Behaghel' 
autocmd FileType scala let b:scommenter_file_author='Hubert Behaghel' 
autocmd FileType scala let b:scommenter_extra_line_text_offset = 20 
"autocmd FileType scala let g:scommenter_file_copyright_list = [ 
"  \    'COPYRIGHT', 
"  \    'Second line of copyright', 
"  \    'And a third line' 
"  \] 
"autocmd FileType scala let b:scommenter_user_tags = [ 
"  \["pre", 0, 1, 0], 
"  \["post", 0, 1, 0], 
"  \["requires", 1, 1, 0], 
"  \["provides", 0, 1, 0] 
"  \] 
autocmd FileType scala map <Leader>= :EnsimeFormatSource<cr>
autocmd FileType scala map <Leader>se :Ensime<cr>
