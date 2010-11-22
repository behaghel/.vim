" Vim indent file
" Language   : Scala (http://scala-lang.org/)
" Maintainer : Stefan Matthias Aust
" Last Change: 2006 Apr 13
" Revision   : $Id$
"        $URL$

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetScalaIndent()

setlocal indentkeys=0{,0},0),!^F,<>>,<CR>

setlocal autoindent sw=2 et

if exists("*GetScalaIndent")
  finish
endif

function! CountParens(line)
  " first get rid of everything between ""
  let line = substitute(a:line, '"\([^"]\|\\"\)*"', '', 'g')
  let open = substitute(line, '[^(]', '', 'g')
  let close = substitute(line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! CountAccols(line)
  " first get rid of everything between ""
  let line = substitute(a:line, '"\([^"]\|\\"\)*"', '', 'g')
  let open = substitute(line, '[^{]', '', 'g')
  let close = substitute(line, '[^}]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! GetScalaIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  let ind = GetScalaIndent_(lnum)
  return ind
endfunction

function! IsDeclaration(line)
  if a:line =~ '\(\<object\>\|\<class\>\|\<def\>\|\<val\>\|\<var\>\)'
    return 1
  else
    return 0
  endif
endfunction

function! IsUnfinishedStatement(line)
  " line end with an operator or ; (eg for-clauses)
  " but if only a ; on a line >> Autoclose vim addon. Exclude it
  if a:line =~ '[-=+&:/*|<>!?%#;]\+\s*$' && a:line !~ '^\s*;\s*$'
    return 1
  endif
  return 0
endfunction

function! IsOneLineBlockStart(line)
  if a:line =~ '^\s*\(\(\<lazy\>\|\<implicit\>\|\<private\(\[\S\+\]\)\?\)\s\+\)\?\<\(def\|va[lr]\)\>.*[=]\s*$'
        \ || a:line =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>.*[)=]\s*$'
        \ || a:line =~ '^\s*\<else\>\s*$'
        \ || a:line =~ '^\s*\<case\>.*=>\s*$'
    return 1
  endif
  return 0
endfunction

function! FindMatchingOpenBraceIndent(lnum)
  let lnum = a:lnum
  let cumul = -1
  while cumul != 0 && lnum > 0
    let lnum = prevnonblank(lnum - 1)
    let pline = getline(lnum)
    let cumul = cumul + CountAccols(pline)
  endwhile
  return indent(lnum)
endfunction

function! GetScalaIndent_(lnum)
  let lnum = a:lnum
  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  " prevline is a comment: same indent
  if prevline =~ '^\s*//'
    return ind
  endif

  if prevline =~ '^\s*\*/\s*$'
    echom "dedenting after multiline comment"
    return ind - &shiftwidth
  endif

  let thisline = getline(v:lnum)

  " for Autoclose with {{
"  if thisline =~ '^\s*}}' && prevline =~ '^\s*;\s*$'
"    echom "autoclose"
"    return ind - &shiftwidth
"  endif

  " when yield is on its own line. indentkeys should contains =yield
  if thisline =~ '^\s*yield'
    echom "nicely indenting yield""
    return ind - 3
  endif

"  if CountAccols(thisline) == -a
"    return ind
"  endif
"  if CountParens(thisline) == -c
"    return ind
"  endif

  " Subtract a 'shiftwidth' on '}' or html
  if thisline =~ '^\s*</'
    echom "</..."
    let ind = ind - &shiftwidth
  endif

  if thisline =~ '^\s*}}\s*$' && prevline =~ '^\s*;\s*$'
    echom "Autoclose end"
    return ind - &shiftwidth
  endif

  if thisline =~ '^\s*}\s*$'
    if prevline =~ '{\s*$'
      echom "Autoclose body"
      return ind + &shiftwidth
    endif
    let ind = FindMatchingOpenBraceIndent(v:lnum)
    echom "finding indent of matching open brace"
    echom ind
"    if prevline =~ '^\s*}\s*$'
"      " to tackle this strange behaviour that reindent the } after having it
"      " rightly dedent
"      echom "dedent bug?"
"      let ind = ind - &shiftwidth
"    endif
    return ind
  endif

  " prevline is only a }
  if prevline =~ '^\s*}\s*$'
    return ind
  endif

  " """"""""""""""""""""""""""""
  " Is prevline a terminated statement ?

  " Indent html literals
  if prevline !~ '/>\s*$' && prevline =~ '^\s*<[a-zA-Z][^>]*>\s*$'
    echom "indenting XML literal"
    return ind + &shiftwidth
  endif
  
  " Align 'for' clauses nicely
  if prevline =~ '^\s*\<for\> (.*;\s*$'
    echom "nicely indenting for clauses"
    return ind + 5
  endif
  " when yield is on the same line as last for-clause
  if prevline =~ 'yield\s*$'
    echom "nicely indenting for clauses"
    return ind - 3
  endif
 
  " Previous line ends with an operator: indent
  if IsUnfinishedStatement(prevline) > 0
    echom "unfinished statement:"
    echom prevline
    " pprevline checked for cases where one line split in more than 2
    let pprevline = getline(lnum - 1)
    if IsUnfinishedStatement(pprevline) < 1
      echom "continuing previous line"
      echom pprevline
      return ind + &shiftwidth
    else
      return ind
    endif
  endif

  if IsOneLineBlockStart(prevline) > 0
    echom "prevline is one-line-block start"
    return ind + &shiftwidth
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  " echo c
  if c > 0
    let ind = ind + &shiftwidth
    echom "continuing paren-content"
  elseif c < 0
    echom "dedenting because of closed parens"
    let ind = ind - &shiftwidth
  endif

  " Add a 'shiftwidth' after lines that start a block
  let a = CountAccols(prevline)
  " echo c
  if a > 0
    let ind = ind + &shiftwidth
    echom "starting new block"
  elseif a < 0
    echom "dedenting because of closed braces"
    let ind = ind - &shiftwidth
  endif

  " if previous line is a one line yield
  if prevline =~ '^\s\+\<yield\>' && a == 0
    echom "dedenting after monoline yield"
    let ind = ind - &shiftwidth
  endif

  " if prevline does not start a block and is terminated
  " should we dedent the next one ?
  if a <= 0 && c <= 0 " a new block is not started by previous line
    let pplnum = lnum 
    let pprevline = prevline
    let bstart = IsOneLineBlockStart(pprevline) 
"     let bend = CountParens(pprevline)
"     let unfinished =  IsUnfinishedStatement(pprevline)
"     while bstart > 0 || unfinished > 0 || bend < 0
    while bstart <= 0 && IsDeclaration(pprevline) <= 0 && strlen(substitute(pprevline,"\s+","","g")) > 0
      echom pprevline
      if bstart > 0
        let ind = ind - &shiftwidth
        echom "prevline is a monoline block"
      endif
      let pplnum = pplnum - 1
      let pprevline = getline(pplnum)
      let bstart = IsOneLineBlockStart(pprevline) 
"       let bend = CountParens(pprevline)
"       let unfinished =  IsUnfinishedStatement(pprevline)
    endwhile
    if bstart > 0
      let ind = ind - &shiftwidth
      echom "prevline is a monoline block"
    endif
  endif


  echom "standard indent"
  return ind
endfunction
