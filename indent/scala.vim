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

function! IsUnfinishedStatement(line)
  " line end with an operator
  if a:line =~ '\s\+[=+&-:/*|<>!?%#]\+\s*$'
    return 1
  endif
  return 0
endfunction

function! IsOneLineBlockStart(line)
  if a:line =~ '^\s*\(\(\<implicit\>\|\<private\(\[\S\+\]\)\?\)\s\+\)\?\<\(def\|va[lr]\)\>.*[=]\s*$'
        \ || a:line =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>[^)]*[)=]\s*$'
        \ || a:line =~ '^\s*\<else\>\s*$'
        \ || a:line =~ '^\s*\<case\>.*=>\s*$'
    return 1
  endif
  return 0
endfunction

function! GetScalaIndent_(lnum)

  let lnum = a:lnum

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  " Is prevline a terminated statement ?

  " Indent html literals
  if prevline !~ '/>\s*$' && prevline =~ '^\s*<[a-zA-Z][^>]*>\s*$'
    echom "indenting XML literal"
    return ind + &shiftwidth
  endif
  
  " Previous line ends with an operator: indent
  if IsUnfinishedStatement(prevline) > 0
    " pprevline checked for cases where one line split in more than 2
    if IsUnfinishedStatement(getline(prevnonblank(lnum - 1))) < 1
      echom "continuing previous line"
      return ind + &shiftwidth
    else
      return ind
    endif
  endif

  " Align 'for' clauses nicely
  if prevline =~ '^\s*\<for\> (.*;\s*$'
    echom "nicely indenting for clauses"
    return ind - &shiftwidth + 5
  endif

  " prevline is a terminated statement
  " does prevline start a new block ?

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  " echo c
  if c > 0
    let ind = ind + &shiftwidth
    echom "continuing paren-content""
  elseif c < 0
    let ind = ind - &shiftwidth
  endif

  " Add a 'shiftwidth' after lines that start a block
  let a = CountAccols(prevline)
  " echo c
  if a > 0
    let ind = ind + &shiftwidth
    echom "starting new block"
  elseif c < 0
    let ind = ind - &shiftwidth
  endif

  " if prevline does not start a block and is terminated
  " should we dedent the next one ?
  if a <= 0 && c <= 0 " a new block is not started by previous line
    let pplnum = lnum - 1
    let pprevline = getline(prevnonblank(pplnum))
    echom pprevline
    while IsOneLineBlockStart(pprevline) > 0
          \ || IsUnfinishedStatement(pprevline) > 0
       "   \ || IsUnfinishedStatement(pprevline) > 0
       "   \ || IsUnfinishedStatement(pprevline) > 0
      let ind = ind - &shiftwidth
      echom "prevline is a monoline block"
      let pplnum = pplnum - 1
      let pprevline = getline(prevnonblank(pplnum))
    endwhile
  endif

  let thisline = getline(v:lnum)

  " for Autoclose with {{
  if thisline =~ '^\s*}}' && prevline =~ '^\s*;\s*$'
    echom "autoclose"
    return ind - &shiftwidth
  endif

  if CountAccols(thisline) == -a
    return ind
  endif
  if CountParens(thisline) == -c
    return ind
  endif

  " Subtract a 'shiftwidth' on '}' or html
  if thisline =~ '^\s*[})]'
        \ || thisline =~ '^\s*</'
    echom "), } or </..."
    let ind = ind - &shiftwidth
  endif

  echom "standard indent"
  return ind
endfunction
