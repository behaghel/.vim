" ==================================================================
" File:         mail_set.vim
" Purpose:      Mappings for the use of mail, news,...
" Author:       From the work of Sven Guckes in his .vimrc
"               Sven Guckes guckes@vim.org (guckes@math.fu-berlin.de)
"               <URL:http://www.math.fu-berlin.de/~guckes/>
"               using vim-5.0w [980209]
"               Adapted by Luc Hermitte <hermitte at free.fr>
"               <URL:http://hermitte.free.fr/vim/>
" Last update:  06th aug 2002
" Remarks:      Many things have not been changed from the original
"               version
"               VIM 6.x required !
" ===================================================================
if exists("g:loaded_mail_set_vim") | finish | endif
let g:loaded_mail_set_vim = 1

set guioptions+=f

if !exists('maplocalleader') || '' == maplocalleader
  let maplocalleader = ','
endif

"
" ===================================================================
" Help {{{
"======================================================================
"
" Load functions helpfull for Display help messages
" We will use "mail" as prefix
if exists("*BuildHelp") " {{{
  command! -buffer -nargs=1 MailHelp :call BuildHelp("mail", <q-args>)
   noremap <buffer> <C-F1> :call ShowHelp("mail")<cr>
  inoremap <buffer> <C-F1> <esc>:call ShowHelp("mail")<cr>a
else
  command! -buffer -nargs=1 MailHelp
endif " }}}
"
MailHelp |			-------------------------
MailHelp |			E - M A I L   M A C R O S
MailHelp |			-------------------------
MailHelp |
MailHelp |
"
MailHelp | <S-F1>  : Help on other generic macros                            [N]
MailHelp | <C-F1>  : Display this help                                       [N]
MailHelp |
"  }}}
" ===================================================================
" Settings {{{
" ===================================================================
"
  set noai
  set comments+=mb:*
  set comments+=n:\|		" '|' is a quote char
  set comments+=n:%		" '%' as well
  " single-quote needed with VimSpell plugin
  set isk+='
  set tw=72
" }}}
" ===================================================================
" MAPpings {{{
" ===================================================================
"
" -------------------------------------------------------------------
" Part 1 - prepare for editing {{{
" -------------------------------------------------------------------
" }}}
" -------------------------------------------------------------------
" Part 2 - getting rid of empty (quoted) lines and space runs. {{{
" -------------------------------------------------------------------
"
MailHelp |[c   ]    ,ce   = 'clear empty lines'
MailHelp |                 Deletes all lines which are empty or 'whitespace only' lines
  cmap <LocalLeader>ce g/^\s*$/d
"
MailHelp |[ nv ]    ,cqel = 'clear quoted empty lines'
MailHelp |                 Clears (makes empty) all lines which start with '>'
MailHelp |                 and any amount of following spaces.
  " nmap <LocalLeader>cqel :%s/^[>[:space:]]\+$//
  " vmap <LocalLeader>cqel  :s/^[>[:space:]]\+$//
  " Defined by Brian Medley plugin
" The following do not work as "\s" is not a character
" and thus cannot be part of a "character set".
" nmap <LocalLeader>cqel :%s/^[>\s]\+$//
" vmap <LocalLeader>cqel  :s/^[>\s]\+$//
"
" Some people have strange habits within their writing.
" But if you cannot educate them - rewrite their text!  ;-)
"
MailHelp |[ nv ]    ,ksr  = 'kill space runs'
MailHelp |                 Substitutes runs of two or more space to a single space.
" Why can't this be an option of "text formatting"? *hrmpf*
" nmap <LocalLeader>ksr :%s/  */ /g
" vmap <LocalLeader>ksr  :s/  */ /g
  nmap <LocalLeader>ksr :%s/ \+/ /g
  vmap <LocalLeader>ksr  :s/ \+/ /g
"
MailHelp |[ nv ]    ,Sl   = 'squeeze lines'
MailHelp |                 Turn all blocks of empty lines (within current visual) into 
MailHelp |                 *one* empty line
   map <LocalLeader>Sl :g/^$/,/./-j
" }}}
" -------------------------------------------------------------------
" Part 3 - Change Quoting Level {{{
" -------------------------------------------------------------------
"
MailHelp |[ nv ]    ,dp   = de-quote current inner paragraph
"  map <LocalLeader>dp {jma}kmb:'a,'bs/^> //<CR>
   map <LocalLeader>dp vip:s/^> //<CR>
  vmap <LocalLeader>dp    :s/^> //<CR>
