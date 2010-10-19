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

function! GetScalaIndent_(lnum)

  let lnum = a:lnum

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  "Indent html literals
  if prevline !~ '/>\s*$' && prevline =~ '^\s*<[a-zA-Z][^>]*>\s*$'
    return ind + &shiftwidth
  endif

  " Add a 'shiftwidth' after lines that start a block
  let a = CountAccols(prevline)
  " echo c
  if a > 0
    let ind = ind + &shiftwidth
"  elseif c < 0
"    let ind = ind - &shiftwidth
  endif

  " If if, for or while end with ), this is a one-line block
  " If val, var, def end with =, this is a one-line block
  if prevline =~ '^\s*\<\(def\|va[lr]\)\>.*[=]\s*$'
        \ || prevline =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>[^)]*[)=]\s*$'
        \ || prevline =~ '^\s*\<else\>\s*$'
    let ind = ind + &shiftwidth
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  " echo c
  if c > 0
    let ind = ind + &shiftwidth
  elseif c < 0
    let ind = ind - &shiftwidth
    echom "prevline lacks of )"
  endif
  
  " Dedent after if, for, while and val, var, def without block
  let pprevline = getline(prevnonblank(lnum - 1))
  if pprevline =~ '^\s*\<\(def\|va[lr]\)\>.*[=]\s*$'
        \ || pprevline =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>[^)]*[)=]\s*$'
        \ || pprevline =~ '^\s*\<else\>\s*$'
    let ind = ind - &shiftwidth
    echom "prevline is a monoline block"
  endif

  " Align 'for' clauses nicely
  if prevline =~ '^\s*\<for\> (.*;\s*$'
    let ind = ind - &shiftwidth + 5
  endif

  let thisline = getline(v:lnum)

  " for Autoclose with {{
"  if thisline =~ '^\s*}}' && prevline =~ '^\s*;\s*$'
"    echom "autoclose"
"    return ind - &shiftwidth
"  endif
  if thisline =~ '^\s*}' && prevline =~ '{$'
    echom "autoclose"
    return ind
  endif

  " Subtract a 'shiftwidth' on '}' or html
  if thisline =~ '^\s*[})]'
        \ || thisline =~ '^\s*</'
    echom "} or </..."
    let ind = ind - &shiftwidth
  endif

  return ind
endfunction