"
"      ,qp = quote current paragraph
"            jump to first inner line, mark with 'a';
"            jump to last  inner line, mark with 'b';
"            then do the quoting as a substitution
"            on the line range "'a,'b":
"  map <LocalLeader>qp {jma}kmb:'a,'bs/^/> /<CR>
"      vim-5 now has selection of "inner" and "all"
"      of current text object - mapping commented!
"
"      ,qp = quote current paragraph (old version)
"            jump to first inner line, Visual,
"            jump to last  inner line,
"            then do the quoting as a substitution:
"  map <LocalLeader>qp {jV}k:s/^/> /<CR>
"
MailHelp |[ nv ]    ,qp   = quote current (inner) paragraph
"            select inner paragraph
"            then do the quoting as a substitution:
   map <LocalLeader>qp   vip:s/^/> /<CR>
"
"      ,qp = quote current paragraph
"            just do the quoting as a substitution:
  vmap <LocalLeader>qp    :s/^/> /<CR>

"
MailHelp |[  v ]    ,kpq  = 'kill power quote' -
MailHelp |                 Changing quote style to *the* true quote prefix string '> ':
"
"       Fix Supercite aka PowerQuote (Hi, Andi! :-):
"       before ,kpq:    >   Sven> text
"       after  ,kpq:    > > text
"      ,kpq kill power quote
  vmap <LocalLeader>kpq :s/^> *[a-zA-Z]*>/> >/e<C-M>
  normal 1GVG,kpq
"
MailHelp |[ nv ]    ,fq   = 'fix quoting' - Fix various other quote characters:
function! FixQuoteHeaders()
  let v:errmsg = ''
  while v:errmsg == ""
    '<,'>s/^\(\( *>\)*\)\s*\([-"\|:}]\s*\)/\1 > /e
  endwhile
endfunction  
  vnoremap <LocalLeader>fq :call FixQuoteHeaders()<CR>
      nmap <LocalLeader>fq vip<LocalLeader>fq

" }}}
" -------------------------------------------------------------------
" Part 4 - Weed Headers of quoted mail/post {{{
" -------------------------------------------------------------------
"
" First step:  Define regexpr for headers.
" This makes reading the following mappings much easier.
" cab HADDR     From\\|Cc\\|To
  cab HEMAIL ^\(From\\|Cc\\|To\\|Date\\|Subject\\|Message-ID\\|Message-Id\\|X-\)
  cab HNEWS  ^\(From\\|Cc\\|To\\|Date\\|Subject\\|Message-ID\\|X-\\|Newsgroups\)
"
MailHelp |[ nv ]    ,we   = 'weed email header'
MailHelp |[ nv ]    ,wp   = 'weed post header'
"
  nmap <LocalLeader>we vip:v/HEMAIL/d<CR>
  vmap <LocalLeader>we    :v/HEMAIL/d<CR>
  nmap <LocalLeader>wp vip:v/HNEWS/d<CR>
  vmap <LocalLeader>wp    :v/HNEWS/d<CR>
"
"      ,ri = "Read in" basic lines from the email header
"            Useful when replying to an email:
" nmap <LocalLeader>ri :r!readmsg\|egrep "^From:\|^Subject:\|^Date:\|^To: \|^Cc:"
"            NOTE: "readmsg" ships with the mailer ELM.
" }}}
" -------------------------------------------------------------------
" Part 5 - Reformatting Text {{{
" -------------------------------------------------------------------
"
" MailHelp |[ n  ]    ,<cr> = break line
MailHelp |[ n  ]   <c-cr> = break line
nnoremap <LocalLeader><cr>  i<cr><esc>O
" nnoremap <c-cr> i<cr><esc>O
" This macro supposes &formatoption contains 'r'

" ===================================================================
" Edit your reply!  (Or else!)
" ===================================================================
" }}}
" -------------------------------------------------------------------
" Part 6  - Inserting Special or Standard Text {{{
" Part 6a - The header {{{
" -------------------------------------------------------------------
"
" automatically delete <hermitte@laas.fr> from the CC:'s list
 " so $VIM/settings/Mail_cc.set
"
"    Add adresses for To: and Cc: lines
"
"     ,ca = check alias (reads in expansion of alias name)
" map <LocalLeader>ca :r!elmalias -f "\%v (\%n)"
" MailHelp |[ nv ]    ,Ca   = 'check alias' (reads in expansion of alias name)
" MailHelp |                  and prints it with the format '\%n <\%v>'
  " source <sfile>:p:h/Mail_mutt_alias.set
"
MailHelp |[ nv ]    ,cc   = 'copy notice'
"   Insert a Cc line so that person will receive a "courtesy copy";
"   this tells the addressee that text is a copy of a public article.
"   This assumes that there is exactly one empty line after the first
"   paragraph and the first line of the second paragraph contains the
"   return address with a trailing colon (which is later removed).
  map <LocalLeader>cc 1G}jyykPICc: <ESC>$x
" map <LocalLeader>cc ma1G}jy/ writes<CR>'aoCc: <ESC>$p
" 
MailHelp |[ nv ]    ,mlu  = 'make letter urgent' (by giving the 'Priority: urgent')
  map <LocalLeader>mlu 1G}OPriority: urgent<ESC>
"
"    Pet peeve:  Unmeaningful Subject lines.  Change them!
"    This command keeps the old Subject line in "X-Old-Subject:" -
"    so the recipient can still search for it and you keep a copy for editing:
MailHelp |[ nv ]    ,cs   = 'change Subject:' line
  map <LocalLeader>cs 1G/^Subject: <CR>yypIX-Old-<ESC>-W
"
" The message must be sent to the VIM mailing list =>  {{{
" - Reply-To: = vim@vim.org
" - Cc:	      = vim@vim.org
noremap <LocalLeader>cv :call <sid>ToVIM_ML()<cr>

function! s:AddToField(field,text)
  let l = search('^'.a:field)
  if l == 0 | exe "normal +" | put = a:field | endif
    exe "normal A".a:text."\<esc>"
endfunction

function! s:ToVIM_ML()
  normal gg
  let i = search('^To:.*vim@vim\.org')
  if i == 0
    normal gg
    call s:AddToField('Cc: ', 'vim@vim.org')
    call s:AddToField('Reply-To: ', 'vim@vim.org')
  endif
endfunction
" if search('vim@vim\.org') | exe "normal ,cv" | endif
" }}}

"     ,cS = change Sven's address.
"           Used when replying as the "guy from vim".
" map <LocalLeader>cS 1G/^From: Sven Guckes/e+2<CR>C<Amailv><ESC>
" 
" Condense several Re: {{{
if !exists(':MailCondenseRe')
  runtime ftplugin/mail/Mail_Re_set.vim
endif
if exists(':MailCondenseRe')
  MailHelp |[ nv ]    ,re   = Condense multiple 'Re:_' to just one 'Re:' in Subject lines:
  MailHelp |                 And change 'Re: Re[n]' to 'Re[n+1]' ; automatic
  " [thanks to Dominique Baldo]:
  noremap <LocalLeader>re :MailCondenseRe<cr>
  :MailCondenseRe
endif
" Condense several Re: }}}
"
MailHelp |[ nv ]    ,( ,) = Put parentheses around 'visual text' / current word
"      Used when commenting out an old subject.
"      Example:
"      Subject: help
"      Subject: vim - using autoindent (Re: help)
"
"      ,) and ,( :
" Beware : works!
  vnoremap <LocalLeader>( v`>a)<ESC>`<i(<ESC>
  vnoremap <LocalLeader>) v`>a)<ESC>`<i(<ESC>
      nmap <LocalLeader>( viw<LocalLeader>(
      nmap <LocalLeader>) viw<LocalLeader>)
" }}}
" -------------------------------------------------------------------
" Part 6b - End of text - dealing with "signatures". {{{
" -------------------------------------------------------------------
"
"       remove signatures
"
MailHelp |[ nv ]    ,kqs  = 'kill quoted sig' (to remove those damn sigs for replies)
MailHelp |                 Automatically called
"  map <LocalLeader>kqs G?^> *-- $<CR>dG
  "normal ,kqsV,cqel<CR>
"     ,kqs = kill quoted sig unto start of own signature:
" map <LocalLeader>kqs G?^> *-- $<CR>d/^-- $/<C-M>
  " source <sfile>:p:h/Mail_Sig.set
  map <LocalLeader>kqs :EraseSignature<CR>
  " :EraseSignature
"
MailHelp |[ n  ]    ,aq   = 'add quote'
MailHelp |                 Reads in a quote from my favourite quotations:
  nmap <LocalLeader>aq :r!agrep -d "^-- $" ~/.P/txt/quotes.favourite<ESC>b
" see http://www.math.fu-berlin.de/~guckes/txt/quotes.favourite
"
MailHelp |[ n  ]    ,s    = 'sign' -
MailHelp |                 Read in signature file (requires manual completion):
  nmap <LocalLeader>s :r!agrep -d "^-- $" ~/.P/sig/SIGS<S-Left>
" available as http://www.math.fu-berlin.de/~guckes/sig/SIGS
"
MailHelp |[ n  ]    ,S    = signature addition of frequently used signatures
  "nmap <LocalLeader>SE :r!agrep -d '^-- $' comp.mail.elm ~/.P/sig/SIGS<S-Left>
  "nmap <LocalLeader>SM :r!agrep -d '^-- $' WOOF ~/.P/sig/SIGS<S-Left>
  "nmap <LocalLeader>SV :r!agrep -d '^-- $' IMproved ~/.P/sig/SIGS<S-Left>
  nmap <LocalLeader>SC G:r!agrep -d '^-- $' fr.comp.lang.c ~/.mutt/SIGS.txt<CR>
  nmap <LocalLeader>SV G:r!agrep -d '^-- $' fr.rec.jeux    ~/.mutt/SIGS.txt<CR>
"
MailHelp |[ n  ]    ,at   = 'add text' -
MailHelp |                 Read in text file (requires manual completion):
  nmap <LocalLeader>at :r ~/Mail/
" }}}
" }}}
" }}}
" ===================================================================
" ABbreviations {{{
" ===================================================================
"
" Inserting an ellipsis to indicate deleted text
MailHelp |
MailHelp |  Abbreviations
MailHelp | ---------------
MailHelp |[   i]    [..   -> [...]
MailHelp |[   a]    Yell  -> [...]
MailHelp |[  v ]    ,ell  -> [...]
  inoremap [..   [...]
  inoreab  Yell  [...]
  vnoremap <LocalLeader>ell c[...]<ESC>

MailHelp |[   a]    yfcomp-> fr.comp.os.ms-windows.programmation
  inoreabbr yfcomp fr.comp.os.ms-windows.programmation
" }}}
" ===================================================================
" PGP - encryption and decryption {{{
" ===================================================================
"
" encrypt
  map ;e :%!/bin/sh -c 'pgp -feast 2>/dev/tty'
" decrypt
  map ;d :/^-----BEG/,/^-----END/!/bin/sh -c 'pgp -f 2>/dev/tty'
" sign
  map ;s :,$! /bin/sh -c 'pgp -fast +clear 2>/dev/tty'
  map ;v :,/^-----END/w !pgp -m
"
" PGP - original mappings
"
"       encrypt and sign (useful for mailing to someone else)
"csh: map #1 :,$! /bin/sh -c 'pgp -feast 2>/dev/tty^V|^V|sleep 4'
" sh: map #1 :,$! pgp -feast 2>/dev/tty^V|^V|sleep 4
"
"       sign (useful for mailing to someone else)
"csh: map #2 :,$! /bin/sh -c 'pgp -fast +clear 2>/dev/tty'
" sh: map #2 :,$! pgp -fast +clear 2>/dev/tty
"
"       decrypt
"csh: map #3 :/^-----BEG/,/^-----END/!\
"             /bin/sh -c 'pgp -f 2>/dev/tty^V|^V|sleep 4'
" sh: map #3 :/^-----BEG/,/^-----END/!\
"             pgp -f 2>/dev/tty^V|^V|sleep 4
"
"       view (pages output, like more)
"csh: map #4 :,/^-----END/w !pgp -m
" sh: map #4 :,/^-----END/w !pgp -m
"
"       encrypt alone (useful for encrypting for oneself)
"csh: map #5 :,$! /bin/sh -c 'pgp -feat 2>/dev/tty^V|^V|sleep 4'
" sh: map #5 :,$! pgp -feat 2>/dev/tty^V|^V|sleep 4
"
" Elijah http://www.mathlab.sunysb.edu/~elijah/pgppub.html says :
" The significant feature is that stderr is redirected independently
" of stdout, and it is redirected to /dev/tty which is a synonym for
" the current terminal on Unix.  I don't know why the ||sleep 4
" stuff is there, but it is harmless so I left it. Since csh is such
" junk, special rules are used if you are using it (tcsh, too).
" ksh and bash should use the sh form. zsh, et al: consult your
" manual.  The #<num> format is used to map function keys. If your
" terminal does not support the requested function key, use a
" literal #<num>.  Not all of the clones correctly support this.
"
"
" Give the URL under the cursor to Netscape
" map <LocalLeader>net yA:!netscape -remote "openurl <C-R>""
" }}}
" ===================================================================
" AutoCommands {{{
" ===================================================================
"
" I do not use many autocommands.  But I do test them a little...
"
" Automatically place the cursor onto the first line of the mail body:
" autocmd BufRead .followup,.article,.letter :normal 1G}j
"
" }}}
" ===================================================================
" Moderation, with modappbot, stuff {{{
" ===================================================================
  " source <sfile>:p:h/Mail_Moderation.set
" }}}
" ===================================================================
" Last but not least...
" ===================================================================
" The last line is allowed to be a "modeline" with my setup.
" It gives vim commands for setting variable values that are
" specific for editing this file.  Used mostly for setting
" the textwidth (tw) and the "shiftwidth" (sw).
" Note that the colon within the value of "comments" needs to
" be escaped with a backslash!  (Thanks, Thomas!)
"======================================================================
"vim:tw=70 et sw=4 comments=\:\" vim600: set foldmethod=marker:
